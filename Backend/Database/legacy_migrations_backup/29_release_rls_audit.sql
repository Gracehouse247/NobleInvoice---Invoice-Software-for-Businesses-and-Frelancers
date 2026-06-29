-- c:\Projects\NobleGo\Database\29_release_rls_audit.sql
-- Final release audit of RLS policies for multi-tenant isolation.

-- 1. Client Ledger RLS
ALTER TABLE public.client_ledger ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Team access for client_ledger" ON public.client_ledger;
CREATE POLICY "Team access for client_ledger" 
  ON public.client_ledger FOR ALL 
  USING (is_team_member(team_id));

-- 2. Pending Invitations (Already handled in 28 but added here for audit consistency if needed)
-- (Skipped as 28 is fresh)

-- 3. Ensure Invoices and Invoice Items have strong team scoping
ALTER TABLE public.invoices ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Team access for invoices" ON public.invoices;
CREATE POLICY "Team access for invoices" 
  ON public.invoices FOR ALL 
  USING (is_team_member(team_id));

ALTER TABLE public.invoice_items ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Team access for invoice_items" ON public.invoice_items;
CREATE POLICY "Team access for invoice_items" 
  ON public.invoice_items FOR ALL 
  USING (
    EXISTS (
      SELECT 1 FROM public.invoices
      WHERE invoices.id = invoice_items.invoice_id
      AND is_team_member(invoices.team_id)
    )
  );

-- 4. Clients RLS
ALTER TABLE public.clients ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Team access for clients" ON public.clients;
CREATE POLICY "Team access for clients" 
  ON public.clients FOR ALL 
  USING (is_team_member(team_id));

-- 5. Business Cards RLS
ALTER TABLE public.business_cards ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Team access for business_cards" ON public.business_cards;
CREATE POLICY "Team access for business_cards" 
  ON public.business_cards FOR ALL 
  USING (is_team_member(team_id));

-- 6. QR History RLS (Corrected table name to qr_codes)
ALTER TABLE public.qr_codes ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Team access for qr_codes" ON public.qr_codes;
CREATE POLICY "Team access for qr_codes" 
  ON public.qr_codes FOR ALL 
  USING (is_team_member(team_id));
