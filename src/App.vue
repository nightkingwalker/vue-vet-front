<template>
  <div class="bg-img-preset">
    <!-- Header Component -->
    <AppHeader
      :is-mobile="isMobile"
      v-if="authStore.isLoggedIn && route.path != '/login'"
      :show-mobile-menu-button="showSidebar"
      :mobile-menu-visible="mobileMenuVisible"
      @toggle-mobile-menu="mobileMenuVisible = !mobileMenuVisible"
    />

    <!-- Main Layout -->
    <div class="flex items-between">
      <!-- Sidebar Component -->
      <AppSidebar
        v-if="authStore.isLoggedIn && route.path != '/login'"
        :is-mobile="isMobile"
        :mobile-menu-visible="mobileMenuVisible"
        @item-click="mobileMenuVisible = false"
      />

      <!-- Main Content -->
      <div
        class="container mx-auto mt-14 min-h-[92vh] lg:h-[85vh] md:p-4 rounded-lg border border-[#c4c7c5] dark:!border-[#444746] overflow-hidden"
        :class="{
          'clear-glass ': authStore.isLoggedIn && route.path !== '/login',
          '!border-0 ': route.path === '/login',
        }"
      >
        <router-view v-slot="{ Component, route }">
          <transition :name="route.meta.transition || 'fade'" mode="out-in">
            <div :key="route.path">
              <!-- Added wrapper div -->
              <component :is="Component" />
            </div>
          </transition>
        </router-view>

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
  <Transition name="fade">
    <div
      class="offline-bar absolute bottom-0 h-12 bg-red-600 w-full z-20 bg-opacity-60 text-white flex justify-center items-center gap-4"
      v-if="!online"
    >
      <i class="fa-solid fa-wifi"></i>
      {{ $t("app.offline_message") }}
    </div>
  </Transition>
</template>

<script setup lang="ts">
import {
  ref,
  computed,
  onMounted,
  onUnmounted,
  watch,
  watchEffect,
  getCurrentInstance,
} from "vue";
import { useRoute } from "vue-router";
import router from "@/router";
import eventBus from "@/eventBus";
import { useI18n } from "vue-i18n";
import { useAuthStore } from "@/stores/authStore";
import { useDevice } from "@/composables/useDevice";
import AppHeader from "@/views/partials/App/AppHeader.vue";
import AppSidebar from "@/views/partials/App/AppSidebar.vue";
import SessionTimeout from "@/views/partials/App/SessionTimeout.vue";
import ConfirmDialog from "primevue/confirmdialog";
import { useToast } from "primevue/usetoast";
import Toast from "primevue/toast";
import Cookies from "js-cookie";
import { useTheme } from "@/composables/useTheme";
import { useLanguage } from "@/composables/useLanguage";
const { $connectivity } = getCurrentInstance().appContext.config.globalProperties;
const online = ref(true);
const route = useRoute();
const toast = useToast();
// console.log(route.path);
const { t, locale } = useI18n();
const authStore = useAuthStore();
// console.log(authStore.token);
const { isMobile } = useDevice();
const { initializeLanguage } = useLanguage();
const { isDarkMode, initializeTheme, toggleTheme } = useTheme();
// console.log("isDarkMode", isDarkMode.value);
const mobileMenuVisible = ref(false);

// Computed properties
const showSidebar = computed(() => authStore.isLoggedIn && route.path !== "/login");
const isRtl = computed(() => {
  // 1. First try to get language from cookie
  const cookieLanguage = Cookies.get("language");

  // 2. If cookie exists, use it for RTL check
  if (cookieLanguage) {
    return ["ar", "he", "fa"].includes(cookieLanguage);
  }

  // 3. Fall back to current locale if no cookie
  return ["ar", "he", "fa"].includes(locale.value);
});
// ============== KEYBOARD SHORTCUTS ==============
const shortcuts = {
  // F2 Shortcuts
  F2: () => {
    if (route.path === "/owners") eventBus.emit("AddOwner");
    if (route.path === "/invoices") eventBus.emit("AddInvoice");
    if (route.path === "/pets" || route.path.match(/^\/\d+\/pets$/))
      eventBus.emit("AddPet");
    if (route.path === "/add-inventory-food") eventBus.emit("AddInventoryItem");
    if (route.path === "/add-inventory-pharmaceutical") eventBus.emit("AddInventoryItem");
    if (route.path === "/add-inventory-toys") eventBus.emit("AddInventoryItem");
    if (route.path === "/add-inventory-grooming") eventBus.emit("AddInventoryItem");
    if (route.path === "/add-inventory-treatment") eventBus.emit("AddInventoryItem");
  },
  "Ctrl+F2": () => {
    if (route.path === "/owners") eventBus.emit("AddOwner");
    if (route.path === "/invoices") eventBus.emit("AddInvoice");
  },
  "Ctrl+p": () => router.push("/pets"),
  "Ctrl+o": () => router.push("/owners"),
  "Ctrl+i": () => router.push("/invoices"),
  "Ctrl+l": () => {
    // isDarkMode.value = !isDarkMode.value;
    toggleTheme();
    // console.log("TOGGLING THEME", isDarkMode.value);
  },
  // "Ctrl+l": () => toggleDarkMode(),
  "Ctrl+r": () => router.push("/reports/stock-movement"),
  "Ctrl+z": () => {},
  "Ctrl+Alt+Home": () => router.push("/"),
  "Ctrl+Alt+p": () => router.push("/preferences"),
  "Ctrl+Alt+q": () => eventBus.emit("QuickActions"),
};

const handleKeyDown = (event) => {
  const combo = [
    event.ctrlKey && "Ctrl",
    event.altKey && "Alt",
    event.shiftKey && "Shift",
    event.key,
  ]
    .filter(Boolean)
    .join("+");

  if (shortcuts[combo]) {
    event.preventDefault();
    shortcuts[combo]();
  }
};

watchEffect(() => {
  document.documentElement.setAttribute("dir", isRtl.value ? "rtl" : "ltr");
});
// Initialize theme
onMounted(() => {
  initializeTheme();
  initializeLanguage();
  document.addEventListener("keydown", handleKeyDown);
  const { $connectivity } = getCurrentInstance().appContext.config.globalProperties;
  const interval = setInterval(async () => {
    online.value = true;
    online.value = await $connectivity.getOnlineStatus();
    // console.log("online.value", online.value);
  }, 5000);
  eventBus.on("show-toast", toast.add);
});

// Log current screen width in pixels
function logActiveMediaQuery() {
  const width = window.innerWidth;
  let mediaQuery = "";

  if (width < 576) mediaQuery = "@media (max-width: 575.98px)";
  else if (width >= 576 && width < 768)
    mediaQuery = "@media (min-width: 576px) and (max-width: 767.98px)";
  else if (width >= 768 && width < 992)
    mediaQuery = "@media (min-width: 768px) and (max-width: 991.98px)";
  else if (width >= 992 && width < 1200)
    mediaQuery = "@media (min-width: 992px) and (max-width: 1199.98px)";
  else if (width >= 1200) mediaQuery = "@media (min-width: 1200px)";

  console.log(`Screen Width: ${width}px, using ${mediaQuery} { /* Your CSS here */ }`);
}
// Initial check + update on resize
logActiveMediaQuery();
window.addEventListener("resize", logActiveMediaQuery);
</script>

<style>
/* Global styles that were previously in App.vue:lang(ar) */
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

/* Container responsive sizing:lang(ar) */
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
/* Fade transition:lang(ar) */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.6s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

/* Slide transitions:lang(ar) */
.slide-right-enter-active,
.slide-right-leave-active {
  transition: all 0.4s ease;
  position: absolute;
  width: 100%;
}

.slide-right-enter-from {
  opacity: 0;
  transform: translateX(-30px);
}

.slide-right-leave-to {
  opacity: 0;
  transform: translateX(30px);
}
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.5s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
/* Extra small devices (phones, 576px and down):lang(ar) */
@media (max-width: 575.98px) {
  .quarter-lg {
    width: 100%;
  }
  i.sx__chevron.sx__chevron--next,
  i.sx__chevron.sx__chevron--previous {
    font-size: 0 !important;
  }
  .text-6xl {
    font-size: 3.75rem !important;
  }
  :lang(ar) *:not(i) {
    font-size: 11px !important;
  }
}

/* Small devices (portrait tablets and large phones, 576px and up):lang(ar) */
@media (min-width: 576px) and (max-width: 767.98px) {
  .quarter-lg {
    width: 100%;
  }
  i.sx__chevron.sx__chevron--next,
  i.sx__chevron.sx__chevron--previous {
    font-size: 0 !important;
  }
  .text-6xl {
    font-size: 3.75rem !important;
  }
  :lang(ar) *:not(i) {
    font-size: 11px !important;
  }
  .p-menu.p-component.fixed {
    padding-left: 5px;
    padding-right: 5px;
  }
}

/* Medium devices (landscape tablets, 768px and up):lang(ar) */
@media (min-width: 768px) and (max-width: 991.98px) {
  .quarter-lg {
    width: 100%;
  }
  i.sx__chevron.sx__chevron--next,
  i.sx__chevron.sx__chevron--previous {
    font-size: 0 !important;
  }
  .text-6xl {
    font-size: 3.75rem !important;
  }
  :lang(ar) *:not(i) {
    font-size: 12px !important;
  }
  .p-menu.p-component.fixed {
    padding-left: 5px;
    padding-right: 5px;
  }
}

/* Large devices (laptops/desktops, 992px and up):lang(ar) */
@media (min-width: 992px) and (max-width: 1199.98px) {
  .quarter-lg {
    width: 100%;
  }
  .quarter-lg .p-card.p-component {
    display: flex;
    flex-direction: row;
    gap: 10px;
  }
  .quarter-lg .p-card.p-component .p-card-header {
    width: calc(25% - 10px);
  }
  .quarter-lg .p-card.p-component .p-card-header > div {
    height: 100%;
  }
  .p-menu.p-component.fixed {
    padding-left: 5px;
    padding-right: 5px;
  }
  .quarter-lg .p-card.p-component .p-card-body {
    width: calc(75% - 5px);
    margin: 0;
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
  }
  .quarter-lg .p-card.p-component .p-card-body .p-card-caption,
  .quarter-lg .p-card.p-component .p-card-body .p-card-content,
  .quarter-lg .p-card.p-component .p-card-body .p-card-footer {
    /*flex-basis: 33%; /* Initial width */
    flex-grow: 1; /* Can grow if needed */
  }
  .quarter-lg .p-card.p-component .p-card-body .p-card-caption {
    order: 0;
    width: 24%;
  }
  .quarter-lg .p-card.p-component .p-card-body .p-card-caption .card-title {
    flex-direction: column;
  }
  .quarter-lg .p-card.p-component .p-card-body .p-card-content {
    order: 1;
    width: 74%;
  }
  .quarter-lg .p-card.p-component .p-card-body .p-card-content > div {
    flex-direction: row;
    flex-wrap: nowrap;
    display: flex;
    justify-content: start;
    align-content: flex-start;
    gap: 10px;
  }
  .quarter-lg .p-card.p-component .p-card-body .p-card-content > div > div {
    width: 33%;
    /* flex-direction: column; */
    margin-top: 0;
  }
  .quarter-lg .p-card.p-component .p-card-body .p-card-footer {
    order: 3;
    width: 100%;
  }
  .container {
    width: 89vw;
  }
  .text-6xl {
    font-size: 3.75rem !important;
  }
  i.sx__chevron.sx__chevron--next,
  i.sx__chevron.sx__chevron--previous {
    font-size: 0 !important;
  }
  :lang(ar) *:not(i) {
    font-size: 11px !important;
  }
}

/* Extra large devices (large laptops and desktops, 1200px and up):lang(ar) */
@media (min-width: 1200px) and (max-width: 1919px) {
  * {
    zoom: 0.995;
  }
  .container {
    width: 90vw;
  }
  .text-6xl {
    font-size: 3.75rem !important;
  }
  i.sx__chevron.sx__chevron--next,
  i.sx__chevron.sx__chevron--previous {
    font-size: 0 !important;
  }
  :lang(ar) *:not(i) {
    font-size: 12px !important;
  }
}

/* 2K and larger screens:lang(ar) */
@media (min-width: 1920px) {
  .text-6xl {
    font-size: 3.75rem !important;
  }
  i.sx__chevron.sx__chevron--next,
  i.sx__chevron.sx__chevron--previous {
    font-size: 0 !important;
  }
  :lang(ar) *:not(i) {
    font-size: 14px !important;
  }
}

/* 4K and larger screens:lang(ar) */
@media (min-width: 3840px) {
  .text-6xl {
    font-size: 3.75rem !important;
  }
  i.sx__chevron.sx__chevron--next,
  i.sx__chevron.sx__chevron--previous {
    font-size: 0 !important;
  }
  :lang(ar) *:not(i) {
    font-size: 11px !important;
  }
}
:root {
  color-scheme: dark light;
}
</style>
