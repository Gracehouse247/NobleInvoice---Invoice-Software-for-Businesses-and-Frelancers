-- C:\Projects\NobleGo\Database\33_fix_subscription_tiers.sql
-- ─────────────────────────────────────────────────────────────────────────────
-- NobleGo: Fix Subscription Columns and Tier Consistency
-- ─────────────────────────────────────────────────────────────────────────────

-- 1. Ensure Profiles table has all required columns for SubscriptionController
ALTER TABLE public.profiles 
ADD COLUMN IF NOT EXISTS is_yearly_plan BOOLEAN DEFAULT FALSE;

-- 2. Ensure subscription_tier is TEXT to avoid enum mismatch issues 
-- (If it was an enum from monetization_migration.sql, we cast it back to TEXT for flexibility)
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'profiles' 
        AND column_name = 'subscription_tier'
        AND data_type = 'USER-DEFINED'
    ) THEN
        ALTER TABLE public.profiles ALTER COLUMN subscription_tier TYPE TEXT;
    END IF;
END $$;

-- 3. Sync existing data to new clean tier names if needed
UPDATE public.profiles SET subscription_tier = 'pulse' WHERE subscription_tier ILIKE '%pulse%';
UPDATE public.profiles SET subscription_tier = 'elite' WHERE subscription_tier ILIKE '%elite%';
UPDATE public.profiles SET subscription_tier = 'solo' WHERE subscription_tier NOT IN ('pulse', 'elite');

-- 4. Create a helper function for the webhook to use (Optional but safer)
CREATE OR REPLACE FUNCTION public.upgrade_user_subscription(
    target_user_id UUID,
    target_tier TEXT,
    is_yearly BOOLEAN
) RETURNS VOID AS $$
DECLARE
    expiry_interval INTERVAL;
BEGIN
    IF is_yearly THEN
        expiry_interval := '1 year';
    ELSE
        expiry_interval := '1 month';
    END IF;

    UPDATE public.profiles
    SET 
        subscription_tier = target_tier,
        subscription_expires_at = NOW() + expiry_interval,
        is_yearly_plan = is_yearly,
        updated_at = NOW()
    WHERE id = target_user_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
