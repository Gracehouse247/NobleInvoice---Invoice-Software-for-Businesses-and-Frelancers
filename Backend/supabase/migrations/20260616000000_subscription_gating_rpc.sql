-- =============================================================================
-- Migration: Subscription & PAYG Feature Gating RPC
-- Creates a central source of truth for resolving a user's limits and features.
-- =============================================================================

-- 1. Ensure payg_entitlements has dpp_credits if needed
ALTER TABLE public.payg_entitlements 
ADD COLUMN IF NOT EXISTS dpp_credits INTEGER DEFAULT 0 NOT NULL CHECK (dpp_credits >= 0);

-- 2. Create the RPC Function
CREATE OR REPLACE FUNCTION public.resolve_user_limits(p_user_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER -- Runs with elevated privileges to read profiles/entitlements securely
AS $$
DECLARE
    v_tier TEXT;
    v_payg RECORD;
    v_result JSONB;
BEGIN
    -- 1. Get the user's tier
    SELECT COALESCE(subscription_tier, 'explorer') INTO v_tier
    FROM public.profiles
    WHERE id = p_user_id;

    -- Default to explorer if profile not found
    IF v_tier IS NULL THEN
        v_tier := 'explorer';
    END IF;

    -- 2. Get PAYG entitlements
    SELECT * INTO v_payg
    FROM public.payg_entitlements
    WHERE user_id = p_user_id;

    -- 3. Build the limits JSON based on tier
    IF v_tier IN ('pro', 'elite', 'pulse') THEN
        -- Premium Tiers
        v_result := jsonb_build_object(
            'tier', v_tier,
            'limits', jsonb_build_object(
                'max_invoices_per_month', -1,
                'max_clients', -1,
                'has_advanced_editing', true,
                'allowed_templates', jsonb_build_array('*'),
                'dpp_image_limit', -1
            ),
            'features', jsonb_build_object(
                'recurring_invoices', true,
                'inventory_management', true,
                'analytics_and_reports', true,
                'multi_user', (v_tier = 'elite'),
                'contracts', (v_tier = 'elite'),
                'dpp_enabled', true,
                'ai_voice_assistant', true,
                'wallet_payments', true,
                'marketing_networking', true,
                'brand_identity_studio', true
            )
        );
    ELSE
        -- Free Tier / PAYG
        v_result := jsonb_build_object(
            'tier', 'explorer',
            'limits', jsonb_build_object(
                'max_invoices_per_month', 10,
                'max_clients', 5 + COALESCE(v_payg.client_slots, 0),
                'has_advanced_editing', false,
                'allowed_templates', COALESCE(to_jsonb(v_payg.unlocked_invoices), '[]'::jsonb),
                'dpp_image_limit', (COALESCE(v_payg.dpp_credits, 0) * 3) -- e.g., 3 images per DPP credit
            ),
            'features', jsonb_build_object(
                'recurring_invoices', false,
                'inventory_management', false,
                'analytics_and_reports', false,
                'multi_user', false,
                'contracts', false,
                'dpp_enabled', (COALESCE(v_payg.dpp_credits, 0) > 0),
                'ai_voice_assistant', false,
                'wallet_payments', false,
                'marketing_networking', false,
                'brand_identity_studio', false
            )
        );
    END IF;

    RETURN v_result;
END;
$$;

-- Grant execution to authenticated users
GRANT EXECUTE ON FUNCTION public.resolve_user_limits(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.resolve_user_limits(UUID) TO service_role;
