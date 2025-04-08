import { createI18n } from 'vue-i18n';
import en from '@/locales/en.json';
import ar from '@/locales/ar.json';

// Set up Vue I18n
export const i18n = createI18n({
  legacy: false, // Required for Vue 3
  locale: 'en', // Default language
  fallbackLocale: 'en', // Fallback if translation missing
  messages: { en, ar }, // Load translations
});