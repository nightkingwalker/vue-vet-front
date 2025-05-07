// src/composables/useTheme.js
import { ref, watch } from 'vue';
import { useAuthStore } from '@/stores/authStore';
import Cookies from 'js-cookie';
import { useRoute } from "vue-router";
import eventBus from "@/eventBus";

export const useTheme = () => {
    const authStore = useAuthStore();
    const isDarkMode = ref(false);

    const applyTheme = (theme) => {
        const systemPrefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
        const isDark = theme === 'system' ? systemPrefersDark : theme === 'dark';

        isDarkMode.value = isDark;
        document.documentElement.classList.toggle('dark', isDark);
        localStorage.setItem("theme", theme);
        Cookies.set("theme", theme); // If you want to use cookies

        // Emit event if needed
        eventBus.emit("themeChange", theme);
    };

    // Initialize theme when composable is created
    initializeTheme();

    function initializeTheme() {
        const theme = authStore.currentTheme || 'system';
        applyTheme(theme);
    }

    const toggleTheme = () => {
        const newTheme = isDarkMode.value ? 'light' : 'dark';
        authStore.updateTheme(newTheme);
        applyTheme(newTheme);
    };

    // Watch for system theme changes
    const systemThemeQuery = window.matchMedia('(prefers-color-scheme: dark)');
    systemThemeQuery.addEventListener('change', (e) => {
        if (authStore.currentTheme === 'system') {
            applyTheme('system');
        }
    });

    // Watch for auth changes
    watch(
        () => authStore.isLoggedIn,
        (loggedIn) => {
            if (loggedIn) initializeTheme();
        }
    );

    return {
        isDarkMode,
        initializeTheme,
        toggleTheme,
        applyTheme
    };
};