-- ============================================================
-- NobleGo: Expense → Invoice Link Migration
-- File: 101_expense_invoice_link.sql
-- Safe to run multiple times (fully idempotent).
-- Run this BEFORE deploying the updated Flutter app.
-- ============================================================

DO $$
BEGIN
    -- 1. ADD invoice_id FOREIGN KEY COLUMN
    -- Uses ON DELETE SET NULL: if an invoice is deleted, the expense
    -- is NOT deleted — it simply becomes "unlinked" (invoice_id = NULL).
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'public'
          AND table_name   = 'expenses'
          AND column_name  = 'invoice_id'
    ) THEN
        ALTER TABLE public.expenses
            ADD COLUMN invoice_id BIGINT REFERENCES public.invoices(id) ON DELETE SET NULL;

        RAISE NOTICE 'expenses.invoice_id column added successfully.';
    ELSE
        RAISE NOTICE 'expenses.invoice_id already exists — skipping.';
    END IF;

END $$;

-- ============================================================
-- 2. PERFORMANCE INDICES
-- ============================================================

-- Fast lookup: "give me all expenses for invoice #42"
-- Powers the Project Costs section on Invoice Details screen.
CREATE INDEX IF NOT EXISTS idx_expenses_invoice_id
    ON public.expenses (invoice_id)
    WHERE invoice_id IS NOT NULL;

-- Fast lookup: sorted expense history per team (default view)
-- Powers the Expense History screen sort.
CREATE INDEX IF NOT EXISTS idx_expenses_team_date
    ON public.expenses (team_id, expense_date DESC);

-- ============================================================
-- 3. HARDENED RLS POLICY
-- Replaces the weaker policy from 100_expense_schema_repair.sql.
-- Now aligns with the standard team_members subquery pattern
-- used across all other tables in this schema.
-- ============================================================

ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;

-- Drop both old and new policy names for idempotency
DROP POLICY IF EXISTS "Team members can manage expenses"    ON public.expenses;
DROP POLICY IF EXISTS "Team members can access expenses"   ON public.expenses;

CREATE POLICY "Team members can access expenses"
    ON public.expenses FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM public.team_members
            WHERE team_members.team_id = expenses.team_id
              AND team_members.user_id = auth.uid()
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.team_members
            WHERE team_members.team_id = expenses.team_id
              AND team_members.user_id = auth.uid()
        )
    );

-- ============================================================
-- 4. DOCUMENTATION
-- ============================================================

COMMENT ON COLUMN public.expenses.invoice_id IS
    'Optional FK to invoices.id. Links this expense to the project/job it was incurred for. NULL = unlinked (general overhead). ON DELETE SET NULL preserves the expense record when an invoice is deleted.';

COMMENT ON INDEX idx_expenses_invoice_id IS
    'Partial index for expense→invoice lookups. Powers the Project Costs section on InvoiceDetailsScreen.';

COMMENT ON INDEX idx_expenses_team_date IS
    'Composite index for the Expense History screen (team-scoped, date-sorted queries).';
