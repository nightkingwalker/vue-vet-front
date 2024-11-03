import { defineStore } from 'pinia';
import axios from 'axios';
import eventBus from '@/eventBus'; // Import the event bus created with mitt
import router from '@/router';

// Create an Axios instance
const apiClient = axios.create({
    baseURL: import.meta.env.VITE_API_URL || 'https://vet-api.ids-tech.net/api',
});

export const useAuthStore = defineStore('auth', {
    state: () => ({
        token: localStorage.getItem('access_token') || null,
        refreshToken: localStorage.getItem('refresh_token') || null,
        tokenExpiry: localStorage.getItem('token_expiry') || null,
        refreshExpiry: localStorage.getItem('refresh_expiry') || null,
        refreshTimeout: null,
    }),
    getters: {
        isLoggedIn: (state) => !!state.token
    },
    actions: {
        logIn(accessToken, refreshToken, tokenExpiry, refreshExpiry) {
            this.token = accessToken;
            this.refreshToken = refreshToken;
            this.tokenExpiry = tokenExpiry;
            this.refreshExpiry = refreshExpiry;

            localStorage.setItem('access_token', accessToken);
            localStorage.setItem('refresh_token', refreshToken);
            localStorage.setItem('token_expiry', tokenExpiry);
            localStorage.setItem('refresh_expiry', refreshExpiry);

            this.startTokenRefresh();
            this.$patch({ token: accessToken });
        },
        logOut() {
            this.token = null;
            this.refreshToken = null;
            this.tokenExpiry = null;
            this.refreshExpiry = null;

            localStorage.removeItem('access_token');
            localStorage.removeItem('refresh_token');
            localStorage.removeItem('token_expiry');
            localStorage.removeItem('refresh_expiry');

            // eventBus.emit('show-toast', {
            //     severity: 'error',
            //     summary: 'Signed Out',
            //     detail: 'You have been signed out.',
            //     life: 5000,
            // });

            router.push('/login');
        },
        startTokenRefresh() {
            if (!this.token || !this.tokenExpiry) return;

            const currentTime = Date.now() / 1000;
            const timeUntilExpiry = this.tokenExpiry - currentTime;

            const refreshTime = (timeUntilExpiry - 5 * 60) * 1000; // Convert to milliseconds

            if (refreshTime > 0) {
                this.refreshTimeout = setTimeout(() => {
                    this.refreshTokenAction();
                }, refreshTime);
            } else {
                this.logOut(); // Directly log out if the token is already expired
            }
        },
        async refreshTokenAction() {
            // console.log("Attempting refresh");
            const payload = {
                refresh_token: this.refreshToken
            }; // Ensure the payload is an object not a string.
            try {
                const response = await apiClient.post('/auth/refresh', payload, {
                    headers: {
                        'Content-Type': 'application/json', // Ensuring header is set right here.
                        'Authorization': `Bearer ${this.token}` // Make sure the current token is sent if needed.
                    }
                });

                const { access_token, expires_in, refresh_token, refresh_expires_in } = response.data;

                // Calculate the new expiry times based on current time + expiresIn.
                // const currentTime = Math.floor(Date.now() / 1000);
                const newTokenExpiry = expires_in;
                const newRefreshExpiry = refresh_expires_in;
                this.logIn(access_token, refresh_token, newTokenExpiry, newRefreshExpiry);
            } catch (error) {
                console.error('Token refresh failed', error.response || error);
                this.logOut(); // Log out if refresh fails
            }
        }
    }
});