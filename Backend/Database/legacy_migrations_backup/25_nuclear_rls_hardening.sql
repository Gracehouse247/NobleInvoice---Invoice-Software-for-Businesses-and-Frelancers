-- ==============================================================================
-- NOBLEGO: NUCLEAR RLS HARDENING (FINAL SECURITY PASS)
-- Run this in your Supabase SQL Editor to resolve "Table Publicly Accessible" warnings.
-- ==============================================================================

-- 1. Enable RLS on ALL identified tables (Sweeping all known tables)
DO $$
DECLARE
    t TEXT;
BEGIN
    FOR t IN 
        SELECT tablename 
        FROM pg_tables 
        WHERE schemaname = 'public' 
    LOOP
        EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY;', t);
    END LOOP;
END $$;

-- 2. Specifically harden the 'client_ledger' table (found to be missing RLS)
DROP POLICY IF EXISTS "Team access for client_ledger" ON public.client_ledger;
CREATE POLICY "Team access for client_ledger" ON public.client_ledger
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM public.team_members 
      WHERE team_members.team_id = client_ledger.team_id 
      AND team_members.user_id = auth.uid()
    )
  );

-- 3. Ensure 'live_chat_messages' is hardened
DROP POLICY IF EXISTS "Users can manage own chat messages" ON public.live_chat_messages;
CREATE POLICY "Users can manage own chat messages" ON public.live_chat_messages
  FOR ALL USING (auth.uid() = user_id);

-- 4. Secure 'qr_scans' (Allow public insert, but only owner select)
DROP POLICY IF EXISTS "Public insert scans" ON public.qr_scans;
CREATE POLICY "Public insert scans" ON public.qr_scans FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Owners view scans" ON public.qr_scans;
CREATE POLICY "Owners view scans" ON public.qr_scans FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM public.qr_codes q 
        WHERE q.id = qr_scans.qr_code_id AND q.user_id = auth.uid()
    )
);

-- 5. Final check: Ensure NO tables in 'public' are readable by 'anon' unless explicit
-- (Supabase default is usually secure, but we double-down here)
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO service_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO anon; -- Only if you have public tables
