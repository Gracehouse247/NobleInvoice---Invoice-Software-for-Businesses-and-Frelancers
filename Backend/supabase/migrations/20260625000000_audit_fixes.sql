-- Fix #21: Update handle_new_user to read 'name' from metadata
CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    new_team_id UUID;
BEGIN
    INSERT INTO public.profiles (id, email, display_name, onboarding_completed)
    VALUES (
        new.id, 
        new.email, 
        COALESCE(
            new.raw_user_meta_data->>'display_name', 
            new.raw_user_meta_data->>'full_name', 
            new.raw_user_meta_data->>'name', 
            substring(new.email from '(.*)@')
        ), 
        FALSE
    )
    ON CONFLICT (id) DO NOTHING;

    -- Create a team if the user doesn't already own one
    IF NOT EXISTS (SELECT 1 FROM public.teams WHERE owner_id = new.id) THEN
        INSERT INTO public.teams (owner_id, name)
        VALUES (new.id, 'My Business')
        RETURNING id INTO new_team_id;

        IF new_team_id IS NOT NULL THEN
            INSERT INTO public.team_members (team_id, user_id, role)
            VALUES (new_team_id, new.id, 'owner')
            ON CONFLICT DO NOTHING;
        END IF;
    END IF;

    RETURN new;
END;
$function$;

-- Fix #27: Align subscription_tier default
ALTER TABLE public.profiles ALTER COLUMN subscription_tier SET DEFAULT 'explorer';
UPDATE public.profiles SET subscription_tier = 'explorer' WHERE subscription_tier IS NULL;

-- Fix #1: Verify password natively
CREATE OR REPLACE FUNCTION public.verify_password(p_email TEXT, p_password TEXT)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, auth
AS $$
DECLARE
  v_user auth.users;
BEGIN
  SELECT * INTO v_user FROM auth.users WHERE email = p_email;
  IF NOT FOUND THEN
    RETURN FALSE;
  END IF;
  
  -- Supabase uses bcrypt for encrypted_password
  IF v_user.encrypted_password = crypt(p_password, v_user.encrypted_password) THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END;
$$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION public.verify_password(TEXT, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.verify_password(TEXT, TEXT) TO anon;

-- Fix #28: Change quantity from INT to NUMERIC(15,2) to support fractional quantities
ALTER TABLE public.invoice_items ALTER COLUMN quantity TYPE NUMERIC(15,2) USING quantity::numeric(15,2);
