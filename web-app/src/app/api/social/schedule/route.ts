import { NextRequest, NextResponse } from 'next/server';
import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
);

export async function POST(req: NextRequest) {
  try {
    const { articleId, platform, content, scheduledFor } = await req.json();

    if (!platform || !content || !scheduledFor) {
      return NextResponse.json({ error: 'Missing required fields' }, { status: 400 });
    }

    // Insert into scheduled_posts
    const { data, error } = await supabase.from('scheduled_posts').insert({
      article_id: articleId || null,
      platform,
      content_text: typeof content === 'string' ? content : JSON.stringify(content),
      scheduled_for: new Date(scheduledFor).toISOString(),
      status: 'pending'
    }).select().single();

    if (error) {
      throw error;
    }

    return NextResponse.json({ success: true, data });
  } catch (error: any) {
    console.error('Schedule Error:', error);
    return NextResponse.json({ error: error.message || 'Failed to schedule post' }, { status: 500 });
  }
}
