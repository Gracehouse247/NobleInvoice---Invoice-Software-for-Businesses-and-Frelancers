-- Add industry and country fields to profiles table for onboarding

ALTER TABLE public.profiles
ADD COLUMN IF NOT EXISTS industry TEXT,
ADD COLUMN IF NOT EXISTS country TEXT;
