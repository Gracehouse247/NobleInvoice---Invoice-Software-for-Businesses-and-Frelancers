-- Migration: atomic_invoice_update
-- Description: Creates an RPC to update an invoice and its items atomically

CREATE OR REPLACE FUNCTION update_invoice_with_items(
    p_invoice_id UUID,
    p_invoice_data JSONB,
    p_items JSONB
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_updated_invoice JSONB;
BEGIN
    -- 1. Update the invoice record
    UPDATE invoices
    SET
        client_id = (p_invoice_data->>'client_id')::BIGINT,
        invoice_number = p_invoice_data->>'invoice_number',
        invoice_type = p_invoice_data->>'invoice_type',
        issue_date = (p_invoice_data->>'issue_date')::DATE,
        due_date = (p_invoice_data->>'due_date')::DATE,
        status = p_invoice_data->>'status',
        currency_code = p_invoice_data->>'currency_code',
        tax_rate = (p_invoice_data->>'tax_rate')::NUMERIC,
        tax_type = p_invoice_data->>'tax_type',
        tax_amount = (p_invoice_data->>'tax_amount')::NUMERIC,
        discount_type = p_invoice_data->>'discount_type',
        discount_value = (p_invoice_data->>'discount_value')::NUMERIC,
        discount_amount = (p_invoice_data->>'discount_amount')::NUMERIC,
        subtotal = (p_invoice_data->>'subtotal')::NUMERIC,
        total_amount = (p_invoice_data->>'total_amount')::NUMERIC,
        notes = p_invoice_data->>'notes',
        metadata = p_invoice_data->'metadata',
        updated_at = NOW()
    WHERE id = p_invoice_id;

    -- Return the updated invoice row
    SELECT row_to_json(i) INTO v_updated_invoice
    FROM invoices i
    WHERE id = p_invoice_id;

    IF v_updated_invoice IS NULL THEN
        RAISE EXCEPTION 'Invoice not found';
    END IF;

    -- 2. Delete existing items
    DELETE FROM invoice_items WHERE invoice_id = p_invoice_id;

    -- 3. Insert new items if provided
    IF jsonb_array_length(p_items) > 0 THEN
        INSERT INTO invoice_items (
            invoice_id,
            product_id,
            description,
            quantity,
            unit_price,
            total
        )
        SELECT
            p_invoice_id,
            (item->>'product_id')::BIGINT,
            item->>'description',
            (item->>'quantity')::NUMERIC,
            (item->>'unit_price')::NUMERIC,
            (item->>'total')::NUMERIC
        FROM jsonb_array_elements(p_items) AS item;
    END IF;

    RETURN v_updated_invoice;
END;
$$;
