<template>
  <div class="loading-overlay" v-if="isLoading">
    <div class="spinner"></div>
    <!-- Optional: Add a progress bar instead -->
    <!-- <div class="progress-bar"></div> -->
  </div>
</template>

<script setup>
import { ref } from "vue";

const isLoading = ref(false);

// Expose methods to control loading state
const startLoading = () => (isLoading.value = true);
const stopLoading = () => (isLoading.value = false);

// Make methods available to parent components
defineExpose({ startLoading, stopLoading });
</script>

<style scoped>
.loading-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.7);
  display: grid;
  place-items: center;
  z-index: 9999;
}

.spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #f3f3f3;
  border-top: 4px solid #3498db;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

/* Optional: Progress bar alternative */
.progress-bar {
  height: 4px;
  width: 100%;
  background: linear-gradient(to right, #3498db, #2ecc71);
  animation: progress 2s ease-in-out infinite;
}
</style>
