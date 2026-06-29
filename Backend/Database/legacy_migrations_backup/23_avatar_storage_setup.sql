-- ==============================================================================
-- NOBLEGO: AVATAR STORAGE CONFIGURATION
-- ==============================================================================

-- 1. Create the 'avatars' bucket if it doesn't exist
-- We use a more permissive approach for bucket creation
INSERT INTO storage.buckets (id, name, public)
VALUES ('avatars', 'avatars', true)
ON CONFLICT (id) DO UPDATE SET public = true;

-- 2. Storage Policies for 'avatars'
-- Note: We skip 'ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY' 
-- because it's usually already enabled for Supabase Storage.

-- Policy: Allow public to view avatars
-- We use 'DO' blocks to avoid errors if policies already exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'objects' AND policyname = 'Public Access for Avatars'
    ) THEN
        CREATE POLICY "Public Access for Avatars"
        ON storage.objects FOR SELECT
        USING ( bucket_id = 'avatars' );
    END IF;
END $$;

-- Policy: Allow authenticated users to upload their own avatar
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'objects' AND policyname = 'User Upload Avatar'
    ) THEN
        CREATE POLICY "User Upload Avatar"
        ON storage.objects FOR INSERT
        TO authenticated
        WITH CHECK (
            bucket_id = 'avatars' AND 
            (storage.foldername(name))[1] = auth.uid()::text
        );
    END IF;
END $$;

-- Policy: Allow users to update their own avatar
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'objects' AND policyname = 'User Update Avatar'
    ) THEN
        CREATE POLICY "User Update Avatar"
        ON storage.objects FOR UPDATE
        TO authenticated
        USING (
            bucket_id = 'avatars' AND 
            (storage.foldername(name))[1] = auth.uid()::text
        );
    END IF;
END $$;

-- Policy: Allow users to delete their own avatar
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'objects' AND policyname = 'User Delete Avatar'
    ) THEN
        CREATE POLICY "User Delete Avatar"
        ON storage.objects FOR DELETE
        TO authenticated
        USING (
            bucket_id = 'avatars' AND 
            (storage.foldername(name))[1] = auth.uid()::text
        );
    END IF;
END $$;
