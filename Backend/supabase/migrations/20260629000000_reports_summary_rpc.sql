-- RPC: get_reports_summary
-- Returns aggregated monthly stats for the current user filtered by date range.
CREATE OR REPLACE FUNCTION public.get_reports_summary(
  p_user_id UUID,
  p_start_date TIMESTAMPTZ,
  p_end_date   TIMESTAMPTZ
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_team_id UUID;
  v_result  JSONB;
BEGIN
  -- Resolve team for user
  SELECT id INTO v_team_id FROM public.teams WHERE owner_id = p_user_id LIMIT 1;
  IF v_team_id IS NULL THEN v_team_id := p_user_id; END IF;

  SELECT jsonb_build_object(
    'total_revenue',   COALESCE(SUM(CASE WHEN status = 'paid' THEN total_amount ELSE 0 END), 0),
    'total_invoices',  COUNT(*),
    'paid_count',      COUNT(CASE WHEN status = 'paid' THEN 1 END),
    'active_clients',  COUNT(DISTINCT client_id),
    'avg_invoice_value', COALESCE(AVG(CASE WHEN status = 'paid' THEN total_amount END), 0),
    'monthly_buckets', (
      SELECT jsonb_agg(bucket ORDER BY bucket_month)
      FROM (
        SELECT
          to_char(date_trunc('month', created_at), 'Mon') AS month,
          date_trunc('month', created_at)                  AS bucket_month,
          SUM(CASE WHEN status = 'paid' THEN total_amount ELSE 0 END) AS revenue,
          COUNT(*) AS invoices,
          COUNT(DISTINCT client_id) AS clients
        FROM public.invoices
        WHERE team_id = v_team_id
          AND created_at >= p_start_date
          AND created_at <= p_end_date
        GROUP BY 1, 2
      ) bucket
    ),
    'top_clients', (
      SELECT jsonb_agg(c ORDER BY c_revenue DESC)
      FROM (
        SELECT
          cl.name                                                      AS name,
          SUM(CASE WHEN i.status = 'paid' THEN i.total_amount ELSE 0 END) AS c_revenue,
          COUNT(i.id)                                                  AS invoice_count
        FROM public.invoices i
        JOIN public.clients cl ON cl.id = i.client_id
        WHERE i.team_id = v_team_id
          AND i.created_at >= p_start_date
          AND i.created_at <= p_end_date
        GROUP BY cl.name
        ORDER BY c_revenue DESC
        LIMIT 5
      ) c
    )
  )
  INTO v_result
  FROM public.invoices
  WHERE team_id = v_team_id
    AND created_at >= p_start_date
    AND created_at <= p_end_date;

  RETURN v_result;
END;
$$;

GRANT EXECUTE ON FUNCTION public.get_reports_summary(UUID, TIMESTAMPTZ, TIMESTAMPTZ) TO authenticated;
