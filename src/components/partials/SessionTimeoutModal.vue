<template>
  <div v-if="isVisible" class="modal-overlay">
    <div class="modal-content">
      <h3>Session Timeout Warning</h3>
      <p>
        You've been inactive for a while. Do you want to stay logged in? You will be
        logged out in <strong>{{ countdown }}</strong> seconds.
      </p>
      <button @click="stayLoggedIn">Yes, keep me logged in</button>
      <button @click="logOut">No, log me out</button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from "vue";

const props = defineProps({
  isVisible: Boolean,
});

const emit = defineEmits(["update:isVisible"]);
const countdown = ref(60);
let timerId = null;

const stayLoggedIn = () => {
  clearInterval(timerId);
  emit("update:isVisible", false); // Close the modal
};

const logOut = () => {
  clearInterval(timerId);
  // Perform log out logic here
  emit("update:isVisible", false); // Close the modal
};

onMounted(() => {
  timerId = setInterval(() => {
    countdown.value--;
    if (countdown.value <= 0) {
      logOut(); // Automatically log out when countdown reaches zero
    }
  }, 1000);
});

onUnmounted(() => {
  clearInterval(timerId);
});
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
}

.modal-content {
  background: white;
  padding: 20px;
  border-radius: 5px;
  text-align: center;
}
</style>
