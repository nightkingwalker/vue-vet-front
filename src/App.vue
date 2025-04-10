<template>
  <div>
    <!-- Dark Mode Toggle Button -->
    <div class="flex">
      <button
        @click="toggleDarkMode"
        type="button"
        class="absolute z-50 ltr:right-4 rtl:left-4 top-2 flex items-center p-1 cursor-pointer gap-3 bg-[var(--p-surface-800)] dark:bg-[var(--p-surface-100)] rounded-sm hover:rounded-sm hover:bg-gray-400 w-6 h-5 text-center shadow-md"
        :title="titleDark"
      >
        <i v-if="isDarkMode" class="fa-solid fa-sun text-yellow-500 text-md w-4"></i>
        <i v-else class="fa-solid fa-moon text-md text-white w-4"></i>
      </button>
      <button
        v-if="isMobile"
        @click="mobileMenuVisible = !mobileMenuVisible"
        class="absolute z-50 ltr:left-4 rtl:right-4 top-2 flex items-center p-1 cursor-pointer gap-3 bg-[var(--p-surface-800)] dark:bg-[var(--p-surface-100)] rounded-sm hover:rounded-sm w-6 h-5"
      >
        <i
          :class="mobileMenuVisible ? 'pi pi-times' : 'pi pi-bars'"
          class="text-white"
        ></i>
      </button>
    </div>
    <!-- Main Layout -->
    <div class="flex items-between">
      <!-- Sidebar Menu -->
      <Menu
        v-if="authStore.isLoggedIn && route.path != `/login`"
        :model="menuItems"
        :style="{
          'transition: 1s': isMobile && mobileMenuVisible,
        }"
        :class="{
          'absolute ltr:inset-y-0 ltr:left-0 rtl:inset-y-0 rtl:right-0 z-40 w-[100vw] mobile-menu': isMobile,
          ' md:w-60 2xl:w-1/6 lg:w-1/5': !isMobile,
          hidden: isMobile && !mobileMenuVisible,
        }"
        class="!py-8 px-4 sm:text-sm 2xl:text-md lg:text-sm !rounded-none h-[100vh] top-0 left-0"
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
            class="relative overflow-hidden w-full border-0 bg-transparent flex items-center p-2 pl-4 hover:bg-surface-100 dark:hover:bg-surface-800 rounded-none cursor-pointer transition-colors duration-200"
          >
            <Avatar icon="pi pi-user" class="ltr:mr-2 rtl:ml-2" shape="circle" />
            <span class="inline-flex flex-col items-start">
              <span class="font-bold">{{ userName }}</span>
            </span>
          </router-link>
        </template>

        <!-- Menu Item Templates -->
        <template #submenulabel="{ item }">
          <span class="text-primary font-bold">{{ item.label }}</span>
        </template>

        <template #item="{ item, props }">
          <RouterLink
            v-ripple
            class="flex items-center"
            v-bind="props.action"
            :to="item.route || ''"
          >
            <span :class="item.icon" />
            <span>{{ item.label }}</span>
            <Badge v-if="item.badge" class="ml-auto" :value="item.badge" />
            <span
              v-if="item.shortcut"
              class="shortcut ltr:ml-auto rtl:mr-auto !text-[10px] p-1 text-gray-600 dark:text-gray-400 justify-self-end"
            >
              {{ item.shortcut }}
            </span>
          </RouterLink>
        </template>
      </Menu>
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

        <Toast position="bottom-right" />
      </div>
    </div>
  </div>
</template>

<script setup>
// ============== IMPORTS ==============
import { ref, computed, onMounted, onUnmounted, watch, watchEffect } from "vue";
import { useRoute, RouterLink, RouterView } from "vue-router";
import { useI18n } from "vue-i18n";
import { useAuthStore } from "@/stores/authStore";
import { useToast } from "primevue/usetoast";
import { useConfirm } from "primevue/useconfirm";
import Cookies from "js-cookie";
import eventBus from "@/eventBus";
import router from "@/router";

// PrimeVue Components
import Menu from "primevue/menu";
import Avatar from "primevue/avatar";
import Image from "primevue/image";
import Badge from "primevue/badge";
import Toast from "primevue/toast";
import ConfirmDialog from "primevue/confirmdialog";

// Assets
import Logo from "@/assets/logo.png";

// ============== INITIALIZATIONS ==============
const { t, locale } = useI18n();
const toast = useToast();
const confirm = useConfirm();
const route = useRoute();
const authStore = useAuthStore();

// ============== REACTIVE STATE ==============
const isDarkMode = ref(false);
const titleDark = ref("");
const activeItem = ref(null);
const countdown = ref(300);
const checked = ref(false);
import { useDevice } from "@/composables/useDevice";

const { isMobile, mobileMenuVisible } = useDevice();
// ============== COMPUTED PROPERTIES ==============
const isRtl = computed(() => ["ar", "he", "fa"].includes(locale.value));
const userName = computed(() => authStore.user?.name || Cookies.get("name") || "");
const formattedCountdown = computed(() => {
  const minutes = Math.floor(countdown.value / 60);
  const seconds = countdown.value % 60;
  return `${String(minutes).padStart(2, "0")}:${String(seconds).padStart(2, "0")}`;
});
const timeoutMessage = computed(() =>
  t("app.session.timeout_message", { time: formattedCountdown.value })
);

// ============== MENU CONFIGURATION ==============
const menuItems = computed(() => [
  {
    label: t("app.menu.calendar"),
    icon: "pi pi-calendar !text-md",
    route: "/",
    shortcut: "CTRL+ALT+Home",
  },
  {
    label: t("app.menu.patients"),
    icon: "fa-solid fa-paw !text-md !text-center",
    items: [
      {
        label: t("app.menu.owners"),
        route: "/owners",
        icon: "fa-solid fa-users !text-md !text-center",
        shortcut: "CTRL+O",
      },
      {
        label: t("app.menu.pets"),
        route: "/pets",
        icon: "fa-solid fa-paw !text-md !text-center",
        shortcut: "CTRL+P",
      },
    ],
  },
  {
    label: t("app.menu.inventories"),
    icon: "fa-solid fa-store !text-md",
    items: [
      {
        label: t("app.menu.pet_food"),
        route: "/add-inventory-food",
        icon: "fa-solid fa-bone !text-md !text-center",
      },
      {
        label: t("app.menu.toys_tools"),
        route: "/add-inventory-toys",
        icon: "fa-solid fa-volleyball !text-md !text-center",
      },
      {
        label: t("app.menu.pharmaceutical"),
        route: "/add-inventory-pharmaceutical",
        icon: "fa-solid fa-pills !text-md !text-center",
      },
      {
        label: t("app.menu.grooming"),
        route: "/add-inventory-grooming",
        icon: "fa-solid fa-shower !text-md !text-center",
      },
    ],
  },
  {
    label: t("app.menu.invoices"),
    icon: "fa-solid fa-file-invoice-dollar !text-md",
    shortcut: "CTRL+I",
    route: "/invoices",
  },
  {
    label: t("app.menu.reports"),
    icon: "fa-solid fa-scroll !text-md",
    route: "/reports",
  },
  {
    label: t("app.menu.settings"),
    icon: "pi pi-cog !text-md",
    route: "/settings",
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

// ============== KEYBOARD SHORTCUTS ==============
const shortcuts = {
  // F2 Shortcuts
  F2: () => {
    if (route.path === "/owners") eventBus.emit("AddOwner");
    if (route.path === "/invoices") eventBus.emit("AddInvoice");
    if (route.path === "/pets") eventBus.emit("AddPet");
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
function toggleDarkMode() {
  isDarkMode.value = !isDarkMode.value;
  const element = document.documentElement;
  const theme = isDarkMode.value ? "dark" : "light";

  // Emit theme change for calendar if needed
  if (route.path === "/") {
    eventBus.emit("themeChange", theme);
  }

  // Update DOM and storage
  element.classList.toggle("dark", isDarkMode.value);
  titleDark.value = isDarkMode.value
    ? t("app.theme.light_mode")
    : t("app.theme.dark_mode");
  localStorage.setItem("theme", theme);
}

// ============== SESSION MANAGEMENT ==============
let activityTimeout = null;
let timerId = null;
let logoutTimerId = null;
const SOUND_URL =
  "https://soundbible.com/mp3/Ruger%20357%20Magnum%20Gun%20Cock-SoundBible.com-735730842.mp3";

const playSound = () => {
  new Audio(SOUND_URL).play();
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
onMounted(() => {
  // Initialize theme
  const savedTheme = localStorage.getItem("theme");
  if (savedTheme === "dark") {
    isDarkMode.value = true;
    titleDark.value = t("app.theme.light_mode");
    document.documentElement.classList.add("dark");
  }

  // Event listeners
  eventBus.on("show-toast", toast.add);
  document.addEventListener("mousemove", resetActivityTimeout);
  document.addEventListener("keypress", resetActivityTimeout);
  document.addEventListener("keydown", handleKeyDown);
  resetActivityTimeout();
});

onUnmounted(() => {
  // Cleanup
  eventBus.off("show-toast", toast.add);
  document.removeEventListener("mousemove", resetActivityTimeout);
  document.removeEventListener("keypress", resetActivityTimeout);
  document.removeEventListener("keydown", handleKeyDown);
  clearTimers();
});

// Watch route changes for active menu item
watch(
  () => route.path,
  (newPath) => {
    activeItem.value = newPath;
  }
);

// RTL direction handling
watchEffect(() => {
  document.documentElement.setAttribute("dir", isRtl.value ? "rtl" : "ltr");
});
</script>

<style scoped>
/* Menu item styling */
:deep(.p-megamenu-item:last-child .p-megamenu-item-content):hover {
  background: none !important;
}

/* Container responsive sizing */
@media (min-width: 1536px) {
  .container {
    max-width: 80%;
  }
}

/* Active route styling */
.router-link-active {
  background: black;
  color: var(--p-primary-contrast-color);
  border-radius: 0.5rem !important;
}

.dark .router-link-active {
  background: var(--p-surface-300);
  color: var(--p-primary-contrast-color);
}
.dark .router-link-active .shortcut {
  color: var(--p-primary-contrast-color);
}
/* Base menu styles */
.mobile-menu {
  top: 0;
  left: 0;
  transform: translateX(-100%);
  transition: transform 1s ease;
  box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
}

.mobile-menu-visible {
  transform: translateX(0);
}
</style>
