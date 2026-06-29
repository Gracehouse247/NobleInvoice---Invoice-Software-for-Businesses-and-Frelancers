-- ==============================================================================
-- NOBLEGO: THE "NUCLEAR" RLS REPAIR (Final Solution)
-- This script eliminates ALL recursion by using Security Definer lookups 
-- for EVERY security check. 
-- ==============================================================================

-- ── 1. HELPERS: SECURITY DEFINER (Bypasses parent RLS) ──────────────────────

-- Check if I am a member of a team WITHOUT triggering team_members RLS
CREATE OR REPLACE FUNCTION public.check_is_member(t_id uuid)
RETURNS boolean AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.team_members 
    WHERE team_members.team_id = t_id 
    AND team_members.user_id = auth.uid()
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

-- Check if I am the OWNER of a team WITHOUT triggering teams RLS
CREATE OR REPLACE FUNCTION public.check_is_owner(t_id uuid)
RETURNS boolean AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.teams 
    WHERE teams.id = t_id 
    AND teams.owner_id = auth.uid()
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

-- ── 2. RESET: Clean Slate for all core tables ──────────────────────────────
DROP POLICY IF EXISTS "Member visibility" ON public.team_members;
DROP POLICY IF EXISTS "Team members visibility" ON public.team_members;
DROP POLICY IF EXISTS "Team members insert" ON public.team_members;
DROP POLICY IF EXISTS "Client management" ON public.clients;
DROP POLICY IF EXISTS "Client access" ON public.clients;
DROP POLICY IF EXISTS "Product management" ON public.products;
DROP POLICY IF EXISTS "Product access" ON public.products;
DROP POLICY IF EXISTS "Invoice management" ON public.invoices;
DROP POLICY IF EXISTS "Invoice access" ON public.invoices;
DROP POLICY IF EXISTS "Teams visibility" ON public.teams;
DROP POLICY IF EXISTS "Profile visibility" ON public.profiles;
DROP POLICY IF EXISTS "Profile management" ON public.profiles;

-- ── 3. IMPLEMENT THE ZERO-RECURSION POLICIES ────────────────────────────────

-- TEAMS: You can see teams you own or are a member of
CREATE POLICY "Teams visibility" ON public.teams
  FOR SELECT TO authenticated 
  USING (owner_id = auth.uid() OR check_is_member(id));

-- TEAM_MEMBERS: You can see memberships for your teams
CREATE POLICY "Member visibility" ON public.team_members
  FOR SELECT TO authenticated 
  USING (user_id = auth.uid() OR check_is_owner(team_id));

-- CLIENTS: Based on member check
CREATE POLICY "Client management" ON public.clients
  FOR ALL TO authenticated 
  USING (check_is_member(team_id))
  WITH CHECK (check_is_member(team_id));

-- PRODUCTS: Based on member check
CREATE POLICY "Product management" ON public.products
  FOR ALL TO authenticated 
  USING (check_is_member(team_id))
  WITH CHECK (check_is_member(team_id));

-- INVOICES: Based on member check
CREATE POLICY "Invoice management" ON public.invoices
  FOR ALL TO authenticated 
  USING (check_is_member(team_id))
  WITH CHECK (check_is_member(team_id));

-- PROFILES: Based on ID check
CREATE POLICY "Profile visibility" ON public.profiles
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "Profile management" ON public.profiles
  FOR UPDATE TO authenticated 
  USING (id = auth.uid());

-- ── 4. TABLE AUDIT ─────────────────────────────────────────────────────────
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS fcm_token TEXT;
ALTER TABLE public.clients ADD COLUMN IF NOT EXISTS business_name TEXT;
ALTER TABLE public.clients ADD COLUMN IF NOT EXISTS position TEXT;
ALTER TABLE public.clients ADD COLUMN IF NOT EXISTS country_code TEXT;

-- ── 5. FINAL VERIFY ────────────────────────────────────────────────────────
SELECT policyname, tablename, cmd FROM pg_policies 
WHERE tablename IN ('team_members', 'clients', 'profiles', 'invoices', 'teams')
ORDER BY tablename;
