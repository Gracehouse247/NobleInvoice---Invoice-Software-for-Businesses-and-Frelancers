-- Add pillar_page_id to seo_articles to support Topic Clusters and Internal Linking hierarchies
ALTER TABLE public.seo_articles 
ADD COLUMN IF NOT EXISTS pillar_page_id UUID REFERENCES public.seo_articles(id) ON DELETE SET NULL;

-- Add a comment to describe the column
COMMENT ON COLUMN public.seo_articles.pillar_page_id IS 'References the parent pillar article for topic cluster grouping';

-- Create an index to speed up fetching related cluster articles
CREATE INDEX IF NOT EXISTS idx_seo_articles_pillar_page_id ON public.seo_articles(pillar_page_id);
