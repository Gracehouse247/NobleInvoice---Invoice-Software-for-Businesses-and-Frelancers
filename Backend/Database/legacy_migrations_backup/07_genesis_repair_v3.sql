-- ==============================================================================
-- NOBLEGO: THE "GENESIS" DB REPAIR (Resolution V3 - ULTIMATE)
-- Safe-guarding against missing 'team_id' columns in legacy tables.
-- ==============================================================================

-- ── 1. HELPERS: SECURITY DEFINER ───────────────────────────────────────────
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

-- ── 2. SCHEMA SYNC: Ensure team_id exists on all business tables ───────────
DO $$
DECLARE
    tbl TEXT;
    tables TEXT[] := ARRAY['clients', 'invoices', 'products', 'expenses', 'vendors', 'folders', 'qr_codes'];
BEGIN
    FOREACH tbl IN ARRAY tables LOOP
        -- If table exists but team_id column doesn't, add it.
        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = tbl) AND
           NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = tbl AND column_name = 'team_id') THEN
            EXECUTE format('ALTER TABLE %I ADD COLUMN team_id UUID REFERENCES public.teams(id) ON DELETE CASCADE', tbl);
        END IF;
    END LOOP;
END $$;

-- ── 3. NUCLEAR WIPE ────────────────────────────────────────────────────────
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT policyname, tablename 
        FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename IN ('profiles', 'teams', 'team_members', 'clients', 'products', 'invoices', 'invoice_items', 'expenses', 'vendors', 'stock_ledger', 'folders', 'qr_codes')
    ) LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON %I', r.policyname, r.tablename);
    END LOOP;
END $$;

-- ── 4. IMPLEMENT CLEAN RLS ──────────────────────────────────────────────────

-- PROFILES
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Profiles select" ON public.profiles FOR SELECT TO authenticated USING (true);
CREATE POLICY "Profiles update" ON public.profiles FOR UPDATE TO authenticated USING (id = auth.uid());
CREATE POLICY "Profiles insert" ON public.profiles FOR INSERT TO authenticated WITH CHECK (id = auth.uid());

-- TEAMS
ALTER TABLE public.teams ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Teams select" ON public.teams FOR SELECT TO authenticated USING (owner_id = auth.uid() OR check_is_member(id));
CREATE POLICY "Teams insert" ON public.teams FOR INSERT TO authenticated WITH CHECK (owner_id = auth.uid());
CREATE POLICY "Teams update" ON public.teams FOR UPDATE TO authenticated USING (owner_id = auth.uid());

-- TEAM MEMBERS
ALTER TABLE public.team_members ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Members select" ON public.team_members FOR SELECT TO authenticated USING (user_id = auth.uid() OR check_is_owner(team_id));
CREATE POLICY "Members insert" ON public.team_members FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid() OR check_is_owner(team_id));

-- SHARED BUSINESS TABLES
DO $$
DECLARE
    tbl TEXT;
    tables TEXT[] := ARRAY['clients', 'invoices', 'products', 'expenses', 'vendors', 'folders', 'qr_codes'];
BEGIN
    FOREACH tbl IN ARRAY tables LOOP
        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = tbl) THEN
            EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY', tbl);
            EXECUTE format('CREATE POLICY "Team access for %s" ON %I FOR ALL TO authenticated USING (check_is_member(team_id)) WITH CHECK (check_is_member(team_id))', tbl, tbl);
        END IF;
    END LOOP;
END $$;

-- ── 5. FINAL TABLE SYNC ────────────────────────────────────────────────────
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS fcm_token TEXT;
-- Advanced CRM columns
ALTER TABLE public.clients ADD COLUMN IF NOT EXISTS business_name TEXT;
ALTER TABLE public.clients ADD COLUMN IF NOT EXISTS position TEXT;
ALTER TABLE public.clients ADD COLUMN IF NOT EXISTS country_code TEXT;

-- ── 6. VERIFY
SELECT policyname, tablename, cmd FROM pg_policies WHERE schemaname = 'public' ORDER BY tablename;
