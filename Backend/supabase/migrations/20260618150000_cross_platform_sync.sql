-- Migration: cross_platform_sync
-- Purpose: Sync branding fields from profiles to teams table to prevent mismatch across Mobile/Web

-- 1. Create the function that will perform the sync
CREATE OR REPLACE FUNCTION public.sync_profile_branding_to_team()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE public.teams
  SET 
    name = NEW.business_name,
    business_address = NEW.business_address,
    business_email = NEW.business_email,
    business_phone = NEW.business_phone,
    tax_number = NEW.tax_number,
    brand_color = NEW.brand_color,
    secondary_color = NEW.secondary_color,
    brand_logo_url = NEW.brand_logo_url,
    brand_signature_url = NEW.brand_signature_url,
    brand_voice = NEW.brand_voice,
    invoice_footer = NEW.invoice_footer
  WHERE owner_id = NEW.id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. Drop the trigger if it exists to avoid conflicts during testing/re-runs
DROP TRIGGER IF EXISTS on_profile_branding_updated ON public.profiles;

-- 3. Create the trigger to fire AFTER an UPDATE on the relevant columns of the profiles table
CREATE TRIGGER on_profile_branding_updated
  AFTER UPDATE OF 
    business_name, 
    business_address, 
    business_email, 
    business_phone, 
    tax_number, 
    brand_color, 
    secondary_color, 
    brand_logo_url, 
    brand_signature_url, 
    brand_voice, 
    invoice_footer
  ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.sync_profile_branding_to_team();
