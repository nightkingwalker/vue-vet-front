// src/composables/useLanguage.js
import { ref, watch } from 'vue';
import { useAuthStore } from '@/stores/authStore';
import { useI18n } from 'vue-i18n';
import Cookies from 'js-cookie';

export const useLanguage = () => {
    const authStore = useAuthStore();
    const { locale } = useI18n();

    const applyLanguage = (lang) => {
        // Update i18n locale
        locale.value = lang;
        // Update HTML attribute
        document.documentElement.lang = lang;
        // Update store and cookies
        authStore.updateLanguage(lang);
    };

    const initializeLanguage = () => {
        const lang = authStore.currentLanguage || 'en';
        applyLanguage(lang);
    };

    // Initialize language when composable is created
    initializeLanguage();

    // Watch for auth changes
    watch(
        () => authStore.isLoggedIn,
        (loggedIn) => {
            if (loggedIn) initializeLanguage();
        }
    );

    return {
        applyLanguage,
        initializeLanguage
    };
};