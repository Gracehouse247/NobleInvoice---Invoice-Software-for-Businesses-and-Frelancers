-- 35_estimates_and_quotes_support.sql
-- Run this in Supabase SQL Editor to support Estimate & Quote workflows

-- 1. Ensure columns are flexible (already TEXT, but we explicitly permit new values)
-- No changes needed for column types, but we add an index for faster filtering of estimates
CREATE INDEX IF NOT EXISTS idx_invoices_type_status ON public.invoices (invoice_type, status);

-- 2. Add 'accepted' and 'rejected' statuses logic for Estimates
-- Since status is TEXT, we can just start using these values.
-- We add a comment to document the valid states for future developers.
COMMENT ON COLUMN public.invoices.status IS 'States: draft, pending, paid, overdue, voided, accepted, rejected';
COMMENT ON COLUMN public.invoices.invoice_type IS 'States: standard, proforma, commercial, progress, recurring, final, credit_memo, debit_memo, mixed, estimate, quote';

-- 3. Inventory Integration: Ensure items can be linked to products correctly
-- (This was already in link_items_to_inventory.sql but repeated here for safety)
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='invoice_items' AND column_name='product_id') THEN
        ALTER TABLE public.invoice_items ADD COLUMN product_id BIGINT REFERENCES public.products(id) ON DELETE SET NULL;
    END IF;
END $$;
