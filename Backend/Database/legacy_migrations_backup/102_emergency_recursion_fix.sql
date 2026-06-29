-- ==============================================================================
-- NobleGo: EMERGENCY RECURSION & RLS CONSOLIDATION
-- File: 102_emergency_recursion_fix.sql
-- Run this in your Supabase SQL Editor to resolve "Connection reset by peer" errors.
-- ==============================================================================

-- 1. RE-CREATE HELPERS (Robust, Non-Recursive)
-- SECURITY DEFINER bypasses RLS, search_path = public prevents search-path attacks.

CREATE OR REPLACE FUNCTION public.safe_check_is_member(t_id uuid)
RETURNS boolean AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.team_members 
    WHERE team_members.team_id = t_id 
    AND team_members.user_id = auth.uid()
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

CREATE OR REPLACE FUNCTION public.safe_check_is_owner(t_id uuid)
RETURNS boolean AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.teams 
    WHERE teams.id = t_id 
    AND teams.owner_id = auth.uid()
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

-- 2. RESET: Clean Slate for all core tables (Dropping all known conflicting policies)
DO $$
DECLARE
    pol RECORD;
BEGIN
    FOR pol IN 
        SELECT policyname, tablename 
        FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename IN ('teams', 'team_members', 'clients', 'invoices', 'products', 'expenses', 'invoice_items', 'product_categories')
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON public.%I', pol.policyname, pol.tablename);
    END LOOP;
END $$;

-- 3. IMPLEMENT THE UNIFIED NON-RECURSIVE POLICIES

-- TEAMS: You can see teams you own or are a member of
CREATE POLICY "Teams: Unified Access" ON public.teams
  FOR ALL TO authenticated 
  USING (owner_id = auth.uid() OR safe_check_is_member(id));

-- TEAM_MEMBERS: You can see memberships for your teams
-- (Crucial: This only queries teams via owner check to break the membership loop)
CREATE POLICY "Team Members: Unified Access" ON public.team_members
  FOR ALL TO authenticated 
  USING (user_id = auth.uid() OR safe_check_is_owner(team_id));

-- CLIENTS: Based on safe member check
CREATE POLICY "Clients: Unified Access" ON public.clients
  FOR ALL TO authenticated 
  USING (safe_check_is_member(team_id))
  WITH CHECK (safe_check_is_member(team_id));

-- PRODUCTS: Based on safe member check
CREATE POLICY "Products: Unified Access" ON public.products
  FOR ALL TO authenticated 
  USING (safe_check_is_member(team_id))
  WITH CHECK (safe_check_is_member(team_id));

-- PRODUCT CATEGORIES: Based on safe member check
CREATE POLICY "Product Categories: Unified Access" ON public.product_categories
  FOR ALL TO authenticated 
  USING (safe_check_is_member(team_id))
  WITH CHECK (safe_check_is_member(team_id));

-- INVOICES: Based on safe member check
CREATE POLICY "Invoices: Unified Access" ON public.invoices
  FOR ALL TO authenticated 
  USING (safe_check_is_member(team_id))
  WITH CHECK (safe_check_is_member(team_id));

-- INVOICE ITEMS: Inherits from invoice parent check
CREATE POLICY "Invoice Items: Unified Access" ON public.invoice_items
  FOR ALL TO authenticated 
  USING (
    EXISTS (
      SELECT 1 FROM public.invoices 
      WHERE invoices.id = invoice_items.invoice_id 
      AND safe_check_is_member(invoices.team_id)
    )
  );

-- EXPENSES: Based on safe member check
CREATE POLICY "Expenses: Unified Access" ON public.expenses
  FOR ALL TO authenticated 
  USING (safe_check_is_member(team_id))
  WITH CHECK (safe_check_is_member(team_id));

-- 4. FINAL VERIFY
SELECT policyname, tablename, cmd FROM pg_policies 
WHERE tablename IN ('team_members', 'clients', 'invoices', 'teams', 'expenses')
ORDER BY tablename;
