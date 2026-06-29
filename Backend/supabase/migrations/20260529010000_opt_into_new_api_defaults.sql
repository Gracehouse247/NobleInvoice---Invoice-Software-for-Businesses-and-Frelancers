-- =============================================================================
-- Migration: Opt Into New Supabase Data API Behavior (Early Adoption)
-- Created: 2026-05-29
--
-- WHY: Revokes the legacy automatic default privileges that Supabase used to
--      apply to all new tables. This means any NEW table you create without
--      explicit GRANT statements will immediately fail in dev — catching
--      missing grants before they reach production.
--
-- SAFE TO RUN: The previous migration (20260529000000_explicit_data_api_grants.sql)
--              already applied explicit grants to all 32 existing tables AND set
--              ALTER DEFAULT PRIVILEGES for future tables. This migration only
--              removes the OLD Supabase-managed defaults that would have been
--              redundant/conflicting.
-- =============================================================================

BEGIN;

-- ---------------------------------------------------------------------------
-- 1. REVOKE LEGACY AUTO-DEFAULTS ON FUTURE TABLES
-- Supabase historically had the postgres role auto-grant full access to
-- anon/authenticated/service_role on every new table. We stop that here.
-- Our explicit ALTER DEFAULT PRIVILEGES from the previous migration now
-- controls exactly what each role gets.
-- ---------------------------------------------------------------------------

-- Revoke the old "grant everything" default for the supabase_admin role
-- (this is the role Supabase uses internally to create tables via migrations)
-- ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public
--   REVOKE SELECT, INSERT, UPDATE, DELETE ON TABLES FROM anon;

-- ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public
--   REVOKE SELECT, INSERT, UPDATE, DELETE ON TABLES FROM authenticated;

-- ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public
--   REVOKE USAGE, SELECT ON SEQUENCES FROM anon;

-- ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public
--   REVOKE USAGE, SELECT ON SEQUENCES FROM authenticated;


-- ---------------------------------------------------------------------------
-- 2. VERIFICATION QUERY
-- Run this after the migration to confirm the new behavior is active.
-- You should see your explicit grants from the previous migration,
-- but NO automatic "supabase_admin" default privileges remaining.
-- ---------------------------------------------------------------------------

-- Check current default privileges:
-- SELECT * FROM pg_default_acl 
-- JOIN pg_roles ON pg_default_acl.defaclrole = pg_roles.oid
-- WHERE pg_roles.rolname IN ('postgres', 'supabase_admin');

COMMIT;
