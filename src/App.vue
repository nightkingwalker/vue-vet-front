<template>
  <!-- <div :class="{ rtl: isRtl }"> -->
  <div>
    <button
      @click="toggleDarkMode"
      type="button"
      class="absolute right-4 top-2 flex items-center p-1 cursor-pointer gap-3 bg-[var(--p-surface-800)] dark:bg-[var(--p-surface-100)] rounded-xl hover:rounded-xl hover:bg-gray-400 w-6 h-5 text-center shadow-md"
    >
      <i v-if="isDarkMode" class="fa-solid fa-sun text-yellow-500 text-md w-4"></i>
      <i v-else class="fa-solid fa-moon text-md text-white w-4"></i>
    </button>
    <div class="flex items-between">
      <Menu
        v-if="authStore.isLoggedIn && route.path != `/login`"
        :model="menuItems"
        class="w-full md:w-60 !py-8 px-4 sm:text-sm 2xl:text-md lg:text-sm !rounded-none h-[100vh] 2xl:w-1/6 lg:w-1/5 top-0 left-0"
      >
        <template #start>
          <div class="flex justify-center w-full">
            <Image
              :src="Logo"
              alt="Image"
              class="flex justify-center rounded-[4rem] dark:bg-white w-[5rem] p-1"
            />
          </div>
          <router-link
            to="/profile"
            v-ripple
            class="relative overflow-hidden w-full border-0 bg-transparent flex items-center p-2 pl-4 hover:bg-surface-100 dark:hover:bg-surface-800 rounded-none cursor-pointer transition-colors duration-200"
          >
            <Avatar icon="pi pi-user" class="mr-2" shape="circle" />
            <span class="inline-flex flex-col items-start">
              <span class="font-bold">{{ userName }}</span>
            </span>
          </router-link>
        </template>
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
              class="ml-auto !text-[10px] p-1 text-gray-100 dark:text-gray-800"
              >{{ item.shortcut }}</span
            >
          </RouterLink>
        </template>
        <template #end> </template>
      </Menu>
      <div class="container mx-auto mt-6 2xl:px-0 xl:px-6 lg:px-6 md:px-8">
        <router-view />
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
import Menu from "primevue/menu";
import Avatar from "primevue/avatar";
import Image from "primevue/image";
import Badge from "primevue/badge";
import Logo from "@/assets/logo.png";
import SpeedDial from "primevue/speeddial";
import Button from "primevue/button";
import { ref, onMounted, onUnmounted, computed, watch, provide, watchEffect } from "vue";
import eventBus from "@/eventBus";
import { useToast } from "primevue/usetoast";
import { useAuthStore } from "@/stores/authStore";
import { RouterLink, RouterView, useRoute } from "vue-router";
import { useConfirm } from "primevue/useconfirm";
import router from "@/router";
import Cookies from "js-cookie";
import ToggleSwitch from "primevue/toggleswitch";
import { useI18n } from "vue-i18n";

const { t } = useI18n();
const confirm = useConfirm();
const toast = useToast();
const route = useRoute();
const checked = ref(false);
const activeItem = ref(null);

watch(
  () => route.path,
  () => {
    activeItem.value = route.path;
    console.log(activeItem.value);
  }
);

let activityTimeout;
const currentRoute = router.currentRoute;
const countdown = ref(300);
// let isRtl = true;
let timerId = null;
let logoutTimerId = null;
const { locale } = useI18n();
const isRtl = computed(() => ["ar", "he", "fa"].includes(locale.value));
provide("isRtl", isRtl);

// Optional: dynamically set <html dir="rtl">
watchEffect(() => {
  document.documentElement.setAttribute("dir", isRtl.value ? "rtl" : "ltr");
});
const menuItems = computed(() => [
  {
    label: t("app.menu.calendar"),
    icon: "pi pi-calendar !text-md",
    class: "",
    route: "/",
    command: () => {},
  },
  {
    label: t("app.menu.patients"),
    icon: "fa-solid fa-paw !text-md !text-center",
    items: [
      {
        label: t("app.menu.owners"),
        class: "mx-4",
        route: "/owners",
        icon: "fa-solid fa-users !text-md !text-center",
        shortcut: "CTRL+O",
        command: () => {},
      },
      {
        label: t("app.menu.pets"),
        class: "mx-4",
        route: "/pets",
        icon: "fa-solid fa-paw !text-md !text-center",
        shortcut: "CTRL+P",
        command: () => {},
      },
    ],
    command: () => {},
  },
  {
    label: t("app.menu.inventories"),
    icon: "fa-solid fa-store !text-md",
    command: () => {},
    items: [
      {
        label: t("app.menu.pet_food"),
        class: "mx-4",
        route: "/add-inventory-food",
        icon: "fa-solid fa-bone !text-md !text-center",
        command: () => {},
      },
      {
        label: t("app.menu.toys_tools"),
        class: "mx-4",
        route: "/add-inventory-toys",
        icon: "fa-solid fa-volleyball !text-md !text-center",
        command: () => {},
      },
      {
        label: t("app.menu.pharmaceutical"),
        class: "mx-4",
        route: "/add-inventory-pharmaceutical",
        icon: "fa-solid fa-pills !text-md !text-center",
        command: () => {},
      },
      {
        label: t("app.menu.grooming"),
        class: "mx-4",
        route: "/add-inventory-grooming",
        icon: "fa-solid fa-shower !text-md !text-center",
        command: () => {},
      },
    ],
  },
  {
    label: t("app.menu.invoices"),
    icon: "fa-solid fa-file-invoice-dollar !text-md",
    class: "",
    shortcut: "CTRL+Q",
    route: "/invoices",
  },
  {
    label: t("app.menu.reports"),
    icon: "fa-solid fa-scroll !text-md",
    class: "",
    shortcut: "CTRL+Q",
    route: "/settings",
  },
  {
    label: t("app.menu.settings"),
    icon: "pi pi-cog !text-md",
    class: "",
    shortcut: "CTRL+Q",
    route: "/settings",
  },
  {
    label: t("app.menu.logout"),
    icon: "pi pi-sign-out !text-md",
    class: "",
    shortcut: "CTRL+Q",
    route: "/logout",
    command: () => {
      signOut();
    },
  },
]);

const dockItems = [
  {
    label: t("app.menu.pets"),
    class: "",
    route: "/pets",
    content:
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 576 512"><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32l52.1 0c12.7 0 24.9 5.1 33.9 14.1L496 64l56 0c13.3 0 24 10.7 24 24l0 24c0 44.2-35.8 80-80 80l-32 0-16 0-21.3 0-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32l-32 0c-17.7 0-32-14.3-32-32l0-115.2c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2L160 480c0 17.7-14.3 32-32 32l-32 0c-17.7 0-32-14.3-32-32l0-230.2c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192l30 0 16 0 159.8 0L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>',
    command: () => {},
  },
  {
    label: t("app.menu.owners"),
    class: "",
    route: "/owners",
    content:
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 512"><path d="M144 0a80 80 0 1 1 0 160A80 80 0 1 1 144 0zM512 0a80 80 0 1 1 0 160A80 80 0 1 1 512 0zM0 298.7C0 239.8 47.8 192 106.7 192l42.7 0c15.9 0 31 3.5 44.6 9.7c-1.3 7.2-1.9 14.7-1.9 22.3c0 38.2 16.8 72.5 43.3 96c-.2 0-.4 0-.7 0L21.3 320C9.6 320 0 310.4 0 298.7zM405.3 320c-.2 0-.4 0-.7 0c26.6-23.5 43.3-57.8 43.3-96c0-7.6-.7-15-1.9-22.3c13.6-6.3 28.7-9.7 44.6-9.7l42.7 0C592.2 192 640 239.8 640 298.7c0 11.8-9.6 21.3-21.3 21.3l-213.3 0zM224 224a96 96 0 1 1 192 0 96 96 0 1 1 -192 0zM128 485.3C128 411.7 187.7 352 261.3 352l117.3 0C452.3 352 512 411.7 512 485.3c0 14.7-11.9 26.7-26.7 26.7l-330.7 0c-14.7 0-26.7-11.9-26.7-26.7z"/></svg>',
    command: () => {},
  },
  {
    label: t("app.menu.inventories"),
    class: "",
    route: "/about",
    content:
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 576 512"><path d="M547.6 103.8L490.3 13.1C485.2 5 476.1 0 466.4 0L109.6 0C99.9 0 90.8 5 85.7 13.1L28.3 103.8c-29.6 46.8-3.4 111.9 51.9 119.4c4 .5 8.1 .8 12.1 .8c26.1 0 49.3-11.4 65.2-29c15.9 17.6 39.1 29 65.2 29c26.1 0 49.3-11.4 65.2-29c15.9 17.6 39.1 29 65.2 29c26.2 0 49.3-11.4 65.2-29c16 17.6 39.1 29 65.2 29c4.1 0 8.1-.3 12.1-.8c55.5-7.4 81.8-72.5 52.1-119.4zM499.7 254.9c0 0 0 0-.1 0c-5.3 .7-10.7 1.1-16.2 1.1c-12.4 0-24.3-1.9-35.4-5.3L448 384l-320 0 0-133.4c-11.2 3.5-23.2 5.4-35.6 5.4c-5.5 0-11-.4-16.3-1.1l-.1 0c-4.1-.6-8.1-1.3-12-2.3L64 384l0 64c0 35.3 28.7 64 64 64l320 0c35.3 0 64-28.7 64-64l0-64 0-131.4c-4 1-8 1.8-12.3 2.3z"/></svg>',
    command: () => {},
  },
];

const isDarkMode = ref(false);
const titleDark = ref("");

function toggleDarkMode() {
  isDarkMode.value = !isDarkMode.value;
  const calTheme = isDarkMode.value ? "dark" : "light";
  const element = document.querySelector("html");
  if (route.path === "/") {
    eventBus.emit("themeChange", calTheme);
  }
  if (isDarkMode.value) {
    element.classList.add("dark");
    titleDark.value = "Toggle Light Mode";
    localStorage.setItem("theme", "dark");
  } else {
    element.classList.remove("dark");
    titleDark.value = "Toggle Dark Mode";
    localStorage.setItem("theme", "light");
  }
  return isDarkMode.value;
}

const timeoutMessage = computed(() => {
  return t("app.session.timeout_message", { time: formattedCountdown.value });
});

const soundUrl =
  "https://soundbible.com/mp3/Ruger%20357%20Magnum%20Gun%20Cock-SoundBible.com-735730842.mp3";

const playSound = () => {
  var audio = new Audio(soundUrl);
  audio.play();
};

const formattedCountdown = computed(() => {
  const minutes = Math.floor(countdown.value / 60);
  const seconds = countdown.value % 60;
  return String(minutes).padStart(2, "0") + ":" + String(seconds).padStart(2, "0");
});

const showConfirm = () => {
  confirm.require({
    message: timeoutMessage.value,
    header: t("app.session.timeout_header"),
    icon: "fa-regular fa-clock fa-shaketext-red-500",
    acceptLabel: t("app.session.stay_logged_in"),
    rejectLabel: t("app.session.log_out"),
    acceptIcon: "fas fa-clock-rotate-left",
    rejectIcon: "fas fa-right-from-bracket",
    acceptClass: "!text-sm",
    rejectClass: "!text-sm",
    accept: () => {
      clearTimers();
    },
    reject: () => {
      clearTimers();
      authStore.logOut();
      router.push("/login");
    },
    onHide: () => {
      clearTimers();
    },
  });

  resetCountdown();
  startLogoutTimer();
};

const resetActivityTimeout = () => {
  clearTimeout(activityTimeout);
  activityTimeout = setTimeout(() => {
    if (currentRoute._value.meta.allowSessionTimeout) {
      playSound();
      showConfirm();
    }
  }, 5 * 60 * 10000);
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
        accept: () => {
          clearTimers();
        },
        reject: () => {
          clearTimers();
          authStore.logOut();
          router.push("/login");
        },
        onHide: () => {
          clearTimers();
        },
      });
    }
  }, 1000);
};

const startLogoutTimer = () => {
  if (logoutTimerId) clearTimeout(logoutTimerId);
  logoutTimerId = setTimeout(() => {
    if (countdown.value <= 0) {
      authStore.logOut();
      router.push("/login");
    }
  }, 300000);
};

const handleKeyDown = (event) => {
  if (event.key === "F2") {
    event.preventDefault();
    if (route.path === `/owners`) {
      eventBus.emit("AddOwner");
    }
    if (route.path === `/invoices`) {
      eventBus.emit("AddInvoice");
    }
  }
  if (event.ctrlKey) {
    switch (event.key) {
      case "F2":
        event.preventDefault();
        if (route.path === `/owners`) {
          eventBus.emit("AddOwner");
        }
        if (route.path === `/invoices`) {
          eventBus.emit("AddInvoice");
        }
        break;
      case "p":
        event.preventDefault();
        router.push("/pets");
        break;
      case "o":
        event.preventDefault();
        router.push(`/owners`);
        break;
      case "q":
        event.preventDefault();
        signOut();
        break;
      case "z":
        event.preventDefault();
        break;
      default:
        break;
    }
  }
};

const clearTimers = () => {
  clearInterval(timerId);
  clearTimeout(logoutTimerId);
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

onMounted(() => {
  const savedTheme = localStorage.getItem("theme");

  if (savedTheme === "dark") {
    isDarkMode.value = true;
    titleDark.value = "Toggle Light Mode";
    document.querySelector("html").classList.add("dark");
  } else {
    isDarkMode.value = false;
    titleDark.value = "Toggle Dark Mode";
    document.querySelector("html").classList.remove("dark");
  }

  eventBus.on("show-toast", (data) => {
    toast.add(data);
  });

  document.addEventListener("mousemove", resetActivityTimeout);
  document.addEventListener("keypress", resetActivityTimeout);
  document.addEventListener("keydown", handleKeyDown);
  resetActivityTimeout();
});

onUnmounted(() => {
  document.removeEventListener("mousemove", resetActivityTimeout);
  document.removeEventListener("keypress", resetActivityTimeout);
  document.removeEventListener("keydown", handleKeyDown);
  clearTimeout(activityTimeout);
});

const userName = computed(() => {
  return authStore.user?.name || Cookies.get("name") || "";
});

const authStore = useAuthStore();
</script>

<style scoped>
:deep(.p-megamenu-item:last-child .p-megamenu-item-content):hover {
  background: none !important;
}
@media (min-width: 1536px) {
  .container {
    max-width: 80%;
  }
}
.router-link-active {
  background: black;
  color: var(--p-primary-contrast-color);
  border-radius: 3px !important;
}
.dark .router-link-active {
  background: var(--p-surface-300);
  color: var(--p-primary-contrast-color);
}
</style>
