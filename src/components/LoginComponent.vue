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

      <form v-if="!requires2FA" @submit.prevent="login">
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
          </div>
          <small
            id=""
            :class="{ 'text-green-500': !isError, 'text-red-500': isError } + ` h-4`"
            >{{ message }}</small
          >
        </div>
        <div class="flex items-end justify-end">
          <button
            type="submit"
            class="p-button p-button-content !text-[var(--p-primary-color)] py-2 px-4 rounded focus:outline-none focus:shadow-outline h-8"
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
      <form
        v-if="requires2FA"
        @submit.prevent="verify2FA"
        class="transition-transform duration-300 transform"
        :class="{ 'translate-x-0': requires2FA, 'translate-x-full': !requires2FA }"
      >
        <h2 class="text-md font-bold mb-4">Two-Factor Authentication</h2>
        <p class="text-sm mb-4">Please enter the 2FA code from your authenticator app.</p>
        <!-- <div>
          <InputText
            id="twoFactorCode"
            v-model="twoFactorCode"
            placeholder="Enter your 2FA code"
            fluid
            style="
              border-top: 1px solid var(--p-inputgroup-addon-border-color);
              border-bottom: 1px solid var(--p-inputgroup-addon-border-color);
            "
            class="!bg-gray-200 !dark:bg-gray-600 !text-gray-800 focus:!ring-0 focus:!ring-offset-0 !border-x-0 focus:!outline-0"
          />
        </div> -->
        <div class="mb-6">
          <div class="flex flex-col gap-2 text-gray-600 dark:text-gray-400">
            <InputGroup
              class="!bg-gray-200 !dark:bg-gray-600 !text-gray-800 flex rounded-md overflow-hidden"
            >
              <InputGroupAddon
                class="!bg-gray-200 !dark:bg-gray-600 !text-gray-800 px-4 flex flex-col item-center justify-center"
                ><i class="pi pi-shield"></i
              ></InputGroupAddon>
              <InputText
                id="twoFactorCode"
                v-model="twoFactorCode"
                placeholder="Enter your 2FA code"
                :feedback="false"
                fluid
                autofocus
                style="
                  border-top: 1px solid var(--p-inputgroup-addon-border-color);
                  border-bottom: 1px solid var(--p-inputgroup-addon-border-color);
                "
                class="!bg-gray-200 !dark:bg-gray-600 !text-gray-800 !ring-0 focus:!ring-0 !ring-offset-0 focus:!ring-offset-0 !border-x-0"
              />
            </InputGroup>
            <small
              id=""
              :class="{ 'text-green-500': !isError, 'text-red-500': isError } + ` h-4`"
              >{{ message }}</small
            >
          </div>
          <!-- <RecaptchaV2
            ref="recaptcha"
            :sitekey="GOOGLE_RECAPTCHA_SITE_KEY"
            @verify="onVerify"
            @expired="onExpired"
          /> -->
          <div class="mt-4">
            <RecaptchaV2
              ref="recaptcha"
              :sitekey="GOOGLE_RECAPTCHA_SITE_KEY"
              @verify="onVerify"
              @expired="onExpired"
            />
          </div>
        </div>

        <div class="flex items-end justify-end">
          <button
            type="submit"
            class="p-button p-button-content !text-[var(--p-primary-color)] py-2 px-4 rounded focus:outline-none focus:shadow-outline h-8"
            :disabled="!captchaToken"
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
import { RecaptchaV2 } from "vue3-recaptcha-v2";

const email = ref("");
const password = ref("");
const message = ref("");
const isError = ref(false);
const isPassword = ref(true);
const loading = ref(false);
const router = useRouter();
const authStore = useAuthStore(); // Define authStore using useAuthStore
const requires2FA = ref(false); // Controls 2FA form visibility
const temporaryToken = ref(""); // Stores the temporary token for 2FA verification
const twoFactorCode = ref("");
const GOOGLE_RECAPTCHA_SITE_KEY = import.meta.env.VITE_GOOGLE_RECAPTCHA_SITE_KEY;

const captchaToken = ref(null);
console.log("Site Key:", GOOGLE_RECAPTCHA_SITE_KEY);
console.log("Captcha Token:", captchaToken.value);
// Methods
const onVerify = (token) => {
  captchaToken.value = token;
};

const onExpired = () => {
  captchaToken.value = null;
};

const login = async () => {
  if (!captchaToken.value) {
    alert("Please complete the CAPTCHA.");
    return;
  }
  loading.value = true;
  try {
    const response = await axios.post(import.meta.env.VITE_API_URL + "/login", {
      email: email.value,
      password: password.value,
    });
    console.log(response.data);
    const {
      access_token,
      refresh_token,
      expires_in,
      refresh_expires_in,
      requires_2fa,
      temporary_token,
    } = response.data;

    if (requires_2fa) {
      requires2FA.value = true;
      temporaryToken.value = temporary_token;
      message.value = "Two-Factor Authentication is required.";
    } else {
      authStore.logIn(access_token, refresh_token, expires_in, refresh_expires_in);
      router.push("/").catch((err) => console.error("Router error:", err));
    }

    isError.value = false;
  } catch (error) {
    isError.value = true;
    message.value = error.response?.data?.message || "Login failed. Please try again.";
  } finally {
    loading.value = false;
  }
};

const verify2FA = async () => {
  loading.value = true;

  try {
    const response = await axios.post(
      import.meta.env.VITE_API_URL + "/2fa/verify",
      { two_factor_code: twoFactorCode.value },
      { headers: { Authorization: `Bearer ${temporaryToken.value}` } }
    );
    console.log(response.data);
    const {
      access_token,
      refresh_token,
      expires_in,
      refresh_expires_in,
      user,
    } = response.data;

    authStore.logIn(
      access_token,
      refresh_token,
      expires_in,
      refresh_expires_in,
      user.name
    );
    message.value = "Two-Factor Authentication verified!";
    router.push("/").catch((err) => console.error("Router error:", err));
    isError.value = false;
  } catch (error) {
    // isError.value = true;
    // message.value = error.response?.data?.message || "Invalid 2FA code.";
    if (error.response) {
      if (error.response.status === 429) {
        console.error("Too many attempts. Please try again later.");
        message.value =
          error.response?.data?.message || "Too many attempts. Please try again later.";
        this.showToast("Too many attempts. Please try again in a minute.");
      } else {
        console.error("Verification failed: ", error.response.data);
        message.value =
          error.response?.data?.message || "Invalid 2FA code. Please try again.";
        this.showToast("Invalid 2FA code. Please try again.");
      }
    } else {
      console.error("Error sending request: ", error.message);
      this.showToast("An unexpected error occurred. Please try again.");
    }
  } finally {
    loading.value = false;
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
<style>
form {
  transition: transform 0.3s ease-in-out;
}

form.translate-x-full {
  transform: translateX(100%);
}

form.translate-x-0 {
  transform: translateX(0);
}
</style>
