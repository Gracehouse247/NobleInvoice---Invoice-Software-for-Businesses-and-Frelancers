import { NextRequest, NextResponse } from 'next/server';

export async function GET(req: NextRequest) {
  const clientId = process.env.LINKEDIN_CLIENT_ID;
  const redirectUri = process.env.LINKEDIN_CALLBACK_URL;

  if (!clientId || !redirectUri) {
    return NextResponse.json({ error: 'LinkedIn credentials not configured.' }, { status: 500 });
  }

  // Define the required scopes for posting to a LinkedIn page or profile
  const scope = 'w_member_social r_liteprofile'; // Or newer scopes depending on the App setup e.g., openid, profile, w_member_social
  const state = Math.random().toString(36).substring(7); // Simple CSRF protection

  const authUrl = `https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=${clientId}&redirect_uri=${encodeURIComponent(redirectUri)}&state=${state}&scope=${encodeURIComponent(scope)}`;

  return NextResponse.redirect(authUrl);
}
