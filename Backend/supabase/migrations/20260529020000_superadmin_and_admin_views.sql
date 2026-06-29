-- supabase/migrations/20260531010000_superadmin_and_admin_views.sql
--
-- Adds platform-level superadmin support and admin reporting views/RPCs.
--
-- Changes:
--   1. Add `is_superadmin` boolean to profiles (default false).
--   2. Add `flw_subaccount_id` to teams table to store the Flutterwave vendor
--      subaccount ID for split payment commission collection.
--   3. Create admin-only security-definer views/RPCs for global stats.
--   4. RLS policy: only superadmins can read these views.
--

-- ── 1. Add is_superadmin to profiles ─────────────────────────────────────────

ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS is_superadmin BOOLEAN NOT NULL DEFAULT false;

COMMENT ON COLUMN public.profiles.is_superadmin IS
  'Platform-level superadmin flag. Only set manually by a database admin. '
  'Never derived from subscription_tier.';

-- ── 2. Add flw_subaccount_id to teams ────────────────────────────────────────

ALTER TABLE public.teams
  ADD COLUMN IF NOT EXISTS flw_subaccount_id TEXT DEFAULT NULL;

COMMENT ON COLUMN public.teams.flw_subaccount_id IS
  'Flutterwave subaccount ID (e.g. RS_XXXXXX) for split payment commission collection. '
  'Set when a team owner registers their bank account via the platform.';

-- ── 3. Admin-only aggregation RPC ────────────────────────────────────────────
-- Returns platform-wide stats. Callable only by superadmins.

CREATE OR REPLACE FUNCTION public.get_platform_stats()
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_caller_id UUID := auth.uid();
  v_is_super  BOOLEAN;
  v_result    JSONB;
BEGIN
  -- Verify caller is a superadmin
  SELECT is_superadmin INTO v_is_super
    FROM public.profiles
   WHERE id = v_caller_id;

  IF NOT FOUND OR NOT v_is_super THEN
    RAISE EXCEPTION 'Forbidden: superadmin access required';
  END IF;

  SELECT jsonb_build_object(
    'total_users',          (SELECT COUNT(*) FROM public.profiles),
    'active_subscriptions', (SELECT COUNT(*) FROM public.profiles WHERE subscription_status = 'active'),
    'total_revenue',        (SELECT COALESCE(SUM(amount), 0) FROM public.billing_history WHERE status = 'success'),
    'revenue_this_month',   (
      SELECT COALESCE(SUM(amount), 0)
        FROM public.billing_history
       WHERE status = 'success'
         AND created_at >= date_trunc('month', NOW())
    ),
    'new_users_this_week',  (
      SELECT COUNT(*)
        FROM public.profiles
       WHERE created_at >= NOW() - INTERVAL '7 days'
    ),
    'new_users_today',      (
      SELECT COUNT(*)
        FROM public.profiles
       WHERE created_at >= date_trunc('day', NOW())
    ),
    'total_invoices',       (SELECT COUNT(*) FROM public.invoices),
    'paid_invoices',        (SELECT COUNT(*) FROM public.invoices WHERE status = 'paid'),
    'pending_invoices',     (SELECT COUNT(*) FROM public.invoices WHERE status IN ('sent', 'overdue')),
    'total_teams',          (SELECT COUNT(*) FROM public.teams),
    'superadmin_count',     (SELECT COUNT(*) FROM public.profiles WHERE is_superadmin = true),
    'plan_distribution', (
      SELECT jsonb_agg(
        jsonb_build_object('tier', subscription_tier, 'count', cnt)
        ORDER BY cnt DESC
      )
      FROM (
        SELECT COALESCE(subscription_tier, 'explorer') AS subscription_tier,
               COUNT(*) AS cnt
          FROM public.profiles
         GROUP BY 1
      ) sub
    )
  ) INTO v_result;

  RETURN v_result;
END;
$$;

REVOKE ALL ON FUNCTION public.get_platform_stats FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_platform_stats TO authenticated;

-- ── 4. Revenue trend RPC (last 30 days, grouped by day) ──────────────────────

CREATE OR REPLACE FUNCTION public.get_revenue_trend(p_days INT DEFAULT 30)
RETURNS TABLE (day DATE, revenue NUMERIC, invoice_count BIGINT)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_caller_id UUID := auth.uid();
  v_is_super  BOOLEAN;
BEGIN
  SELECT is_superadmin INTO v_is_super
    FROM public.profiles WHERE id = v_caller_id;

  IF NOT FOUND OR NOT v_is_super THEN
    RAISE EXCEPTION 'Forbidden: superadmin access required';
  END IF;

  RETURN QUERY
    SELECT
      created_at::DATE                    AS day,
      COALESCE(SUM(amount), 0)           AS revenue,
      COUNT(*)                           AS invoice_count
    FROM public.billing_history
    WHERE status = 'success'
      AND created_at >= NOW() - (p_days || ' days')::INTERVAL
    GROUP BY 1
    ORDER BY 1;
END;
$$;

REVOKE ALL ON FUNCTION public.get_revenue_trend FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_revenue_trend TO authenticated;

-- ── 5. User growth trend RPC (last 30 days) ───────────────────────────────────

CREATE OR REPLACE FUNCTION public.get_user_growth_trend(p_days INT DEFAULT 30)
RETURNS TABLE (day DATE, new_signups BIGINT, cumulative_total BIGINT)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_caller_id UUID := auth.uid();
  v_is_super  BOOLEAN;
BEGIN
  SELECT is_superadmin INTO v_is_super
    FROM public.profiles WHERE id = v_caller_id;

  IF NOT FOUND OR NOT v_is_super THEN
    RAISE EXCEPTION 'Forbidden: superadmin access required';
  END IF;

  RETURN QUERY
    SELECT
      created_at::DATE           AS day,
      COUNT(*)                   AS new_signups,
      SUM(COUNT(*)) OVER (ORDER BY created_at::DATE) AS cumulative_total
    FROM public.profiles
    WHERE created_at >= NOW() - (p_days || ' days')::INTERVAL
    GROUP BY 1
    ORDER BY 1;
END;
$$;

REVOKE ALL ON FUNCTION public.get_user_growth_trend FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_user_growth_trend TO authenticated;

-- ── 6. Admin notifications table ─────────────────────────────────────────────
-- Stores system-generated events visible in the admin Notification Center.

CREATE TABLE IF NOT EXISTS public.admin_notifications (
  id          BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  type        TEXT NOT NULL CHECK (type IN ('success', 'alert', 'message', 'info')),
  title       TEXT NOT NULL,
  description TEXT,
  is_read     BOOLEAN NOT NULL DEFAULT false,
  metadata    JSONB DEFAULT '{}',
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_admin_notifications_created_at
  ON public.admin_notifications (created_at DESC);
CREATE INDEX IF NOT EXISTS idx_admin_notifications_is_read
  ON public.admin_notifications (is_read) WHERE is_read = false;

ALTER TABLE public.admin_notifications ENABLE ROW LEVEL SECURITY;

-- Only superadmins can read or update notifications
DROP POLICY IF EXISTS "Superadmins can manage notifications" ON public.admin_notifications;
CREATE POLICY "Superadmins can manage notifications" ON public.admin_notifications
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles
       WHERE id = auth.uid() AND is_superadmin = true
    )
  );
