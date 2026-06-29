-- ==============================================================================
-- NOBLEGO: INVOICE ITEMS & RECURRING INVOICES RLS FIX
-- ==============================================================================

-- Drop if exist
DROP POLICY IF EXISTS "Invoice items management" ON public.invoice_items;
DROP POLICY IF EXISTS "Recurring invoice management" ON public.recurring_invoices;

-- Invoice items policy: Access if user has access to the parent invoice's team
CREATE POLICY "Invoice items management" ON public.invoice_items
  FOR ALL TO authenticated 
  USING (
    EXISTS (
      SELECT 1 FROM public.invoices 
      WHERE invoices.id = invoice_items.invoice_id
      AND public.is_team_member(invoices.team_id)
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.invoices 
      WHERE invoices.id = invoice_items.invoice_id
      AND public.is_team_member(invoices.team_id)
    )
  );

-- Recurring invoices policy: Access based on team_id directly
CREATE POLICY "Recurring invoice management" ON public.recurring_invoices
  FOR ALL TO authenticated 
  USING (public.is_team_member(team_id))
  WITH CHECK (public.is_team_member(team_id));
