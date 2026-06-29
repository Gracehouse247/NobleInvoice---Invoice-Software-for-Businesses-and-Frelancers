-- ==============================================================================
-- NOBLEGO: IDEMPOTENT RLS REPAIR SCRIPT (V2)
-- Run this ENTIRE script in Supabase SQL Editor.
-- It will safely replace existing policies to fix the recursion error.
-- ==============================================================================

-- ── 1. Fix Profiles table ──────────────────────────────────────────────────
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS fcm_token TEXT;

-- ── 2. FIX TEAM_MEMBERS RECURSION ──────────────────────────────────────────
-- Drop ALL variations of policy names to ensure a clean slate
DROP POLICY IF EXISTS "Users can view members of their teams" ON public.team_members;
DROP POLICY IF EXISTS "Owners and Admins manage team members" ON public.team_members;
DROP POLICY IF EXISTS "Owners can insert team_members" ON public.team_members;
DROP POLICY IF EXISTS "Team members visibility" ON public.team_members;
DROP POLICY IF EXISTS "Team members insert" ON public.team_members;

-- Safe creation of new, non-recursive policies
CREATE POLICY "Team members visibility" ON public.team_members FOR SELECT TO authenticated
USING ( 
  user_id = auth.uid() OR 
  team_id IN (SELECT id FROM public.teams WHERE owner_id = auth.uid())
);

CREATE POLICY "Team members insert" ON public.team_members FOR INSERT TO authenticated
WITH CHECK (
  user_id = auth.uid() OR
  team_id IN (SELECT id FROM public.teams WHERE owner_id = auth.uid())
);

-- ── 3. FIX CLIENTS POLICIES ────────────────────────────────────────────────
DROP POLICY IF EXISTS "Team members view clients"   ON public.clients;
DROP POLICY IF EXISTS "Team members insert clients" ON public.clients;
DROP POLICY IF EXISTS "Team members update clients" ON public.clients;
DROP POLICY IF EXISTS "Team members delete clients" ON public.clients;
DROP POLICY IF EXISTS "Client access" ON public.clients;

CREATE POLICY "Client access" ON public.clients FOR ALL TO authenticated
USING (
  team_id IN (SELECT team_id FROM public.team_members WHERE user_id = auth.uid())
)
WITH CHECK (
  team_id IN (SELECT team_id FROM public.team_members WHERE user_id = auth.uid())
);

-- ── 4. FIX INVOICES & PRODUCTS ─────────────────────────────────────────────
DROP POLICY IF EXISTS "Team members manage products" ON public.products;
DROP POLICY IF EXISTS "Product access" ON public.products;
CREATE POLICY "Product access" ON public.products FOR ALL TO authenticated
USING ( team_id IN (SELECT team_id FROM public.team_members WHERE user_id = auth.uid()) );

DROP POLICY IF EXISTS "Team members manage invoices" ON public.invoices;
DROP POLICY IF EXISTS "Invoice access" ON public.invoices;
CREATE POLICY "Invoice access" ON public.invoices FOR ALL TO authenticated
USING ( team_id IN (SELECT team_id FROM public.team_members WHERE user_id = auth.uid()) );

-- ── 5. VERIFY ──────────────────────────────────────────────────────────────
SELECT schemaname, tablename, policyname FROM pg_policies 
WHERE tablename IN ('team_members', 'clients', 'profiles')
ORDER BY tablename;
