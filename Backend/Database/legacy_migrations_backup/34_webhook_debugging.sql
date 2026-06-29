-- C:\Projects\NobleGo\Database\34_webhook_debugging.sql
CREATE TABLE IF NOT EXISTS public.webhook_logs (
    id BIGSERIAL PRIMARY KEY,
    payload JSONB,
    headers JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.webhook_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Service role only" ON public.webhook_logs FOR ALL USING (auth.role() = 'service_role');
