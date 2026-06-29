-- Database/37_ai_sentiment_and_payments.sql

-- 1. Add Sentiment Analysis fields to CRM Notes
ALTER TABLE client_notes 
ADD COLUMN IF NOT EXISTS sentiment VARCHAR(50),
ADD COLUMN IF NOT EXISTS sentiment_confidence NUMERIC(3,2);

-- 2. Add an index for faster filtering of notes by sentiment
CREATE INDEX IF NOT EXISTS idx_client_notes_sentiment ON client_notes(sentiment);

-- 3. Add gateway tracking fields to Invoices for Automated Reconciliation
ALTER TABLE invoices
ADD COLUMN IF NOT EXISTS payment_gateway VARCHAR(50),
ADD COLUMN IF NOT EXISTS gateway_transaction_id VARCHAR(255);
