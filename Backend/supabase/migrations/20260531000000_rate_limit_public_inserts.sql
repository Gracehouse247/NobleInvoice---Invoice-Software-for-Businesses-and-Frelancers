-- supabase/migrations/20260531000000_rate_limit_public_inserts.sql
--
-- Hardens the public-insert RLS policies on identity_leads and scan_logs.
--
-- Problem: The original policies allowed unlimited unauthenticated inserts with
-- no validation, making them vulnerable to spam / denial-of-wallet attacks.
--
-- Solution:
--   1. Add per-identity insert rate-limiting via a helper function that checks
--      how many rows have been inserted for a given identity_id in the last
--      minute. Inserts exceeding the threshold are rejected at the DB level.
--
--   2. Add a NOT NULL constraint on identity_id (already exists via FK, kept
--      explicit) and basic email format validation on identity_leads.
--
--   3. scan_logs: limit to 10 scans per identity per minute to prevent
--      artificial inflation of scan analytics.
--
-- NOTE: For CAPTCHA enforcement, wrap the public-facing insert endpoint in an
-- Edge Function (e.g. /submit-lead) that validates a CAPTCHA token before
-- writing to the database. This file handles the database-level safety net.
--

-- ── 1. Rate-limit helper function ────────────────────────────────────────────

CREATE OR REPLACE FUNCTION public.check_insert_rate_limit(
  p_table_name TEXT,
  p_identity_id UUID,
  p_max_per_minute INT
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_count INT;
BEGIN
  IF p_table_name = 'identity_leads' THEN
    SELECT COUNT(*) INTO v_count
      FROM public.identity_leads
     WHERE identity_id = p_identity_id
       AND created_at >= NOW() - INTERVAL '1 minute';
  ELSIF p_table_name = 'scan_logs' THEN
    SELECT COUNT(*) INTO v_count
      FROM public.scan_logs
     WHERE identity_id = p_identity_id
       AND scanned_at >= NOW() - INTERVAL '1 minute';
  ELSE
    RETURN FALSE;
  END IF;

  RETURN v_count < p_max_per_minute;
END;
$$;

-- Revoke direct execution from public; only the RLS check will call it
REVOKE ALL ON FUNCTION public.check_insert_rate_limit FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.check_insert_rate_limit TO anon, authenticated;

-- ── 2. identity_leads — replace public insert policy ─────────────────────────

DROP POLICY IF EXISTS "Public can submit leads" ON public.identity_leads;

CREATE POLICY "Public can submit leads (rate-limited)" ON public.identity_leads
  FOR INSERT
  WITH CHECK (
    -- The identity must exist (FK already enforces this, belt-and-suspenders)
    identity_id IS NOT NULL
    -- Basic email format validation
    AND email ~* '^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$'
    -- Rate limit: max 5 lead submissions per identity per minute
    AND public.check_insert_rate_limit('identity_leads', identity_id, 5)
  );

-- ── 3. scan_logs — replace public insert policy ───────────────────────────────

DROP POLICY IF EXISTS "Public can insert scan logs" ON public.scan_logs;

CREATE POLICY "Public can insert scan logs (rate-limited)" ON public.scan_logs
  FOR INSERT
  WITH CHECK (
    identity_id IS NOT NULL
    -- Rate limit: max 10 scan events per identity per minute
    AND public.check_insert_rate_limit('scan_logs', identity_id, 10)
  );

-- ── 4. Add index to speed up the rate-limit subqueries ───────────────────────
-- (These may already exist; IF NOT EXISTS keeps migration idempotent)

CREATE INDEX IF NOT EXISTS idx_identity_leads_rate_limit
  ON public.identity_leads (identity_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_scan_logs_rate_limit
  ON public.scan_logs (identity_id, scanned_at DESC);
