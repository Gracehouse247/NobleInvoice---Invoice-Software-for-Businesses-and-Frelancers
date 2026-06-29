-- ==========================================
-- NobleGo: Final Schema Repair & Onboarding Fix (V3)
-- ==========================================
-- FIXES:
-- 1. All missing columns for Branding & Onboarding
-- 2. CRITICAL RLS Policies for Self-Healing
-- 3. CRITICAL RLS Policies for CRM (Clients, Products, Invoices)

DO $$
BEGIN
    -- 1. FIX PROFILES TABLE
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='profiles' AND column_name='business_name') THEN
        ALTER TABLE public.profiles ADD COLUMN business_name TEXT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='profiles' AND column_name='industry') THEN
        ALTER TABLE public.profiles ADD COLUMN industry TEXT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='profiles' AND column_name='country') THEN
        ALTER TABLE public.profiles ADD COLUMN country TEXT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='profiles' AND column_name='brand_color') THEN
        ALTER TABLE public.profiles ADD COLUMN brand_color TEXT DEFAULT '#2563EB';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='profiles' AND column_name='secondary_color') THEN
        ALTER TABLE public.profiles ADD COLUMN secondary_color TEXT DEFAULT '#1E293B';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='profiles' AND column_name='brand_voice') THEN
        ALTER TABLE public.profiles ADD COLUMN brand_voice TEXT DEFAULT 'Professional';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='profiles' AND column_name='brand_logo_url') THEN
        ALTER TABLE public.profiles ADD COLUMN brand_logo_url TEXT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='profiles' AND column_name='tax_number') THEN
        ALTER TABLE public.profiles ADD COLUMN tax_number TEXT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='profiles' AND column_name='invoice_footer') THEN
        ALTER TABLE public.profiles ADD COLUMN invoice_footer TEXT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='profiles' AND column_name='onboarding_completed') THEN
        ALTER TABLE public.profiles ADD COLUMN onboarding_completed BOOLEAN DEFAULT FALSE;
    END IF;

    -- 2. FIX TEAMS TABLE
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='teams' AND column_name='brand_color') THEN
        IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='teams' AND column_name='primary_color') THEN
            ALTER TABLE public.teams RENAME COLUMN primary_color TO brand_color;
        ELSE
            ALTER TABLE public.teams ADD COLUMN brand_color TEXT DEFAULT '#2563EB';
        END IF;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='teams' AND column_name='secondary_color') THEN
        ALTER TABLE public.teams ADD COLUMN secondary_color TEXT DEFAULT '#1E293B';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='teams' AND column_name='brand_voice') THEN
        ALTER TABLE public.teams ADD COLUMN brand_voice TEXT DEFAULT 'Professional';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='teams' AND column_name='brand_logo_url') THEN
        IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='teams' AND column_name='logo_url') THEN
            ALTER TABLE public.teams RENAME COLUMN logo_url TO brand_logo_url;
        ELSE
            ALTER TABLE public.teams ADD COLUMN brand_logo_url TEXT;
        END IF;
    END IF;
END $$;

-- 3. STORAGE & BUCKETS
INSERT INTO storage.buckets (id, name, public) VALUES ('brand-assets', 'brand-assets', true) ON CONFLICT (id) DO NOTHING;

-- 4. CRITICAL: CRM RLS POLICIES (Fixes "Save Client", "Save Product", "Save Invoice")
-- Enable RLS (In case script is re-run)
ALTER TABLE public.clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.product_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.invoices ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.invoice_items ENABLE ROW LEVEL SECURITY;

-- CLIENTS: Allow access to everyone in the same team
DROP POLICY IF EXISTS "Team members can access clients" ON public.clients;
CREATE POLICY "Team members can access clients" ON public.clients 
FOR ALL USING (
    EXISTS (SELECT 1 FROM public.team_members WHERE team_id = clients.team_id AND user_id = auth.uid())
);

-- PRODUCTS: Allow access to everyone in the same team
DROP POLICY IF EXISTS "Team members can access products" ON public.products;
CREATE POLICY "Team members can access products" ON public.products 
FOR ALL USING (
    EXISTS (SELECT 1 FROM public.team_members WHERE team_id = products.team_id AND user_id = auth.uid())
);

-- INVOICES: Allow access to everyone in the same team
DROP POLICY IF EXISTS "Team members can access invoices" ON public.invoices;
CREATE POLICY "Team members can access invoices" ON public.invoices 
FOR ALL USING (
    EXISTS (SELECT 1 FROM public.team_members WHERE team_id = invoices.team_id AND user_id = auth.uid())
);

-- INVOICE ITEMS
DROP POLICY IF EXISTS "Team members can access invoice items" ON public.invoice_items;
CREATE POLICY "Team members can access invoice items" ON public.invoice_items 
FOR ALL USING (
    EXISTS (SELECT 1 FROM public.invoices i WHERE i.id = invoice_items.invoice_id AND EXISTS (SELECT 1 FROM public.team_members WHERE team_id = i.team_id AND user_id = auth.uid()))
);

-- 5. RE-SYNC TRIGGERS (Self-Healing)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.team_members ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can insert own profile" ON public.profiles;
CREATE POLICY "Users can insert own profile" ON public.profiles FOR INSERT WITH CHECK (auth.uid() = id);

DROP POLICY IF EXISTS "Users can create own teams" ON public.teams;
CREATE POLICY "Users can create own teams" ON public.teams FOR INSERT WITH CHECK (auth.uid() = owner_id);

DROP POLICY IF EXISTS "Users can join team as member" ON public.team_members;
CREATE POLICY "Users can join team as member" ON public.team_members FOR INSERT WITH CHECK (auth.uid() = user_id);
