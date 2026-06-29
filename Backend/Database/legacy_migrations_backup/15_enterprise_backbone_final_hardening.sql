-- ==============================================================================
-- NOBLEINVOICE: ENTERPRISE BACKBONE & FINAL HARDENING
-- Consolidated migration for all missing or mismatched schema components.
-- Scope: Invoicing, Reminders, Recurring Engine, Notifications, and Security.
-- ==============================================================================

-- 🚀 1. NOTIFICATIONS: FCM Token Infrastructure
-- Stores per-team device tokens for targeted push notifications.
CREATE TABLE IF NOT EXISTS public.fcm_tokens (
  id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id     UUID   NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  team_id     UUID   NOT NULL REFERENCES public.teams(id) ON DELETE CASCADE,
  token       TEXT   NOT NULL,
  platform    TEXT   NOT NULL DEFAULT 'android', -- 'android' | 'ios'
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (team_id, token)
);

-- Apply RLS: Users can only manage tokens associated with their own auth session
ALTER TABLE public.fcm_tokens ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Users manage own fcm tokens" ON public.fcm_tokens;
CREATE POLICY "Users manage own fcm tokens" 
  ON public.fcm_tokens FOR ALL 
  USING (auth.uid() = user_id) 
  WITH CHECK (auth.uid() = user_id);

-- 🚀 2. RECURRING INVOICES: Table Normalization
-- Ensures the table matches the controller expectations (template_data JSONB).
-- We use a DO block to safely upgrade existing structure.
DO $$
BEGIN
    -- Ensure recurring_invoices exists
    CREATE TABLE IF NOT EXISTS public.recurring_invoices (
      id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
      team_id UUID REFERENCES public.teams(id) ON DELETE CASCADE,
      user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
      client_id BIGINT REFERENCES public.clients(id) ON DELETE SET NULL,
      frequency TEXT NOT NULL DEFAULT 'monthly',
      next_run_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      last_run_at TIMESTAMPTZ,
      is_active BOOLEAN DEFAULT TRUE,
      template_data JSONB NOT NULL DEFAULT '{}'::jsonb,
      created_at TIMESTAMPTZ DEFAULT NOW(),
      updated_at TIMESTAMPTZ DEFAULT NOW()
    );

    -- If legacy columns exist from initial schema, drop/rename them
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='recurring_invoices' AND column_name='interval') THEN
        ALTER TABLE public.recurring_invoices RENAME COLUMN interval TO frequency;
    END IF;
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='recurring_invoices' AND column_name='next_run_date') THEN
        ALTER TABLE public.recurring_invoices RENAME COLUMN next_run_date TO next_run_at;
    END IF;

    -- Ensure UUID types for foreign keys (legacy fix)
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='recurring_invoices' AND column_name='user_id' AND data_type != 'uuid') THEN
        ALTER TABLE public.recurring_invoices ALTER COLUMN user_id TYPE UUID USING user_id::UUID;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='recurring_invoices' AND column_name='team_id') THEN
        ALTER TABLE public.recurring_invoices ADD COLUMN team_id UUID REFERENCES public.teams(id) ON DELETE CASCADE;
    END IF;
    
    -- Explicitly add missing columns for existing table
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='recurring_invoices' AND column_name='is_active') THEN
        ALTER TABLE public.recurring_invoices ADD COLUMN is_active BOOLEAN DEFAULT TRUE;
        -- Data migration: if status was 'active', set is_active to true
        IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='recurring_invoices' AND column_name='status') THEN
            UPDATE public.recurring_invoices SET is_active = (status = 'active');
        END IF;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='recurring_invoices' AND column_name='template_data') THEN
        ALTER TABLE public.recurring_invoices ADD COLUMN template_data JSONB NOT NULL DEFAULT '{}'::jsonb;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='recurring_invoices' AND column_name='last_run_at') THEN
        ALTER TABLE public.recurring_invoices ADD COLUMN last_run_at TIMESTAMPTZ;
    END IF;
END $$;

-- Apply RLS to recurring_invoices
ALTER TABLE public.recurring_invoices ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Team access for recurring_invoices" ON public.recurring_invoices;
CREATE POLICY "Team access for recurring_invoices" 
  ON public.recurring_invoices FOR ALL 
  USING (is_team_member(team_id));

-- 🚀 3. PERFORMANCE: Scoped Indices
-- Accelerate the daily CRON scans for reminders and recurrence generation.
CREATE INDEX IF NOT EXISTS idx_invoices_due_reminder ON public.invoices (status, due_date) WHERE status = 'pending';
CREATE INDEX IF NOT EXISTS idx_recurring_generation ON public.recurring_invoices (is_active, next_run_at) WHERE is_active = TRUE;

-- 🚀 4. AUTOMATION: pg_cron Schedules
-- Requires pg_cron and pg_net extensions to be enabled in Dashboard.
-- NOTE: Edge function URLs should be set via Supabase Project Settings or passed in the URL.

-- Daily Invoice Reminders (08:00 UTC)
SELECT cron.schedule(
  'noble-overdue-reminders',
  '0 8 * * *',
  $$
    SELECT net.http_post(
      url     := (SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'EDGE_FUNCTION_BASE_URL') || '/send-invoice-reminders',
      headers := jsonb_build_object('Authorization', 'Bearer ' || (SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'SERVICE_ROLE_KEY'), 'Content-Type', 'application/json'),
      body    := '{}'::jsonb
    );
  $$
);

-- Daily Recurring Generation (01:00 UTC)
SELECT cron.schedule(
  'noble-recurring-generation',
  '0 1 * * *',
  $$
    SELECT net.http_post(
      url     := (SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'EDGE_FUNCTION_BASE_URL') || '/process-recurring-invoices',
      headers := jsonb_build_object('Authorization', 'Bearer ' || (SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'SERVICE_ROLE_KEY'), 'Content-Type', 'application/json'),
      body    := '{}'::jsonb
    );
  $$
);

-- 🚀 5. SECURITY: Global Shared Tables RLS Hardening
-- Ensure stock_ledger, vendors, and chat messages are properly scoped to teams.

-- Vendors
ALTER TABLE public.vendors ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Team access for vendors" ON public.vendors;
CREATE POLICY "Team access for vendors" ON public.vendors FOR ALL USING (is_team_member(team_id));

-- Stock Ledger
ALTER TABLE public.stock_ledger ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Team access for stock_ledger" ON public.stock_ledger;
CREATE POLICY "Team access for stock_ledger" ON public.stock_ledger FOR ALL USING (is_team_member(team_id));

-- Live Chat Messages (Owned by user)
ALTER TABLE public.live_chat_messages ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Users can manage own messages" ON public.live_chat_messages;
CREATE POLICY "Users can manage own messages" ON public.live_chat_messages FOR ALL USING (auth.uid() = user_id);

-- Record Table Sync Completion
COMMENT ON TABLE public.recurring_invoices IS 'Enterprise Edition: Unified polymorphic template engine.';
