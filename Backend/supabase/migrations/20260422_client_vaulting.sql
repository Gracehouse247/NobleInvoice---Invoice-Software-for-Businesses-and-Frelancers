-- supabase/migrations/20260421_client_vaulting.sql

-- Add columns to store payment tokens for automated recurring charges
ALTER TABLE public.clients
ADD COLUMN IF NOT EXISTS payment_token TEXT,
ADD COLUMN IF NOT EXISTS payment_method_brand TEXT, -- e.g. "Visa", "Mastercard"
ADD COLUMN IF NOT EXISTS payment_method_last4 TEXT,
ADD COLUMN IF NOT EXISTS payment_token_updated_at TIMESTAMPTZ;

-- Add index for faster lookups during automated jobs
CREATE INDEX IF NOT EXISTS idx_clients_payment_token ON public.clients (payment_token) WHERE payment_token IS NOT NULL;

COMMENT ON COLUMN public.clients.payment_token IS 'Vaulted Flutterwave token for recurring charges';
