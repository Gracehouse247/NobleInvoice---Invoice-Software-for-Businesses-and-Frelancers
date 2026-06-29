-- ==============================================================================
-- NOBLEGO: TRACKING & READ RECEIPTS MIGRATION
-- Adds analytical tracking to invoices for professional monitoring.
-- ==============================================================================

-- 1. Extend Invoices with Tracking Columns
ALTER TABLE public.invoices 
ADD COLUMN IF NOT EXISTS opened_at TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS view_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS tracking_token UUID DEFAULT gen_random_uuid();

-- 2. Create Tracking Index
CREATE INDEX IF NOT EXISTS idx_invoices_tracking ON public.invoices (tracking_token);

-- 3. Update Existing Reminders Job to handle Tiered Overdue logic (3d/7d)
-- We don't need to change the cron schedule, only the Edge Function logic 
-- but we make sure the index supports quick range scans.
CREATE INDEX IF NOT EXISTS idx_invoices_overdue_scan 
ON public.invoices (status, due_date) 
WHERE status = 'pending';

-- 4. Analytics View for Dashboard (Optional but helpful)
CREATE OR REPLACE VIEW public.invoice_tracking_stats AS
SELECT 
  team_id,
  COUNT(*) FILTER (WHERE opened_at IS NOT NULL) as total_opened,
  COUNT(*) FILTER (WHERE opened_at IS NULL AND due_date < NOW()) as total_ignored_overdue,
  AVG(EXTRACT(EPOCH FROM (opened_at - issue_date))/3600)::NUMERIC(10,2) as avg_hours_to_open
FROM public.invoices
GROUP BY team_id;
