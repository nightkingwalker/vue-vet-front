<template>
  <div
    class="flex items-center justify-center min-h-[90vh] bg-stone-100 dark:bg-stone-800 mx-auto lg:!text-[14px]"
  >
    <div class="p-8 bg-white dark:bg-stone-900 shadow-lg rounded-lg max-w-md w-full">
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
            <label for="username">{{ $t("login.username") }}</label>
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
                :placeholder="$t('login.username')"
                :feedback="false"
                fluid
                required
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
            <label for="password">{{ $t("login.password") }}</label>
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
                :placeholder="$t('login.password')"
                :feedback="false"
                fluid
                required
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
          <small id="" :class="!isError ? `text-green-500 h-4` : `text-red-500 h-4`">{{
            message
          }}</small>
        </div>
        <div class="flex items-end justify-end">
          <button
            type="submit"
            class="p-button p-button-content !text-[var(--p-primary-color)] py-2 px-4 rounded focus:outline-none focus:shadow-outline h-8"
            :disabled="loading ? true : false"
          >
            <i class="fa-solid fa-spinner fa-spin" v-if="loading"></i>
            <span v-else>{{ $t("login.submit") }}</span>
          </button>
        </div>
      </form>

      <form
        v-if="requires2FA"
        @submit.prevent="verify2FA"
        class="transition-transform duration-300 transform"
        :class="{ 'translate-x-0': requires2FA, 'translate-x-full': !requires2FA }"
      >
        <h2 class="text-md font-bold mb-4">{{ $t("two_factor.title") }}</h2>
        <p class="text-sm mb-4">{{ $t("two_factor.description") }}</p>
        <div class="mb-6">
          <div class="flex flex-col gap-2 text-gray-600 dark:text-gray-400">
            <InputOtp
              v-model="twoFactorCode"
              id="twoFactorCode"
              :length="6"
              dir="ltr"
              autofocus
              :invalid="tfaInvalid"
              class="mx-auto justify-center"
              placeholder="000000"
            >
              <template #default="{ attrs, events }">
                <input
                  type="text"
                  v-bind="attrs"
                  v-on="events"
                  autofocus
                  :class="{
                    invalid: tfaInvalid,
                  }"
                  class="custom-otp-input"
                  placeholder="0"
                />
              </template>
            </InputOtp>
            <small
              id=""
              :class="{ 'text-green-500': !isError, 'text-red-500': isError } + ` h-4`"
              >{{ message }}</small
            >
          </div>
        </div>

        <div class="flex items-end justify-end">
          <button
            type="submit"
            class="p-button p-button-content py-2 px-4 rounded focus:outline-none focus:shadow-outline h-8"
          >
            <!-- :disabled="!captchaToken" -->
            <i class="fa-solid fa-spinner fa-spin" v-if="loading"></i>
            <span v-else>{{ $t("two_factor.verify") }}</span>
          </button>
        </div>
      </form>
    </div>
  </div>
  <small id="" class="text-[8pt] text-gray-600"
    >Site is protected by reCAPTCHA. Google
    <a href="https://policies.google.com/privacy" class="text-blue-500">Privacy Policy</a>
    and
    <a href="https://policies.google.com/terms" class="text-blue-500">Terms of Service</a>
    apply.</small
  >
</template>

<script setup>
import { ref, computed } from "vue";
import { useRouter } from "vue-router";
import { useI18n } from "vue-i18n";
import InputText from "primevue/inputtext";
import InputGroupAddon from "primevue/inputgroupaddon";
import InputGroup from "primevue/inputgroup";
import { useAuthStore } from "@/stores/authStore";
import axios from "axios";
import Logo from "@/assets/logo-DOqaXMyT.png";
import Image from "primevue/image";
import InputOtp from "primevue/inputotp";

const { t } = useI18n();
const email = ref("");
const password = ref("");
const message = ref("");
const isError = ref(false);
const isPassword = ref(true);
const loading = ref(false);
const router = useRouter();
const authStore = useAuthStore();
const requires2FA = ref(false);
const temporaryToken = ref("");
const twoFactorCode = ref("");
const GOOGLE_RECAPTCHA_SITE_KEY = import.meta.env.VITE_GOOGLE_RECAPTCHA_SITE_KEY;
const captchaToken = ref(null);
const tfaInvalid = ref(false);
const login = async () => {
  try {
    loading.value = true;
    const response = await axios.post(import.meta.env.VITE_API_URL + "/login", {
      email: email.value,
      password: password.value,
    });
    const {
      access_token,
      refresh_token,
      expires_in,
      refresh_expires_in,
      requires_2fa,
      temporary_token,
      user,
    } = response.data;

    if (requires_2fa) {
      // console.log(response.data)
      requires2FA.value = true;
      temporaryToken.value = temporary_token;
      message.value = t("two_factor.required");
      isError.value = true;
    } else {
      authStore.logIn(
        access_token,
        refresh_token,
        expires_in,
        refresh_expires_in,
        user.name,
        user.preference.user_theme,
        user.preference.user_language,
        user.preference.shortcuts,
        user.current_branch
      );
      router.push("/").catch((err) => console.error("Router error:", err));
    }

    isError.value = false;
  } catch (error) {
    isError.value = true;
    message.value = error.response?.data?.message || t("login.error");
  } finally {
    loading.value = false;
  }
};

/* const verify2FA = async () => {
  console.log("TRYING OTP");
  if (!tfa_code.value) {
    console.log("NO OTP")
    tfaInvalid.value = true;
    return
  }
  loading.value = true;
  console.log("TRYING OTP");
  try {
    const response = await axios.post(
      import.meta.env.VITE_API_URL + "/2fa/verify",
      { two_factor_code: twoFactorCode.value },
      { headers: { Authorization: `Bearer ${temporaryToken.value}` } }
    );
    console.log(response);
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
      user.name,
      user.current_branch
    );
    isError.value = false;
    message.value = t("two_factor.success");
    router.push("/").catch((err) => console.error("Router error:", err));
    isError.value = false;
  } catch (error) {
    if (error.response) {
      if (error.response.status === 429) {
        message.value = error.response?.data?.message || t("two_factor.throttled");
        isError.value = true;
      } else {
        isError.value = true;
        message.value = error.response?.data?.message || t("two_factor.invalid");
      }
    } else {
      message.value = t("login.error");
    }
  } finally {
    loading.value = false;
  }
};
 */
const verify2FA = async () => {
  // console.log("RUNNING 2FA")
  if (!twoFactorCode.value || twoFactorCode.value.length !== 6) {
    tfaInvalid.value = true;
    message.value = t("two_factor.invalid_length");
    return;
  }

  loading.value = true;
  tfaInvalid.value = false;

  try {
    const response = await axios.post(
      import.meta.env.VITE_API_URL + "/2fa/verify",
      {
        two_factor_code: twoFactorCode.value,
        // recaptcha_token: captchaToken.value // Include if your backend expects it
      },
      {
        headers: {
          Authorization: `Bearer ${temporaryToken.value}`,
        },
      }
    );

    const {
      access_token,
      refresh_token,
      expires_in,
      refresh_expires_in,
      user,
    } = response.data;
    console.log(user);
    authStore.logIn(
      access_token,
      refresh_token,
      expires_in,
      refresh_expires_in,
      user.name,
      user.preference.user_theme,
      user.preference.user_language,
      user.preference.shortcuts,
      user.current_branch
    );

    message.value = t("two_factor.success");
    router.push("/").catch((err) => console.error("Router error:", err));
  } catch (error) {
    tfaInvalid.value = true;

    if (error.response) {
      if (error.response.status === 429) {
        message.value = error.response?.data?.message || t("two_factor.throttled");
      } else {
        message.value = error.response?.data?.message || t("two_factor.invalid");
      }
    } else {
      message.value = t("login.error");
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

.grecaptcha-badge {
  visibility: hidden;
}

.custom-otp-input {
  width: 40px;
  font-size: 36px;
  border: 0 none;
  appearance: none;
  text-align: center;
  transition: all 0.2s;
  background: transparent;
  border-bottom: 2px solid var(--p-inputtext-border-color);
}

.custom-otp-input.invalid,
label.fa_code {
  border-bottom-color: red;
  box-shadow: 2px 3px 5px rgba(255, 0, 0, 0.3);
  color: red;
}

.custom-otp-input:focus {
  outline: 0 none;
  border-bottom-color: var(--p-primary-color);
}
</style>
