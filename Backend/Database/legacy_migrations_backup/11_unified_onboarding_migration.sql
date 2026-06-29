-- ==========================================
-- NobleGo: Unified Onboarding State Sync
-- ==========================================

-- 1. Update Profiles with Onboarding Status
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='profiles' AND column_name='onboarding_completed') THEN
        ALTER TABLE public.profiles ADD COLUMN onboarding_completed BOOLEAN DEFAULT FALSE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='profiles' AND column_name='business_industry') THEN
        ALTER TABLE public.profiles ADD COLUMN business_industry TEXT;
    END IF;
END $$;

-- 2. Ensure Teams table has all Branding Columns
DO $$
BEGIN
    -- Logo
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='teams' AND column_name='brand_logo_url') THEN
        ALTER TABLE public.teams ADD COLUMN brand_logo_url TEXT;
    END IF;
    
    -- Primary Brand Color
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='teams' AND column_name='brand_color') THEN
        ALTER TABLE public.teams ADD COLUMN brand_color TEXT DEFAULT '#2563EB';
    END IF;

    -- Secondary Accent Color
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='teams' AND column_name='secondary_color') THEN
        ALTER TABLE public.teams ADD COLUMN secondary_color TEXT DEFAULT '#1E293B';
    END IF;

    -- Business Contact Info
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='teams' AND column_name='business_address') THEN
        ALTER TABLE public.teams ADD COLUMN business_address TEXT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='teams' AND column_name='business_email') THEN
        ALTER TABLE public.teams ADD COLUMN business_email TEXT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='teams' AND column_name='business_phone') THEN
        ALTER TABLE public.teams ADD COLUMN business_phone TEXT;
    END IF;

    -- Invoicing Config
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='teams' AND column_name='tax_number') THEN
        ALTER TABLE public.teams ADD COLUMN tax_number TEXT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='teams' AND column_name='invoice_footer') THEN
        ALTER TABLE public.teams ADD COLUMN invoice_footer TEXT;
    END IF;

    -- Brand Voice
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='teams' AND column_name='brand_voice') THEN
        ALTER TABLE public.teams ADD COLUMN brand_voice TEXT DEFAULT 'Professional & Trusted';
    END IF;
END $$;
