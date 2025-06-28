<template>
  <div
    class="flex items-center justify-center min-h-[90vh] bg-stone-100 dark:bg-stone-800 container mx-auto lg:!text-[14px]"
  >
    <div
      class="p-8 bg-white dark:bg-stone-900 shadow-lg rounded-lg max-w-md w-full relative"
    >
      <div class="w-full flex justify-center">
        <Image
          :src="Logo"
          alt="Image"
          class="flex justify-center rounded-[4rem] w-[5rem] p-1"
        />
      </div>

      <!-- Login Form -->
      <form v-if="!requires2FA" @submit.prevent="login">
        <div>
          <label for="email">Email</label>
          <InputText
            id="email"
            v-model="email"
            placeholder="Enter your email"
            class="w-full mb-4"
          />
        </div>
        <div>
          <label for="password">Password</label>
          <InputText
            id="password"
            type="password"
            v-model="password"
            placeholder="Enter your password"
            class="w-full mb-4"
          />
        </div>
        <div>
          <button
            type="submit"
            class="p-button p-button-content py-2 px-4 rounded focus:outline-none focus:shadow-outline"
            :disabled="loading"
          >
            <i class="fa-solid fa-spinner fa-spin" v-if="loading"></i>
            <span v-else>Log In</span>
          </button>
        </div>
      </form>

      <!-- 2FA Verification Form -->
      <form
        v-if="requires2FA"
        @submit.prevent="verify2FA"
        class="transition-transform duration-300 transform"
        :class="{ 'translate-x-0': requires2FA, 'translate-x-full': !requires2FA }"
      >
        <h2 class="text-xl font-bold mb-4">Two-Factor Authentication</h2>
        <p>Please enter the 2FA code from your authenticator app.</p>
        <div>
          <label for="twoFactorCode">2FA Code</label>
          <!-- <InputText id="twoFactorCode" v-model="twoFactorCode" placeholder="Enter your 2FA code" class="w-full mb-4" /> -->
          <InputOtp
            v-model="twoFactorCode"
            id="twoFactorCode"
            :length="6"
            dir="ltr"
            :invalid="tfaInvalid"
            class="mx-auto justify-center"
            placeholder="000000"
          >
            <template #default="{ attrs, events }">
              <input
                type="text"
                v-bind="attrs"
                v-on="events"
                :class="{
                  invalid: tfaInvalid,
                }"
                class="custom-otp-input"
                placeholder="0"
              />
            </template>
          </InputOtp>
        </div>
        <div>
          <button
            type="submit"
            class="p-button p-button-content py-2 px-4 rounded focus:outline-none focus:shadow-outline"
            :disabled="loading"
          >
            <i class="fa-solid fa-spinner fa-spin" v-if="loading"></i>
            <span v-else>Verify 2FA</span>
          </button>
        </div>
      </form>

      <!-- Message Display -->
      <small
        v-if="message"
        :class="{ 'text-red-500': isError, 'text-green-500': !isError }"
      >
        {{ message }}
      </small>
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
import InputOtp from "primevue/inputotp";
import { useAuthStore } from "@/stores/authStore";
import axios from "axios";
import Logo from "@/assets/logo.png";
import Image from "primevue/image";

const email = ref("");
const password = ref("");
const twoFactorCode = ref("");
const message = ref("");
const isError = ref(false);
const loading = ref(false);
const requires2FA = ref(false); // Controls 2FA form visibility
const temporaryToken = ref(""); // Stores the temporary token for 2FA verification
const router = useRouter();
const authStore = useAuthStore();

const login = async () => {
  loading.value = true;

  try {
    const response = await axios.post(import.meta.env.VITE_API_URL + "/login", {
      email: email.value,
      password: password.value,
    });
    
    // Extract values from the response
    const {
      requires_2fa,
      temporary_token,
      access_token,
      refresh_token,
      expires_in,
      refresh_expires_in,
    } = response.data;

    if (requires_2fa) {
      // Show the 2FA form if required
      requires2FA.value = true; // Ensure this is true to trigger the form
      temporaryToken.value = temporary_token; // Store temporary token for 2FA verification
      message.value = "Please enter your 2FA code.";
    } else {
      // Complete login if 2FA is not required
      authStore.logIn(access_token, refresh_token, expires_in, refresh_expires_in);
      message.value = "Logged in successfully!";
      router.push("/").catch((err) => console.error("Router error:", err));
    }

    isError.value = false;
  } catch (error) {
    isError.value = true;
    loading.value = false;

    if (axios.isAxiosError(error) && error.response) {
      message.value = error.response.data.error || "An error occurred.";
    } else {
      message.value = "An unexpected error occurred.";
    }
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
      {
        headers: {
          Authorization: `Bearer ${temporaryToken.value}`, // Use the temporary token
        },
      }
    );

    // Extract tokens and user data
    const { access_token, refresh_token, expires_in, refresh_expires_in } = response.data;

    // Complete login process
    authStore.logIn(access_token, refresh_token, expires_in, refresh_expires_in);
    message.value = "2FA verified successfully!";
    router.push("/").catch((err) => console.error("Router error:", err));
    isError.value = false;
  } catch (error) {
    isError.value = true;

    if (axios.isAxiosError(error) && error.response) {
      message.value = error.response.data.error || "Invalid 2FA code.";
    } else {
      message.value = "An unexpected error occurred.";
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
<style scoped>
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
