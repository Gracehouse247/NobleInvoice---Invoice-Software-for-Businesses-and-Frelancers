-- Migration: Add CMS capabilities to seo_articles and create cms_media bucket

-- 1. Add new columns to seo_articles for manual CMS posts
ALTER TABLE seo_articles 
ADD COLUMN IF NOT EXISTS excerpt TEXT,
ADD COLUMN IF NOT EXISTS tags TEXT[] DEFAULT '{}',
ADD COLUMN IF NOT EXISTS views INTEGER DEFAULT 0;

-- 2. Create the cms_media storage bucket if it doesn't exist
INSERT INTO storage.buckets (id, name, public)
VALUES ('cms_media', 'cms_media', true)
ON CONFLICT (id) DO NOTHING;

-- 3. Storage Policies for cms_media

-- Allow public to read media (view/download)
DROP POLICY IF EXISTS "Public Access" ON storage.objects;
CREATE POLICY "Public Access" 
ON storage.objects FOR SELECT 
USING ( bucket_id = 'cms_media' );

-- Allow admins/editors to upload (insert)
DROP POLICY IF EXISTS "Admin Upload Access" ON storage.objects;
CREATE POLICY "Admin Upload Access"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'cms_media' AND (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND (profiles.role IN ('super_admin', 'seo_manager', 'content_editor') OR profiles.is_superadmin = true)
    )
  )
);

-- Allow admins/editors to update media
DROP POLICY IF EXISTS "Admin Update Access" ON storage.objects;
CREATE POLICY "Admin Update Access"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'cms_media' AND (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND (profiles.role IN ('super_admin', 'seo_manager', 'content_editor') OR profiles.is_superadmin = true)
    )
  )
);

-- Allow admins/editors to delete media
DROP POLICY IF EXISTS "Admin Delete Access" ON storage.objects;
CREATE POLICY "Admin Delete Access"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'cms_media' AND (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND (profiles.role IN ('super_admin', 'seo_manager', 'content_editor') OR profiles.is_superadmin = true)
    )
  )
);
