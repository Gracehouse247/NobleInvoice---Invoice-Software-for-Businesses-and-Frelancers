'use server';

import { createServerClient, type CookieOptions } from '@supabase/ssr';
import { cookies } from 'next/headers';

export async function completeOnboardingAction(formData: FormData) {
  const cookieStore = await cookies();
  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        get(name: string) {
          return cookieStore.get(name)?.value;
        },
        set(name: string, value: string, options: CookieOptions) {
          try {
            cookieStore.set({ name, value, ...options });
          } catch (error) {
            // The `set` method was called from a Server Component.
          }
        },
        remove(name: string, options: CookieOptions) {
          try {
            cookieStore.set({ name, value: '', ...options });
          } catch (error) {
            // The `delete` method was called from a Server Component.
          }
        },
      },
    }
  );

  const { data: { user }, error: authError } = await supabase.auth.getUser();

  if (authError || !user) {
    return { success: false, error: 'Unauthorized' };
  }

  // Extract step 1 data (Identity)
  const businessName = formData.get('businessName') as string;
  const industry = formData.get('industry') as string;
  const country = formData.get('country') as string;

  // Extract step 2 data (Branding)
  const brandColor = formData.get('brandColor') as string;
  const secondaryColor = formData.get('secondaryColor') as string;
  const brandVoice = formData.get('brandVoice') as string;
  const logoUrl = formData.get('logoUrl') as string; // Assume uploaded by client and URL passed

  // Extract step 3 data (Invoicing)
  const taxNumber = formData.get('taxNumber') as string;
  const invoiceFooter = formData.get('invoiceFooter') as string;

  if (!businessName) {
    return { success: false, error: 'Business name is required' };
  }

  const { error: updateError } = await supabase
    .from('profiles')
    .update({
      business_name: businessName,
      industry: industry || null,
      country: country || null,
      brand_color: brandColor || '#1E293B',
      secondary_color: secondaryColor || '#2563EB',
      brand_voice: brandVoice || 'Professional',
      brand_logo_url: logoUrl || null,
      tax_number: taxNumber || null,
      invoice_footer: invoiceFooter || null,
      onboarding_completed: true,
    })
    .eq('id', user.id);

  if (updateError) {
    console.error('Error updating profile during onboarding:', updateError);
    return { success: false, error: 'Failed to complete onboarding' };
  }

  return { success: true };
}
