<template>
  <!-- This component works invisibly in the background -->
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from "vue";
import { useConfirm } from "primevue/useconfirm";
import { useToast } from "primevue/usetoast";
import { useAuthStore } from "@/stores/authStore";
import { useRouter } from "vue-router";
import { useI18n } from "vue-i18n";

const { t, locale } = useI18n();
const props = defineProps({
  timeoutDuration: {
    type: Number,
    default: 300, // 5 minutes in seconds
  },
  allowTimeout: {
    type: Boolean,
    default: true,
  },
});

const emit = defineEmits(["timeout-warning", "timeout", "activity-reset"]);

const confirm = useConfirm();
const toast = useToast();
const authStore = useAuthStore();
const router = useRouter();

const countdown = ref(props.timeoutDuration);
const timerId = ref<number>();
const logoutTimerId = ref<number>();
const activityTimeout = ref<number>();

const formattedCountdown = computed(() => {
  const minutes = Math.floor(countdown.value / 60);
  const seconds = countdown.value % 60;
  return `${String(minutes).padStart(2, "0")}:${String(seconds).padStart(2, "0")}`;
});

const playSound = () => {
  new Audio("/sounds/timeout.mp3")
    .play()
    .catch((e) => console.error("Audio playback failed:", e));
};

const clearTimers = () => {
  clearInterval(timerId.value);
  clearTimeout(logoutTimerId.value);
  clearTimeout(activityTimeout.value);
  emit("activity-reset");
};

const resetActivityTimeout = () => {
  clearTimeout(activityTimeout.value);
  activityTimeout.value = (setTimeout(() => {
    if (props.allowTimeout) {
      playSound();
      showConfirm();
    }
  }, props.timeoutDuration * 1000) as unknown) as number;
};

const resetCountdown = () => {
  countdown.value = props.timeoutDuration;
  clearInterval(timerId.value);

  timerId.value = (setInterval(() => {
    countdown.value--;
    emit("timeout-warning", countdown.value);

    if (countdown.value <= 0) {
      clearInterval(timerId.value);
      handleTimeout();
    } else {
      updateTimeoutDialog();
    }
  }, 1000) as unknown) as number;
};
const timeoutMessage = computed(() =>
  t("app.session.timeout_message", { time: formattedCountdown.value })
);
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
    accept: () => {
      clearTimers();
      emit("activity-reset");
    },
    reject: () => {
      handleTimeout();
    },
    onHide: () => {
      clearTimers();
    },
  });
};

const showConfirm = () => {
  updateTimeoutDialog();
  resetCountdown();
  startLogoutTimer();
};

const startLogoutTimer = () => {
  clearTimeout(logoutTimerId.value);
  logoutTimerId.value = (setTimeout(() => {
    if (countdown.value <= 0) {
      handleTimeout();
    }
  }, props.timeoutDuration * 1000) as unknown) as number;
};

const handleTimeout = () => {
  clearTimers();
  authStore.logOut();
  router.push("/login");
  toast.add({
    severity: "warn",
    summary: "Session Expired",
    detail: "You have been logged out due to inactivity",
    life: 5000,
  });
  emit("timeout");
};

// Activity listeners
const setupActivityListeners = () => {
  window.addEventListener("mousemove", resetActivityTimeout);
  window.addEventListener("keypress", resetActivityTimeout);
  window.addEventListener("click", resetActivityTimeout);
  window.addEventListener("scroll", resetActivityTimeout);
};

const cleanupActivityListeners = () => {
  window.removeEventListener("mousemove", resetActivityTimeout);
  window.removeEventListener("keypress", resetActivityTimeout);
  window.removeEventListener("click", resetActivityTimeout);
  window.removeEventListener("scroll", resetActivityTimeout);
};

onMounted(() => {
  setupActivityListeners();
  resetActivityTimeout();
});

onUnmounted(() => {
  cleanupActivityListeners();
  clearTimers();
});
</script>
