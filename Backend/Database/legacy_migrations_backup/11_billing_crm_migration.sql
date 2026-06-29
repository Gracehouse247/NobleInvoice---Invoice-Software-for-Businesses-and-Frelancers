-- C:\Projects\NobleGo\Database\11_billing_crm_migration.sql
-- ─────────────────────────────────────────────────────────────────────────────
-- NobleGo: Billing History + CRM Enhancements Migration
-- Run this in your Supabase SQL editor
-- ─────────────────────────────────────────────────────────────────────────────

-- ── 1. Subscription Expiry on Profiles ───────────────────────────────────────
ALTER TABLE profiles 
  ADD COLUMN IF NOT EXISTS subscription_expires_at TIMESTAMPTZ;

-- ── 2. Real Billing History Table ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS billing_history (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  amount           NUMERIC(10,2) NOT NULL,
  currency         TEXT NOT NULL DEFAULT 'USD',
  plan             TEXT NOT NULL,
  billing_period   TEXT,           -- 'monthly' | 'yearly'
  transaction_ref  TEXT UNIQUE,    -- Flutterwave tx_ref
  status           TEXT DEFAULT 'success',  -- 'success' | 'failed' | 'pending'
  created_at       TIMESTAMPTZ DEFAULT NOW()
);

-- RLS: users see only their own billing records
ALTER TABLE billing_history ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users see own billing" ON billing_history;
CREATE POLICY "Users see own billing" ON billing_history
  FOR ALL USING (auth.uid() = user_id);

-- ── 3. CRM: Lead Status on Clients ───────────────────────────────────────────
ALTER TABLE clients 
  ADD COLUMN IF NOT EXISTS lead_status TEXT DEFAULT 'active';
  -- Values: 'lead' | 'active' | 'vip' | 'churned'

-- ── 4. Client Communication Logs ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS client_communication_logs (
  id          BIGSERIAL PRIMARY KEY,
  team_id     UUID REFERENCES teams(id) ON DELETE CASCADE,
  client_id   BIGINT REFERENCES clients(id) ON DELETE CASCADE,
  author_id   UUID REFERENCES auth.users(id),
  type        TEXT NOT NULL,   -- 'call' | 'meeting' | 'whatsapp' | 'email' | 'note'
  summary     TEXT,
  logged_at   TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE client_communication_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Team members see logs" ON client_communication_logs;
CREATE POLICY "Team members see logs" ON client_communication_logs
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM team_members tm
      WHERE tm.team_id = client_communication_logs.team_id
        AND tm.user_id = auth.uid()
    )
  );

-- ── 5. Index for performance ──────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_billing_history_user ON billing_history(user_id);
CREATE INDEX IF NOT EXISTS idx_comm_logs_client ON client_communication_logs(client_id);
CREATE INDEX IF NOT EXISTS idx_clients_lead_status ON clients(lead_status);
