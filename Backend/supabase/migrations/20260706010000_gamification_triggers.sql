-- Migration: gamification_triggers
-- Description: Triggers to automatically handle XP and badge progression on invoice status changes.

CREATE OR REPLACE FUNCTION public.compute_level(xp INTEGER)
RETURNS INTEGER AS $$
DECLARE
    new_level INTEGER := 1;
BEGIN
    IF xp >= 99999 THEN new_level := 11;
    ELSIF xp >= 6500 THEN new_level := 10;
    ELSIF xp >= 5000 THEN new_level := 9;
    ELSIF xp >= 3800 THEN new_level := 8;
    ELSIF xp >= 2800 THEN new_level := 7;
    ELSIF xp >= 2000 THEN new_level := 6;
    ELSIF xp >= 1400 THEN new_level := 5;
    ELSIF xp >= 900 THEN new_level := 4;
    ELSIF xp >= 500 THEN new_level := 3;
    ELSIF xp >= 200 THEN new_level := 2;
    END IF;
    RETURN new_level;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION public.handle_invoice_gamification()
RETURNS TRIGGER AS $$
DECLARE
    v_user_id UUID;
    v_xp_to_add INTEGER := 0;
    v_invoices_to_add INTEGER := 0;
    v_payments_to_add INTEGER := 0;
BEGIN
    -- Only act if status changed
    IF NEW.status = OLD.status THEN
        RETURN NEW;
    END IF;

    -- Get the user_id (owner of the team)
    SELECT owner_id INTO v_user_id FROM public.teams WHERE id = NEW.team_id;
    IF v_user_id IS NULL THEN
        RETURN NEW;
    END IF;

    IF NEW.status = 'sent' AND OLD.status != 'sent' THEN
        v_xp_to_add := 50;
        v_invoices_to_add := 1;
    ELSIF NEW.status = 'paid' AND OLD.status != 'paid' THEN
        v_xp_to_add := 100;
        v_payments_to_add := 1;
    END IF;

    IF v_xp_to_add > 0 THEN
        UPDATE public.user_gamification
        SET 
            xp = xp + v_xp_to_add,
            level = public.compute_level(xp + v_xp_to_add),
            invoices_sent = invoices_sent + v_invoices_to_add,
            payments_received = payments_received + v_payments_to_add,
            updated_at = NOW()
        WHERE user_id = v_user_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_invoice_status_gamification ON public.invoices;
CREATE TRIGGER on_invoice_status_gamification
    AFTER UPDATE OF status ON public.invoices
    FOR EACH ROW EXECUTE FUNCTION public.handle_invoice_gamification();
