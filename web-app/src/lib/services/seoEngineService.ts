import { supabase } from '@/lib/supabase';
import { SEOKeyword, SEOArticle, RankingsTracker, SEOSettings } from '@/lib/seoData';

export const seoEngineService = {
  // Bulk import keywords
  async importKeywords(keywords: Omit<SEOKeyword, 'id' | 'status' | 'created_at'>[]): Promise<{ data: any; error: any }> {
    try {
      const records = keywords.map(kw => ({
        ...kw,
        status: 'pending',
        created_at: new Date().toISOString()
      }));

      const { data, error } = await supabase
        .from('seo_keywords')
        .insert(records)
        .select();

      return { data, error };
    } catch (err: any) {
      return { data: null, error: err };
    }
  },

  // Fetch all keywords
  async getKeywords(): Promise<{ data: SEOKeyword[] | null; error: any }> {
    const { data, error } = await supabase
      .from('seo_keywords')
      .select('*')
      .order('created_at', { ascending: false });

    return { data, error };
  },

  // Fetch ranking history
  async getRankings(): Promise<{ data: RankingsTracker[] | null; error: any }> {
    const { data, error } = await supabase
      .from('rankings_tracker')
      .select(`
        id,
        keyword_id,
        google_rank,
        serps_snapshot_url,
        tracked_at,
        seo_keywords ( keyword )
      `)
      .order('tracked_at', { ascending: false });

    // Format query return structure
    const formattedData = data?.map((item: any) => ({
      id: item.id,
      keyword_id: item.keyword_id,
      google_rank: item.google_rank,
      serps_snapshot_url: item.serps_snapshot_url,
      tracked_at: item.tracked_at,
      keyword: item.seo_keywords?.keyword || 'Unknown'
    })) || [];

    return { data: formattedData as RankingsTracker[], error };
  },

  // Fetch generated articles list
  async getArticles(): Promise<{ data: SEOArticle[] | null; error: any }> {
    const { data, error } = await supabase
      .from('seo_articles')
      .select('*')
      .order('published_at', { ascending: false });

    return { data, error };
  },

  // Get active queue statistics
  async getQueueStats(): Promise<{ pending: number; processing: number; completed: number; failed: number }> {
    const { data, error } = await supabase
      .from('seo_keywords')
      .select('status');

    const stats = { pending: 0, processing: 0, completed: 0, failed: 0 };
    if (!error && data) {
      data.forEach((kw: any) => {
        if (kw.status === 'pending') stats.pending++;
        else if (kw.status === 'processing') stats.processing++;
        else if (kw.status === 'completed') stats.completed++;
        else if (kw.status === 'failed') stats.failed++;
      });
    }
    return stats;
  },

  // Force trigger execution pipeline for a specific keyword
  async triggerGeneration(keywordId: string): Promise<{ success: boolean; error: any }> {
    try {
      // Set status to processing
      await supabase
        .from('seo_keywords')
        .update({ status: 'processing' })
        .eq('id', keywordId);

      // Hit our Supabase edge function
      const session = await supabase.auth.getSession();
      const response = await fetch(
        `${process.env.NEXT_PUBLIC_SUPABASE_URL}/functions/v1/autonomous-seo-orchestrator`,
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${session.data.session?.access_token}`
          },
          body: JSON.stringify({ keywordId })
        }
      );

      if (!response.ok) {
        throw new Error(await response.text());
      }

      return { success: true, error: null };
    } catch (err: any) {
      // Set status back to failed
      await supabase
        .from('seo_keywords')
        .update({ status: 'failed' })
        .eq('id', keywordId);

      return { success: false, error: err.message };
    }
  },

  // Save orchestration settings
  async saveSettings(settings: {
    default_meta_title: string;
    default_meta_description: string;
    auto_publish: boolean;
    cron_expression: string;
  }): Promise<{ error: any }> {
    try {
      // Try to upsert into seo_settings table
      const { error } = await supabase
        .from('seo_settings')
        .upsert({
          id: 'global',
          ...settings,
          updated_at: new Date().toISOString()
        }, { onConflict: 'id' });

      if (error) {
        // Fallback: save to localStorage if table doesn't exist yet
        console.warn('seo_settings table not available, saving to localStorage:', error.message);
        localStorage.setItem('seo_settings', JSON.stringify(settings));
        return { error: null }; // Treat as success with localStorage fallback
      }

      return { error: null };
    } catch (err: any) {
      // Ultimate fallback
      localStorage.setItem('seo_settings', JSON.stringify(settings));
      return { error: null };
    }
  },

  // Load orchestration settings
  async loadSettings(): Promise<{ data: any; error: any }> {
    try {
      const { data, error } = await supabase
        .from('seo_settings')
        .select('*')
        .eq('id', 'global')
        .single();

      if (error || !data) {
        // Fallback: load from localStorage
        const local = localStorage.getItem('seo_settings');
        if (local) {
          return { data: JSON.parse(local), error: null };
        }
        return { data: null, error };
      }

      return { data, error: null };
    } catch (err: any) {
      const local = localStorage.getItem('seo_settings');
      if (local) {
        return { data: JSON.parse(local), error: null };
      }
      return { data: null, error: err };
    }
  }
};
