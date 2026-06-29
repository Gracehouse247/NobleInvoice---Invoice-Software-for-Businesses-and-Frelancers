-- C:\Projects\NobleGo\Database\22_payment_methods_table.sql
-- ==============================================================================
-- NOBLEGO PHASE 8: MERCHANT PAYMENT METHODS STORAGE
-- Stores masked card data and payment tokens for the merchant's own usage.
-- ==============================================================================

CREATE TABLE IF NOT EXISTS public.payment_methods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    type TEXT NOT NULL, -- 'visa', 'mastercard', 'flutterwave', etc.
    last4 TEXT,
    expiry TEXT,
    token TEXT, -- Optional gateway token
    is_default BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.payment_methods ENABLE ROW LEVEL SECURITY;

-- Policies: Users can only see and manage their own payment methods
CREATE POLICY "Users can view their own payment methods" 
ON public.payment_methods FOR SELECT 
TO authenticated 
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own payment methods" 
ON public.payment_methods FOR INSERT 
TO authenticated 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own payment methods" 
ON public.payment_methods FOR UPDATE 
TO authenticated 
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own payment methods" 
ON public.payment_methods FOR DELETE 
TO authenticated 
USING (auth.uid() = user_id);

-- Indexing for fast lookups
CREATE INDEX IF NOT EXISTS idx_payment_methods_user_id ON public.payment_methods(user_id);

-- Trigger for updated_at
CREATE OR REPLACE TRIGGER set_payment_methods_updated_at
BEFORE UPDATE ON public.payment_methods
FOR EACH ROW
EXECUTE FUNCTION public.handle_updated_at();

COMMENT ON TABLE public.payment_methods IS 'Stores masked card data and gateway tokens for the authenticated merchant.';
