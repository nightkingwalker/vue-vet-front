/* // composables/useDevice.js
import { ref, onMounted, onUnmounted } from 'vue';

const isMobile = ref(false);
const mobileMenuVisible = ref(false);

const checkMobile = () => {
  isMobile.value = window.innerWidth < 1024;
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
 */
// composables/useDevice.js
import { ref, onMounted, onUnmounted } from "vue";

export function useDevice() {
  const isMobile = ref(false);
  const mobileMenuVisible = ref(false);

  const checkMobile = () => {
    // Match Tailwind's lg breakpoint (>=1024px = desktop)
    isMobile.value = !window.matchMedia("(min-width: 1024px)").matches;
  };

  onMounted(() => {
    checkMobile();
    window.addEventListener("resize", checkMobile);
  });

  onUnmounted(() => {
    window.removeEventListener("resize", checkMobile);
  });

  return {
    isMobile,
    mobileMenuVisible,
  };
}
