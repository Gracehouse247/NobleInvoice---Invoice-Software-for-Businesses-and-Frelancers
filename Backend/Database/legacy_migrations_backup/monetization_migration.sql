-- ============================================================
-- NobleGo Phase 8: Subscription Monetization Migration (FIXED)
-- ============================================================

-- 1. Create Monetization Enum
DO $$ BEGIN
    CREATE TYPE sub_tier AS ENUM ('solo', 'pro', 'squad');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- 2. Add Subscription fields to Profiles
ALTER TABLE profiles 
ADD COLUMN IF NOT EXISTS subscription_tier sub_tier DEFAULT 'solo',
ADD COLUMN IF NOT EXISTS subscription_status TEXT DEFAULT 'active',
ADD COLUMN IF NOT EXISTS subscription_expiry TIMESTAMPTZ;

-- 3. Sync legacy 'plan' column to new 'subscription_tier'
-- (Based on existing 'plan' column found in your schema)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='profiles' AND column_name='plan') THEN
        EXECUTE 'UPDATE profiles SET subscription_tier = ''pro'' WHERE plan = ''pro''';
        EXECUTE 'UPDATE profiles SET subscription_tier = ''solo'' WHERE plan = ''free'' OR plan IS NULL';
    END IF;
END $$;

-- 4. Clean up / Storage Policy:
-- Ensure only 'pro' or 'squad' can upload logo branding to a specific folder
-- This logic is usually handled in the App UI, but RLS adds safety.
