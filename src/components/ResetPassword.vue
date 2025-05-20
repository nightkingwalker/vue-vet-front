<template>
  <div class="flex items-center justify-center min-h-screen">
    <div
      class="w-full max-w-md p-8 space-y-8 bg-white rounded-lg shadow dark:bg-gray-800"
    >
      <h1 class="text-2xl font-bold">Reset Password</h1>

      <form @submit.prevent="handleReset">
        <input type="hidden" v-model="token" />

        <div class="space-y-4">
          <InputText v-model="email" type="email" placeholder="Email" class="w-full" />

          <InputText
            v-model="password"
            type="password"
            placeholder="New Password"
            class="w-full"
          />

          <InputText
            v-model="passwordConfirmation"
            type="password"
            placeholder="Confirm Password"
            class="w-full"
          />

          <Button
            type="submit"
            label="Reset Password"
            class="w-full"
            :loading="loading"
          />
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRoute, useRouter } from "vue-router";
import axios from "axios";

const route = useRoute();
const router = useRouter();

const token = ref("");
const email = ref("");
const password = ref("");
const passwordConfirmation = ref("");
const loading = ref(false);
const error = ref("");

onMounted(() => {
  token.value = route.params.token;
});

const handleReset = async () => {
  if (password.value !== passwordConfirmation.value) {
    error.value = "Passwords don't match";
    return;
  }

  loading.value = true;

  try {
    await axios.post(import.meta.env.VITE_API_URL + "/reset-password", {
      token: token.value,
      email: email.value,
      password: password.value,
      password_confirmation: passwordConfirmation.value,
    });

    router.push("/login");
  } catch (err) {
    error.value = err.response?.data?.message || "Failed to reset password";
  } finally {
    loading.value = false;
  }
};
</script>
