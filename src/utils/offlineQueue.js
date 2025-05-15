import axios from '@/axios';
import { waitForConnection, getOnlineStatus } from './connectivity';

const QUEUE_KEY = 'offline-submissions';
const MAX_ATTEMPTS = 3;
const RETRY_DELAY = 5000;
const DEBUG_MODE = true;


// Debug logger
function debugLog(...messages) {
    if (DEBUG_MODE) {
        console.log('[OfflineQueue]', new Date().toISOString(), ...messages);
    }
}

// Encryption helpers
const encryptData = (data) => {
    return btoa(encodeURIComponent(JSON.stringify(data)));
};

const decryptData = (data) => {
    return JSON.parse(decodeURIComponent(atob(data)));
};

export const addToQueue = async (submission) => {
    const queue = getQueue();
    const newItem = {
        id: Date.now(),
        data: encryptData(submission.data),
        endpoint: submission.endpoint,
        method: submission.method,
        attempts: 0,
        createdAt: new Date().toISOString(),
        expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString()
    };

    queue.push(newItem);
    localStorage.setItem(QUEUE_KEY, JSON.stringify(queue));
    debugLog('Item added to queue:', newItem);

    // Attempt to process queue immediately if online
    if (await getOnlineStatus()) {
        debugLog('Online - attempting immediate processing');
        await processQueue();
    }
};

// Enhanced processQueue with better error handling
export const processQueue = async () => {
    debugLog('Starting queue processing');

    try {
        if (!(await waitForConnection())) {
            debugLog('No connection available - skipping processing');
            return;
        }

        const queue = getQueue();
        if (queue.length === 0) {
            debugLog('Queue is empty - nothing to process');
            return;
        }

        const now = new Date();
        const successItems = [];
        const failedItems = [];
        let processedCount = 0;

        for (const item of queue) {
            // Skip expired items
            if (new Date(item.expiresAt) < now) {
                debugLog(`Skipping expired item ${item.id}`);
                continue;
            }

            try {
                debugLog(`Processing item ${item.id} (attempt ${item.attempts + 1})`);

                await axios({
                    method: item.method,
                    url: item.endpoint,
                    data: decryptData(item.data),
                    headers: {
                        'X-Offline-Retry': 'true',
                        'X-Original-Attempt-Time': item.createdAt
                    }
                });

                successItems.push(item.id);
                processedCount++;
                debugLog(`Successfully processed item ${item.id}`);
            } catch (error) {
                debugLog(`Error processing item ${item.id}:`, error);

                if (item.attempts < MAX_ATTEMPTS) {
                    const updatedItem = {
                        ...item,
                        attempts: item.attempts + 1
                    };
                    failedItems.push(updatedItem);
                    debugLog(`Will retry item ${item.id} (attempt ${updatedItem.attempts})`);
                } else {
                    debugLog(`Max attempts reached for item ${item.id} - giving up`);
                }
            }
        }

        localStorage.setItem(QUEUE_KEY, JSON.stringify(failedItems));
        debugLog(`Queue processing complete. Success: ${successItems.length}, Failed: ${failedItems.length}`);

        return {
            successCount: successItems.length,
            failedCount: failedItems.length
        };
    } catch (error) {
        debugLog('Error in processQueue:', error);
        throw error;
    }
};
export function getPendingCount() {
    return getQueue().length;
}
function getQueue() {
    try {
        const raw = localStorage.getItem(QUEUE_KEY);
        if (!raw) return []; // <- this avoids the JSON.parse error

        const queue = JSON.parse(raw);
        return queue.map(item => ({
            ...item,
            data: typeof item.data === 'string' ? item.data : encryptData(item.data)
        }));
    } catch (error) {
        console.error('Failed to parse offline queue:', error);
        return [];
    }
}

// Enhanced initialization
let isInitialized = false;

export const initQueueProcessor = () => {
    if (isInitialized) {
        debugLog('Queue processor already initialized');
        return;
    }

    isInitialized = true;
    debugLog('Initializing queue processor');

    // Process queue on online event
    window.addEventListener('online', async () => {
        debugLog('Browser online event detected - processing queue');
        await processQueue();
    });

    // Process queue on app visibility change
    document.addEventListener('visibilitychange', async () => {
        if (document.visibilityState === 'visible') {
            debugLog('App became visible - checking queue');
            await processQueue();
        }
    });

    // Periodic queue processing (every 5 minutes)
    setInterval(async () => {
        debugLog('Periodic queue check');
        await processQueue();
    }, 5 * 60 * 1000);

    // Initial processing attempt
    processQueue().catch(error => {
        debugLog('Initial queue processing failed:', error);
    });
};
export const clearExpiredSubmissions = () => {
    const now = new Date();
    const queue = getQueue().filter(item => new Date(item.expiresAt) >= now);
    localStorage.setItem(QUEUE_KEY, JSON.stringify(queue));
};
// Initialize when module loads
initQueueProcessor();
clearExpiredSubmissions();
