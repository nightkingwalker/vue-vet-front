/*NEEDS TO WORK ON SECURITY */

import { defineStore } from "pinia";
import axios from "axios";
import Cookies from "js-cookie";
import router from "@/router";

const apiClient = axios.create({
  baseURL: import.meta.env.VITE_API_URL || "https://vet-api.ids-tech.net/api",
  timeout: 5000,
  headers: {
    "Content-Type": "application/json",
  },
});

// Interceptor to attach the access token to requests
apiClient.interceptors.request.use(
  (config) => {
    const accessToken = Cookies.get("access_token");
    if (accessToken) {
      config.headers["Authorization"] = `Bearer ${accessToken}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

export const useAuthStore = defineStore("auth", {
  state: () => ({
    token: Cookies.get("access_token") || null,
    refreshToken: Cookies.get("refresh_token") || null,
    tokenExpiry: Cookies.get("token_expiry") || null,
    refreshExpiry: Cookies.get("refresh_expiry") || null,
    BranchID: Cookies.get("M3K8g2387BahBaqyjDe6") || null,
    refreshTimeout: null,
    userTheme: Cookies.get("theme") || 'light',
    userLanguage: Cookies.get("language") || 'en' // Initialize from cookies

  }),
  getters: {
    isLoggedIn: (state) => !!state.token,
    currentTheme: (state) => state.userTheme,
    currentLanguage: (state) => state.userLanguage // Simple getter from state
  },
  actions: {
    // Log in user and store tokens
    logIn(
      accessToken,
      refreshToken,
      tokenExpiry,
      refreshExpiry,
      userName,
      userTheme = 'light',  // Default value added here
      userLanguage = 'en',   // Default language
      shortcuts = null,      // Default shortcuts
      M3K8g2387BahBaqyjDe6, //clinic_b_uid
    ) {
      this.token = accessToken;
      this.refreshToken = refreshToken;
      this.tokenExpiry = tokenExpiry;
      this.refreshExpiry = refreshExpiry;
      this.BranchID = M3K8g2387BahBaqyjDe6;
      this.updateTheme(userTheme);
      Cookies.set("name", userName, {
        // secure: true,
        sameSite: "Strict",
        expires: new Date((tokenExpiry * 1000) + 172800), // Convert UNIX timestamp to Date object
      });
      Cookies.set("theme", userTheme, {
        // secure: true,
        sameSite: "Strict",
        expires: new Date((tokenExpiry * 1000) + 172800), // Convert UNIX timestamp to Date object
      });
      Cookies.set("language", userLanguage, {
        // secure: true,
        sameSite: "Strict",
        expires: new Date((tokenExpiry * 1000) + 172800), // Convert UNIX timestamp to Date object
      });
      Cookies.set("shortcuts", shortcuts, {
        // secure: true,
        sameSite: "Strict",
        expires: new Date((tokenExpiry * 1000) + 172800), // Convert UNIX timestamp to Date object
      });
      Cookies.set("M3K8g2387BahBaqyjDe6", M3K8g2387BahBaqyjDe6, {
        // secure: true,
        sameSite: "Strict",
        expires: new Date((tokenExpiry * 1000) + 172800), // Convert UNIX timestamp to Date object
      });
      Cookies.set("access_token", accessToken, {
        // secure: true,
        sameSite: "Strict",
        expires: new Date((tokenExpiry * 1000) + 172800), // Convert UNIX timestamp to Date object
      });
      Cookies.set("refresh_token", refreshToken, {
        // secure: true,
        sameSite: "Strict",
        expires: new Date(refreshExpiry * 1000), // Convert UNIX timestamp to Date object
      });
      Cookies.set("token_expiry", tokenExpiry, {
        // secure: true,
        sameSite: "Strict",
        expires: new Date((tokenExpiry * 1000) + 172800),
      });
      Cookies.set("refresh_expiry", refreshExpiry, {
        // secure: true,
        sameSite: "Strict",
        expires: new Date(refreshExpiry * 1000),
      });

      this.startTokenRefresh();
    },

    // Log out user and clear cookies
    logOut() {
      this.token = null;
      this.refreshToken = null;
      this.tokenExpiry = null;
      this.refreshExpiry = null;

      Cookies.remove("access_token");
      Cookies.remove("refresh_token");
      Cookies.remove("token_expiry");
      Cookies.remove("refresh_expiry");
      Cookies.remove("name");
      Cookies.remove("theme");
      Cookies.remove("language");
      Cookies.remove("shortcuts");
      Cookies.remove("M3K8g2387BahBaqyjDe6");
      localStorage.removeItem('theme');
      document.documentElement.classList.remove('dark');

      router.push("/login");
    },
    updateLanguage(language) {
      this.userLanguage = language;
      Cookies.set("language", language, {
        sameSite: "Strict",
        expires: new Date((this.tokenExpiry * 1000) + 172800),
      });
    },
    setUserPreferences(preferences) {
      if (preferences.user_theme) {
        this.updateTheme(preferences.user_theme); // Use the action
      }
      if (preferences.user_language) {
        // Handle language updates if needed
      }
    },

    updateTheme(theme) {
      this.userTheme = theme;
      Cookies.set("theme", theme, {
        sameSite: "Strict",
        expires: new Date((this.tokenExpiry * 1000) + 172800),
      });
      localStorage.setItem('theme', theme);
    },
    // Schedule token refresh before expiry
    startTokenRefresh() {
      if (!this.token || !this.tokenExpiry) return;

      const currentTime = Math.floor(Date.now() / 1000);
      const timeUntilExpiry = this.tokenExpiry - currentTime;

      if (timeUntilExpiry > 0) {
        const refreshTime = (timeUntilExpiry - 5 * 60) * 1000; // Refresh 5 minutes before expiry
        this.refreshTimeout = setTimeout(() => this.refreshTokenAction(), refreshTime);
      } else {
        this.logOut(); // Log out if the token is already expired
      }
    },

    // Perform token refresh
/*
    async refreshTokenAction() {
      if (!this.refreshToken) {
        this.logOut();
        return;
      }

      try {
        const response = await apiClient.post("/auth/refresh", {
          refresh_token: this.refreshToken,
        });

        const {
          access_token,
          expires_in,
          refresh_token,
          refresh_expires_in,
        } = response.data;

        // Update tokens and restart the refresh process
        const currentTime = Math.floor(Date.now() / 1000);
        this.logIn(
          access_token,
          refresh_token,
          currentTime + expires_in,
          currentTime + refresh_expires_in
        );
      } catch (error) {
        console.error("Token refresh failed", error);
        this.logOut();
      }
    },*/
    async refreshTokenAction() {
      if (!this.refreshToken) {
        this.logOut();
        return;
      }

      try {
        const response = await apiClient.post("/auth/refresh", {
          refresh_token: this.refreshToken,
        });

        const {
          access_token,
          expires_in,
          refresh_token,
          refresh_expires_in,
          user,
        } = response.data;

        // These are actual expiry timestamps in your case
        this.token = access_token;
        this.refreshToken = refresh_token;
        this.tokenExpiry = expires_in;
        this.refreshExpiry = refresh_expires_in;

        // Extract values from user object
        const userName = user.name;
        const branchId = user.current_branch;

        this.BranchID = branchId;

        const commonCookieOptions = {
          secure: true,
          sameSite: "Strict",
        };

        // Set cookies with new expiry
        Cookies.set("access_token", access_token, {
          ...commonCookieOptions,
          expires: new Date((expires_in * 1000) + 172800),
        });

        Cookies.set("refresh_token", refresh_token, {
          ...commonCookieOptions,
          expires: new Date(refresh_expires_in * 1000),
        });

        Cookies.set("token_expiry", expires_in, {
          ...commonCookieOptions,
          expires: new Date((expires_in * 1000) + 172800),
        });

        Cookies.set("refresh_expiry", refresh_expires_in, {
          ...commonCookieOptions,
          expires: new Date(refresh_expires_in * 1000),
        });

        Cookies.set("name", userName, {
          ...commonCookieOptions,
          expires: new Date((expires_in * 1000) + 172800),
        });

        Cookies.set("M3K8g2387BahBaqyjDe6", branchId, {
          ...commonCookieOptions,
          expires: new Date((expires_in * 1000) + 172800),
        });

        // Restart the refresh cycle
        this.startTokenRefresh();

      } catch (error) {
        console.error("Token refresh failed", error);
        this.logOut();
      }
    }

  },
});
