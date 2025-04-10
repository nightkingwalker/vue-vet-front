// composables/useDevice.js
import { ref, onMounted, onUnmounted } from 'vue';

const isMobile = ref(false);
const mobileMenuVisible = ref(false);

const checkMobile = () => {
  isMobile.value = window.innerWidth < 768;
};

export function useDevice() {
  onMounted(() => {
    checkMobile();
    window.addEventListener('resize', checkMobile);
  });

  onUnmounted(() => {
    window.removeEventListener('resize', checkMobile);
  });

  return {
    isMobile,
    mobileMenuVisible,
    checkMobile,
  };
}
