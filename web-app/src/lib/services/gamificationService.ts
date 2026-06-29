import { supabase } from '@/lib/supabase';
import { GamificationModel, UserData } from '@/types';

export const XP_PER_TASK = 25;
export const XP_PER_HABIT = 10;
export const XP_PER_NOTE = 5;

export const XP_THRESHOLDS: Record<number, number> = {
    1: 200, 2: 500, 3: 900, 4: 1400, 5: 2000, 6: 2800, 7: 3800, 8: 5000, 9: 6500, 10: 99999,
};

export const computeLevel = (xp: number): number => {
    let level = 1;
    for (let i = 1; i <= 10; i++) {
        if (xp >= XP_THRESHOLDS[i]) {
            level = i + 1;
        } else {
            break;
        }
    }
    return Math.min(Math.max(level, 1), 10);
};

export const BADGES = [
    { id: 'b1', name: 'First Step', desc: 'Complete your first task', icon: '🥇', xp: 50, isUnlocked: (g: GamificationModel) => g.tasksCompleted >= 1 },
    { id: 'b2', name: 'Habit Builder', desc: '7-day habit streak', icon: '🔥', xp: 100, isUnlocked: (g: GamificationModel) => g.habitsLogged >= 7 },
    { id: 'b3', name: 'Focus Master', desc: 'Complete 10 tasks', icon: '🧠', xp: 200, isUnlocked: (g: GamificationModel) => g.tasksCompleted >= 10 },
];

export interface GamificationResult {
    leveledUp: boolean;
    newBadges: string[];
    streakMilestone?: number;
    streakLabel?: string;
    updatedModel: GamificationModel;
}

export const gamificationService = {
    async initIfNeeded(uid: string): Promise<void> {
        const { error } = await supabase
            .from('user_gamification')
            .select('*')
            .eq('user_id', uid)
            .single();

        if (error && error.code === 'PGRST116') {
            await supabase.from('user_gamification').insert({ user_id: uid });
        }
    },

    subscribeToGamification(uid: string, callback: (model: GamificationModel) => void): () => void {
        supabase.from('user_gamification').select('*').eq('user_id', uid).single().then(({ data }) => {
            if (data) {
                callback({
                    uid: data.user_id,
                    xp: data.xp,
                    level: data.level,
                    unlockedBadges: data.unlocked_badges || [],
                    tasksCompleted: data.tasks_completed,
                    habitsLogged: data.habits_logged,
                    notesCreated: data.notes_created,
                    currentStreak: data.current_streak
                });
            }
        });

        const channel = supabase
            .channel(`gamification:${uid}`)
            .on('postgres_changes', {
                event: '*',
                schema: 'public',
                table: 'user_gamification',
                filter: `user_id=eq.${uid}`
            }, (payload) => {
                const data = payload.new as any;
                if (data) {
                    callback({
                        uid: data.user_id,
                        xp: data.xp,
                        level: data.level,
                        unlockedBadges: data.unlocked_badges || [],
                        tasksCompleted: data.tasks_completed,
                        habitsLogged: data.habits_logged,
                        notesCreated: data.notes_created,
                        currentStreak: data.current_streak
                    });
                }
            })
            .subscribe();

        return () => { supabase.removeChannel(channel); };
    },

    subscribeToLeaderboard(callback: (users: UserData[]) => void): () => void {
        supabase
            .from('user_gamification')
            .select(`
                user_id,
                xp,
                level,
                unlocked_badges,
                profiles!user_id (display_name, brand_logo_url)
            `)
            .order('xp', { ascending: false })
            .limit(10)
            .then(({ data, error }) => {
                if (error) {
                    console.warn('[gamificationService.subscribeToLeaderboard]', error.message);
                    return;
                }
                if (data) {
                    const users = data.map((d: any) => ({
                        id: d.user_id,
                        email: '',
                        name: d.profiles?.display_name || 'Noble User',
                        photoUrl: d.profiles?.brand_logo_url || undefined,
                        gamification: {
                            uid: d.user_id,
                            xp: d.xp,
                            level: d.level,
                            unlockedBadges: d.unlocked_badges || [],
                            tasksCompleted: 0,
                            habitsLogged: 0,
                            notesCreated: 0,
                            currentStreak: 0
                        }
                    })) as unknown as UserData[];
                    callback(users);
                }
            });
        return () => {};
    },

    async _processEvent(uid: string, eventType: 'task' | 'habit' | 'note', habitStreak?: number): Promise<GamificationResult | null> {
        const { data: current, error } = await supabase
            .from('user_gamification')
            .select('*')
            .eq('user_id', uid)
            .single();

        if (error || !current) return null;

        let xpAdded = 0;
        let updateData: any = {};
        
        let currentBadges = Array.isArray(current.unlocked_badges) ? [...current.unlocked_badges] : [];

        if (eventType === 'task') {
            xpAdded = XP_PER_TASK;
            updateData.tasks_completed = current.tasks_completed + 1;
        } else if (eventType === 'habit') {
            xpAdded = XP_PER_HABIT;
            updateData.habits_logged = current.habits_logged + 1;
            if (habitStreak !== undefined && habitStreak > current.current_streak) {
                updateData.current_streak = habitStreak;
            }
        } else if (eventType === 'note') {
            xpAdded = XP_PER_NOTE;
            updateData.notes_created = current.notes_created + 1;
        }

        const newXp = current.xp + xpAdded;
        const newLevel = computeLevel(newXp);
        const leveledUp = newLevel > current.level;

        updateData.xp = newXp;
        updateData.level = newLevel;

        const modelForBadges: GamificationModel = {
            uid,
            xp: newXp,
            level: newLevel,
            unlockedBadges: currentBadges,
            tasksCompleted: updateData.tasks_completed ?? current.tasks_completed,
            habitsLogged: updateData.habits_logged ?? current.habits_logged,
            notesCreated: updateData.notes_created ?? current.notes_created,
            currentStreak: updateData.current_streak ?? current.current_streak
        };

        const newBadgesUnlocked: string[] = [];
        BADGES.forEach(b => {
            if (!currentBadges.includes(b.id) && b.isUnlocked(modelForBadges)) {
                newBadgesUnlocked.push(b.id);
                currentBadges.push(b.id);
            }
        });

        if (newBadgesUnlocked.length > 0) {
            updateData.unlocked_badges = currentBadges;
        }

        await supabase.from('user_gamification').update(updateData).eq('user_id', uid);

        return {
            leveledUp,
            newBadges: newBadgesUnlocked,
            streakMilestone: updateData.current_streak,
            streakLabel: updateData.current_streak ? `${updateData.current_streak} Day Streak!` : undefined,
            updatedModel: {
                ...modelForBadges,
                unlockedBadges: currentBadges
            }
        };
    },

    async onTaskCompleted(uid: string) { return this._processEvent(uid, 'task'); },
    async onHabitLogged(uid: string, habitStreak?: number) { return this._processEvent(uid, 'habit', habitStreak); },
    async onNoteCreated(uid: string) { return this._processEvent(uid, 'note'); }
};
