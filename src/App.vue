<template>
  <div>
    <!-- Header Component -->
    <AppHeader
      :is-mobile="isMobile"
      :show-mobile-menu-button="showSidebar"
      :mobile-menu-visible="mobileMenuVisible"
      @toggle-mobile-menu="mobileMenuVisible = !mobileMenuVisible"
    />

    <!-- Main Layout -->
    <div class="flex items-between">
      <!-- Sidebar Component -->
      <AppSidebar
        v-if="showSidebar"
        :is-mobile="isMobile"
        :mobile-menu-visible="mobileMenuVisible"
        @item-click="mobileMenuVisible = false"
      />

      <!-- Main Content -->
      <div class="container mx-auto mt-6 2xl:px-0 xl:px-6 lg:px-6 md:px-8">
        <router-view />

        <!-- Global UI Components -->
        <ConfirmDialog class="md:w-[35vw] sm:w-full !text-sm">
          <template #message="slotProps">
            <div
              class="flex flex-col items-center w-full mx-auto gap-4 text-md text-center"
            >
              <i :class="slotProps.message.icon" class="!text-6xl text-yellow-500"></i>
              <p>{{ slotProps.message.message }}</p>
            </div>
          </template>
        </ConfirmDialog>

        <Toast :position="isRtl ? 'bottom-left' : 'bottom-right'" />
      </div>
    </div>

    <!-- Session Timeout Manager -->
    <SessionTimeout
      :allow-timeout="(route.meta.allowSessionTimeout as boolean) ?? true"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from "vue";
import { useRoute } from "vue-router";
import { useI18n } from "vue-i18n";
import { useAuthStore } from "@/stores/authStore";
import { useDevice } from "@/composables/useDevice";
import AppHeader from "@/views/partials/App/AppHeader.vue";
import AppSidebar from "@/views/partials/App/AppSidebar.vue";
import SessionTimeout from "@/views/partials/App/SessionTimeout.vue";
import ConfirmDialog from "primevue/confirmdialog";
import Toast from "primevue/toast";

const route = useRoute();
const { t, locale } = useI18n();
const authStore = useAuthStore();
const { isMobile } = useDevice();

const mobileMenuVisible = ref(false);

// Computed properties
const showSidebar = computed(() => authStore.isLoggedIn && route.path !== "/login");
const isRtl = computed(() => ["ar", "he", "fa"].includes(locale.value));

// Initialize theme
onMounted(() => {
  document.documentElement.setAttribute("dir", isRtl.value ? "rtl" : "ltr");
});
</script>

<style>
/* Global styles that were previously in App.vue */
.button-transition:hover {
  translate: -0.07rem -0.07rem !important;
  --tw-drop-shadow: drop-shadow(0 3px 3px rgba(0, 0, 0, 0.3));
  filter: var(--tw-blur) var(--tw-brightness) var(--tw-contrast) var(--tw-grayscale)
    var(--tw-hue-rotate) var(--tw-invert) var(--tw-saturate) var(--tw-sepia)
    var(--tw-drop-shadow);
}

button {
  transition: all 0.2s ease-in-out !important;
}

button:hover {
  translate: -0.07rem -0.07rem;
  --tw-drop-shadow: drop-shadow(0 3px 3px rgba(0, 0, 0, 0.3)) !important;
  filter: var(--tw-blur) var(--tw-brightness) var(--tw-contrast) var(--tw-grayscale)
    var(--tw-hue-rotate) var(--tw-invert) var(--tw-saturate) var(--tw-sepia)
    var(--tw-drop-shadow);
}

/* Container responsive sizing */
@media (min-width: 1536px) {
  .container {
    max-width: 90%;
  }
}

.scrollbar-hide {
  -ms-overflow-style: none;
  scrollbar-width: none;
}

.scrollbar-hide::-webkit-scrollbar {
  display: none;
}
</style>
