<template>
  <div class="flex items-center justify-center min-h-[90vh] mx-auto">
    <div
      class="p-8 clear-glass shadow-xl rounded-2xl max-w-sm w-full relative overflow-hidden"
    >
      <!-- Header with paw decorations -->
      <div
        class="relative bg-[var(--p-surface-600)] text-white px-8 py-6 -mx-8 -mt-8 mb-6 text-center"
      >
        <i class="fas fa-paw absolute text-2xl opacity-20 top-4 left-5"></i>
        <i class="fas fa-paw absolute text-2xl opacity-20 bottom-4 right-5"></i>
        <div class="flex flex-col items-center">
          <Image
            :src="Logo"
            alt="Clinic Logo"
            class="w-16 h-16 mb-3 rounded-full bg-white p-1"
          />
          <h1 class="text-2xl font-semibold">Paws & Care</h1>
          <p class="text-sm opacity-90 mt-1">Veterinary Clinic Management</p>
        </div>
      </div>
      <!-- Main Form -->
      <form
        v-if="!requires2FA && !showBranchSelection"
        @submit.prevent="login"
        class="space-y-5"
      >
        <!-- Email Input -->
        <div>
          <div class="flex flex-col gap-2 text-gray-600 dark:text-gray-400">
            <label for="username">{{ $t("login.username") }}</label>
            <InputGroup
              class="!bg-surface-200 !dark:bg-surface-600 dark:!text-gray-200 !text-gray-800 flex rounded-md overflow-hidden"
            >
              <InputGroupAddon
                class="!bg-surface-200 !dark:bg-surface-600 dark:!text-gray-200 !text-gray-800 px-4 flex flex-col item-center justify-center"
                ><i class="pi pi-user"></i
              ></InputGroupAddon>
              <InputText
                id="username"
                :autocomplete="`vetapp-username username`"
                v-model="email"
                aria-describedby="username-help"
                :placeholder="$t('login.username')"
                :feedback="false"
                fluid
                required
                style="
                  border-top: 1px solid var(--p-inputgroup-addon-border-color);
                  border-bottom: 1px solid var(--p-inputgroup-addon-border-color);
                  border-inline-start: 1px solid var(--p-inputgroup-addon-border-color);
                  border-inline-end: 1px solid var(--p-inputgroup-addon-border-color);
                "
                class="!bg-surface-200 !dark:bg-surface-600 dark:!text-gray-200 !text-gray-800 focus:!ring-0 focus:!ring-offset-0 focus:!outline-0"
              />
            </InputGroup>
          </div>
        </div>
        <div class="mb-6">
          <div class="flex flex-col gap-2 text-gray-600 dark:text-gray-400">
            <label for="password">{{ $t("login.password") }}</label>
            <InputGroup
              class="!bg-surface-200 !dark:bg-surface-600 dark:!text-gray-200 !text-gray-800 flex rounded-md overflow-hidden"
            >
              <InputGroupAddon
                class="!bg-surface-200 !dark:bg-surface-600 dark:!text-gray-200 !text-gray-800 px-4 flex flex-col item-center justify-center"
                ><i class="pi pi-shield"></i
              ></InputGroupAddon>
              <InputText
                v-model="password"
                :autocomplete="`vetapp-password`"
                id="password"
                type="password"
                :placeholder="$t('login.password')"
                :feedback="false"
                fluid
                required
                style="
                  border-top: 1px solid var(--p-inputgroup-addon-border-color);
                  border-bottom: 1px solid var(--p-inputgroup-addon-border-color);
                  border-inline-start: 1px solid var(--p-inputgroup-addon-border-color);
                  border-inline-end: 1px solid var(--p-inputgroup-addon-border-color);
                "
                class="!bg-surface-200 !dark:bg-surface-600 dark:!text-gray-200 !text-gray-800 !ring-0 focus:!ring-0 !ring-offset-0 focus:!ring-offset-0"
              />
              <InputGroupAddon
                class="!bg-surface-200 !dark:bg-surface-600 dark:!text-gray-200 !text-gray-800 px-4 flex flex-col item-center justify-center"
                ><i class="pi pi-eye password-shield" @click="togglePassInput()"></i
              ></InputGroupAddon>
            </InputGroup>
          </div>
          <small id="" :class="!isError ? `text-green-500 h-4` : `text-red-500 h-4`">{{
            message
          }}</small>
        </div>
        <!-- Remember Me & Forgot Password -->
        <div class="flex items-center justify-between text-sm">
          <div class="flex items-center justify-start gap-2">
            <ToggleSwitch
              v-model="rememberMe"
              inputId="rememberMe"
              :binary="true"
              class="mr-2"
            />
            <label for="rememberMe" class="text-gray-600 dark:text-gray-400">
              {{ $t("login.remember_me") }}
            </label>
          </div>
          <a
            href="#"
            class="text-blue-600 hover:text-blue-800 font-medium"
            @click.prevent="showForgotPasswordModal = true"
          >
            {{ $t("login.forgot_password") }}
          </a>
        </div>
        <div class="flex items-end justify-end">
          <button
            type="submit"
            class="p-button p-button-content w-full !bg-[var(--p-surface-600)] !text-[var(--p-surface-200)] py-2 px-4 rounded-xl focus:outline-none focus:shadow-outline h-10"
            :disabled="loading ? true : false"
          >
            <i class="fa-solid fa-spinner fa-spin" v-if="loading"></i>
            <span v-else>{{ $t("login.submit") }}</span>
          </button>
        </div>
        <!-- Divider -->
        <!--         <div class="relative my-6">
              <div class="absolute inset-0 flex items-center">
                <div class="w-full border-t border-gray-200 dark:border-gray-600"></div>
              </div>
              <div class="relative flex justify-center text-sm">
                <span class="px-2 bg-white dark:bg-stone-900 text-gray-500">
                  or continue with
                </span>
              </div>
            </div>
       -->
        <!-- Social Login Buttons -->
        <!--         <div class="flex justify-center space-x-4">
              <button
                type="button"
                class="w-12 h-12 rounded-full border border-gray-200 dark:border-gray-600 flex items-center justify-center text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 hover:text-gray-800 dark:hover:text-gray-100 transition"
              >
                <i class="fab fa-google"></i>
              </button>
              <button
                type="button"
                class="w-12 h-12 rounded-full border border-gray-200 dark:border-gray-600 flex items-center justify-center text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 hover:text-gray-800 dark:hover:text-gray-100 transition"
              >
                <i class="fab fa-apple"></i>
              </button>
              <button
                type="button"
                class="w-12 h-12 rounded-full border border-gray-200 dark:border-gray-600 flex items-center justify-center text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 hover:text-gray-800 dark:hover:text-gray-100 transition"
              >
                <i class="fab fa-facebook-f"></i>
              </button>
            </div> -->
      </form>
      <!-- 2FA Form -->
      <form
        v-if="requires2FA"
        @submit.prevent="verify2FA"
        class="space-y-5 transition-transform duration-300"
        :class="{ 'translate-x-0': requires2FA, 'translate-x-full': !requires2FA }"
      >
        <h2 class="text-xl font-bold text-gray-800 dark:text-gray-200">
          {{ $t("two_factor.title") }}
        </h2>
        <p class="text-sm text-gray-600 dark:text-gray-400">
          {{ $t("two_factor.description") }}
        </p>
        <div class="space-y-2">
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
                  'custom-otp-input': true,
                }"
                placeholder="0"
              />
            </template>
          </InputOtp>
          <small
            :class="{ 'text-green-500': !isError, 'text-red-500': isError }"
            class="block h-4"
          >
            {{ message }}
          </small>
        </div>
        <button
          type="submit"
          class="w-full bg-blue-600 hover:bg-blue-700 text-white font-semibold py-3 px-4 rounded-xl shadow-md hover:shadow-lg transform hover:-translate-y-0.5 transition duration-200 disabled:opacity-50"
          :disabled="loading"
        >
          <i class="fa-solid fa-spinner fa-spin mr-2" v-if="loading"></i>
          <span v-else>{{ $t("two_factor.verify") }}</span>
        </button>
      </form>
      <!-- Branch Selection -->
      <BranchSelection
        v-if="showBranchSelection"
        :branches="userBranches"
        @branch-selected="handleBranchSelected"
      />
      <!-- Footer -->
      <small class="block text-[8pt] text-gray-600 dark:text-gray-400 mt-6">
        Site is protected by reCAPTCHA. Google
        <a href="https://policies.google.com/privacy" class="text-blue-500"
          >Privacy Policy</a
        >
        and
        <a href="https://policies.google.com/terms" class="text-blue-500"
          >Terms of Service</a
        >
        apply.
      </small>
    </div>
  </div>
  <!-- Forgot Password Modal -->
  <Dialog
    v-model:visible="showForgotPasswordModal"
    modal
    :header="t('login.reset_password')"
    :style="{ width: '450px' }"
    :draggable="false"
  >
    <div class="space-y-4">
      <p class="text-sm text-gray-600 dark:text-gray-400">
        {{ $t("login.enter_email_to_reset") }}
      </p>

      <InputText
        v-model="forgotPasswordEmail"
        type="email"
        :placeholder="$t('login.username')"
        class="w-full"
      />

      <small
        class="block h-4"
        :class="forgotPasswordMessage.success ? 'text-green-500' : 'text-red-500'"
      >
        {{ forgotPasswordMessage.message }}
      </small>

      <div class="flex justify-end gap-2">
        <Button
          :label="$t('login.cancel')"
          severity="secondary"
          @click="showForgotPasswordModal = false"
        />
        <Button
          :label="$t('login.send_link')"
          :loading="forgotPasswordLoading"
          @click="sendPasswordResetLink"
        />
      </div>
    </div>
  </Dialog>

  <!-- Reset Password Modal (for testing - in production this would be a separate page) -->
  <Dialog
    v-model:visible="showResetPasswordModal"
    modal
    :header="t('login.reset_password')"
    :style="{ width: '450px' }"
    :draggable="false"
  >
    <div class="space-y-4">
      <p class="text-sm text-gray-600 dark:text-gray-400">
        {{ $t("login.resetting_for") }}: <strong>{{ forgotPasswordEmail }}</strong>
      </p>

      <InputText
        v-model="newPassword"
        type="password"
        :autocomplete="`vetapp-newPassword`"
        :placeholder="$t('login.new_password')"
        class="w-full"
      />

      <InputText
        v-model="confirmPassword"
        :autocomplete="`vetapp-password`"
        type="password"
        :placeholder="$t('login.confirm_password')"
        class="w-full"
      />

      <small
        class="block h-4"
        :class="
          resetPasswordMessage.includes('success') ? 'text-green-500' : 'text-red-500'
        "
      >
        {{ resetPasswordMessage }}
      </small>

      <div class="flex justify-end gap-2">
        <Button
          :label="$t('login.cancel')"
          severity="secondary"
          @click="showResetPasswordModal = false"
        />
        <Button
          :label="$t('login.reset_password')"
          :loading="resetPasswordLoading"
          @click="handlePasswordReset"
        />
      </div>
    </div>
  </Dialog>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useI18n } from "vue-i18n";
import InputText from "primevue/inputtext";
import InputGroupAddon from "primevue/inputgroupaddon";
import InputGroup from "primevue/inputgroup";
import { useAuthStore } from "@/stores/authStore";
import axios from "axios";
import Logo from "@/assets/logo-DOqaXMyT.png";
import Image from "primevue/image";
import InputOtp from "primevue/inputotp";
import ToggleSwitch from "primevue/toggleswitch";
import Dialog from "primevue/dialog";
import Button from "primevue/button";
import BranchSelection from "@/components/LoginComponentSelectBranch.vue";

const { t, locale } = useI18n();

const email = ref("");
const password = ref("");
const message = ref("");
const isError = ref(false);
const isPassword = ref(true);
const loading = ref(false);
const route = useRoute();
const router = useRouter();
const authStore = useAuthStore();
const requires2FA = ref(false);
const temporaryToken = ref("");
const twoFactorCode = ref("");
const GOOGLE_RECAPTCHA_SITE_KEY = import.meta.env.VITE_GOOGLE_RECAPTCHA_SITE_KEY;
const captchaToken = ref(null);
const rememberMe = ref(false);
/** Reset Password */
const showForgotPasswordModal = ref(false);
const forgotPasswordEmail = ref("");
const forgotPasswordMessage = ref("");
const forgotPasswordLoading = ref(false);
const resetToken = ref(""); // For testing - remove in production
const showResetPasswordModal = ref(false);
const newPassword = ref("");
const confirmPassword = ref("");
const resetPasswordLoading = ref(false);
const resetPasswordMessage = ref("");

/** select branch */
const showBranchSelection = ref(false);
const userBranches = ref([]);
/**End Reset Password */
const tfaInvalid = ref(false);
const props = defineProps({
  action: {
    type: String,
    default: "login",
  },
  code: {
    type: String,
    default: null,
  },
});
const login = async () => {
  try {
    loading.value = true;
    const response = await axios.post(import.meta.env.VITE_API_URL + "/login", {
      email: email.value,
      password: password.value,
      remember_me: rememberMe.value, // Send remember_me flag to backend
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
      requires2FA.value = true;
      temporaryToken.value = temporary_token;
      message.value = t("two_factor.required");
      isError.value = true;
    } else if (user.branches && user.branches.length > 1) {
      authStore.logIn(
        access_token,
        refresh_token,
        expires_in,
        refresh_expires_in,
        user.name,
        user.preference.user_theme,
        user.preference.user_language,
        user.preference.shortcuts,
        user.current_branch,
        rememberMe.value // Pass remember_me to authStore
      );

      // Show branch selection
      userBranches.value = user.branches;

      showBranchSelection.value = true;
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
        user.current_branch,
        rememberMe.value // Pass remember_me to authStore
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

const verify2FA = async () => {
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

    if (user.branches && user.branches.length > 1) {
      // Show branch selection
      userBranches.value = branches;
      showBranchSelection.value = true;
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

      message.value = t("two_factor.success");
      router.push("/").catch((err) => console.error("Router error:", err));
    }
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
const sendPasswordResetLink = async () => {
  if (!forgotPasswordEmail.value) {
    // forgotPasswordMessage.value = "Please enter your email address";
    forgotPasswordMessage.value = {
      success: false,
      message: "Please enter your email address",
    };
    return;
  }

  forgotPasswordLoading.value = true;
  forgotPasswordMessage.value = "";

  try {
    const response = await axios.post(import.meta.env.VITE_API_URL + "/forgot-password", {
      email: forgotPasswordEmail.value,
    });

    // forgotPasswordMessage.value = "Password reset link sent to your email";
    forgotPasswordMessage.value = {
      success: true,
      message: "Password reset link sent to your email",
    };
    setTimeout(() => {
      showForgotPasswordModal.value = false;
      forgotPasswordEmail.value = "";
    }, 2000);
  } catch (error) {
    forgotPasswordMessage.value = error.response?.data?.message || "An error occurred";
  } finally {
    forgotPasswordLoading.value = false;
  }
};

const handlePasswordReset = async () => {
  if (newPassword.value !== confirmPassword.value) {
    resetPasswordMessage.value = "Passwords do not match";
    return;
  }

  resetPasswordLoading.value = true;

  try {
    const response = await axios.post(import.meta.env.VITE_API_URL + "/reset-password", {
      code: resetToken.value,
      password: newPassword.value,
      password_confirmation: confirmPassword.value,
    });

    resetPasswordMessage.value = response.data.message;
    setTimeout(() => {
      showResetPasswordModal.value = false;
      router.push("/login");
    }, 1500);
  } catch (error) {
    resetPasswordMessage.value = error.response?.data?.message || "An error occurred";
  } finally {
    resetPasswordLoading.value = false;
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
const verifyResetCode = async (code) => {
  forgotPasswordLoading.value = true;
  try {
    const response = await axios.post(
      import.meta.env.VITE_API_URL + "/verify-reset-code",
      {
        code: code,
      }
    );

    if (response.data.valid) {
      resetToken.value = code;
      showResetPasswordModal.value = true;
      forgotPasswordEmail.value = response.data.email;
    }
  } catch (error) {
    // forgotPasswordMessage.value =
    //   error.response?.data?.message || "Invalid or expired reset link";
    isError.value = true;
    message.value = error.response?.data?.message || t("login.error");
  } finally {
    forgotPasswordLoading.value = false;
  }
};
const handleBranchSelected = (branchId) => {
  showBranchSelection.value = false;
  // Update user's current branch in auth store
  authStore.setCurrentBranch(branchId);
};

onMounted(() => {
  if (route.query.code) {
    verifyResetCode(route.query.code);
  }
});
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

.xx {
  color: white;
  font-size: 1.2rem;
  border: 1px solid rgba(255, 255, 255, 0.2);
  background-color: rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(20px) saturate(120%);
  box-shadow: 0 8px 16px 0 rgba(0, 0, 0, 0.2);
}
</style>
