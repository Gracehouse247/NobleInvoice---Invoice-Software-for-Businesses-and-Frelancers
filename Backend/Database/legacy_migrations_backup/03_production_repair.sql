-- ==============================================================================
-- NOBLEGO: PRODUCTION REPAIR MIGRATION
-- Run this ENTIRE script in Supabase SQL Editor to fix all issues
-- ==============================================================================

-- ── 1. Add missing columns to clients table ────────────────────────────────
ALTER TABLE public.clients
  ADD COLUMN IF NOT EXISTS business_name  TEXT,
  ADD COLUMN IF NOT EXISTS position       TEXT,
  ADD COLUMN IF NOT EXISTS country_code   TEXT DEFAULT '+234',
  ADD COLUMN IF NOT EXISTS company_name   TEXT;

-- ── 2. Add missing profiles columns (if not present) ──────────────────────
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS company        TEXT,
  ADD COLUMN IF NOT EXISTS industry       TEXT,
  ADD COLUMN IF NOT EXISTS country        TEXT;

-- ── 3. FIX THE ROOT CAUSE: Add RLS policies for clients table ─────────────
-- These were MISSING and causing ALL insert/select operations to fail silently

-- Drop any existing policies on clients to start clean
DROP POLICY IF EXISTS "Access team clients"        ON public.clients;
DROP POLICY IF EXISTS "Team members view clients"  ON public.clients;
DROP POLICY IF EXISTS "Team members insert clients" ON public.clients;
DROP POLICY IF EXISTS "Team members update clients" ON public.clients;
DROP POLICY IF EXISTS "Team members delete clients" ON public.clients;

-- Allow team members to SELECT their team's clients
CREATE POLICY "Team members view clients" ON public.clients
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.team_members
      WHERE team_members.team_id = clients.team_id
        AND team_members.user_id = auth.uid()
    )
  );

-- Allow team members to INSERT clients for their team
CREATE POLICY "Team members insert clients" ON public.clients
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.team_members
      WHERE team_members.team_id = clients.team_id
        AND team_members.user_id = auth.uid()
    )
  );

-- Allow team members to UPDATE their team's clients
CREATE POLICY "Team members update clients" ON public.clients
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM public.team_members
      WHERE team_members.team_id = clients.team_id
        AND team_members.user_id = auth.uid()
    )
  );

-- Allow team members to DELETE their team's clients
CREATE POLICY "Team members delete clients" ON public.clients
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM public.team_members
      WHERE team_members.team_id = clients.team_id
        AND team_members.user_id = auth.uid()
    )
  );

-- ── 4. FIX RLS policies for products table ────────────────────────────────
DROP POLICY IF EXISTS "Team members view products"   ON public.products;
DROP POLICY IF EXISTS "Team members manage products" ON public.products;

CREATE POLICY "Team members manage products" ON public.products
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM public.team_members
      WHERE team_members.team_id = products.team_id
        AND team_members.user_id = auth.uid()
    )
  );

-- ── 5. FIX RLS policies for invoices table ────────────────────────────────
DROP POLICY IF EXISTS "Team members view invoices"   ON public.invoices;
DROP POLICY IF EXISTS "Team members manage invoices" ON public.invoices;

CREATE POLICY "Team members manage invoices" ON public.invoices
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM public.team_members
      WHERE team_members.team_id = invoices.team_id
        AND team_members.user_id = auth.uid()
    )
  );

-- ── 6. FIX RLS for invoice_items (linked to invoices) ─────────────────────
DROP POLICY IF EXISTS "Team members manage invoice_items" ON public.invoice_items;

CREATE POLICY "Team members manage invoice_items" ON public.invoice_items
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM public.invoices i
      JOIN public.team_members tm ON tm.team_id = i.team_id
      WHERE i.id = invoice_items.invoice_id
        AND tm.user_id = auth.uid()
    )
  );

-- ── 7. Fix profiles: Allow users to INSERT their own profile ──────────────
DROP POLICY IF EXISTS "Users insert own profile" ON public.profiles;
CREATE POLICY "Users insert own profile" ON public.profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

-- ── 8. Fix teams: Allow owner to INSERT a team ────────────────────────────
DROP POLICY IF EXISTS "Owners can insert teams" ON public.teams;
CREATE POLICY "Owners can insert teams" ON public.teams
  FOR INSERT WITH CHECK (auth.uid() = owner_id);

-- ── 9. Fix team_members: Allow users to INSERT themselves ─────────────────
DROP POLICY IF EXISTS "Owners can insert team_members" ON public.team_members;
CREATE POLICY "Owners can insert team_members" ON public.team_members
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- ── 10. Verify fix worked ─────────────────────────────────────────────────
SELECT schemaname, tablename, policyname, cmd
FROM pg_policies
WHERE tablename IN ('clients', 'invoices', 'products')
ORDER BY tablename, cmd;
