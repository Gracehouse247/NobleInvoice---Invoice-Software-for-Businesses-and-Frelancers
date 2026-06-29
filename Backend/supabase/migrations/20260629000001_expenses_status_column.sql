-- Migration: 20260629000001_expenses_status_column.sql
ALTER TABLE public.expenses
  ADD COLUMN IF NOT EXISTS status TEXT NOT NULL DEFAULT 'pending'
  CHECK (status IN ('pending', 'approved', 'reimbursed'));
