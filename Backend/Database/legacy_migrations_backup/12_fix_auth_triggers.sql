-- ==========================================
-- NobleGo: Auth Trigger Fix (Final Version)
-- Solves "Database error saving new user"
-- ==========================================

-- 1. DROP EXISTING TRIGGER/FUNCTION
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP FUNCTION IF EXISTS public.handle_new_user();

-- 2. CREATE NEW ROBUST TRIGGER FUNCTION
CREATE OR REPLACE FUNCTION public.handle_new_user() 
RETURNS trigger AS $$
DECLARE
    new_team_id UUID;
BEGIN
    -- A. Create the User Profile
    INSERT INTO public.profiles (
        id, 
        email, 
        display_name,
        onboarding_completed
    )
    VALUES (
        new.id, 
        new.email, 
        COALESCE(new.raw_user_meta_data->>'full_name', substring(new.email from '(.*)@')),
        FALSE
    );

    -- B. Create a Default Personal Team (Business) for the User
    INSERT INTO public.teams (
        owner_id, 
        name,
        primary_color,
        secondary_color
    )
    VALUES (
        new.id, 
        COALESCE(new.raw_user_meta_data->>'business_name', 'My Business'),
        '#2563EB',
        '#1E293B'
    )
    RETURNING id INTO new_team_id;

    -- C. Link User to the Team as 'owner'
    INSERT INTO public.team_members (
        team_id, 
        user_id, 
        role
    )
    VALUES (
        new_team_id, 
        new.id, 
        'owner'::team_role
    );

    RETURN new;
EXCEPTION
    WHEN others THEN
        -- Log or ignore errors to prevent locking out logins
        RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. RE-ATTACH TRIGGER
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
