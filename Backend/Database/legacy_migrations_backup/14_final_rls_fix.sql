-- ==============================================================================
-- NOBLEGO: FINAL RLS REPAIR V2 (The Nuclear Solution)
-- Fixes Infinite Recursion in Teams/TeamMembers and ensures data persistence.
-- ==============================================================================

-- 1. Helper Function: Check Team Membership (SECURITY DEFINER bypasses RLS)
CREATE OR REPLACE FUNCTION public.is_team_member(team_id_to_check uuid)
RETURNS boolean AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.team_members
    WHERE team_id = team_id_to_check
    AND user_id = auth.uid()
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

-- 2. Helper Function: Check if user is the Owner of a Team
CREATE OR REPLACE FUNCTION public.is_team_owner(team_id_to_check uuid)
RETURNS boolean AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.teams
    WHERE id = team_id_to_check
    AND owner_id = auth.uid()
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

-- 3. CLEAN START: Drop all existing conflicting policies on CORE tables
-- Drop from teams
DROP POLICY IF EXISTS "Users can view teams they belong to" ON public.teams;
DROP POLICY IF EXISTS "Owners can manage teams" ON public.teams;
DROP POLICY IF EXISTS "Team visibility" ON public.teams;
DROP POLICY IF EXISTS "Team management" ON public.teams;

-- Drop from team_members
DROP POLICY IF EXISTS "Users can view members of their teams" ON public.team_members;
DROP POLICY IF EXISTS "Owners and Admins manage team members" ON public.team_members;
DROP POLICY IF EXISTS "Member visibility" ON public.team_members;
DROP POLICY IF EXISTS "Team members visibility" ON public.team_members;

-- Drop from clients
DROP POLICY IF EXISTS "Client management" ON public.clients;
DROP POLICY IF EXISTS "Client access" ON public.clients;

-- Drop from invoices
DROP POLICY IF EXISTS "Invoice management" ON public.invoices;
DROP POLICY IF EXISTS "Invoice access" ON public.invoices;

-- 4. IMPLEMENT NON-RECURSIVE POLICIES

-- TEAMS
CREATE POLICY "Teams visibility" ON public.teams
  FOR SELECT TO authenticated 
  USING (owner_id = auth.uid() OR is_team_member(id));

CREATE POLICY "Teams management" ON public.teams
  FOR ALL TO authenticated 
  USING (owner_id = auth.uid())
  WITH CHECK (owner_id = auth.uid());

-- TEAM MEMBERS
CREATE POLICY "Team members visibility" ON public.team_members
  FOR SELECT TO authenticated 
  USING (user_id = auth.uid() OR is_team_member(team_id));

CREATE POLICY "Team members management" ON public.team_members
  FOR ALL TO authenticated 
  USING (is_team_owner(team_id) OR user_id = auth.uid())
  WITH CHECK (is_team_owner(team_id) OR user_id = auth.uid());

-- CLIENTS
CREATE POLICY "Client management" ON public.clients
  FOR ALL TO authenticated 
  USING (is_team_member(team_id))
  WITH CHECK (is_team_member(team_id));

-- INVOICES
CREATE POLICY "Invoice management" ON public.invoices
  FOR ALL TO authenticated 
  USING (is_team_member(team_id))
  WITH CHECK (is_team_member(team_id));

-- PRODUCTS
DROP POLICY IF EXISTS "Product management" ON public.products;
DROP POLICY IF EXISTS "Product access" ON public.products;
CREATE POLICY "Product management" ON public.products
  FOR ALL TO authenticated 
  USING (is_team_member(team_id))
  WITH CHECK (is_team_member(team_id));

-- 5. VERIFY
SELECT policyname, tablename, cmd FROM pg_policies 
WHERE tablename IN ('teams', 'team_members', 'clients', 'invoices', 'products');
