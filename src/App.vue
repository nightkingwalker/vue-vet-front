<script setup>
import Menu from "primevue/menu";
import Avatar from "primevue/avatar";
import Image from "primevue/image";
import Badge from "primevue/badge";
import Logo from "@/assets/logo.png";
import SpeedDial from "primevue/speeddial";
import Button from "primevue/button";
import { ref, onMounted, onUnmounted, computed } from "vue";
import eventBus from "@/eventBus";
import { useToast } from "primevue/usetoast";
import { useAuthStore } from "@/stores/authStore";
import { RouterLink, RouterView, useRoute } from "vue-router";
import { useConfirm } from "primevue/useconfirm";
import router from "@/router";
import ToggleSwitch from "primevue/toggleswitch";
// import { useNotificationStore } from "@/stores/notificationStore"; // assuming the store is in src/stores/
// const notificationStore = useNotificationStore();
const confirm = useConfirm();
const toast = useToast();
const route = useRoute();
const checked = ref(false);
let activityTimeout;
const currentRoute = router.currentRoute;
const countdown = ref(300); // Countdown starting at 60 seconds
let isRtl = false;
let timerId = null;
let logoutTimerId = null;
const menuItems = [
  {
    label: "Home",
    icon: "pi pi-home !text-md",
    class: "",
    route: "/",
    command: () => {
      // Callback to run
    },
  },
  {
    label: "Account",
    icon: "pi pi-info-circle !text-md",
    class: "",
    route: "/account",
    command: () => {
      // Callback to run
    },
  },
  {
    label: "Patients",
    // icon: "pi pi-sign-out !text-md",
    class: "",
    icon: "fa-solid fa-paw !text-md !text-center",
    items: [
      {
        label: "Pets",
        // icon: "pi pi-sign-out !text-md",
        class: "mx-4",
        route: "/pets",
        icon: "fa-solid fa-paw !text-md !text-center",
        shortcut: "CTRL+P",
        // content:
        // '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 576 512"><!--!Font Awesome Free 6.6.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.--><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32l52.1 0c12.7 0 24.9 5.1 33.9 14.1L496 64l56 0c13.3 0 24 10.7 24 24l0 24c0 44.2-35.8 80-80 80l-32 0-16 0-21.3 0-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32l-32 0c-17.7 0-32-14.3-32-32l0-115.2c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2L160 480c0 17.7-14.3 32-32 32l-32 0c-17.7 0-32-14.3-32-32l0-230.2c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192l30 0 16 0 159.8 0L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>',
        command: () => {
          // Callback to run
        },
      },
      {
        label: "Owners",
        // icon: "pi pi-sign-out !text-md",
        class: "mx-4",
        route: "/owners",
        icon: "fa-solid fa-users !text-md !text-center",
        shortcut: "CTRL+O",
        // content:
        // '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 512" ><!--!Font Awesome Free 6.6.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.--><path d="M144 0a80 80 0 1 1 0 160A80 80 0 1 1 144 0zM512 0a80 80 0 1 1 0 160A80 80 0 1 1 512 0zM0 298.7C0 239.8 47.8 192 106.7 192l42.7 0c15.9 0 31 3.5 44.6 9.7c-1.3 7.2-1.9 14.7-1.9 22.3c0 38.2 16.8 72.5 43.3 96c-.2 0-.4 0-.7 0L21.3 320C9.6 320 0 310.4 0 298.7zM405.3 320c-.2 0-.4 0-.7 0c26.6-23.5 43.3-57.8 43.3-96c0-7.6-.7-15-1.9-22.3c13.6-6.3 28.7-9.7 44.6-9.7l42.7 0C592.2 192 640 239.8 640 298.7c0 11.8-9.6 21.3-21.3 21.3l-213.3 0zM224 224a96 96 0 1 1 192 0 96 96 0 1 1 -192 0zM128 485.3C128 411.7 187.7 352 261.3 352l117.3 0C452.3 352 512 411.7 512 485.3c0 14.7-11.9 26.7-26.7 26.7l-330.7 0c-14.7 0-26.7-11.9-26.7-26.7z"/></svg>',
        command: () => {
          // Callback to run
        },
      },
    ],
    // content:
    // '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 576 512"><!--!Font Awesome Free 6.6.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.--><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32l52.1 0c12.7 0 24.9 5.1 33.9 14.1L496 64l56 0c13.3 0 24 10.7 24 24l0 24c0 44.2-35.8 80-80 80l-32 0-16 0-21.3 0-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32l-32 0c-17.7 0-32-14.3-32-32l0-115.2c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2L160 480c0 17.7-14.3 32-32 32l-32 0c-17.7 0-32-14.3-32-32l0-230.2c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192l30 0 16 0 159.8 0L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>',
    command: () => {
      // Callback to run
    },
  },
  {
    label: "Inventories",
    // icon: "pi pi-sign-out !text-md",
    class: "",
    route: "/about",
    icon: "fa-solid fa-store !text-md",
    // content:
    // '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 576 512"><!--!Font Awesome Free 6.6.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.--><path d="M547.6 103.8L490.3 13.1C485.2 5 476.1 0 466.4 0L109.6 0C99.9 0 90.8 5 85.7 13.1L28.3 103.8c-29.6 46.8-3.4 111.9 51.9 119.4c4 .5 8.1 .8 12.1 .8c26.1 0 49.3-11.4 65.2-29c15.9 17.6 39.1 29 65.2 29c26.1 0 49.3-11.4 65.2-29c15.9 17.6 39.1 29 65.2 29c26.2 0 49.3-11.4 65.2-29c16 17.6 39.1 29 65.2 29c4.1 0 8.1-.3 12.1-.8c55.5-7.4 81.8-72.5 52.1-119.4zM499.7 254.9c0 0 0 0-.1 0c-5.3 .7-10.7 1.1-16.2 1.1c-12.4 0-24.3-1.9-35.4-5.3L448 384l-320 0 0-133.4c-11.2 3.5-23.2 5.4-35.6 5.4c-5.5 0-11-.4-16.3-1.1l-.1 0c-4.1-.6-8.1-1.3-12-2.3L64 384l0 64c0 35.3 28.7 64 64 64l320 0c35.3 0 64-28.7 64-64l0-64 0-131.4c-4 1-8 1.8-12.3 2.3z"/></svg>',
    command: () => {
      // Callback to run
    },
    items: [
      {
        label: "Stores",
        // icon: "pi pi-sign-out !text-md",
        class: "mx-4",
        route: "/pets",
        icon: "fa-solid fa-paw !text-md !text-center",
        // content:
        // '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 576 512"><!--!Font Awesome Free 6.6.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.--><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32l52.1 0c12.7 0 24.9 5.1 33.9 14.1L496 64l56 0c13.3 0 24 10.7 24 24l0 24c0 44.2-35.8 80-80 80l-32 0-16 0-21.3 0-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32l-32 0c-17.7 0-32-14.3-32-32l0-115.2c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2L160 480c0 17.7-14.3 32-32 32l-32 0c-17.7 0-32-14.3-32-32l0-230.2c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192l30 0 16 0 159.8 0L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>',
        command: () => {
          // Callback to run
        },
      },
      {
        label: "Stores",
        // icon: "pi pi-sign-out !text-md",
        class: "mx-4",
        route: "/owners",
        icon: "fa-solid fa-users !text-md !text-center",
        // content:
        // '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 512" ><!--!Font Awesome Free 6.6.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.--><path d="M144 0a80 80 0 1 1 0 160A80 80 0 1 1 144 0zM512 0a80 80 0 1 1 0 160A80 80 0 1 1 512 0zM0 298.7C0 239.8 47.8 192 106.7 192l42.7 0c15.9 0 31 3.5 44.6 9.7c-1.3 7.2-1.9 14.7-1.9 22.3c0 38.2 16.8 72.5 43.3 96c-.2 0-.4 0-.7 0L21.3 320C9.6 320 0 310.4 0 298.7zM405.3 320c-.2 0-.4 0-.7 0c26.6-23.5 43.3-57.8 43.3-96c0-7.6-.7-15-1.9-22.3c13.6-6.3 28.7-9.7 44.6-9.7l42.7 0C592.2 192 640 239.8 640 298.7c0 11.8-9.6 21.3-21.3 21.3l-213.3 0zM224 224a96 96 0 1 1 192 0 96 96 0 1 1 -192 0zM128 485.3C128 411.7 187.7 352 261.3 352l117.3 0C452.3 352 512 411.7 512 485.3c0 14.7-11.9 26.7-26.7 26.7l-330.7 0c-14.7 0-26.7-11.9-26.7-26.7z"/></svg>',
        command: () => {
          // Callback to run
        },
      },
    ],
  },

  {
    label: "Log out",
    icon: "pi pi-sign-out !text-md",
    class: "",
    shortcut: "CTRL+Q",
    to: "#",
    command: () => {
      signOut();
    },
  },
];
const dockItems = [
  {
    label: "Pets",
    // icon: "pi pi-sign-out !text-md",
    class: "",
    route: "/pets",
    content:
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 576 512"><!--!Font Awesome Free 6.6.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.--><path d="M309.6 158.5L332.7 19.8C334.6 8.4 344.5 0 356.1 0c7.5 0 14.5 3.5 19 9.5L392 32l52.1 0c12.7 0 24.9 5.1 33.9 14.1L496 64l56 0c13.3 0 24 10.7 24 24l0 24c0 44.2-35.8 80-80 80l-32 0-16 0-21.3 0-5.1 30.5-112-64zM416 256.1L416 480c0 17.7-14.3 32-32 32l-32 0c-17.7 0-32-14.3-32-32l0-115.2c-24 12.3-51.2 19.2-80 19.2s-56-6.9-80-19.2L160 480c0 17.7-14.3 32-32 32l-32 0c-17.7 0-32-14.3-32-32l0-230.2c-28.8-10.9-51.4-35.3-59.2-66.5L1 167.8c-4.3-17.1 6.1-34.5 23.3-38.8s34.5 6.1 38.8 23.3l3.9 15.5C70.5 182 83.3 192 98 192l30 0 16 0 159.8 0L416 256.1zM464 80a16 16 0 1 0 -32 0 16 16 0 1 0 32 0z"/></svg>',
    command: () => {
      // Callback to run
    },
  },
  {
    label: "Owners",
    // icon: "pi pi-sign-out !text-md",
    class: "",
    route: "/owners",
    content:
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 512" ><!--!Font Awesome Free 6.6.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.--><path d="M144 0a80 80 0 1 1 0 160A80 80 0 1 1 144 0zM512 0a80 80 0 1 1 0 160A80 80 0 1 1 512 0zM0 298.7C0 239.8 47.8 192 106.7 192l42.7 0c15.9 0 31 3.5 44.6 9.7c-1.3 7.2-1.9 14.7-1.9 22.3c0 38.2 16.8 72.5 43.3 96c-.2 0-.4 0-.7 0L21.3 320C9.6 320 0 310.4 0 298.7zM405.3 320c-.2 0-.4 0-.7 0c26.6-23.5 43.3-57.8 43.3-96c0-7.6-.7-15-1.9-22.3c13.6-6.3 28.7-9.7 44.6-9.7l42.7 0C592.2 192 640 239.8 640 298.7c0 11.8-9.6 21.3-21.3 21.3l-213.3 0zM224 224a96 96 0 1 1 192 0 96 96 0 1 1 -192 0zM128 485.3C128 411.7 187.7 352 261.3 352l117.3 0C452.3 352 512 411.7 512 485.3c0 14.7-11.9 26.7-26.7 26.7l-330.7 0c-14.7 0-26.7-11.9-26.7-26.7z"/></svg>',
    command: () => {
      // Callback to run
    },
  },
  {
    label: "Inventories",
    // icon: "pi pi-sign-out !text-md",
    class: "",
    route: "/about",
    content:
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 576 512"><!--!Font Awesome Free 6.6.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.--><path d="M547.6 103.8L490.3 13.1C485.2 5 476.1 0 466.4 0L109.6 0C99.9 0 90.8 5 85.7 13.1L28.3 103.8c-29.6 46.8-3.4 111.9 51.9 119.4c4 .5 8.1 .8 12.1 .8c26.1 0 49.3-11.4 65.2-29c15.9 17.6 39.1 29 65.2 29c26.1 0 49.3-11.4 65.2-29c15.9 17.6 39.1 29 65.2 29c26.2 0 49.3-11.4 65.2-29c16 17.6 39.1 29 65.2 29c4.1 0 8.1-.3 12.1-.8c55.5-7.4 81.8-72.5 52.1-119.4zM499.7 254.9c0 0 0 0-.1 0c-5.3 .7-10.7 1.1-16.2 1.1c-12.4 0-24.3-1.9-35.4-5.3L448 384l-320 0 0-133.4c-11.2 3.5-23.2 5.4-35.6 5.4c-5.5 0-11-.4-16.3-1.1l-.1 0c-4.1-.6-8.1-1.3-12-2.3L64 384l0 64c0 35.3 28.7 64 64 64l320 0c35.3 0 64-28.7 64-64l0-64 0-131.4c-4 1-8 1.8-12.3 2.3z"/></svg>',
    command: () => {
      // Callback to run
    },
  },
];

const isDarkMode = ref(false);
const titleDark = ref("");
// Toggle dark mode and save the preference in localStorage
function toggleDarkMode() {
  isDarkMode.value = !isDarkMode.value;
  const calTheme = isDarkMode.value ? "dark" : "light";
  const element = document.querySelector("html");
  if (route.path === "/") {
    // console.log("calendar page");
    // const savedTheme = isDarkMode.value ? "dark" : "light";
    // calendarApp.setTheme(savedTheme);
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
  return (
    "You've been inactive for a while.You will be automatically logged out in " +
    formattedCountdown.value +
    " seconds."
  );
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
  // console.log(String(minutes).padStart(2, "0") + ":" + String(seconds).padStart(2, "0"));
  return String(minutes).padStart(2, "0") + ":" + String(seconds).padStart(2, "0");
});

const showConfirm = () => {
  // console.log("PLAYING AUDIO");

  confirm.require({
    message: timeoutMessage.value,
    header: "Session Timeout",
    icon: "fa-regular fa-clock fa-shaketext-red-500",
    acceptLabel: "Stay Logged in",
    rejectLabel: "Log out",
    acceptIcon: "fas fa-clock-rotate-left",
    rejectIcon: "fas fa-right-from-bracket",
    acceptClass: "!text-sm",
    rejectClass: "!text-sm",
    accept: () => {
      // console.log("User stays logged in");
      clearTimers();
    },
    reject: () => {
      // console.log("User logged out");
      clearTimers();
      authStore.logOut();
      router.push("/login");
    },
    onHide: () => {
      // Handles the case when dialog is closed without any action
      clearTimers();
    },
  });

  resetCountdown();
  startLogoutTimer();
};
const resetActivityTimeout = () => {
  // // console.log(currentRoute._value.meta);
  clearTimeout(activityTimeout);
  activityTimeout = setTimeout(() => {
    if (currentRoute._value.meta.allowSessionTimeout) {
      // Only show session timeout dialog if allowed by the route metadata
      playSound();
      showConfirm();
    }
  }, 5 * 60 * 10000); // 10 seconds for demonstration 5 * 60 *
};

const resetCountdown = () => {
  countdown.value = 300; // Reset to 60 seconds
  clearInterval(timerId);
  timerId = setInterval(() => {
    countdown.value--;
    if (countdown.value <= 0) {
      clearInterval(timerId);
      authStore.logOut(); // Automatically log out if countdown reaches zero
      router.push("/login");
    } else {
      confirm.require({
        message: timeoutMessage.value,
        header: "Session Timeout",
        icon: "fa-regular fa-clock fa-shake text-red-500",
        acceptLabel: "Stay Logged in",
        rejectLabel: "Log out",
        acceptIcon: "fas fa-clock-rotate-left",
        rejectIcon: "fas fa-right-from-bracket",
        acceptClass: "!text-sm",
        rejectClass: "!text-sm",
        accept: () => {
          // console.log("User stays logged in");
          clearTimers();
        },
        reject: () => {
          // console.log("User logged out");
          clearTimers();
          authStore.logOut();
          router.push("/login");
        },
        onHide: () => {
          // Handles the case when dialog is closed without any action
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
      // Only log out if the countdown has finished
      // console.log("Automatically logging out due to inactivity");
      authStore.logOut();
      router.push("/login");
    }
  }, 300000); // 60 seconds
};
const handleKeyDown = (event) => {
  if (event.key === "F2") {
    event.preventDefault();
    console.log(route.path);
    // router.push({ name: "Owners" });
    if (route.path === `/owners`) {
      eventBus.emit("AddOwner");
      console.log("Ctrl + N pressed");
    }
  }
  if (event.ctrlKey) {
    switch (event.key) {
      case "F2": // Ctrl + O
        event.preventDefault();
        console.log(route.path);
        // router.push({ name: "Owners" });
        if (route.path === `/owners`) {
          eventBus.emit("AddOwner");
          console.log("Ctrl + N pressed");
        }
        break;
      case "p": // Ctrl + O
        event.preventDefault();
        router.push("/pets");
        break;
      case "o": // Ctrl + O
        event.preventDefault(); // Prevent default save action
        console.log("Ctrl + O pressed");
        router.push(`/owners`);
        break;
      case "q": // Ctrl + S
        event.preventDefault(); // Prevent default save action
        console.log("Ctrl + q pressed");
        // Add your custom save logic here
        signOut();
        break;
      case "z": // Ctrl + Z
        event.preventDefault(); // Prevent default undo action
        console.log("Ctrl + Z pressed");
        // Add your undo logic here
        break;
      // Add more cases as needed for other key combinations
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
    // Perform any necessary cleanup or API calls here
    authStore.logOut(); // Call the logOut method from your auth store
    toast.add({
      severity: "info",
      summary: "Signed out",
      detail: "User logged out",
      life: 3000,
    });
    router.push("/login"); // Redirect to the login page
    // console.log("User signed out successfully");
  } catch (error) {
    // console.error("Error signing out:", error);
  }
};
// Load the saved theme from localStorage when the component is mounted
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
  resetActivityTimeout(); // Set initial timeout on app start
});
onUnmounted(() => {
  document.removeEventListener("mousemove", resetActivityTimeout);
  document.removeEventListener("keypress", resetActivityTimeout);

  document.removeEventListener("keydown", handleKeyDown);

  clearTimeout(activityTimeout);
});

const authStore = useAuthStore();
</script>

<template>
  <div :class="{ rtl: isRtl }">
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
        class="w-full md:w-60 !py-8 px-4 sm:text-sm 2xl:text-lg lg:text-sm !rounded-none h-[100vh] 2xl:w-1/6 lg:w-1/5 top-0 left-0"
      >
        <template #start>
          <div class="flex justify-center w-full">
            <Image
              :src="Logo"
              alt="Image"
              class="flex justify-center rounded-[4rem] dark:bg-white w-[5rem] p-1"
            />
          </div>
        </template>
        <template #submenulabel="{ item }">
          <span class="text-primary font-bold">{{ item.label }}</span>
        </template>
        <template #item="{ item, props }">
          <RouterLink
            v-ripple
            class="flex items-center"
            v-bind="props.action"
            :to="item.route"
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
        <template #end>
          <button
            v-ripple
            class="relative overflow-hidden w-full border-0 bg-transparent flex items-start p-2 pl-4 hover:bg-surface-100 dark:hover:bg-surface-800 rounded-none cursor-pointer transition-colors duration-200"
          >
            <Avatar icon="pi pi-user" class="mr-2" shape="circle" />
            <span class="inline-flex flex-col items-start">
              <span class="font-bold">Tarek Sawah</span>
              <span class="text-sm">Admin</span>
            </span>
          </button>
        </template>
      </Menu>
      <div class="container mx-auto mt-6 2xl:px-0 xl:px-6 lg:px-6 md:px-8">
        <router-view />
        <!-- <RouterView class="" /> -->
        <!-- <ConfirmDialog /> -->
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
<style scoped>
:deep(.p-megamenu-item:last-child .p-megamenu-item-content):hover {
  background: none !important;
}
@media (min-width: 1536px) {
  .container {
    max-width: 1280px;
  }
}
</style>
