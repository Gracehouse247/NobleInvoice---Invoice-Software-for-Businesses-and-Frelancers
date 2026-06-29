import { create } from 'zustand';
import { persist } from 'zustand/middleware';

export interface SyncAction {
    id: string;
    type: 'CREATE_INVOICE' | 'UPDATE_INVOICE' | 'CREATE_CLIENT' | 'UPDATE_CLIENT';
    payload: any;
    timestamp: number;
    retryCount: number;
}

export interface SyncConflict {
    action: SyncAction;
    remoteData?: any;
    message: string;
}

interface SyncStore {
    queue: SyncAction[];
    conflicts: SyncConflict[];
    isOnline: boolean;
    addToQueue: (action: Omit<SyncAction, 'id' | 'timestamp' | 'retryCount'>) => void;
    removeFromQueue: (id: string) => void;
    incrementRetry: (id: string) => void;
    setOnlineStatus: (status: boolean) => void;
    clearQueue: () => void;
    addConflict: (conflict: SyncConflict) => void;
    removeConflict: (actionId: string) => void;
}

export const useSyncStore = create<SyncStore>()(
    persist(
        (set) => ({
            queue: [],
            conflicts: [],
            isOnline: typeof window !== 'undefined' ? navigator.onLine : true,
            
            addToQueue: (action) => set((state) => ({
                queue: [
                    ...state.queue, 
                    {
                        ...action,
                        id: crypto.randomUUID(),
                        timestamp: Date.now(),
                        retryCount: 0
                    }
                ]
            })),
            
            removeFromQueue: (id) => set((state) => ({
                queue: state.queue.filter(a => a.id !== id)
            })),
            
            incrementRetry: (id) => set((state) => ({
                queue: state.queue.map(a => 
                    a.id === id ? { ...a, retryCount: a.retryCount + 1 } : a
                )
            })),
            
            setOnlineStatus: (status) => set({ isOnline: status }),
            
            clearQueue: () => set({ queue: [], conflicts: [] }),

            addConflict: (conflict) => set((state) => ({
                conflicts: [...state.conflicts, conflict],
                // Also remove it from the regular queue so it doesn't keep failing
                queue: state.queue.filter(a => a.id !== conflict.action.id)
            })),

            removeConflict: (actionId) => set((state) => ({
                conflicts: state.conflicts.filter(c => c.action.id !== actionId)
            }))
        }),
        {
            name: 'noble-sync-queue',
        }
    )
);
