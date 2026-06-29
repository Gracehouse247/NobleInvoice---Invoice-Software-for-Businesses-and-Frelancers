ALTER TABLE public.identity_leads ADD COLUMN IF NOT EXISTS is_converted BOOLEAN DEFAULT false;
