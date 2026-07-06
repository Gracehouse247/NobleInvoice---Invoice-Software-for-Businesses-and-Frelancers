-- 20260703184803_setup_pg_cron_recurring_invoices.sql
-- Description: Enables pg_cron and pg_net to schedule the daily processing of recurring invoices.

CREATE EXTENSION IF NOT EXISTS pg_cron;
CREATE EXTENSION IF NOT EXISTS pg_net;

-- Schedule the recurring invoice processor to run daily at 00:00 UTC.
-- IMPORTANT: Update YOUR_PROJECT_URL and YOUR_SERVICE_ROLE_KEY with actual values before executing in production, 
-- or use Supabase Vault to store the secret securely.

SELECT cron.schedule(
  'process-recurring-invoices-daily', -- Job name
  '0 0 * * *',                        -- Cron expression (Daily at midnight)
  $$
    SELECT net.http_post(
        url:='YOUR_PROJECT_URL/functions/v1/process-recurring-invoices',
        headers:='{"Content-Type": "application/json", "Authorization": "Bearer YOUR_SERVICE_ROLE_KEY"}'::jsonb
    );
  $$
);
