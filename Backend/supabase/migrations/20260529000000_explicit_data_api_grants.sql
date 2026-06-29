-- =============================================================================
-- Migration: Explicit Data API Grants for Supabase Policy Change
-- Created: 2026-05-29
-- 
-- WHY: Starting October 30, 2026, Supabase will no longer auto-expose tables
--      in the "public" schema to the Data API. Without explicit GRANTs,
--      supabase-js/PostgREST/GraphQL queries will silently return empty results.
--
-- INDUSTRY STANDARD: Every table should have explicit GRANT statements
-- following the Principle of Least Privilege:
--   - authenticated: CRUD on tables they own (RLS controls which rows)
--   - anon: SELECT-only on public-facing tables, INSERT on lead capture
--   - service_role: Full access (bypasses RLS, used by Edge Functions/webhooks)
-- =============================================================================

BEGIN;

-- ---------------------------------------------------------------------------
-- 0. SCHEMA USAGE GRANTS
-- Required for any role to see tables in the public schema at all.
-- ---------------------------------------------------------------------------
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


-- ---------------------------------------------------------------------------
-- 1. CORE USER DATA TABLES — authenticated: full CRUD, service_role: full CRUD
-- These are the main app tables accessed by logged-in users via supabase-js.
-- RLS policies (already in place) control which rows each user can access.
-- ---------------------------------------------------------------------------

-- Profiles
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.profiles TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.profiles TO service_role;

-- Teams
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.teams TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.teams TO service_role;

-- Team Members
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.team_members TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.team_members TO service_role;

-- Clients
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.clients TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.clients TO service_role;

-- Client Notes
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.client_notes TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.client_notes TO service_role;

-- Client Communication Logs
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.client_communication_logs TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.client_communication_logs TO service_role;

-- Client Documents
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.client_documents TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.client_documents TO service_role;

-- Client Ledger
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.client_ledger TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.client_ledger TO service_role;

-- Invoices
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.invoices TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.invoices TO service_role;

-- Invoice Items
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.invoice_items TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.invoice_items TO service_role;

-- Recurring Invoices
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.recurring_invoices TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.recurring_invoices TO service_role;

-- Products
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.products TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.products TO service_role;

-- Product Categories
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.product_categories TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.product_categories TO service_role;

-- Stock Ledger
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.stock_ledger TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.stock_ledger TO service_role;

-- Expenses
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.expenses TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.expenses TO service_role;

-- Expense Categories
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.expense_categories TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.expense_categories TO service_role;

-- Billing History
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.billing_history TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.billing_history TO service_role;

-- Business Cards
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.business_cards TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.business_cards TO service_role;

-- Folders (QR Code organization)
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.folders TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.folders TO service_role;

-- QR Codes
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.qr_codes TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.qr_codes TO service_role;

-- Payment Methods
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.payment_methods TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.payment_methods TO service_role;

-- Pending Invitations
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.pending_invitations TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.pending_invitations TO service_role;

-- FCM Tokens (Push Notifications)
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.fcm_tokens TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.fcm_tokens TO service_role;

-- Usage Metrics
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.usage_metrics TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.usage_metrics TO service_role;

-- User Sessions
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.user_sessions TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.user_sessions TO service_role;

-- PAYG Entitlements
GRANT SELECT, INSERT ON TABLE public.payg_entitlements TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.payg_entitlements TO service_role;
-- Note: UPDATE was intentionally revoked from authenticated in security_hotfix.sql
-- Only service_role (Edge Functions/webhooks) should modify entitlements

-- Vendors
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.vendors TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.vendors TO service_role;


-- ---------------------------------------------------------------------------
-- 2. PUBLIC-FACING TABLES — anon: limited access for public website visitors
-- These tables are accessed by unauthenticated users (public card viewing,
-- lead forms, scan tracking, published blog articles).
-- ---------------------------------------------------------------------------

-- Identities (Digital Business Cards) — public viewing
GRANT SELECT ON TABLE public.identities TO anon;

-- Identity Leads — public lead form submission
GRANT SELECT, INSERT ON TABLE public.identity_leads TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.identity_leads TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.identity_leads TO service_role;

-- Scan Logs — public telemetry (anyone scanning a card inserts a log)
GRANT INSERT ON TABLE public.scan_logs TO anon;
GRANT SELECT, INSERT ON TABLE public.scan_logs TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.scan_logs TO service_role;

-- SEO Articles — published articles are publicly readable
GRANT SELECT ON TABLE public.seo_articles TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.seo_articles TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.seo_articles TO service_role;

-- Invoices — public portal viewing (tracking_token based, controlled by RLS)
GRANT SELECT ON TABLE public.invoices TO anon;

-- Invoice Items — public portal viewing (via parent invoice)
GRANT SELECT ON TABLE public.invoice_items TO anon;

-- Profiles — public portal needs to read business info for invoice display
GRANT SELECT ON TABLE public.profiles TO anon;


-- ---------------------------------------------------------------------------
-- 3. ADMIN/INTERNAL TABLES — authenticated admins + service_role
-- Access controlled by RLS policies checking subscription_tier or admin role.
-- ---------------------------------------------------------------------------

-- SEO Keywords (admin SEO engine)
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.seo_keywords TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.seo_keywords TO service_role;

-- Rankings Tracker (admin analytics)
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.rankings_tracker TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.rankings_tracker TO service_role;

-- SEO Settings (admin config)
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.seo_settings TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.seo_settings TO service_role;

-- Webhook Logs (internal — service_role only for writes)
GRANT SELECT ON TABLE public.webhook_logs TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.webhook_logs TO service_role;

-- Live Chat Messages
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.live_chat_messages TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.live_chat_messages TO service_role;

-- QR Scans (analytics telemetry)
GRANT SELECT, INSERT ON TABLE public.qr_scans TO anon;
GRANT SELECT, INSERT ON TABLE public.qr_scans TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.qr_scans TO service_role;


-- ---------------------------------------------------------------------------
-- 4. SEQUENCE GRANTS
-- Tables with GENERATED BY DEFAULT AS IDENTITY or SERIAL columns need
-- sequence usage grants so that INSERT operations can auto-generate IDs.
-- ---------------------------------------------------------------------------

GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO anon;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO authenticated;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO service_role;


-- ---------------------------------------------------------------------------
-- 5. FUTURE-PROOFING: ALTER DEFAULT PRIVILEGES
-- Ensures that any NEW tables created in the public schema by the postgres
-- role will automatically receive grants. This prevents future tables from
-- being invisible to the Data API.
-- ---------------------------------------------------------------------------

-- Authenticated users: full CRUD on future tables (RLS still controls rows)
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO authenticated;

-- Service role: full access on future tables
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO service_role;

-- Anon: read-only on future tables (override per-table if needed)
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
  GRANT SELECT ON TABLES TO anon;

-- Auto-grant sequence usage for future sequences
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
  GRANT USAGE ON SEQUENCES TO anon;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
  GRANT USAGE ON SEQUENCES TO authenticated;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
  GRANT USAGE ON SEQUENCES TO service_role;


COMMIT;

-- =============================================================================
-- VERIFICATION: After running this migration, test these queries in the
-- Supabase SQL Editor to confirm grants are in place:
--
--   SELECT grantee, table_name, privilege_type 
--   FROM information_schema.table_privileges 
--   WHERE table_schema = 'public' 
--   AND grantee IN ('anon', 'authenticated', 'service_role')
--   ORDER BY table_name, grantee;
--
-- Also check the Security Advisor in Dashboard → Database → Security Advisor
-- =============================================================================
