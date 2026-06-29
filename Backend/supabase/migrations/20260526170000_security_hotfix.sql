-- 20260526170000_security_hotfix.sql
-- Fixes critical security vulnerabilities identified in the Final Production Audit

-- 1. Client Documents RLS
ALTER TABLE public.client_documents ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can view own client documents" ON public.client_documents;
CREATE POLICY "Users can view own client documents" 
ON public.client_documents FOR SELECT 
USING (
  auth.uid() = uploader_id OR 
  client_id IN (
    SELECT id FROM public.clients WHERE team_id IN (
      SELECT team_id FROM public.team_members WHERE user_id = auth.uid()
    )
  )
);

DROP POLICY IF EXISTS "Users can insert own client documents" ON public.client_documents;
CREATE POLICY "Users can insert own client documents" 
ON public.client_documents FOR INSERT 
WITH CHECK (auth.uid() = uploader_id);

DROP POLICY IF EXISTS "Users can update own client documents" ON public.client_documents;
CREATE POLICY "Users can update own client documents" 
ON public.client_documents FOR UPDATE 
USING (auth.uid() = uploader_id);

DROP POLICY IF EXISTS "Users can delete own client documents" ON public.client_documents;
CREATE POLICY "Users can delete own client documents" 
ON public.client_documents FOR DELETE 
USING (auth.uid() = uploader_id);


-- 2. Storage Bucket Logo Overwrite Vulnerability
BEGIN;
  DROP POLICY IF EXISTS "Give users access to own folder 1qaz2wsx" ON storage.objects;
  DROP POLICY IF EXISTS "Users can upload logos" ON storage.objects;
  
  DROP POLICY IF EXISTS "Secure logo upload" ON storage.objects;
  CREATE POLICY "Secure logo upload"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'public' AND 
    (storage.foldername(name))[1] = 'logos' AND
    auth.uid()::text = (storage.foldername(name))[2]
  );

  DROP POLICY IF EXISTS "Secure logo update" ON storage.objects;
  CREATE POLICY "Secure logo update"
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (
    bucket_id = 'public' AND 
    (storage.foldername(name))[1] = 'logos' AND
    auth.uid()::text = (storage.foldername(name))[2]
  );
COMMIT;


-- 3. Revoke Client-Side Update on payg_entitlements
REVOKE UPDATE ON public.payg_entitlements FROM authenticated;
REVOKE UPDATE ON public.payg_entitlements FROM anon;

DROP POLICY IF EXISTS "Users can update own entitlements" ON public.payg_entitlements;
