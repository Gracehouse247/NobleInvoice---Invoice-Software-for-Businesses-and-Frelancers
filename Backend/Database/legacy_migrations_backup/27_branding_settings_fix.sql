-- 27_branding_settings_fix.sql
-- Fixes missing columns for template selection and logo persistence.

DO $$
BEGIN
    -- 1. Ensure profiles has default_invoice_template and brand_logo_url (for safety)
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='profiles' AND column_name='default_invoice_template') THEN
        ALTER TABLE public.profiles ADD COLUMN default_invoice_template TEXT;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='profiles' AND column_name='brand_logo_url') THEN
        ALTER TABLE public.profiles ADD COLUMN brand_logo_url TEXT;
    END IF;

    -- 2. Ensure teams has default_invoice_template
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='teams' AND column_name='default_invoice_template') THEN
        ALTER TABLE public.teams ADD COLUMN default_invoice_template TEXT;
    END IF;

    -- 3. Ensure teams has default tax settings (if not already there)
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='teams' AND column_name='default_vat_rate') THEN
        ALTER TABLE public.teams ADD COLUMN default_vat_rate NUMERIC DEFAULT 0;
    END IF;
END $$;
