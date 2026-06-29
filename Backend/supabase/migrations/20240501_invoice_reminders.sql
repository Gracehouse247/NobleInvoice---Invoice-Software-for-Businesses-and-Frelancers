-- =========================================================
-- Migration: Invoice Reminder Infrastructure
-- Run this in Supabase SQL Editor (or as a migration file)
-- =========================================================

-- 1. FCM token storage
-- Stores one or more device tokens per team member.
create table if not exists public.fcm_tokens (
  id          bigint generated always as identity primary key,
  user_id     uuid   not null references auth.users(id) on delete cascade,
  team_id     text   not null,
  token       text   not null,
  platform    text   not null default 'android', -- 'android' | 'ios'
  updated_at  timestamptz not null default now(),
  unique (team_id, token)
);

-- Row-Level Security: users can only manage their own tokens
alter table public.fcm_tokens enable row level security;

create policy "Users manage own tokens"
  on public.fcm_tokens for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- 2. pg_cron schedule: runs every day at 08:00 UTC
-- Requires pg_cron and pg_net extensions — enable in Supabase dashboard.
-- Dashboard → Database → Extensions → search "pg_cron" and "pg_net" and enable both.
-- Wrapped in DO block so this migration succeeds even on environments where pg_cron is not installed (e.g. shadow DB).
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'pg_cron') THEN
    PERFORM cron.schedule(
      'noble-invoice-reminders',
      '0 8 * * *',
      $cron$
        SELECT net.http_post(
          url     := current_setting('app.edge_function_base_url') || '/send-invoice-reminders',
          headers := jsonb_build_object(
            'Authorization', 'Bearer ' || current_setting('app.service_role_key'),
            'Content-Type',  'application/json'
          ),
          body    := '{}'::jsonb
        );
      $cron$
    );
  ELSE
    RAISE NOTICE 'pg_cron extension not found — skipping noble-invoice-reminders schedule. Enable it in the Supabase dashboard to activate.';
  END IF;
END;
$$;

-- NOTE: Set the two app settings in Supabase:
--   alter database postgres set app.edge_function_base_url = 'https://<project-id>.supabase.co/functions/v1';
--   alter database postgres set app.service_role_key = '<your-service-role-key>';

-- 3. Index for fast due-date scanning
create index if not exists idx_invoices_status_due_date
  on public.invoices (status, due_date)
  where status = 'pending';
