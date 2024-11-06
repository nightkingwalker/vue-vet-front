<template>
  <div
    class="flex items-center justify-center min-h-[90vh] bg-stone-100 dark:bg-stone-800 container mx-auto"
  >
    <div class="p-8 bg-white dark:bg-stone-900 shadow-lg rounded-lg max-w-md w-full">
      <!-- <h2 class="text-2xl font-bold mb-6 text-gray-800 dark:text-white">Login</h2> -->
      <div class="w-full flex justify-center">
        <Image
          :src="Logo"
          alt="Image"
          class="flex justify-center rounded-[4rem] dark:bg-white w-[5rem] p-1"
        />
      </div>

      <form @submit.prevent="login">
        <div>
          <div class="flex flex-col gap-2 text-gray-600 dark:text-gray-400">
            <label for="username">Username</label>
            <InputGroup
              class="!bg-gray-200 !dark:bg-gray-600 !text-gray-800 flex rounded-md overflow-hidden"
            >
              <InputGroupAddon
                class="!bg-gray-200 !dark:bg-gray-600 !text-gray-800 px-4 flex flex-col item-center justify-center"
                ><i class="pi pi-user"></i
              ></InputGroupAddon>
              <InputText
                id="username"
                v-model="email"
                aria-describedby="username-help"
                placeholder="Username"
                :feedback="false"
                fluid
                style="
                  border-top: 1px solid var(--p-inputgroup-addon-border-color);
                  border-bottom: 1px solid var(--p-inputgroup-addon-border-color);
                "
                class="!bg-gray-200 !dark:bg-gray-600 !text-gray-800 focus:!ring-0 focus:!ring-offset-0 !border-x-0 focus:!outline-0"
              />
            </InputGroup>
          </div>
        </div>
        <div class="mb-6">
          <div class="flex flex-col gap-2 text-gray-600 dark:text-gray-400">
            <label for="password">Password</label>
            <InputGroup
              class="!bg-gray-200 !dark:bg-gray-600 !text-gray-800 flex rounded-md overflow-hidden"
            >
              <InputGroupAddon
                class="!bg-gray-200 !dark:bg-gray-600 !text-gray-800 px-4 flex flex-col item-center justify-center"
                ><i class="pi pi-shield"></i
              ></InputGroupAddon>
              <InputText
                v-model="password"
                id="password"
                type="password"
                placeholder="Password"
                :feedback="false"
                fluid
                style="
                  border-top: 1px solid var(--p-inputgroup-addon-border-color);
                  border-bottom: 1px solid var(--p-inputgroup-addon-border-color);
                "
                class="!bg-gray-200 !dark:bg-gray-600 !text-gray-800 !ring-0 focus:!ring-0 !ring-offset-0 focus:!ring-offset-0 !border-x-0"
              />
              <InputGroupAddon
                class="!bg-gray-200 !dark:bg-gray-600 !text-gray-800 px-4 flex flex-col item-center justify-center"
                ><i class="pi pi-eye password-shield" @click="togglePassInput()"></i
              ></InputGroupAddon>
            </InputGroup>
            <small
              id=""
              v-if="message"
              :class="{ 'text-green-500': !isError, 'text-red-500': isError }"
              >{{ message }}</small
            >
          </div>
        </div>
        <div class="flex items-end justify-end">
          <button
            type="submit"
            class="p-button p-button-content !text-[var(--p-primary-color)] py-2 px-4 rounded focus:outline-none focus:shadow-outline"
            :disabled="loading ? true : false"
          >
            <i class="fa-solid fa-spinner fa-spin" v-if="loading"></i>
            <span v-else>Log In</span>
          </button>
          <!-- <a
            href="#"
            class="inline-block align-baseline font-bold text-sm text-blue-500 dark:text-blue-300 hover:text-blue-800 dark:hover:text-blue-400"
          >
            Forgot Password?
          </a> -->
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from "vue";
import { useRouter } from "vue-router";
// import { FwbInput } from "flowbite-vue";
import InputText from "primevue/inputtext";
import InputGroupAddon from "primevue/inputgroupaddon";
import InputGroup from "primevue/inputgroup";
import { useAuthStore } from "@/stores/authStore";
import axios from "axios";
import Logo from "@/assets/logo.png";
import Image from "primevue/image";

const email = ref("");
const password = ref("");
const message = ref("");
const isError = ref(false);
const isPassword = ref(true);
const loading = ref(false);
const router = useRouter();
const authStore = useAuthStore(); // Define authStore using useAuthStore
const login = async () => {
  loading.value = true;
  const data = JSON.stringify({
    email: email.value,
    password: password.value,
  });
  const config = {
    method: "post",
    url: import.meta.env.VITE_API_URL + "/login",
    headers: {
      "Content-Type": "application/json",
    },
    data: data,
  };

  try {
    const response = await axios(config);

    const { access_token, refresh_token, expires_in, refresh_expires_in } = response.data;

    authStore.logIn(access_token, refresh_token, expires_in, refresh_expires_in);

    message.value = "Logged in successfully!";
    isError.value = false;

    setTimeout(() => {
      loading.value = false;
      router.push("/").catch((err) => {
        console.error("Router push error:", err);
      });
    }, 2000);
  } catch (error) {
    console.error("Login Error:", error);
    isError.value = true;

    if (axios.isAxiosError(error)) {
      if (error.response) {
        console.error("Data:", error.response.data);
        console.error("Status:", error.response.status);
        console.error("Headers:", error.response.headers);
        loading.value = false;
        message.value =
          error.response.data &&
          error.response.data.error &&
          error.response.data.error === "invalid_credentials"
            ? "Invalid Credentials, please try again"
            : "An error occurred, please try again.";
      } else if (error.request) {
        console.error("No response received:", error.request);
        message.value = "No response from server, please check your network.";
      } else {
        console.error("Error Message:", error.message);
        message.value = "Error sending request: " + error.message;
      }
    } else {
      console.error("Non-Axios Error:", error);
      message.value = "An unexpected error occurred.";
    }
  }
};

const togglePassInput = () => {
  isPassword.value = !isPassword.value;
  var element = document.getElementsByClassName("password-shield");
  if (isPassword.value) {
    element[0].classList.remove("pi-eye-slash");
    element[0].classList.add("pi-eye");
    document.getElementById("password").type = "password";
  } else {
    element[0].classList.remove("pi-eye");
    element[0].classList.add("pi-eye-slash");
    document.getElementById("password").type = "text";
  }
};
</script>
