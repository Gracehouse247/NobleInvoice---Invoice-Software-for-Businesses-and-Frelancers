import { useEffect, useCallback } from 'react';
import { useSyncStore } from '@/store/useSyncStore';
import { clientService, invoiceService } from '@/lib/services/supabaseService';
import { toast } from 'react-hot-toast';

const CONFLICT_MESSAGE = 'Conflict: Data was modified by another device since last sync.';

export function useOfflineSync() {
    const { queue, conflicts, isOnline, setOnlineStatus, removeFromQueue, incrementRetry, addConflict } = useSyncStore();

    const processQueue = useCallback(async () => {
        if (!isOnline || queue.length === 0) return;

        let processedCount = 0;
        let conflictCount = 0;

        // Process sequentially to avoid race conditions
        for (const action of queue) {
            if (action.retryCount >= 3) {
                // After 3 retries, escalate to conflict resolution rather than infinitely retrying.
                // This matches industry best practice: treat a persistently failing action as a conflict.
                addConflict({
                    action,
                    message: `Action failed after 3 retries. Please review and resolve manually.`
                });
                conflictCount++;
                continue;
            }

            try {
                switch (action.type) {
                    case 'CREATE_CLIENT':
                        await clientService.createClient(action.payload);
                        break;
                    case 'UPDATE_CLIENT':
                        if (!action.payload.id) throw new Error('Missing client ID');
                        // Pass the snapshot timestamp so the server can detect concurrent edits
                        await clientService.updateClient(
                            action.payload.id,
                            action.payload,
                            action.payload._snapshotAt
                        );
                        break;
                    case 'CREATE_INVOICE':
                        await invoiceService.createInvoice(action.payload);
                        break;
                    case 'UPDATE_INVOICE':
                        if (!action.payload.id) throw new Error('Missing invoice ID');
                        await invoiceService.updateInvoice(
                            action.payload.id,
                            action.payload,
                            action.payload._snapshotAt
                        );
                        break;
                    default:
                        console.warn(`Unknown action type: ${action.type}`);
                        removeFromQueue(action.id);
                        continue;
                }

                removeFromQueue(action.id);
                processedCount++;

            } catch (err: any) {
                const isConflict = err?.message === CONFLICT_MESSAGE;

                if (isConflict) {
                    // Version conflict: server was changed by another device.
                    // Route to conflict queue for user-assisted resolution — do NOT retry.
                    addConflict({
                        action,
                        message: CONFLICT_MESSAGE
                    });
                    conflictCount++;
                } else {
                    // Transient network/server error — increment retry and try again on next sync
                    console.error(`Failed to process action ${action.id}:`, err);
                    incrementRetry(action.id);
                }
            }
        }

        if (processedCount > 0) {
            toast.success(`✓ Synced ${processedCount} offline action${processedCount > 1 ? 's' : ''}.`);
        }
        if (conflictCount > 0) {
            toast.error(`⚠ ${conflictCount} conflict${conflictCount > 1 ? 's' : ''} detected. Please review.`, {
                duration: 6000,
                id: 'sync-conflict-alert'
            });
        }
    }, [queue, isOnline, removeFromQueue, incrementRetry, addConflict]);

    useEffect(() => {
        const handleOnline = () => {
            setOnlineStatus(true);
            toast.success('Connection restored. Syncing...');
        };
        const handleOffline = () => {
            setOnlineStatus(false);
            toast.error('You are offline. Changes will be saved locally.');
        };

        window.addEventListener('online', handleOnline);
        window.addEventListener('offline', handleOffline);

        if (isOnline && queue.length > 0) {
            processQueue();
        }

        return () => {
            window.removeEventListener('online', handleOnline);
            window.removeEventListener('offline', handleOffline);
        };
    }, [isOnline, setOnlineStatus, processQueue, queue.length]);

    return {
        isOnline,
        queueLength: queue.length,
        conflictCount: conflicts.length,
        processQueue
    };
}
