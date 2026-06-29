-- ============================================================
-- Migration: Add updated_at columns and triggers to Identity tables
-- ============================================================

-- 1. Add updated_at column to identity_leads if it doesn't exist
ALTER TABLE public.identity_leads 
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT NOW();

-- 2. Create trigger for public.identities
DROP TRIGGER IF EXISTS set_identities_updated_at ON public.identities;
CREATE TRIGGER set_identities_updated_at
BEFORE UPDATE ON public.identities
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- 3. Create trigger for public.identity_leads
DROP TRIGGER IF EXISTS set_identity_leads_updated_at ON public.identity_leads;
CREATE TRIGGER set_identity_leads_updated_at
BEFORE UPDATE ON public.identity_leads
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();
