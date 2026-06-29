-- C:\Projects\NobleGo\Database\36_subscription_monetization_hardening.sql
-- ─────────────────────────────────────────────────────────────────────────────
-- NobleGo: Complete Subscription & Monetization Hardening
-- Run this in Supabase SQL Editor.
-- This is idempotent — safe to run multiple times.
-- ─────────────────────────────────────────────────────────────────────────────

-- ── 1. Ensure profiles has all subscription columns ──────────────────────────

ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS subscription_tier        TEXT        NOT NULL DEFAULT 'solo',
  ADD COLUMN IF NOT EXISTS subscription_expires_at  TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS is_yearly_plan           BOOLEAN     NOT NULL DEFAULT false;

-- Ensure the tier is TEXT (not enum — avoids type cast issues)
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name   = 'profiles'
      AND column_name  = 'subscription_tier'
      AND data_type    = 'USER-DEFINED'
  ) THEN
    ALTER TABLE public.profiles
      ALTER COLUMN subscription_tier TYPE TEXT USING subscription_tier::TEXT;
  END IF;
END $$;

-- Normalize any legacy tier values
UPDATE public.profiles SET subscription_tier = 'pulse' WHERE subscription_tier ILIKE '%pulse%' OR subscription_tier ILIKE '%pro%';
UPDATE public.profiles SET subscription_tier = 'elite' WHERE subscription_tier ILIKE '%elite%' OR subscription_tier ILIKE '%squad%';
UPDATE public.profiles SET subscription_tier = 'solo'  WHERE subscription_tier NOT IN ('pulse', 'elite');

-- ── 2. billing_history table ─────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.billing_history (
  id               BIGSERIAL PRIMARY KEY,
  user_id          UUID        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  amount           NUMERIC(10, 2) NOT NULL,
  currency         TEXT        NOT NULL DEFAULT 'USD',
  plan             TEXT        NOT NULL,        -- 'pulse' | 'elite'
  billing_period   TEXT        NOT NULL DEFAULT 'monthly', -- 'monthly' | 'yearly'
  transaction_ref  TEXT,                        -- tx_ref from Flutterwave
  transaction_id   TEXT,                        -- numeric ID from Flutterwave
  status           TEXT        NOT NULL DEFAULT 'pending', -- 'success' | 'failed'
  verified_at      TIMESTAMPTZ,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Add missing columns to existing billing_history if it exists without them
ALTER TABLE public.billing_history ADD COLUMN IF NOT EXISTS transaction_id TEXT;
ALTER TABLE public.billing_history ADD COLUMN IF NOT EXISTS verified_at    TIMESTAMPTZ;

-- RLS: users can read their own billing history; service_role writes
ALTER TABLE public.billing_history ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users read own billing history"   ON public.billing_history;
DROP POLICY IF EXISTS "Service role manages billing"     ON public.billing_history;

CREATE POLICY "Users read own billing history"
  ON public.billing_history FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Service role manages billing"
  ON public.billing_history FOR ALL
  USING (auth.role() = 'service_role')
  WITH CHECK (auth.role() = 'service_role');

-- ── 3. webhook_logs table (for debugging) ────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.webhook_logs (
  id         BIGSERIAL PRIMARY KEY,
  payload    JSONB,
  headers    JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.webhook_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Service role only" ON public.webhook_logs;
CREATE POLICY "Service role only"
  ON public.webhook_logs FOR ALL
  USING (auth.role() = 'service_role')
  WITH CHECK (auth.role() = 'service_role');

-- ── 4. upgrade_user_subscription RPC ─────────────────────────────────────────
-- Called by both the webhook (backup) and the verify-and-upgrade function (primary).
-- SECURITY DEFINER ensures it bypasses RLS and runs as the function owner.

CREATE OR REPLACE FUNCTION public.upgrade_user_subscription(
  target_user_id  UUID,
  target_tier     TEXT,
  is_yearly       BOOLEAN
) RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  expiry_interval INTERVAL;
BEGIN
  -- Validate tier
  IF target_tier NOT IN ('pulse', 'elite') THEN
    RAISE EXCEPTION 'Invalid subscription tier: %', target_tier;
  END IF;

  IF is_yearly THEN
    expiry_interval := INTERVAL '1 year';
  ELSE
    expiry_interval := INTERVAL '1 month';
  END IF;

  UPDATE public.profiles
  SET
    subscription_tier       = target_tier,
    subscription_expires_at = NOW() + expiry_interval,
    is_yearly_plan          = is_yearly,
    updated_at              = NOW()
  WHERE id = target_user_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'User not found: %', target_user_id;
  END IF;
END;
$$;

-- Grant execute permission to service_role and authenticated
GRANT EXECUTE ON FUNCTION public.upgrade_user_subscription(UUID, TEXT, BOOLEAN)
  TO service_role, authenticated;

-- ── 5. increment_usage RPC (for usage tracking) ───────────────────────────────

CREATE OR REPLACE FUNCTION public.increment_usage(
  u_id      UUID,
  m_year    TEXT,
  col_name  TEXT
) RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  -- Upsert the row first
  INSERT INTO public.usage_metrics (user_id, month_year)
  VALUES (u_id, m_year)
  ON CONFLICT (user_id, month_year) DO NOTHING;

  -- Increment the requested column safely
  EXECUTE format(
    'UPDATE public.usage_metrics SET %I = COALESCE(%I, 0) + 1
     WHERE user_id = $1 AND month_year = $2',
    col_name, col_name
  ) USING u_id, m_year;
END;
$$;

GRANT EXECUTE ON FUNCTION public.increment_usage(UUID, TEXT, TEXT)
  TO service_role, authenticated;

-- ── 6. usage_metrics table ────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.usage_metrics (
  id               BIGSERIAL PRIMARY KEY,
  user_id          UUID  NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  month_year       TEXT  NOT NULL, -- e.g. '2024-04'
  clients_created  INT   NOT NULL DEFAULT 0,
  clients_edited   INT   NOT NULL DEFAULT 0,
  invoices_created INT   NOT NULL DEFAULT 0,
  invoices_edited  INT   NOT NULL DEFAULT 0,
  cards_created    INT   NOT NULL DEFAULT 0,
  created_at       TIMESTAMPTZ DEFAULT NOW(),
  updated_at       TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (user_id, month_year)
);

ALTER TABLE public.usage_metrics ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users manage own usage" ON public.usage_metrics;
CREATE POLICY "Users manage own usage"
  ON public.usage_metrics FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ── 7. Performance indices ────────────────────────────────────────────────────

CREATE INDEX IF NOT EXISTS idx_billing_history_user
  ON public.billing_history (user_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_usage_metrics_user_month
  ON public.usage_metrics (user_id, month_year);

-- Done
COMMENT ON FUNCTION public.upgrade_user_subscription IS
  'Atomically upgrades a user subscription tier. Called by verify-and-upgrade-subscription edge function and flw-webhook.';
