-- ==============================================================================
-- ADMIN RPCs: PLATFORM METRICS
-- ==============================================================================

CREATE OR REPLACE FUNCTION public.get_platform_stats()
RETURNS JSONB AS $$
DECLARE
  merchant_count INT;
  total_volume NUMERIC(15,2);
  invoice_count INT;
  platform_revenue NUMERIC(15,2);
  result JSONB;
BEGIN
  -- 1. Total Merchants
  SELECT count(*) INTO merchant_count FROM public.profiles;

  -- 2. Total Transaction Volume (Paid Invoices)
  SELECT coalesce(sum(total_amount), 0) INTO total_volume 
  FROM public.invoices 
  WHERE status = 'paid';

  -- 3. Total Invoices Issued
  SELECT count(*) INTO invoice_count FROM public.invoices;

  -- 4. Platform Revenue (Mock 1% for now, or use real fee logic)
  platform_revenue := total_volume * 0.01;

  result := jsonb_build_object(
    'merchant_count', merchant_count,
    'total_volume', total_volume,
    'invoice_count', invoice_count,
    'platform_revenue', platform_revenue,
    'updated_at', now()
  );

  RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant access (Optional: restriction by role would happen here)
GRANT EXECUTE ON FUNCTION public.get_platform_stats() TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_platform_stats() TO service_role;
