<template>
  <div>
    <!-- Dark Mode Toggle Button -->
    <div class="flex">
      <button
        @click="toggleTheme"
        type="button"
        class="absolute z-50 ltr:right-4 rtl:left-4 top-2 flex items-center justify-center p-1 cursor-pointer gap-3 bg-[var(--p-surface-800)] dark:bg-[var(--p-surface-100)] rounded-lg hover:rounded-lg w-8 h-8 hover:bg-gray-400 text-center shadow-md"
        :title="titleDark"
      >
        <i v-if="isDarkMode" class="fa-solid fa-sun text-yellow-500 text-md w-4"></i>
        <i v-else class="fa-solid fa-moon text-md text-white w-4"></i>
      </button>
      <button
        v-if="isMobile && authStore.isLoggedIn && route.path != `/login`"
        @click="mobileMenuVisible = !mobileMenuVisible"
        class="absolute z-[60] ltr:left-4 rtl:right-4 top-2 flex items-center justify-center p-1 cursor-pointer gap-3 bg-[var(--p-surface-800)] dark:bg-[var(--p-surface-100)] rounded-lg hover:rounded-lg w-8 h-8 menu-toggle-btn"
      >
        <i
          :class="mobileMenuVisible ? 'pi pi-times text-white' : 'pi pi-bars text-white'"
        ></i>
      </button>
    </div>
    <!-- Main Layout -->
    <div class="flex items-between">
      <!-- Sidebar Menu -->
      <Menu
        v-if="authStore.isLoggedIn && route.path != `/login`"
        :model="menuItems"
        @mouseenter="isHovered = true"
        @mouseleave="isHovered = false"
        :class="{
          'fixed ltr:inset-y-0 ltr:left-0 rtl:inset-y-0 rtl:right-0 z-50 w-[100vw] mobile-menu': isMobile,
          'fixed ltr:left-0 rtl:right-0 w-24 2xl:w-20 hover:md:w-60 hover:2xl:w-1/6 hover:lg:w-1/5 z-50 drop-shadow-[0_5px_5px_rgba(0,0,0,0.3)]': !isMobile,
          hidden: isMobile && !mobileMenuVisible,
          'collapsed-menu': !isMobile && !isHovered,
          'expanded-menu': !isMobile && isHovered,
        }"
        class="!py-8 px-4 2xl:px-1 lg:px-1 scrollbar-hide scroll-smooth sm:text-sm 2xl:text-xs lg:text-sm !rounded-none h-[100vh] top-0 left-0 overflow-y-scroll"
      >
        <template #start>
          <!-- Logo -->
          <div class="flex justify-center w-full">
            <Image
              :src="Logo"
              alt="Application Logo"
              class="flex justify-center rounded-[4rem] dark:bg-white w-[5rem] p-1"
            />
          </div>

          <!-- User Profile Link -->
          <router-link
            to="/profile"
            v-ripple
            class="p-menu-item-link relative overflow-hidden w-full border-0 bg-transparent flex items-center hover:bg-surface-100 dark:hover:bg-surface-800 rounded-none cursor-pointer transition-colors duration-200 h-[40px] min-w-[40px]"
          >
            <Avatar
              icon="pi pi-user"
              class="w-[40px]"
              :class="{ 'ltr:mr-2 rtl:ml-2': !isMobile && isHovered }"
              shape="circle"
            />
            <span class="inline-flex flex-col items-start">
              <span class="font-bold">{{ userName }}</span>
            </span>
          </router-link>
        </template>

        <!-- Menu Item Templates -->
        <template #submenulabel="{ item }">
          <div class="font-bold flex items-center p-menu-item-content gap-2">
            <span :class="item.icon"></span>
            <span class="menu-item-label">{{ item.label }}</span>
            <span class="fa-solid fa-angle-down"></span>
          </div>
        </template>

        <template #item="{ item, props }">
          <RouterLink
            v-ripple
            class="flex items-center"
            v-bind="props.action"
            :to="item.route || ''"
          >
            <span :class="item.icon" />
            <span class="menu-item-label">{{ item.label }}</span>
            <Badge v-if="item.badge" class="ml-auto p-badge" :value="item.badge" />
            <span
              v-if="item.shortcut"
              class="shortcut ltr:ml-auto rtl:mr-auto p-1 text-[10px] text-gray-600 dark:text-gray-400 justify-self-end"
            >
              {{ item.shortcut }}
            </span>
          </RouterLink>
        </template>
      </Menu>
      <span
        class="animate-bounce h-6 w-6 text-xs bg-[var(--p-surface-800)] dark:bg-[var(--p-surface-100)] text-white dark:text-[var(--p-surface-800)] rounded-full inline-flex items-center justify-center z-50 right-[calc(100vw/12)] bottom-1 absolute"
        :class="!isMobile && !isHovered ? `hidden` : ``"
      >
        <i class="pi pi-arrow-down text-xs" />
      </span>
      <!-- Main Content Area -->
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

        <Toast :position="!isRtl ? `bottom-right` : `bottom-left`" />
      </div>
    </div>
    <div v-if="!online" class="offline-bar">
      <i class="pi pi-wifi-off mr-2"></i>
      {{ $t("app.offline_message") }}
    </div>
  </div>
</template>

<script setup>
// ============== IMPORTS ==============
import {
  ref,
  computed,
  onMounted,
  onUnmounted,
  watch,
  watchEffect,
  getCurrentInstance,
} from "vue";
import { useRoute, RouterLink, RouterView } from "vue-router";
import { useI18n } from "vue-i18n";
import { useAuthStore } from "@/stores/authStore";
// import { isAuthenticated } from '/src/stores/authStore.js';
import { useToast } from "primevue/usetoast";
import { useConfirm } from "primevue/useconfirm";
import Cookies from "js-cookie";
import eventBus from "@/eventBus";
import router from "@/router";
import { useTheme } from "@/composables/useTheme";
import { useLanguage } from "@/composables/useLanguage";

// PrimeVue Components
import Menu from "primevue/menu";
import Avatar from "primevue/avatar";
import Image from "primevue/image";
import Badge from "primevue/badge";
import Toast from "primevue/toast";
import ConfirmDialog from "primevue/confirmdialog";
import ScrollPanel from "primevue/scrollpanel";

// Assets
import Logo from "@/assets/logo.png";

// ============== INITIALIZATIONS ==============
const { t, locale } = useI18n();
const toast = useToast();
const confirm = useConfirm();
const route = useRoute();
const authStore = useAuthStore();
const isLoggedIn = authStore.isLoggedIn;
const { isDarkMode, initializeTheme, toggleTheme } = useTheme();
const { initializeLanguage } = useLanguage();
const { $connectivity } = getCurrentInstance().appContext.config.globalProperties;
// ============== REACTIVE STATE ==============

// const isDarkMode = ref(false);
const titleDark = ref("");
const activeItem = ref(null);
const countdown = ref(300);
const checked = ref(false);
import { useDevice } from "@/composables/useDevice";
const mobileMenuVisible = ref(false);
const online = ref(true);

// ============== COMPUTED PROPERTIES ==============
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
const userName = computed(() => authStore.user?.name || Cookies.get("name") || "");
const formattedCountdown = computed(() => {
  const minutes = Math.floor(countdown.value / 60);
  const seconds = countdown.value % 60;
  return `${String(minutes).padStart(2, "0")}:${String(seconds).padStart(2, "0")}`;
});
const timeoutMessage = computed(() =>
  t("app.session.timeout_message", { time: formattedCountdown.value })
);
const submenuItemClass = computed(() => {
  return `submenue_item ${
    !isMobile.value && !isHovered.value ? "ltr:pl-6 rtl:pr-6" : ""
  }`;
});

// ============== MENU CONFIGURATION ==============
const menuItems = computed(() => [
  {
    label: t("app.menu.calendar"),
    icon: "pi pi-calendar !text-md",
    route: "/",
    shortcut: "CTRL+ALT+Home",
    command: handleMenuItemClick,
  },
  {
    label: t("app.menu.patients"),
    icon: "fa-solid fa-paw !text-md !text-center",
    items: [
      {
        separator: true,
      },
      {
        label: t("app.menu.owners"),
        route: "/owners",
        icon: "fa-solid fa-users !text-md !text-center",
        shortcut: "CTRL+O",
        class: submenuItemClass,
        command: handleMenuItemClick,
      },
      {
        label: t("app.menu.pets"),
        route: "/pets",
        icon: "fa-solid fa-paw !text-md !text-center",
        shortcut: "CTRL+P",
        class: submenuItemClass,
        command: handleMenuItemClick,
      },
    ],
  },
  {
    label: t("app.menu.inventories"),
    icon: "fas fa-store !text-md",
    items: [
      {
        separator: true,
      },
      {
        label: t("app.menu.pet_food"),
        route: "/add-inventory-food",
        icon: "fa-solid fa-bone !text-md !text-center",
        class: submenuItemClass,
        command: handleMenuItemClick,
      },
      {
        label: t("app.menu.toys_tools"),
        route: "/add-inventory-toys",
        icon: "fa-solid fa-volleyball !text-md !text-center",
        class: submenuItemClass,
        command: handleMenuItemClick,
      },
      {
        label: t("app.menu.pharmaceutical"),
        route: "/add-inventory-pharmaceutical",
        icon: "fa-solid fa-pills !text-md !text-center",
        class: submenuItemClass,
        command: handleMenuItemClick,
      },
      {
        label: t("app.menu.grooming"),
        route: "/add-inventory-grooming",
        icon: "fa-solid fa-shower !text-md !text-center",
        class: submenuItemClass,
        command: handleMenuItemClick,
      },
      {
        label: t("app.menu.treatment"),
        route: "/add-inventory-treatment",
        icon: "fa-solid fa-stethoscope !text-md !text-center",
        class: submenuItemClass,
        command: handleMenuItemClick,
      },
    ],
  },
  {
    separator: true,
  },
  {
    label: t("app.menu.invoices"),
    icon: "fa-solid fa-file-invoice-dollar !text-md",
    shortcut: "CTRL+I",
    route: "/invoices",
    command: handleMenuItemClick,
  },
  {
    label: t("app.menu.reports.stockmovement"),
    icon: "fa-solid fa-arrow-trend-up !text-md",
    route: "/reports",
    command: handleMenuItemClick,
  },
  {
    label: t("app.menu.settings"),
    icon: "pi pi-cog !text-md",
    route: "/settings",
    command: handleMenuItemClick,
  },
  {
    label: t("app.menu.shortcuts"),
    icon: "fa-solid fa-keyboard !text-md",
    route: "/shortcuts",
    command: signOut,
  },
  {
    label: t("app.menu.logout"),
    icon: "pi pi-sign-out !text-md",
    route: "/logout",
    command: signOut,
  },
]);
const isHovered = ref(false);

const { isMobile } = useDevice();
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
  "Ctrl+l": () => toggleDarkMode(),
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

// ============== DARK MODE HANDLING ==============
/* function initializeTheme() {
  const systemPrefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
  // console.log("SYSTEM THEME", systemPrefersDark);
  // Priority: 1. Cookie 2. LocalStorage 3. System preference
  const cookieTheme = Cookies.get("theme");
  // console.log("Coockie THEME", cookieTheme);
  const savedTheme = localStorage.getItem("theme");

  let shouldBeDark = false;

  if (cookieTheme) {
    shouldBeDark = cookieTheme === "system"
      ? systemPrefersDark
      : cookieTheme === "dark";
  } else if (savedTheme) {
    shouldBeDark = savedTheme === "dark";
  } else {
    shouldBeDark = systemPrefersDark;
  }
  // console.log("shouldBeDark", shouldBeDark);
  // Apply the theme
  if (shouldBeDark) {
    isDarkMode.value = true;
    document.documentElement.classList.add("dark");
    titleDark.value = t("app.theme.light_mode");
  }
}
 */
function toggleDarkMode() {
  isDarkMode.value = !isDarkMode.value;

  // Update DOM
  document.documentElement.classList.toggle("dark", isDarkMode.value);

  // Update title
  titleDark.value = isDarkMode.value
    ? t("app.theme.light_mode")
    : t("app.theme.dark_mode");

  // Save preference
  const theme = isDarkMode.value ? "dark" : "light";
  localStorage.setItem("theme", theme);
  Cookies.set("theme", theme); // If you want to use cookies

  // Emit event if needed
  if (route.path === "/") {
    eventBus.emit("themeChange", theme);
  }
}
// ============== SESSION MANAGEMENT ==============
let activityTimeout = null;
let timerId = null;
let logoutTimerId = null;
// const SOUND_URL =
//   "https://soundbible.com/mp3/Ruger%20357%20Magnum%20Gun%20Cock-SoundBible.com-735730842.mp3";
//   "https://soundbible.com/mp3/Ruger%20357%20Magnum%20Gun%20Cock-SoundBible.com-735730842.mp3";

const playSound = () => {
  new Audio("/sounds/timeout.mp3").play();
};

const clearTimers = () => {
  clearInterval(timerId);
  clearTimeout(logoutTimerId);
  clearTimeout(activityTimeout);
};

const resetActivityTimeout = () => {
  clearTimeout(activityTimeout);
  activityTimeout = setTimeout(() => {
    if (route.meta.allowSessionTimeout) {
      playSound();
      showConfirm();
    }
  }, 5 * 60 * 1000); // 5 minutes
};

const resetCountdown = () => {
  countdown.value = 300;
  clearInterval(timerId);

  timerId = setInterval(() => {
    countdown.value--;

    if (countdown.value <= 0) {
      clearInterval(timerId);
      authStore.logOut();
      router.push("/login");
    } else {
      updateTimeoutDialog();
    }
  }, 1000);
};

const updateTimeoutDialog = () => {
  confirm.require({
    message: timeoutMessage.value,
    header: t("app.session.timeout_header"),
    icon: "fa-regular fa-clock fa-shake text-red-500",
    acceptLabel: t("app.session.stay_logged_in"),
    rejectLabel: t("app.session.log_out"),
    acceptIcon: "fas fa-clock-rotate-left",
    rejectIcon: "fas fa-right-from-bracket",
    acceptClass: "!text-sm",
    rejectClass: "!text-sm",
    accept: clearTimers,
    reject: () => {
      clearTimers();
      authStore.logOut();
      router.push("/login");
    },
    onHide: clearTimers,
  });
};

const showConfirm = () => {
  updateTimeoutDialog();
  resetCountdown();
  startLogoutTimer();
};

const startLogoutTimer = () => {
  clearTimeout(logoutTimerId);
  logoutTimerId = setTimeout(() => {
    if (countdown.value <= 0) {
      authStore.logOut();
      router.push("/login");
    }
  }, 300000); // 5 minutes
};

const signOut = () => {
  try {
    authStore.logOut();
    toast.add({
      severity: "info",
      summary: t("app.toast.signed_out"),
      detail: t("app.toast.signed_out_detail"),
      life: 3000,
    });
    clearTimers();
    router.push("/login");
  } catch (error) {
    console.error("Error signing out:", error);
  }
};

// ============== LIFECYCLE HOOKS ==============
onMounted(async () => {
  // Initialize theme
  initializeTheme();
  initializeLanguage();
  const { $connectivity } = getCurrentInstance().appContext.config.globalProperties;
  online.value = await $connectivity.getOnlineStatus();
  const interval = setInterval(async () => {
    online.value = await $connectivity.getOnlineStatus();
    console.log("Initial connectivity status:", online.value); // Changed to console.log
  }, 5000);
  // const savedTheme = localStorage.getItem("theme");
  // if (savedTheme === "dark") {
  //   isDarkMode.value = true;
  //   titleDark.value = t("app.theme.light_mode");
  //   document.documentElement.classList.add("dark");
  // }

  // Event listeners
  eventBus.on("show-toast", toast.add);
  document.addEventListener("mousemove", resetActivityTimeout);
  document.addEventListener("keypress", resetActivityTimeout);
  document.addEventListener("keydown", handleKeyDown);
  resetActivityTimeout();
});

const handleMenuItemClick = () => {
  if (isMobile.value) {
    mobileMenuVisible.value = false;
  }
};
onUnmounted(() => {
  // Cleanup
  eventBus.off("show-toast", toast.add);
  document.removeEventListener("mousemove", resetActivityTimeout);
  document.removeEventListener("keypress", resetActivityTimeout);
  document.removeEventListener("keydown", handleKeyDown);
  clearTimers();
  clearInterval(interval);
});

// Watch route changes for active menu item
watch(
  () => route.path,
  (newPath) => {
    activeItem.value = newPath;
  }
);
watch(isLoggedIn, initializeTheme);
// RTL direction handling
watchEffect(() => {
  document.documentElement.setAttribute("dir", isRtl.value ? "rtl" : "ltr");
});
</script>

<style>
.button-transition:hover {
  translate: -0.07rem -0.07rem !important;
  --tw-drop-shadow: drop-shadow(0 3px 3px rgba(0, 0, 0, 0.3));
  filter: var(--tw-blur) var(--tw-brightness) var(--tw-contrast) var(--tw-grayscale)
    var(--tw-hue-rotate) var(--tw-invert) var(--tw-saturate) var(--tw-sepia)
    var(--tw-drop-shadow);
}

.button-transition {
  transition: all 0.2s ease-in-out !important;
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

/* Menu item styling */
:deep(.p-megamenu-item:last-child .p-megamenu-item-content):hover {
  background: none !important;
}

:deep(.p-menuitem) {
  height: 40px !important;
  min-height: 40px !important;
}

.p-menu {
  transition: width 0.3s ease, transform 0.3s ease;
  will-change: width;
}

/* Container responsive sizing */
@media (min-width: 1536px) {
  .container {
    max-width: 90%;
  }
}

/* Active route styling */
.router-link-active {
  background: black;
  color: var(--p-primary-contrast-color) !important;
  border-radius: 0.5rem !important;
}

.dark .router-link-active {
  background: var(--p-surface-300);
  color: var(--p-primary-contrast-color) !important;
}

.dark .router-link-active .shortcut {
  color: var(--p-primary-contrast-color);
}

/* Base menu styles */
.mobile-menu {
  top: 0;

  box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
}

.mobile-menu-visible {
  transform: translateX(0);
}

.p-menu-separator {
  width: 80%;
  /* border-bottom: 1px solid; */
}

/**MENU UPDATES */
/* Collapsed Menu Styles */
.collapsed-menu {
  overflow: hidden;
  width: 60px !important;
  min-width: 60px !important;
}

.collapsed-menu .menu-item-label,
.collapsed-menu .shortcut,
.collapsed-menu .p-badge,
.collapsed-menu .fa-angle-down {
  opacity: 0;
  width: 0;
  display: none;
  transition: opacity 0.2s ease, width 0.3s ease;
}

.collapsed-menu .p-menu-separator {
  width: 50%;

  /* margin: 0.5rem auto; */
}

.collapsed-menu .router-link-active {
  justify-content: center;
}

/* Center the logo in collapsed state */
.collapsed-menu .flex.justify-center {
  padding: 0;
}

.collapsed-menu .p-image,
.collapsed-menu .p-image img,
.expanded-menu .p-image,
.expanded-menu .p-image img {
  width: 30px !important;
  max-width: 30px !important;
}

/* } */

/* Profile link adjustments */
.collapsed-menu .router-link {
  justify-content: center;
  padding-left: 0 !important;
  padding-right: 0 !important;
}

.collapsed-menu .p-avatar {
  margin-right: 0 !important;
  margin-left: 0 !important;
}

.collapsed-menu span.inline-flex {
  display: none;
}

.collapsed-menu .p-avatar {
  margin-left: 0 !important;
  margin-right: 0 !important;
}

/* } */
/* } */

/* Expanded Menu Styles */
.expanded-menu .expanded-menu .menu-item-label,
.expanded-menu .shortcut,
.expanded-menu .p-badge,
.expanded-menu .fa-angle-down {
  opacity: 1;
  width: auto;
}

.expanded-menu .p-menu-separator {
  width: 80%;
}

/* Smooth transitions */
.menu-item-label {
  transition: opacity 0.3s ease 0.1s;
}

/* Submenu adjustments */
:deep(.p-submenu-list) {
  padding-left: 0.5rem !important;
}

/* Keep active state visible in collapsed mode */
.collapsed-menu .router-link-active {
  position: relative;
}

.collapsed-menu .router-link-active::after {
  content: "";
  position: absolute;
  right: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 3px;
  height: 60%;
  background: var(--primary-color);
  border-radius: 3px;
}

.p-menu-list li:not(.p-menu-separator) {
  height: 40px;
}

.collapsed-menu a {
  height: 40px;
  min-width: 40px;
}

/* Ensure consistent vertical alignment */
.p-menu-item {
  padding-top: 0 !important;
  padding-bottom: 0 !important;
  margin: 0 !important;
  height: 40px !important;
  align-items: center !important;
}

/* Fix the avatar container */
.collapsed-menu .p-avatar,
.expanded-menu .p-avatar {
  margin: 0 !important;
  flex-shrink: 0;
}

/* User name container */
.inline-flex {
  white-space: nowrap;
  overflow: hidden;
  transition: all 0.3s ease;
}

/* Menu container stabilization */
.p-menu {
  top: 0 !important;
  margin-top: 0 !important;
  padding-top: 0 !important;
}

/* Logo container stabilization */
.flex.justify-center {
  padding: 0.5rem 0 !important;
  margin: 0 !important;
  height: auto !important;
}

.p-avatar {
  margin-left: 0 !important;
  margin-right: 0.5rem !important;
  /* Consistent spacing */
}

.collapsed-menu .p-menu-start .p-menu-item-link {
  justify-content: center;
}

.scrollbar-hide {
  -ms-overflow-style: none;
  /* IE and Edge */
  scrollbar-width: none;
  /* Firefox */
}

.scrollbar-hide::-webkit-scrollbar {
  display: none;
  /* Chrome, Safari, and Opera */
}
</style>
