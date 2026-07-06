-- ==============================================================================
-- Migration: 20260706020000_invoice_total_validation.sql
-- Description: Strict backend validation to prevent client-side spoofing of 
--              total_amount on invoices. Automatically calculates and forces
--              the correct totals whenever invoice_items are modified.
-- ==============================================================================

-- 1. Create a function to recalculate the parent invoice totals
CREATE OR REPLACE FUNCTION public.recalculate_invoice_totals()
RETURNS trigger AS $$
DECLARE
    v_invoice_id UUID;
    v_subtotal NUMERIC := 0;
    v_tax_rate NUMERIC := 0;
    v_tax_type TEXT;
    v_discount_type TEXT;
    v_discount_value NUMERIC := 0;
    
    v_calculated_discount NUMERIC := 0;
    v_calculated_tax NUMERIC := 0;
    v_calculated_total NUMERIC := 0;
BEGIN
    -- Determine the invoice_id based on the operation
    IF TG_OP = 'DELETE' THEN
        v_invoice_id := OLD.invoice_id;
    ELSE
        v_invoice_id := NEW.invoice_id;
    END IF;

    -- Calculate the new subtotal from all items belonging to this invoice
    SELECT COALESCE(SUM(quantity * COALESCE(unit_price, 0)), 0)
    INTO v_subtotal
    FROM public.invoice_items
    WHERE invoice_id = v_invoice_id;

    -- Fetch the tax and discount settings from the parent invoice
    SELECT 
        COALESCE(tax_rate, 0), 
        COALESCE(tax_type, 'exclusive'), 
        COALESCE(discount_type, 'none'), 
        COALESCE(discount_value, 0)
    INTO 
        v_tax_rate, v_tax_type, v_discount_type, v_discount_value
    FROM public.invoices
    WHERE id = v_invoice_id;

    -- Calculate discount
    IF v_discount_type = 'percentage' THEN
        v_calculated_discount := v_subtotal * (v_discount_value / 100.0);
    ELSIF v_discount_type = 'fixed' THEN
        v_calculated_discount := v_discount_value;
    END IF;

    -- Ensure discount doesn't exceed subtotal
    IF v_calculated_discount > v_subtotal THEN
        v_calculated_discount := v_subtotal;
    END IF;

    -- Calculate tax (assuming exclusive by default for this basic validation, or use subtotal after discount)
    v_calculated_tax := (v_subtotal - v_calculated_discount) * (v_tax_rate / 100.0);

    -- Calculate final total
    v_calculated_total := (v_subtotal - v_calculated_discount) + v_calculated_tax;

    -- Update the parent invoice with the strictly calculated values
    UPDATE public.invoices
    SET 
        subtotal = v_subtotal,
        discount_amount = v_calculated_discount,
        tax_amount = v_calculated_tax,
        total_amount = v_calculated_total
    WHERE id = v_invoice_id;

    RETURN NULL; -- AFTER trigger, return value is ignored
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. Attach the trigger to the invoice_items table
DROP TRIGGER IF EXISTS trg_recalculate_invoice_totals ON public.invoice_items;
CREATE TRIGGER trg_recalculate_invoice_totals
    AFTER INSERT OR UPDATE OR DELETE
    ON public.invoice_items
    FOR EACH ROW
    EXECUTE FUNCTION public.recalculate_invoice_totals();
