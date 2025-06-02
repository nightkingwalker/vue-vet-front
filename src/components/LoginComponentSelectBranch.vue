<template>
  <!-- <div class="flex items-center justify-center bg-stone-100 dark:bg-stone-800"> -->
  <div class="px-8 py-2 bg-white dark:bg-stone-900 shadow-lg rounded-lg max-w-md w-full">
    <div class="w-full flex justify-center mb-6">
      <Image :src="Logo" alt="Logo" class="w-16 h-16 rounded-full" />
    </div>

    <h2 class="text-xl font-bold mb-4 text-center">Select Branch</h2>
    <p class="text-sm text-gray-600 dark:text-gray-400 mb-6 text-center">
      Please choose branch
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
      <span v-else>Continue</span>
    </button>

    <small
      v-if="message"
      class="block mt-4 text-center"
      :class="isError ? 'text-red-500' : 'text-green-500'"
    >
      {{ message }}
    </small>
  </div>
  <!-- </div> -->
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
