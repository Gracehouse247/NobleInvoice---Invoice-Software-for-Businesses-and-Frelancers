-- C:\Projects\NobleGo\Database\18_payment_gateway_automation.sql
-- ==============================================================================
-- NOBLEGO PHASE 6 & 7: FLUTTERWAVE PAYMENT GATEWAY & CLIENT VAULTING
-- Enables automated checkout links and recurring auto-billing.
-- ==============================================================================

-- 1. Extend Clients for Payment Vaulting (Phase 7)
-- Stores tokenized card data from Flutterwave for future auto-charges.
ALTER TABLE public.clients
ADD COLUMN IF NOT EXISTS payment_token TEXT,
ADD COLUMN IF NOT EXISTS payment_method_brand TEXT, -- e.g. "visa", "mastercard"
ADD COLUMN IF NOT EXISTS payment_method_last4 TEXT,
ADD COLUMN IF NOT EXISTS payment_token_updated_at TIMESTAMPTZ;

-- Fast lookup for the automated charging job
CREATE INDEX IF NOT EXISTS idx_clients_payment_vault ON public.clients (payment_token) WHERE payment_token IS NOT NULL;

-- 2. Extend Teams for Split Payments (Phase 7.5)
-- Stores the merchant's Flutterwave subaccount ID for automatic splits.
ALTER TABLE public.teams
ADD COLUMN IF NOT EXISTS flutterwave_subaccount_id TEXT;

-- 3. Automation Cron Schedule (Verification)
-- The recurring-generation cron is already scheduled in migration 15.
-- No new schedule needed, as the logic is handled within 'process-recurring-invoices' Edge Function.

COMMENT ON COLUMN public.teams.flutterwave_subaccount_id IS 'Flutterwave subaccount ID for automated split payment settlements.';
COMMENT ON COLUMN public.clients.payment_token IS 'Securely vaulted Flutterwave token for card-on-file auto-billing.';
