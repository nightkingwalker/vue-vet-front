<!--<template>
  <div class="px-8 py-2 bg-white dark:bg-stone-900 shadow-lg rounded-lg max-w-md w-full">
    <h2 class="text-xl font-bold mb-4 text-center">{{ $t("branchSelection.title") }}</h2>
    <p class="text-sm text-gray-600 dark:text-gray-400 mb-6 text-center">
      {{ $t("branchSelection.subtitle") }}
    </p>

    <div class="space-y-1">
      <div
        v-for="branch in branches"
        :key="branch.id"
        @click="selectBranch(branch.id)"
        class="px-4 py-1 border rounded-lg cursor-pointer hover:bg-gray-50 dark:hover:bg-stone-800 transition"
        :class="{ 'border-blue-500': selectedBranch === branch.id }"
      >
        <div class="flex items-center">
          <i class="pi pi-building mr-3 text-lg"></i>
          <div>
            <h3 class="font-medium">{{ branch.name }}</h3>
            <p class="text-sm text-gray-500 dark:text-gray-400">{{ branch.address }}</p>
          </div>
        </div>
      </div>
    </div>

    <button
      @click="confirmSelection"
      class="w-full mt-6 p-button p-button-content py-2 px-4 rounded focus:outline-none focus:shadow-outline"
      :disabled="!selectedBranch || loading"
    >
      <i class="fa-solid fa-spinner fa-spin" v-if="loading"></i>
      <span v-else>{{ $t("branchSelection.continueButton") }}</span>
    </button>

    <small
      v-if="message"
      class="block mt-4 text-center"
      :class="isError ? 'text-red-500' : 'text-green-500'"
    >
      {{ isError ? $t("branchSelection.messages.failed") : message }}
    </small>
  </div>
</template>-->
<!--<template>
  <div class="w-full max-w-md px-6 py-6 bg-white dark:bg-stone-900 shadow-xl rounded-2xl">
    <p class="text-sm text-center text-gray-600 dark:text-gray-400 mb-6">
      {{ $t("branchSelection.subtitle") }}
    </p>

    <div class="space-y-3">
      <div
        v-for="branch in branches"
        :key="branch.id"
        @click="selectBranch(branch.id)"
        class="flex items-start gap-3 p-4 border rounded-xl cursor-pointer transition-all duration-150 hover:bg-gray-50 dark:hover:bg-stone-800"
        :class="{
          'border-blue-500 shadow-md': selectedBranch === branch.id,
          'border-gray-300 dark:border-stone-700': selectedBranch !== branch.id,
        }"
        role="button"
      >
        <i class="pi pi-building text-xl pt-1 text-gray-700 dark:text-gray-300"></i>
        <div>
          <h3 class="font-medium text-gray-900 dark:text-white">{{ branch.name }}</h3>
          <p class="text-sm text-gray-500 dark:text-gray-400">{{ branch.address }}</p>
        </div>
      </div>
    </div>

    <button
      @click="confirmSelection"
      :disabled="!selectedBranch || loading"
      class="w-full mt-6 py-2 px-4 rounded-lg font-medium text-white transition-colors duration-150 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed bg-blue-600 hover:bg-blue-700"
    >
      <i class="fa-solid fa-spinner fa-spin" v-if="loading"></i>
      <span v-else>{{ $t("branchSelection.continueButton") }}</span>
    </button>

    <small
      v-if="message"
      class="block mt-4 text-center text-sm"
      :class="isError ? 'text-red-500' : 'text-green-500'"
    >
      {{ isError ? $t("branchSelection.messages.failed") : message }}
    </small>
  </div>
</template>-->
<template>
  <div class="w-full max-w-md px-6 py-6 bg-white dark:bg-stone-900 shadow-xl rounded-2xl">
    <h2 class="text-2xl font-semibold text-center mb-2">
      {{ $t("branchSelection.title") }}
    </h2>
    <p class="text-sm text-center text-gray-600 dark:text-gray-400 mb-6">
      {{ $t("branchSelection.subtitle") }}
    </p>

    <div class="space-y-3">
      <div
        v-for="branch in branches"
        :key="branch.id"
        @click="selectBranch(branch.id)"
        class="flex items-start gap-3 p-4 border rounded-xl cursor-pointer transition-all duration-150 hover:bg-gray-50 dark:hover:bg-stone-800"
        :class="{
          'border-blue-500 shadow-md': selectedBranch === branch.id,
          'border-gray-300 dark:border-stone-700': selectedBranch !== branch.id,
        }"
        role="button"
      >
        <i class="pi pi-building text-xl pt-1 text-gray-700 dark:text-gray-300"></i>
        <div>
          <h3 class="font-medium text-gray-900 dark:text-white">{{ branch.name }}</h3>
          <p class="text-sm text-gray-500 dark:text-gray-400">{{ branch.address }}</p>
        </div>
      </div>
    </div>

    <button
      @click="confirmSelection"
      :disabled="!selectedBranch || loading"
      class="w-full mt-6 py-2 px-4 rounded-lg font-medium text-white transition-colors duration-150 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed !bg-[var(--p-surface-600)] !text-[var(--p-surface-200)] dark:!bg-[var(--p-surface-400)] dark:!text-white hover:bg-blue-700"
    >
      <i class="fa-solid fa-spinner fa-spin" v-if="loading"></i>
      <span v-else>{{ $t("branchSelection.continueButton") }}</span>
    </button>

    <small
      v-if="message"
      class="block mt-4 text-center text-sm"
      :class="isError ? 'text-red-500' : 'text-green-500'"
    >
      {{ isError ? $t("branchSelection.messages.failed") : message }}
    </small>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import { useAuthStore } from "@/stores/authStore";
import axios from "axios";
import Image from "primevue/image";
import Logo from "@/assets/logo.png";

const props = defineProps({
  branches: {
    type: Array,
    required: true,
  },
});

const emit = defineEmits(["branch-selected"]);

const selectedBranch = ref(null);
const loading = ref(false);
const message = ref("");
const isError = ref(false);
const router = useRouter();
const authStore = useAuthStore();

const selectBranch = (branchId) => {
  selectedBranch.value = branchId;
};
// console.log("accessToken", authStore.token);
const confirmSelection = async () => {
  if (!selectedBranch.value) return;

  loading.value = true;
  isError.value = false;
  message.value = "";
  //   console.log("authStore.accessToken", authStore.token);
  try {
    const response = await axios.post(
      import.meta.env.VITE_API_URL + "/select-branch",
      { branch_id: selectedBranch.value },
      {
        headers: {
          Authorization: `Bearer ${authStore.token}`,
          "Content-Type": "application/json",
        },
      }
    );
    // console.log("response.data", response.data);
    const {
      access_token,
      refresh_token,
      expires_in,
      refresh_expires_in,
      requires_2fa,
      temporary_token,
      remember_me,
      user,
    } = response.data;
    authStore.updateTokens(
      access_token,
      refresh_token,
      expires_in,
      refresh_expires_in,
      remember_me
    );
    // emit("branch-selected", selectedBranch.value);
    await router.push("/");
  } catch (error) {
    isError.value = true;
    message.value = error.response?.data?.message || "Failed to select branch";
    // console.log(error);
  } finally {
    loading.value = false;
  }
};
</script>

<style scoped>
/* Add any custom styles here */
</style>
