-- ==============================================================================
-- NOBLEGO: INDUSTRIAL RLS REPAIR (Bypassing Recursion)
-- Best Practice: Using SECURITY DEFINER helper functions to break loops.
-- ==============================================================================

-- ── 1. Helper Function: Check Team Membership ──────────────────────────────
-- Definition: SECURITY DEFINER allows the function to bypass parent RLS.
-- This is the standard industry way to prevent "Infinite Recursion".
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

-- ── 2. Helper Function: Check Profile Ownership ───────────────────────────
CREATE OR REPLACE FUNCTION public.is_profile_owner(profile_id_to_check uuid)
RETURNS boolean AS $$
BEGIN
  RETURN profile_id_to_check = auth.uid();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

-- ── 3. CLEAN START: Drop all existing conflicting policies ────────────────
DROP POLICY IF EXISTS "Team members visibility" ON public.team_members;
DROP POLICY IF EXISTS "Team members insert" ON public.team_members;
DROP POLICY IF EXISTS "Client access" ON public.clients;
DROP POLICY IF EXISTS "Product access" ON public.products;
DROP POLICY IF EXISTS "Invoice access" ON public.invoices;
DROP POLICY IF EXISTS "Public profiles visibility" ON public.profiles;
DROP POLICY IF EXISTS "Owners update own profile" ON public.profiles;

-- ── 4. IMPLEMENT NON-RECURSIVE POLICIES ────────────────────────────────────

-- PROFILE POLICIES
CREATE POLICY "Profile visibility" ON public.profiles
  FOR SELECT TO authenticated USING (true); -- Everyone authenticated can see profiles (required for member lookups)

CREATE POLICY "Profile management" ON public.profiles
  FOR UPDATE TO authenticated USING (is_profile_owner(id));

-- TEAM MEMBERS POLICIES (The core fix)
CREATE POLICY "Member visibility" ON public.team_members
  FOR SELECT TO authenticated USING (
    user_id = auth.uid() OR team_id IN (SELECT id FROM teams WHERE owner_id = auth.uid())
  );

-- CLIENTS (Using the helper)
CREATE POLICY "Client management" ON public.clients
  FOR ALL TO authenticated 
  USING (is_team_member(team_id))
  WITH CHECK (is_team_member(team_id));

-- PRODUCTS
CREATE POLICY "Product management" ON public.products
  FOR ALL TO authenticated 
  USING (is_team_member(team_id))
  WITH CHECK (is_team_member(team_id));

-- INVOICES
CREATE POLICY "Invoice management" ON public.invoices
  FOR ALL TO authenticated 
  USING (is_team_member(team_id))
  WITH CHECK (is_team_member(team_id));

-- ── 5. FINAL TABLE SYNC ────────────────────────────────────────────────────
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS fcm_token TEXT;
ALTER TABLE public.clients ADD COLUMN IF NOT EXISTS business_name TEXT;
ALTER TABLE public.clients ADD COLUMN IF NOT EXISTS position TEXT;
ALTER TABLE public.clients ADD COLUMN IF NOT EXISTS country_code TEXT;

-- ── 6. VERIFY RESULTS ──────────────────────────────────────────────────────
SELECT policyname, tablename, cmd FROM pg_policies 
WHERE tablename IN ('team_members', 'clients', 'profiles', 'invoices');
