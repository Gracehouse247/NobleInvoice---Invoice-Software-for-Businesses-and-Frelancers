-- ============================================================
-- NobleGo: Expense Table Schema Repair Patch
-- ============================================================

DO $$
BEGIN
    -- 1. ADD MISSING COLUMNS TO EXPENSES
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='expenses' AND column_name='team_id') THEN
        ALTER TABLE public.expenses ADD COLUMN team_id UUID REFERENCES public.teams(id) ON DELETE CASCADE;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='expenses' AND column_name='vendor_id') THEN
        ALTER TABLE public.expenses ADD COLUMN vendor_id BIGINT REFERENCES public.vendors(id) ON DELETE SET NULL;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='expenses' AND column_name='category_id') THEN
        ALTER TABLE public.expenses ADD COLUMN category_id BIGINT REFERENCES public.expense_categories(id) ON DELETE SET NULL;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='expenses' AND column_name='currency_code') THEN
        ALTER TABLE public.expenses ADD COLUMN currency_code TEXT DEFAULT 'USD';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='expenses' AND column_name='receipt_url') THEN
        ALTER TABLE public.expenses ADD COLUMN receipt_url TEXT;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='expenses' AND column_name='is_recurring') THEN
        ALTER TABLE public.expenses ADD COLUMN is_recurring BOOLEAN DEFAULT FALSE;
    END IF;

    -- 2. FIX COLUMN CONSTRAINTS
    -- Ensure expense_date has a default
    ALTER TABLE public.expenses ALTER COLUMN expense_date SET DEFAULT CURRENT_DATE;
    -- Ensure amount has a default
    ALTER TABLE public.expenses ALTER COLUMN amount SET DEFAULT 0;

END $$;

-- 3. RE-APPLY RLS POLICIES FOR EXPENSES
ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Team members can manage expenses" ON public.expenses;
CREATE POLICY "Team members can manage expenses" ON public.expenses 
FOR ALL USING (
    EXISTS (SELECT 1 FROM public.team_members WHERE team_id = expenses.team_id AND user_id = auth.uid())
);
