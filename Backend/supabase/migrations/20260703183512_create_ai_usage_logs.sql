CREATE TABLE public.ai_usage_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    month_year VARCHAR(7) NOT NULL, -- Format: YYYY-MM
    calls_made INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, month_year)
);

-- Enable RLS
ALTER TABLE public.ai_usage_logs ENABLE ROW LEVEL SECURITY;

-- Allow users to read their own usage logs
CREATE POLICY "Users can view own usage logs" 
ON public.ai_usage_logs FOR SELECT 
TO authenticated 
USING (auth.uid() = user_id);

-- Edge functions will bypass RLS because they use the service_role key.
-- Users cannot INSERT or UPDATE.

-- Function to handle timestamp auto-update
CREATE OR REPLACE FUNCTION update_ai_usage_logs_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_ai_usage_logs_timestamp
BEFORE UPDATE ON public.ai_usage_logs
FOR EACH ROW
EXECUTE FUNCTION update_ai_usage_logs_updated_at();
