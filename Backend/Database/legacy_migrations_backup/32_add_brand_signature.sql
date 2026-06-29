-- 32_add_brand_signature.sql
-- Add brand_signature_url to profiles and teams tables

ALTER TABLE profiles
ADD COLUMN IF NOT EXISTS brand_signature_url TEXT;

ALTER TABLE teams
ADD COLUMN IF NOT EXISTS brand_signature_url TEXT;
