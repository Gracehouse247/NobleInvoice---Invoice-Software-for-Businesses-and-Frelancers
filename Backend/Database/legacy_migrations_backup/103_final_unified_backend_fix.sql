-- 103_final_unified_backend_fix.sql
-- Unified script to fix recursion, profile access, and subscription status.

-- 1. SECURITY DEFINER HELPER
-- Breaks the recursion by checking memberships WITHOUT triggering RLS on the table.
CREATE OR REPLACE FUNCTION public.check_team_membership(team_id uuid, user_id uuid)
RETURNS boolean AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.team_members 
    WHERE team_members.team_id = $1 
    AND team_members.user_id = $2
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. RESET POLICIES (NUCLEAR OPTION)
-- Ensures we start from a clean state for the affected tables.
DROP POLICY IF EXISTS "Users can view their own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can update their own profile" ON public.profiles;
DROP POLICY IF EXISTS "Members can view teams" ON public.teams;
DROP POLICY IF EXISTS "Members can view memberships" ON public.team_members;
DROP POLICY IF EXISTS "Members can view invoices" ON public.invoices;

-- 3. PROFILE POLICIES (Essential for Auth & Pro check)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Profiles are viewable by owner"
ON public.profiles FOR SELECT
USING (auth.uid() = id);

CREATE POLICY "Profiles are updatable by owner"
ON public.profiles FOR UPDATE
USING (auth.uid() = id);

-- 4. TEAM POLICIES (Non-recursive)
ALTER TABLE public.teams ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Teams are viewable by members"
ON public.teams FOR SELECT
USING (check_team_membership(id, auth.uid()));

-- 5. MEMBERSHIP POLICIES
ALTER TABLE public.team_members ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Memberships are viewable by members"
ON public.team_members FOR SELECT
USING (check_team_membership(team_id, auth.uid()));

-- 6. INVOICE POLICIES
ALTER TABLE public.invoices ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Invoices are viewable by team members"
ON public.invoices FOR SELECT
USING (check_team_membership(team_id, auth.uid()));

CREATE POLICY "Invoices are manageable by team members"
ON public.invoices FOR ALL
USING (check_team_membership(team_id, auth.uid()));

-- 7. USAGE METRICS (Essential for Feature Gating)
ALTER TABLE public.usage_metrics ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usage metrics are viewable by owner"
ON public.usage_metrics FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Usage metrics are manageable by owner"
ON public.usage_metrics FOR ALL
USING (auth.uid() = user_id);

-- 8. SUBSCRIPTION TIER NORMALIZATION
-- If any user has 'Pro' instead of 'pulse', fix it here.
UPDATE public.profiles
SET subscription_tier = 'pulse'
WHERE subscription_tier ILIKE 'pro';

-- Also ensure 'elite' is lowercase
UPDATE public.profiles
SET subscription_tier = 'elite'
WHERE subscription_tier ILIKE 'elite';
