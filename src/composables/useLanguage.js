import { ref, watch, onMounted ,onUnmounted} from 'vue'
import { useAuthStore } from '@/stores/authStore'
import { useI18n } from 'vue-i18n'
import Cookies from 'js-cookie'

export const useLanguage = () => {
  const authStore = useAuthStore()
  const { locale } = useI18n()
  const currentLanguage = ref(locale.value)

  // Main function to apply language changes
  const applyLanguage = (lang) => {
    if (!lang || lang === currentLanguage.value) return
    
    // 1. Update vue-i18n
    locale.value = lang
    
    // 2. Update DOM
    document.documentElement.lang = lang
    
    // 3. Update local ref
    currentLanguage.value = lang
    
    console.log('Applied language:', lang)
  }

  // Initialize language from most authoritative source
  const initializeLanguage = () => {
    const lang = authStore.currentLanguage || 
                Cookies.get('language') ||
                navigator.language?.substring(0, 2) || 
                'en'
    applyLanguage(lang)
  }

  // Watch for store changes (login/logout)
  watch(
    () => authStore.currentLanguage,
    (newLang) => {
      if (newLang) applyLanguage(newLang)
    },
    { immediate: true }
  )

  // Watch for cookie changes (external modifications)
  const checkCookieChanges = () => {
    const cookieLang = Cookies.get('language')
    if (cookieLang && cookieLang !== currentLanguage.value) {
      applyLanguage(cookieLang)
    }
  }

  // Set up periodic cookie checking
  let cookieInterval
  onMounted(() => {
    initializeLanguage()
    cookieInterval = setInterval(checkCookieChanges, 1000) // Check every second
  })

  onUnmounted(() => {
    clearInterval(cookieInterval)
  })

  return {
    applyLanguage,
    initializeLanguage,
    currentLanguage
  }
}