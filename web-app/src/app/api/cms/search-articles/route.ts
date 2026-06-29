import { NextRequest, NextResponse } from 'next/server';
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;
const supabase = createClient(supabaseUrl, supabaseKey);

export async function GET(req: NextRequest) {
  const { searchParams } = new URL(req.url);
  const q = searchParams.get('q');

  if (!q) {
    return NextResponse.json({ articles: [] });
  }

  try {
    // Full-Text search on title and excerpt
    // Or simple ilike if FTS is not explicitly configured
    const { data, error } = await supabase
      .from('seo_articles')
      .select('id, title, slug, excerpt')
      .ilike('title', `%${q}%`)
      .limit(10);

    if (error) {
      throw error;
    }

    return NextResponse.json({ articles: data });
  } catch (err: any) {
    return NextResponse.json({ error: err.message }, { status: 500 });
  }
}
