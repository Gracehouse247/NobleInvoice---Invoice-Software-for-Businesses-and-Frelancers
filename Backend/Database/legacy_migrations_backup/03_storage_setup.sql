-- ==============================================================================
-- NOBLEGO: SUPABASE STORAGE CONFIGURATION
-- Follow these instructions in your Supabase Dashboard
-- ==============================================================================

/*
Unlike SQL tables, Supabase Storage buckets cannot be created purely via 
the default public schema SQL without special extensions or RPCs. 

Please follow these manual steps in your Supabase Dashboard:

1. Go to "Storage" in the left sidebar menu.
2. Click "New Bucket"

CREATE BUCKET 1:
- Name: brand-assets
- Public: YES 
- Purpose: Stores business logos and branding images.

CREATE BUCKET 2:
- Name: qr_assets
- Public: YES
- Purpose: Stores files uploaded to be linked via QR codes (PDFs, Images, MP3s).

CREATE BUCKET 3 (Optional but recommended):
- Name: invoice_pdfs
- Public: NO (Keep Private)
- Purpose: Used for backing up generated invoice PDFs before sending.


STORAGE RLS POLICIES (Example for brand-assets):

Once you create `brand-assets`, you still need to permit uploads via policies.
In the Storage > Policies page, create a policy for the `brand-assets` bucket:

- Choose "New Policy"
- Action: "INSERT"
- Target roles: "authenticated"
- Policy Definition: (bucket_id = 'brand-assets')

And a policy for reading:

- Action: "SELECT"
- Target roles: "anon", "authenticated"
- Policy Definition: (bucket_id = 'brand-assets')

*/
