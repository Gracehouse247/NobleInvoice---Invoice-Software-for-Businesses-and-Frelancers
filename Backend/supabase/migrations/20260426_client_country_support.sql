-- Migration: Add country support to clients table
-- Date: 2026-04-26

ALTER TABLE clients 
ADD COLUMN IF NOT EXISTS country text,
ADD COLUMN IF NOT EXISTS country_code text DEFAULT '+234';

-- Refresh schema cache
NOTIFY pgrst, 'reload schema';
