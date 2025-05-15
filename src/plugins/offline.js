import { addToQueue, processQueue, getPendingCount } from '@/utils/offlineQueue';
import { startMonitoring, getOnlineStatus, waitForConnection } from '@/utils/connectivity';

export default {
    install: (app) => {
        // Make utilities available globally
        app.config.globalProperties.$offline = {
            addToQueue,
            processQueue,
            getPendingCount,
            getOnlineStatus,
            waitForConnection
        };

        // Start monitoring when plugin is installed
        startMonitoring();
    }
};