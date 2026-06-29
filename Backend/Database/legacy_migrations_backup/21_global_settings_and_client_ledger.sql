-- 21_global_settings_and_client_ledger.sql
-- Professional Grade Hardening: Global Settings & Client Ledger Integration.

-- 1. Add Global Invoicing Settings to Teams
ALTER TABLE teams ADD COLUMN IF NOT EXISTS default_vat_rate NUMERIC DEFAULT 0;
ALTER TABLE teams ADD COLUMN IF NOT EXISTS default_wht_rate NUMERIC DEFAULT 0;
ALTER TABLE teams ADD COLUMN IF NOT EXISTS default_payment_terms TEXT DEFAULT 'Payment is due within 14 days of invoice issue.';
ALTER TABLE teams ADD COLUMN IF NOT EXISTS invoice_prefix TEXT DEFAULT 'NGO';

-- 2. Create Client Ledger for Balance Tracking
CREATE TABLE IF NOT EXISTS client_ledger (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    team_id UUID REFERENCES teams(id) ON DELETE CASCADE,
    client_id BIGINT REFERENCES clients(id) ON DELETE CASCADE,
    invoice_id BIGINT REFERENCES invoices(id) ON DELETE SET NULL,
    transaction_type TEXT NOT NULL, -- 'invoice', 'payment', 'credit_memo', 'debit_memo', 'refund'
    amount NUMERIC NOT NULL,        -- Positive for charges, Negative for credits
    balance_before NUMERIC NOT NULL,
    balance_after NUMERIC NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    metadata JSONB DEFAULT '{}'
);

CREATE INDEX IF NOT EXISTS idx_client_ledger_cid ON client_ledger(client_id);
CREATE INDEX IF NOT EXISTS idx_client_ledger_team ON client_ledger(team_id);

-- 3. Function to update client current balance automatically
CREATE OR REPLACE FUNCTION update_client_balance_tracker()
RETURNS TRIGGER AS $$
DECLARE
    adjustment NUMERIC;
BEGIN
    -- Determine adjustment
    IF (TG_OP = 'INSERT') THEN
        adjustment := NEW.amount;
    ELSIF (TG_OP = 'DELETE') THEN
        adjustment := -OLD.amount;
    ELSE
        adjustment := NEW.amount - OLD.amount;
    END IF;

    UPDATE clients 
    SET current_balance = COALESCE(current_balance, 0) + adjustment 
    WHERE id = COALESCE(NEW.client_id, OLD.client_id);
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_client_balance
AFTER INSERT OR UPDATE OR DELETE ON client_ledger
FOR EACH ROW EXECUTE FUNCTION update_client_balance_tracker();

-- 4. Add current_balance to clients table if missing
ALTER TABLE clients ADD COLUMN IF NOT EXISTS current_balance NUMERIC DEFAULT 0;
