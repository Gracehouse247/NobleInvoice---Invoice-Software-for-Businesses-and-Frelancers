-- 20_analytics_and_scale_optimization.sql
-- Scale Hardening: Replace client-side summation with Database-level aggregation.

-- 1. Create a view for merchant revenue analytics
CREATE OR REPLACE VIEW merchant_analytics AS
SELECT 
    team_id,
    COUNT(id) as total_invoices,
    SUM(CASE WHEN status = 'paid' THEN total_amount ELSE 0 END) as total_revenue,
    SUM(CASE WHEN status IN ('pending', 'overdue') THEN total_amount ELSE 0 END) as total_outstanding,
    -- Platform commission (1% as per enterprise standard)
    SUM(CASE WHEN status = 'paid' THEN total_amount * 0.01 ELSE 0 END) as total_commission,
    MAX(created_at) as last_invoice_date
FROM invoices
GROUP BY team_id;

-- 2. Add indexing for high-volume invoice queries
CREATE INDEX IF NOT EXISTS idx_invoices_team_status ON invoices(team_id, status);
CREATE INDEX IF NOT EXISTS idx_invoices_client_id ON invoices(client_id);

-- 3. Security: Grant access to the view
ALTER VIEW merchant_analytics OWNER TO postgres;
GRANT SELECT ON merchant_analytics TO authenticated;

-- 4. Optimize client stats for "Final Invoice" logic
CREATE OR REPLACE FUNCTION get_client_billing_stats(t_id UUID, c_id BIGINT)
RETURNS TABLE (
    total_billed NUMERIC,
    total_paid NUMERIC,
    outstanding NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COALESCE(SUM(total_amount), 0)::NUMERIC,
        COALESCE(SUM(CASE WHEN status = 'paid' THEN total_amount ELSE 0 END), 0)::NUMERIC,
        (COALESCE(SUM(total_amount), 0) - COALESCE(SUM(CASE WHEN status = 'paid' THEN total_amount ELSE 0 END), 0))::NUMERIC
    FROM invoices
    WHERE team_id = t_id AND client_id = c_id AND status != 'draft' AND status != 'voided';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
