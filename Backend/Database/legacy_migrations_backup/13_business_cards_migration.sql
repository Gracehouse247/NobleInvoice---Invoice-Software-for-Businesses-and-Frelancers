-- ==========================================
-- NobleGo: Business Cards Table Migration
-- ==========================================

CREATE TABLE IF NOT EXISTS public.business_cards (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    team_id UUID REFERENCES public.teams(id) ON DELETE CASCADE,
    format TEXT DEFAULT 'standard',
    template_id TEXT DEFAULT 'modern_flat',
    custom_name TEXT,
    custom_title TEXT,
    custom_phone TEXT,
    custom_email TEXT,
    custom_website TEXT,
    custom_address TEXT,
    qr_data TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(team_id) -- Only one active designer state per team
);

-- RLS
ALTER TABLE public.business_cards ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Team members can view business cards" ON public.business_cards;
CREATE POLICY "Team members can view business cards" ON public.business_cards
    FOR SELECT USING (
        EXISTS (SELECT 1 FROM public.team_members WHERE team_id = business_cards.team_id AND user_id = auth.uid())
    );

DROP POLICY IF EXISTS "Owners and Admins can manage business cards" ON public.business_cards;
CREATE POLICY "Owners and Admins can manage business cards" ON public.business_cards
    FOR ALL USING (
        EXISTS (SELECT 1 FROM public.team_members WHERE team_id = business_cards.team_id AND user_id = auth.uid() AND role IN ('owner', 'admin'))
    );
