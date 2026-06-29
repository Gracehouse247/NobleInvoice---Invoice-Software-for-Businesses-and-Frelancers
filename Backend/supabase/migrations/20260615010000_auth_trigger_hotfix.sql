-- Auth Trigger Hotfix
-- Removes the exception swallower to ensure atomic profile and team creation.

CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    new_team_id UUID;
BEGIN
    INSERT INTO public.profiles (id, email, display_name, onboarding_completed)
    VALUES (new.id, new.email, COALESCE(new.raw_user_meta_data->>'full_name', substring(new.email from '(.*)@')), FALSE)
    ON CONFLICT (id) DO NOTHING;

    INSERT INTO public.teams (owner_id, name)
    VALUES (new.id, 'My Business')
    RETURNING id INTO new_team_id;

    INSERT INTO public.team_members (team_id, user_id, role)
    VALUES (new_team_id, new.id, 'owner')
    ON CONFLICT DO NOTHING;

    RETURN new;
END;
$function$;
