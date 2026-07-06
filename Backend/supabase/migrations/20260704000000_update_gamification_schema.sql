-- Migration: update_gamification_schema
-- Description: Creates the user_gamification table with invoicing columns if it doesn't exist, OR renames the legacy columns if it does exist.

DO $$ 
BEGIN
    -- Check if table exists
    IF NOT EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'user_gamification') THEN
        -- Table does not exist, create it from scratch with the correct columns
        CREATE TABLE public.user_gamification (
            id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
            user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE,
            xp INTEGER NOT NULL DEFAULT 0,
            level INTEGER NOT NULL DEFAULT 1,
            unlocked_badges TEXT[] NOT NULL DEFAULT '{}',
            invoices_sent INTEGER NOT NULL DEFAULT 0,
            payments_received INTEGER NOT NULL DEFAULT 0,
            receipts_scanned INTEGER NOT NULL DEFAULT 0,
            current_streak INTEGER NOT NULL DEFAULT 0,
            last_action_date DATE,
            created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
            updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
        );

        -- Add RLS
        ALTER TABLE public.user_gamification ENABLE ROW LEVEL SECURITY;

        -- Policies (checking if they exist first is tricky in a DO block without exception handling, 
        -- but since the table was just created, they don't exist yet)
        
        -- Note: We can't easily run CREATE POLICY inside DO blocks dynamically without EXECUTE, 
        -- so we will do the RLS creation outside the DO block using IF NOT EXISTS.
    ELSE
        -- Table exists, conditionally rename columns if they exist
        IF EXISTS (SELECT FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'user_gamification' AND column_name = 'tasks_completed') THEN
            ALTER TABLE public.user_gamification RENAME COLUMN tasks_completed TO invoices_sent;
        END IF;
        IF EXISTS (SELECT FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'user_gamification' AND column_name = 'habits_logged') THEN
            ALTER TABLE public.user_gamification RENAME COLUMN habits_logged TO payments_received;
        END IF;
        IF EXISTS (SELECT FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'user_gamification' AND column_name = 'notes_created') THEN
            ALTER TABLE public.user_gamification RENAME COLUMN notes_created TO receipts_scanned;
        END IF;
    END IF;
END $$;

-- -------------------------------------------------------------------------------------
-- The following statements run outside the DO block so they are evaluated properly.
-- We use IF NOT EXISTS where possible, or CREATE OR REPLACE for functions.
-- -------------------------------------------------------------------------------------

-- Ensure the table exists before creating policies (it will, due to the DO block above)

-- Enable RLS (idempotent)
ALTER TABLE public.user_gamification ENABLE ROW LEVEL SECURITY;

-- Safely recreate policies (Drop first, then create to avoid "policy already exists" errors)
DROP POLICY IF EXISTS "Users can view own gamification data" ON public.user_gamification;
CREATE POLICY "Users can view own gamification data"
    ON public.user_gamification
    FOR SELECT
    USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update own gamification data" ON public.user_gamification;
CREATE POLICY "Users can update own gamification data"
    ON public.user_gamification
    FOR UPDATE
    USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can insert own gamification data" ON public.user_gamification;
CREATE POLICY "Users can insert own gamification data"
    ON public.user_gamification
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Safely recreate the Auth Trigger
CREATE OR REPLACE FUNCTION public.handle_new_user_gamification()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.user_gamification (user_id)
    VALUES (NEW.id)
    ON CONFLICT (user_id) DO NOTHING;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop trigger if it exists to avoid duplication errors, then create
DROP TRIGGER IF EXISTS on_auth_user_created_gamification ON auth.users;
CREATE TRIGGER on_auth_user_created_gamification
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user_gamification();
