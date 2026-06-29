-- NobleGo: Link Invoice Items to Inventory
ALTER TABLE public.invoice_items 
ADD COLUMN product_id BIGINT REFERENCES public.products(id) ON DELETE SET NULL;
