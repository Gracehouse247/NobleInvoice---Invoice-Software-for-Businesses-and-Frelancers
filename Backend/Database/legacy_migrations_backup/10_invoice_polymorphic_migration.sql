-- NobleGo Invoice Architecture - Migration Script
-- Run this block in your Supabase SQL Editor to prepare your cloud database for the new Unified Smart Engine

-- 1. Ensure the new invoice types (especially 'mixed') are accepted if you are using an explicit ENUM or CHECK constraint
-- If you used a simple text column previously, you don't need this block. 
-- However, if you enforced types, run this to update your database checks:
-- ALTER TYPE invoice_type ADD VALUE IF NOT EXISTS 'mixed';

-- 2. Add the polymorphic JSONB 'metadata' dictionary to your invoices table
-- This column will hold specific attributes (like hs_tariff_codes, validity dates, progress metrics) uniquely for each invoice type.
ALTER TABLE invoices
ADD COLUMN IF NOT EXISTS metadata JSONB DEFAULT '{}'::jsonb;

-- 3. (Optional) Create an index to query invoices faster based on their polymorphic traits 
-- For instance, if you want to quickly find all invoices with a specific customs origin
CREATE INDEX IF NOT EXISTS idx_invoice_metadata ON invoices USING GIN (metadata);

-- 4. Update existing rows (if any) to explicitly contain an empty metadata payload instead of NULL
UPDATE invoices
SET metadata = '{}'::jsonb
WHERE metadata IS NULL;
