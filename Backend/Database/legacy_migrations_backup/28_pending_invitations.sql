-- c:\Projects\NobleGo\Database\28_pending_invitations.sql
-- Migration to support team invitations for users not yet in the system.

CREATE TABLE IF NOT EXISTS pending_invitations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    team_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    role TEXT NOT NULL DEFAULT 'staff',
    invited_by UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT now(),
    expires_at TIMESTAMPTZ NOT NULL,
    
    -- Ensure same user doesn't get multiple active invites to same team
    UNIQUE(team_id, email)
);

-- Enable RLS
ALTER TABLE pending_invitations ENABLE ROW LEVEL SECURITY;

-- Policies
-- 1. Members of a team can see its pending invitations
CREATE POLICY "Team members can view pending invites" ON pending_invitations
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM team_members
            WHERE team_id = pending_invitations.team_id
            AND user_id = auth.uid()
        )
    );

-- 2. Owners and Admins can create invitations
CREATE POLICY "Owners and admins can create invites" ON pending_invitations
    FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM team_members
            WHERE team_id = pending_invitations.team_id
            AND user_id = auth.uid()
            AND role IN ('owner', 'admin')
        )
    );

-- 3. Owners and Admins can delete invitations
CREATE POLICY "Owners and admins can delete invites" ON pending_invitations
    FOR DELETE
    USING (
        EXISTS (
            SELECT 1 FROM team_members
            WHERE team_id = pending_invitations.team_id
            AND user_id = auth.uid()
            AND role IN ('owner', 'admin')
        )
    );
