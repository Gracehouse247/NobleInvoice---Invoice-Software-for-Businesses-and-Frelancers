-- More robust auth trigger to handle new user creations securely
-- Adds support for 'display_name' while falling back to 'full_name' or email prefix

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
