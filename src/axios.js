import axios from "axios";
import { useAuthStore } from "@/stores/authStore";
import router from "@/router";
import eventBus from "./eventBus"; // Import the event bus created with mitt

// Create an Axios instance
const apiClient = axios.create({
    baseURL: import.meta.env.VITE_API_URL || "https://vet-api.ids-tech.net/api",
    timeout: 5000, // Set a timeout for requests
});

// Add a request interceptor to handle token expiry
apiClient.interceptors.request.use(
    async(config) => {
        const authStore = useAuthStore();

        // Check if the token is expired
        if (authStore.tokenExpiry && Date.now() / 1000 > authStore.tokenExpiry) {
            try {
                await authStore.refreshTokenAction();
                config.headers.Authorization = `Bearer ${authStore.token}`;
            } catch (error) {

                authStore.logOut();
                router.push("/login");
                return Promise.reject(error);
            }
        } else if (authStore.token) {
            config.headers.Authorization = `Bearer ${authStore.token}`;
        }
        return config;
    },
    (error) => {
        return Promise.reject(error);
    }
);

// Add a response interceptor to handle 401 errors and other network issues
apiClient.interceptors.response.use(
    (response) => response,
    (error) => {
        if (error.response && error.response.status === 401 && !error.config._retry) {
            const authStore = useAuthStore();
            error.config._retry = true;
            return authStore
                .refreshTokenAction()
                .then(() => {
                    apiClient.defaults.headers.common["Authorization"] = `Bearer ${authStore.token}`;
                    apiClient.defaults.headers.common["Content-Type"] = `application/json`;
                    apiClient.defaults.headers.common["Accept"] = `application/json`;
                    return apiClient(error.config);
                })
                .catch((refreshError) => {
                    eventBus.emit("show-toast", {
                        severity: "error",
                        summary: "Authentication Error",
                        detail: "Session expired, please log in again.",
                        life: 5000,
                    });
                    authStore.logOut();
                    router.push("/login");
                    return Promise.reject(refreshError);
                });
        } else if (!navigator.onLine ||
            error.code === "ECONNABORTED" ||
            error.message.includes("Network Error") ||
            (error.response && error.response.status === 503)
        ) {
            eventBus.emit("show-toast", {
                severity: "error",
                summary: "Network Error",
                detail: "Please check your internet connection and try again.",
                life: 5000,
            });
        }
        return Promise.reject(error);
    }
);

export default apiClient;