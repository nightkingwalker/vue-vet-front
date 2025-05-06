<template>
  <header class="flex items-center justify-end fixed top-0 w-full z-50 px-4 py-2">
    <!-- Mobile Menu Button (Conditional) -->
    <button
      v-if="isMobile && showMobileMenuButton"
      @click="emit('toggle-mobile-menu')"
      class="flex items-center justify-center p-1 cursor-pointer gap-3 bg-[var(--p-surface-800)] dark:bg-[var(--p-surface-100)] rounded-lg w-8 h-8 hover:bg-gray-400 shadow-md"
      :aria-label="mobileMenuButtonLabel"
    >
      <i :class="mobileMenuIcon" class="text-white"></i>
    </button>

    <!-- Logo (Optional)
    <slot name="logo">
      <div v-if="showLogo" class="flex items-center">
        <Image
          :src="logo"
          alt="Application Logo"
          class="rounded-[4rem] dark:bg-white w-10 p-1"
        />
      </div>
    </slot> -->

    <!-- Dark Mode Toggle -->
    <button
      @click="toggleTheme"
      type="button"
      class="flex items-center justify-center p-1 cursor-pointer gap-3 bg-[var(--p-surface-800)] dark:bg-[var(--p-surface-100)] rounded-lg w-8 h-8 hover:bg-gray-400 shadow-md"
      :title="themeToggleTitle"
      :aria-label="themeToggleTitle"
    >
      <i :class="themeIcon" class="text-md w-4" :style="{ color: themeIconColor }"></i>
    </button>
  </header>
</template>

<script setup lang="ts">
import { computed } from "vue";
import Image from "primevue/image";
import { useTheme } from "@/composables/useTheme";

interface Props {
  isMobile?: boolean;
  showMobileMenuButton?: boolean;
  mobileMenuVisible?: boolean;
  showLogo?: boolean;
  logo?: string;
}

const props = withDefaults(defineProps<Props>(), {
  isMobile: false,
  showMobileMenuButton: true,
  mobileMenuVisible: false,
  showLogo: true,
  logo: "/assets/logo-DOqaXMyT.png",
});

const emit = defineEmits(["toggle-mobile-menu"]);

// Theme handling
const { isDarkMode, toggleTheme } = useTheme();

const themeToggleTitle = computed(() =>
  isDarkMode.value ? "Switch to light mode" : "Switch to dark mode"
);

const themeIcon = computed(() =>
  isDarkMode.value ? "fa-solid fa-sun" : "fa-solid fa-moon"
);

const themeIconColor = computed(() => (isDarkMode.value ? "#f59e0b" : "#ffffff"));

// Mobile menu button
const mobileMenuButtonLabel = computed(() =>
  props.mobileMenuVisible ? "Close menu" : "Open menu"
);

const mobileMenuIcon = computed(() =>
  props.mobileMenuVisible ? "pi pi-times" : "pi pi-bars"
);
</script>

<style>
button {
  transition: all 0.2s ease-in-out;
}

button:hover {
  transform: translate(-0.07rem, -0.07rem);
  filter: drop-shadow(0 3px 3px rgba(0, 0, 0, 0.3));
}
</style>
