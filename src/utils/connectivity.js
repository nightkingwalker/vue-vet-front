import axios from '@/axios';

const HEALTH_CHECK_ENDPOINT = '/health-check';
const CHECK_INTERVAL = 2000;
const TIMEOUT = 5000;

// Debug mode - set to true to enable logging
const DEBUG_MODE = false;

// State management
const state = {
    isOnline: navigator.onLine,
    lastChecked: null,
    checking: false
};

function debugLog(...messages) {
    if (DEBUG_MODE) {
        console.debug('[Connectivity]', new Date().toISOString(), ...messages);
    }
}

const checkBackendAlive = async () => {
    // Skip if already checking
    if (state.checking) {
        debugLog('Skipping check - already in progress');
        return state.isOnline;
    }

    state.checking = true;
    debugLog('Starting connectivity check');

    try {
        // First check basic connectivity
        if (!navigator.onLine) {
            state.isOnline = false;
            debugLog('Browser reports offline - navigator.onLine false');
            return false;
        }

        debugLog('Browser reports online, checking backend...');

        // Try a HEAD request with timeout
        const response = await axios.head(HEALTH_CHECK_ENDPOINT, {
            timeout: TIMEOUT,
            headers: {
                'Cache-Control': 'no-cache',
                'Pragma': 'no-cache'
            }
        });

        const success = response.status >= 200 && response.status < 300;
        state.isOnline = success;

        debugLog(`Backend check ${success ? 'successful' : 'failed'}`, {
            status: response.status,
            statusText: response.statusText
        });

        return success;
    } catch (error) {
        state.isOnline = false;
        debugLog('Backend check failed with error:', {
            error: error.name,
            message: error.message,
            config: {
                url: error.config?.url,
                method: error.config?.method
            }
        });
        return false;
    } finally {
        state.checking = false;
        state.lastChecked = Date.now();
        debugLog('Check completed', {
            isOnline: state.isOnline,
            lastChecked: new Date(state.lastChecked).toISOString()
        });
    }
};

export const waitForConnection = async (timeout = 30000) => {
    debugLog('Waiting for connection with timeout:', timeout);
    const start = Date.now();
    while (Date.now() - start < timeout) {
        if (await getOnlineStatus()) {
            debugLog('Connection restored within timeout');
            return true;
        }
        await new Promise(resolve => setTimeout(resolve, 2000));
    }
    debugLog('Timeout reached without connection');
    return false;
};

export const getOnlineStatus = async () => {
    // Return cached result if recent
    if (state.lastChecked && Date.now() - state.lastChecked < CHECK_INTERVAL) {
        debugLog('Using cached online status:', state.isOnline);
        return state.isOnline;
    }
    return await checkBackendAlive();
};

// Continuous monitoring
let monitorInterval;

export const startMonitoring = () => {
    if (monitorInterval) {
        debugLog('Restarting monitoring interval');
        clearInterval(monitorInterval);
    } else {
        debugLog('Starting monitoring interval');
    }

    // Initial check
    checkBackendAlive();

    // Set up interval
    monitorInterval = setInterval(() => {
        debugLog('Interval check triggered');
        checkBackendAlive();
    }, CHECK_INTERVAL);
};

// Initialize
debugLog('Initializing connectivity monitoring');
startMonitoring();

// Add event listeners for browser online/offline events
window.addEventListener('online', () => {
    debugLog('Browser online event detected');
    checkBackendAlive();
});

window.addEventListener('offline', () => {
    debugLog('Browser offline event detected');
    state.isOnline = false;
    state.lastChecked = Date.now();
});