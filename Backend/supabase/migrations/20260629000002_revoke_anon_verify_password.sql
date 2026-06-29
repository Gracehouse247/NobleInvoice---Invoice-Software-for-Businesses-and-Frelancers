-- Revoke anon access to verify_password — this function accesses auth.users.encrypted_password
-- and should NEVER be callable by unauthenticated users.
REVOKE EXECUTE ON FUNCTION public.verify_password(TEXT, TEXT) FROM anon;

-- For now, only authenticated users may call it (e.g. for "change password" pre-confirmation).
