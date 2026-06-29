-- Migration: Add paid_at timestamp to invoices for accurate DSO calculation
ALTER TABLE public.invoices ADD COLUMN IF NOT EXISTS paid_at TIMESTAMPTZ;

-- Update trigger or handle in application logic. 
-- Since we use Supabase directly, a trigger is safer.
CREATE OR REPLACE FUNCTION update_invoice_paid_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'paid' AND (OLD.status IS NULL OR OLD.status != 'paid') THEN
        NEW.paid_at = NOW();
    ELSIF NEW.status != 'paid' THEN
        NEW.paid_at = NULL;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS tr_invoice_paid_timestamp ON public.invoices;
CREATE TRIGGER tr_invoice_paid_timestamp
    BEFORE UPDATE ON public.invoices
    FOR EACH ROW
    EXECUTE FUNCTION update_invoice_paid_timestamp();
