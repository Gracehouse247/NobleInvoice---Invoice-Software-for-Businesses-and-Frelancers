-- supabase/migrations/20260421_automation_cron.sql
--
-- Schedules recurring Edge Function calls using pg_cron + pg_net.
--
-- IMPORTANT: Do NOT hardcode your project ref or service role key here.
-- Instead, store them securely and set them at deploy time.
--
-- Option A (Recommended for Supabase Cloud):
--   Use the Supabase Vault to store the service role key, then reference it
--   via pgsodium.decrypted_secret('service_role_key') inside the cron body.
--
-- Option B (During local development / CI):
--   Set cron jobs after migration using the Supabase CLI or dashboard,
--   passing values from environment variables in a separate setup script.
--
-- This migration intentionally leaves the URL and Authorization header as
-- runtime-configurable strings using app.settings GUC variables so that
-- NO secrets are ever stored in plain text in this file.
--
-- Before running migrations, set the following in your Supabase dashboard
-- under Project Settings → Configuration → App Settings (or via CLI):
--
--   app.settings.supabase_functions_url = 'https://<your-project-ref>.supabase.co/functions/v1'
--   app.settings.service_role_key       = '<your-service-role-key>'  ← store via Vault instead!
--
-- For production, retrieve the key via vault:
--   SELECT pgsodium.decrypted_secret('service_role_key');
--

-- 1. Enable the pg_cron extension if not already enabled
CREATE EXTENSION IF NOT EXISTS pg_cron;
CREATE EXTENSION IF NOT EXISTS pg_net;

-- 2. Grant usage to postgres user
GRANT USAGE ON SCHEMA cron TO postgres;

-- 3. Schedule cron jobs only when pg_cron is available.
--    We use app.settings GUC values so no secrets are baked into this file.
DO $$
DECLARE
  functions_url TEXT;
  auth_header   TEXT;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'pg_cron') THEN
    RAISE NOTICE 'pg_cron extension not found — skipping cron schedules. Enable pg_cron in the Supabase dashboard to activate.';
    RETURN;
  END IF;

  -- Read runtime settings. These must be configured in the dashboard / CLI
  -- and are NEVER hardcoded in migration files.
  BEGIN
    functions_url := current_setting('app.settings.supabase_functions_url');
    auth_header   := 'Bearer ' || current_setting('app.settings.service_role_key');
  EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'app.settings.supabase_functions_url or app.settings.service_role_key not set. Skipping cron registration. Configure these settings and re-run.';
    RETURN;
  END;

  -- Remove stale jobs if they exist (idempotent)
  PERFORM cron.unschedule('process-recurring-invoices-daily')
    WHERE EXISTS (
      SELECT 1 FROM cron.job WHERE jobname = 'process-recurring-invoices-daily'
    );

  PERFORM cron.unschedule('send-invoice-reminders-daily')
    WHERE EXISTS (
      SELECT 1 FROM cron.job WHERE jobname = 'send-invoice-reminders-daily'
    );

  -- Schedule: Recurring Invoice Generation (Daily at Midnight UTC)
  PERFORM cron.schedule(
    'process-recurring-invoices-daily',
    '0 0 * * *',
    format(
      $cron$
        SELECT net.http_post(
          url     := %L,
          headers := '{"Content-Type": "application/json", "Authorization": %s}'::jsonb,
          body    := '{}'::jsonb
        );
      $cron$,
      functions_url || '/process-recurring-invoices',
      quote_literal(auth_header)
    )
  );

  -- Schedule: Payment Reminders (Daily at 8:00 AM UTC)
  PERFORM cron.schedule(
    'send-invoice-reminders-daily',
    '0 8 * * *',
    format(
      $cron$
        SELECT net.http_post(
          url     := %L,
          headers := '{"Content-Type": "application/json", "Authorization": %s}'::jsonb,
          body    := '{}'::jsonb
        );
      $cron$,
      functions_url || '/send-invoice-reminders',
      quote_literal(auth_header)
    )
  );

  RAISE NOTICE 'Cron jobs registered successfully using runtime settings.';
END;
$$;

COMMENT ON COLUMN public.invoices.metadata IS 'Stores meta-data like recurring_interval, next_generation_date, etc.';
