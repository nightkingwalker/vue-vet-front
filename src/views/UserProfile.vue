<template>
  <div class="w-full bg-[var(--p-content-background)] p-8 rounded-lg mt-4">
    <!-- User Profile Container -->
    <div
      class="grid grid-cols-2 gap-y-[10px] gap-x-[10px] lg:w-[70%] md:w-[80%] sm:w-full xl:w-[85%] 2xl:w-[75%] mx-auto"
    >
      <fieldset
        class="h-fit border dark:border-gray-100 border-gray-400 rounded-xl p-6 bg-zinc-100 dark:bg-[var(--p-surface-500)] shadow-sm"
      >
        <legend
          class="px-4 py-1 border dark:border-gray-100 border-gray-400 rounded-xl dark:text-gray-900 dark:bg-gray-400 bg-gray-600 text-white text-sm font-medium"
        >
          <i class="fa-solid fa-address-card mr-2"></i>
          {{ $t("user_profile.profile_information") }}
        </legend>
        <div class="flex items-start gap-6">
          <div class="relative group">
            <div
              class="w-20 h-20 rounded-full overflow-hidden border-2 border-gray-300 dark:border-gray-600"
            >
              <img
                class="w-full h-full object-cover"
                :src="user.avatarUrl"
                alt="Profile Avatar"
              />
            </div>
            <button
              class="absolute -bottom-1 -right-1 inline-flex items-center justify-center w-7 h-7 text-xs font-bold text-white bg-gray-600 border-2 border-white rounded-full shadow-sm hover:bg-gray-200 hover:text-gray-800 hover:border-gray-500 transition-all duration-200"
              @click="showAvatarUploader = !showAvatarUploader"
            >
              <i class="fa-solid fa-pencil text-xs"></i>
            </button>
          </div>
          <div class="flex-1">
            <h2 class="text-xl font-semibold text-gray-900 dark:text-gray-100">
              {{ $t("user_profile.personal_details") }}
            </h2>
            <p class="mt-1 text-sm text-gray-600 dark:text-gray-400">
              {{ $t("user_profile.update_profile_info") }}
            </p>
            <form @submit.prevent="submitForm" class="mt-4 space-y-4">
              <div>
                <label
                  class="block font-medium text-sm text-gray-700 dark:text-gray-300 mb-1"
                  for="name"
                >
                  {{ $t("user_profile.full_name") }}
                </label>
                <InputText
                  class="w-full"
                  size="small"
                  v-model="user.name"
                  id="name"
                  type="text"
                  required
                />
              </div>
              <div>
                <label
                  class="block font-medium text-sm text-gray-700 dark:text-gray-300 mb-1"
                  for="email"
                >
                  {{ $t("user_profile.email_address") }}
                </label>
                <InputText
                  class="w-full"
                  size="small"
                  v-model="user.email"
                  id="email"
                  type="email"
                  readonly
                  disabled
                />
              </div>
              <div class="flex justify-end">
                <button
                  type="submit"
                  class="bg-gray-800 px-5 py-2.5 text-white rounded-lg hover:bg-gray-700 shadow-md text-sm font-medium transition-colors duration-200"
                >
                  {{ $t("user_profile.save_changes") }}
                </button>
              </div>
            </form>
          </div>
        </div>
      </fieldset>
      <!-- Update Password Section -->
      <fieldset
        class="h-fit border dark:border-gray-100 border-gray-400 rounded-xl p-6 bg-zinc-100 dark:bg-[var(--p-surface-500)] shadow-sm"
      >
        <legend
          class="px-4 py-1 border dark:border-gray-100 border-gray-400 rounded-xl dark:text-gray-900 dark:bg-gray-400 bg-gray-600 text-white text-sm font-medium"
        >
          <i class="fa-solid fa-lock mr-2"></i> {{ $t("user_profile.update_password") }}
        </legend>
        <form @submit.prevent="updatePassword" class="space-y-4">
          <div>
            <label
              class="block font-medium text-sm text-gray-700 dark:text-gray-300 mb-1"
              for="current_password"
            >
              {{ $t("user_profile.current_password") }}
            </label>
            <InputText
              class="w-full"
              size="small"
              id="current_password"
              name="current_password"
              v-model="current_password"
              type="password"
              autocomplete="current-password"
            />
          </div>
          <div>
            <label
              class="block font-medium text-sm text-gray-700 dark:text-gray-300 mb-1"
              for="password_"
            >
              {{ $t("user_profile.new_password") }}
            </label>
            <InputText
              class="w-full"
              size="small"
              type="password"
              v-model="newpassword"
              autocomplete="new-password"
            />
          </div>
          <div>
            <label
              class="block font-medium text-sm text-gray-700 dark:text-gray-300 mb-1"
              for="password_confirmation"
            >
              {{ $t("user_profile.confirm_password") }}
            </label>
            <InputText
              class="w-full"
              size="small"
              id="password_confirmation"
              name="password_confirmation"
              v-model="password_confirmation"
              type="password"
              :invalid="passwordMatchError"
              autocomplete="new-password"
            />
            <Message v-if="passwordMatchError" severity="error" class="mt-1 text-xs">
              {{ $t("user_profile.passwords_not_match") }}
            </Message>
          </div>
          <div class="flex justify-end">
            <button
              type="submit"
              class="bg-gray-800 px-5 py-2.5 text-white rounded-lg hover:bg-gray-700 shadow-md text-sm font-medium transition-colors duration-200"
            >
              {{ $t("user_profile.update_password") }}
            </button>
          </div>
        </form>
      </fieldset>
      <!-- User Preferences Section -->
      <fieldset
        class="h-fit border dark:border-gray-100 border-gray-400 rounded-xl p-6 bg-zinc-100 dark:bg-[var(--p-surface-500)] shadow-sm"
      >
        <legend
          class="px-4 py-1 border dark:border-gray-100 border-gray-400 rounded-xl dark:text-gray-900 dark:bg-gray-400 bg-gray-600 text-white text-sm font-medium"
        >
          <i class="fa-solid fa-user-cog mr-2"></i> {{ $t("user_profile.preferences") }}
        </legend>
        <div class="flex justify-between items-start gap-4">
          <!-- Language Selection -->
          <div class="w-1/2">
            <h3 class="text-sm font-medium text-gray-700 dark:text-gray-300 mb-3">
              {{ $t("user_profile.language") }}
            </h3>
            <div class="flex gap-4 mt-4">
              <!-- Language Form -->
              <form @submit.prevent="handleSubmit('language')" class="mx-auto w-full">
                <FloatLabel class="w-full">
                  <Select
                    fluid
                    v-model="language"
                    :options="languages"
                    optionLabel="label"
                    optionValue="value"
                    class="w-full h-10"
                  />
                  <label for="dd-city"
                    >{{ $t("user_profile.language") }}
                    <span class="text-red-600">*</span></label
                  >
                </FloatLabel>
                <button
                  type="submit"
                  class="bg-gray-800 px-5 py-2.5 text-white rounded-lg hover:bg-gray-700 shadow-md text-sm font-medium transition-colors duration-200 mt-2"
                >
                  {{ $t("user_profile.update_language") }}
                </button>
              </form>
            </div>
          </div>
          <!-- Theme Selection -->
          <div class="w-1/2">
            <h3 class="text-sm font-medium text-gray-700 dark:text-gray-300 mb-3">
              {{ $t("user_profile.theme") }}
            </h3>
            <div class="flex gap-4 mt-4">
              <form @submit.prevent="handleSubmit('theme')" class="mx-auto w-full">
                <FloatLabel class="w-full">
                  <Select
                    fluid
                    v-model="theme"
                    :options="themes"
                    optionLabel="label"
                    optionValue="value"
                    class="w-full h-10"
                  />
                  <label for="dd-city"
                    >{{ $t("user_profile.theme") }}
                    <span class="text-red-600">*</span></label
                  >
                </FloatLabel>
                <button
                  type="submit"
                  class="bg-gray-800 px-5 py-2.5 text-white rounded-lg hover:bg-gray-700 shadow-md text-sm font-medium transition-colors duration-200 mt-2"
                >
                  {{ $t("user_profile.update_theme") }}
                </button>
              </form>
            </div>
          </div>
        </div>
      </fieldset>
      <!-- Two Factor Authentication Section -->
      <fieldset
        class="h-fit border dark:border-gray-100 border-gray-400 rounded-xl p-6 bg-zinc-100 dark:bg-[var(--p-surface-500)] shadow-sm"
      >
        <legend
          class="px-4 py-1 border dark:border-gray-100 border-gray-400 rounded-xl dark:text-gray-900 dark:bg-gray-400 bg-gray-600 text-white text-sm font-medium"
        >
          <i class="fa-solid fa-user-shield mr-2"></i>
          {{ $t("user_profile.two_factor_auth") }}
        </legend>
        <div class="space-y-4">
          <div class="flex items-center justify-between">
            <div>
              <h3 class="text-sm font-medium text-gray-700 dark:text-gray-300">
                {{ $t("user_profile.two_factor_auth") }}
              </h3>
              <p class="text-xs text-gray-500 dark:text-gray-400 mt-1">
                {{ $t("user_profile.two_factor_desc") }}
              </p>
            </div>
            <ToggleSwitch v-model="checked" />
          </div>
          <transition name="fade">
            <div
              v-if="checked"
              class="bg-gray-50 dark:bg-gray-700 p-4 rounded-lg border border-gray-200 dark:border-gray-600"
            >
              <p class="text-xs text-green-500 mb-2">
                <i class="fa-solid fa-circle-info mr-1"></i>
                {{ $t("user_profile.scan_qr_code") }}
              </p>
              <div class="flex flex-col items-center">
                <img
                  v-if="checked"
                  class="w-48 h-48 mb-3"
                  :src="qrCodeUrl"
                  alt="2FA QR Code"
                />
                <p class="text-xs text-gray-500 dark:text-gray-400 text-center mb-3">
                  {{ $t("user_profile.secret_key") }}:
                  <code class="bg-gray-200 dark:bg-gray-600 px-1 rounded">{{
                    user.two_factor_secret
                  }}</code>
                </p>
              </div>
              <form @submit.prevent="tfaEnabled" class="space-y-3">
                <div>
                  <label
                    :class="{
                      fa_code: tfaInvalid,
                    }"
                    class="block text-xs text-gray-700 dark:text-gray-300 mb-1"
                    for="2fa_code"
                  >
                    {{ $t("user_profile.enter_verification_code") }}
                  </label>
                  <InputOtp
                    v-model="tfa_code"
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
                <button
                  type="submit"
                  class="w-full bg-gray-800 px-4 py-2 text-white rounded-lg hover:bg-gray-700 shadow-md text-xs font-medium transition-colors duration-200"
                >
                  {{ $t("user_profile.verify_activate") }}
                </button>
              </form>
            </div>
          </transition>
        </div>
      </fieldset>
    </div>
  </div>
</template>
<script setup>
import { onMounted, ref, computed, watchEffect } from "vue";
import QRCode from "qrcode"; // Import the QRCode library
import PlaceHolder from "@/assets/placeholder-1.png";
import Logo from "@/assets/logo-DOqaXMyT.png";
import axiosInstance from "@/axios"; // Assuming axiosInstance is set up correctly
import ToggleSwitch from "primevue/toggleswitch";
import eventBus from "@/eventBus";
import InputText from "primevue/inputtext";
import Message from "primevue/message";
import InputOtp from "primevue/inputotp";
import Select from "primevue/select";
import FloatLabel from "primevue/floatlabel";
import { useI18n } from "vue-i18n";
import { useTheme } from "@/composables/useTheme";
import { useAuthStore } from "@/stores/authStore";
import { useLanguage } from "@/composables/useLanguage";
import Cookies from "js-cookie";

const isRtl = computed(() => {
  // 1. First try to get language from cookie
  const cookieLanguage = Cookies.get("language");

  // 2. If cookie exists, use it for RTL check
  if (cookieLanguage) {
    return ["ar", "he", "fa"].includes(cookieLanguage);
  }

  // 3. Fall back to current locale if no cookie
  return ["ar", "he", "fa"].includes(locale.value);
});
const authStore = useAuthStore();
const { applyLanguage } = useLanguage();
const { t } = useI18n();
const qr_details = ref([]);
const loading = ref(true);
const user = ref({
  id: 1,
  name: "",
  email: "",
  two_factor_secret: "",
  avatarUrl: PlaceHolder,
});
const confirmation_true = ref(false);
const checked = ref(false);
const qrCodeUrl = ref(""); // Holds the QR code image URL
const appName = ref("");
const username = ref("");
const secret = ref(""); // Replace this with your generated secret
const tfa_code = ref("");
const newpassword = ref("");
const password_confirmation = ref("");
const current_password = ref("");
const message = ref("");
const language = ref("");
const theme = ref("");
// Computed value for the QR code
const qrCodeValue = computed(() => {
  return `otpauth://totp/${appName.value}:${username.value}?secret=${secret.value}&issuer=${appName.value}`;
});
const languages = ref([
  { label: t("languages.ar"), value: "ar" },
  { label: t("languages.en"), value: "en" },
]);
const themes = ref([
  { label: t("themes.dark"), value: "dark" },
  { label: t("themes.light"), value: "light" },
  { label: t("themes.system"), value: "system" },
]);
// Generate the QR code URL
/* const generateQRCode = async () => {
  try {
    qrCodeUrl.value = await QRCode.toDataURL(qrCodeValue.value);
  } catch (error) {
    console.error("Error generating QR code:", error);
  }
}; */
const generateQRCodeWithLogo = async (text, logoUrl) => {
  try {
    // Generate the base QR code
    const baseQrCodeUrl = await QRCode.toDataURL(text, {
      width: 350,
      margin: 2,
      errorCorrectionLevel: "H", // Important when adding logo
    });

    // Create canvas for QR code
    const canvas = document.createElement("canvas");
    const ctx = canvas.getContext("2d");
    const qrImage = new Image();

    // Load QR code image
    await new Promise((resolve) => {
      qrImage.onload = resolve;
      qrImage.src = baseQrCodeUrl;
    });

    // Set canvas size and draw QR code
    canvas.width = qrImage.width;
    canvas.height = qrImage.height;
    ctx.drawImage(qrImage, 0, 0);

    // Load logo
    const logoImage = new Image();
    await new Promise((resolve) => {
      logoImage.onload = resolve;
      logoImage.src = logoUrl;
    });

    // Calculate logo size and position (centered)
    const logoSize = canvas.width / 4;
    const logoX = (canvas.width - logoSize) / 2;
    const logoY = (canvas.height - logoSize) / 2;

    // Optional: Add white background behind logo
    ctx.fillStyle = "#ffffff";
    ctx.fillRect(logoX - 2, logoY - 2, logoSize + 4, logoSize + 4);

    // Draw logo on QR code
    ctx.drawImage(logoImage, logoX, logoY, logoSize, logoSize);

    // Update the reactive reference
    qrCodeUrl.value = canvas.toDataURL();
  } catch (error) {
    console.error("Error generating QR code with logo:", error);
  }
};
const tfaInvalid = ref(false);
const tfaEnabled = async () => {
  // console.log("CHECKED " + checked.value);
  if (!tfa_code.value) {
    // console.log("NO OTP");
    tfaInvalid.value = true;
    return;
  }

  loading.value = true;
  const submissionData = {
    two_factor_code: tfa_code.value,
  };

  try {
    const response = await axiosInstance.post(
      !checked.value ? `/2fa/disable` : `/2fa/enable`,
      submissionData
    );
    // console.log(response);
    // emit("submitted", response.data);
    eventBus.emit("show-toast", {
      severity: "success",
      summary: "Data Loaded",
      detail:
        "" + !checked.value
          ? "Two Factor Authentication Disabled Successfully"
          : "Two Factor Authentication Enabled Successfully",
      life: 5000,
    });
  } catch (error) {
    eventBus.emit("show-toast", {
      severity: "warn",
      summary: "Error",
      detail: error,
      life: 5000,
    });
  } finally {
  }
};
const updatePassword = async () => {
  // console.log("CHECKED " + checked.value);
  loading.value = true;
  const submissionData = {
    current_password: current_password.value,
    new_password: newpassword.value,
    new_password_confirmation: password_confirmation.value,
  };

  try {
    const response = await axiosInstance.put(`/user/password`, submissionData);
    // console.log(response);
    // emit("submitted", response.data);
    eventBus.emit("show-toast", {
      severity: "success",
      summary: "Data Loaded",
      detail: "Password Updated Successfully",
      life: 5000,
    });
  } catch (error) {
    if (error.response) {
      // console.error("Response:", error.response);
      // console.error("Data:", error.response.data);
      // console.error("Status:", error.response.status);
      // console.error("Headers:", error.response.headers);
      loading.value = false;
      message.value = error.response.data.message;
    } else if (error.request) {
      console.error("No response received:", error.request);
      message.value = "No response from server, please check your network.";
    } else {
      console.error("Error Message:", error.message);
      message.value = "Error sending request: " + error.message;
    }
  } finally {
  }
};
const handleSubmitLanguag = async () => {
  loading.value = true;
  const submissionData = {
    language: language.value,
  };

  try {
    const response = await axiosInstance.put("/user/preferences", submissionData);
    fetchUserDetails();
    eventBus.emit("show-toast", {
      severity: "success",
      summary: "Success",
      detail: "Language preference updated successfully",
      life: 5000,
    });
  } catch (error) {
    if (error.response) {
      console.error("Error:", error.response.data);
      message.value =
        error.response.data.message || "Failed to update language preference";

      eventBus.emit("show-toast", {
        severity: "error",
        summary: "Error",
        detail: message.value,
        life: 5000,
      });
    } else if (error.request) {
      console.error("No response received:", error.request);
      message.value = "No response from server, please check your network.";
    } else {
      console.error("Error Message:", error.message);
      message.value = "Error sending request: " + error.message;
    }
  } finally {
    loading.value = false;
  }
};
const { isDarkMode, applyTheme } = useTheme();
const handleSubmit = async (type) => {
  loading.value = true;
  // Import the composable functions

  const submissionData = {};
  let successMessage = "";

  if (type === "language") {
    submissionData.user_language = language.value;
    successMessage = "Language preference updated successfully";
    applyLanguage(language.value);
  } else if (type === "theme") {
    submissionData.user_theme = theme.value;
    successMessage = "Theme preference updated successfully";
    authStore.updateTheme(theme.value); // Update store first
    applyTheme(theme.value); // Then apply the theme
  }

  try {
    const response = await axiosInstance.put("/user/preferences", submissionData);
    // console.log(response.data);
    // Update the auth store with new preferences
    // Cookies.set("language", response.data.user_language, {
    //   sameSite: "Strict",
    //   expires: new Date(this.tokenExpiry * 1000 + 172800),
    // });
    document.documentElement.setAttribute(
      "dir",
      response.data.user_language === "ar" ? "rtl" : "ltr"
    );
    authStore.setUserPreferences(response.data); // Make sure your authStore has this method

    eventBus.emit("show-toast", {
      severity: "success",
      summary: "Success",
      detail: successMessage,
      life: 5000,
    });
  } catch (error) {
    let errorMessage = "";

    if (error.response) {
      console.error("Error:", error.response.data);
      errorMessage = error.response.data.message || `Failed to update ${type} preference`;

      // Revert theme if update failed
      if (type === "theme") {
        // applyTheme(authStore.currentTheme); // Revert to previous theme
        const previousTheme = authStore.currentTheme;
        authStore.updateTheme(previousTheme);
        applyTheme(previousTheme);
      }
      if (type === "language") {
        const previousLanguage = authStore.currentLanguage;
        applyLanguage(previousLanguage);
        language.value = previousLanguage;
      }
    } else if (error.request) {
      console.error("No response received:", error.request);
      errorMessage = "No response from server, please check your network.";
    } else {
      console.error("Error Message:", error.message);
      errorMessage = "Error sending request: " + error.message;
    }

    eventBus.emit("show-toast", {
      severity: "error",
      summary: "Error",
      detail: errorMessage,
      life: 5000,
    });
  } finally {
    loading.value = false;
  }
}; // Add this new function to apply the theme
// const applyTheme = (themeValue) => {
//   const isDark = themeValue === 'dark';
//   document.documentElement.classList.toggle('dark', isDark);

//   // Update any theme-related state in your app
//   // For example, if you're using a composable:
//   const { isDarkMode } = useTheme();
//   isDarkMode.value = isDark;

//   // Or if you're using a store:
//   // authStore.setDarkMode(isDark);

//   // You might also want to update local storage/cookies
//   localStorage.setItem('theme', themeValue);
//   Cookies.set('theme', themeValue);
// };
// Fetch user details and update the QR code
// const qrCodeValue = "https://example.com";
const logoUrl = Logo;
const fetchUserDetails = async () => {
  loading.value = true;
  try {
    const response = await axiosInstance.get(`/user-profile`);
    user.value = response.data.user;
    user.value.avatarUrl = PlaceHolder;
    checked.value = response.data.user.two_factor_enabled === 1 ? true : false;
    // Update QR code details with user information
    appName.value = "Vet APP";
    username.value = user.value.email;
    current_password.value = "";
    secret.value = user.value.two_factor_secret;
    language.value = user.value.preference.user_language;
    theme.value = user.value.preference.user_theme;
    // shortcuts.value = user.value.preference.shortcuts;
    // Generate QR code with updated details
    // await generateQRCodeWithLogo(
    //   // "2@kEqcdU/4EtZ3creTUjLhmscM7snJGgyjCih6FlF/2CD6aS+WYAyhsUTWCxvjgkncPVJsIYlaCyJi4SzuY9OjUM6FGVQbE7gTDZ4=,cK6PCxTS7rLKb56bgngH89OYh8bT6GyT+1EwiVhFPlk=,BerpjSH6i0P1Hdb4qGrAori23aY1XpYiuWA5nUpPpyU=,GIrko4ewYRix9acgMhNE/FBnIe1610mV7GpSdM2AGA0=",
    //   logoUrl
    // );
    await generateQRCodeWithLogo(qrCodeValue.value, logoUrl);

    loading.value = false; // Stop loading once data is fetched
  } catch (error) {
    console.error("Error fetching user details:", error);
  }
};

// Form submission handler
const submitForm = async () => {
  // try {
  //   // console.log("Profile updated with:", user.value);
  // } catch (error) {
  //   console.error("Error updating profile:", error);
  // }
  loading.value = true;
  const submissionData = {
    name: user.value.name,
    // email: user.value.email,
  };

  try {
    const response = await axiosInstance.put(`/user`, submissionData);
    // console.log(response);
    // emit("submitted", response.data);
    eventBus.emit("show-toast", {
      severity: "success",
      summary: "Data Loaded",
      detail: "User Details Updated Successfully",
      life: 5000,
    });
  } catch (error) {
    if (error.response) {
      console.error("Response:", error.response);
      console.error("Data:", error.response.data);
      console.error("Status:", error.response.status);
      console.error("Headers:", error.response.headers);
      loading.value = false;
      message.value = error.response.data.message;
    } else if (error.request) {
      console.error("No response received:", error.request);
      message.value = "No response from server, please check your network.";
    } else {
      console.error("Error Message:", error.message);
      message.value = "Error sending request: " + error.message;
    }
  } finally {
  }
};

// Avatar handling (optional for file uploads)
const dropHandler = (event) => {
  // console.log("File dropped:", event);
};

const dragOverHandler = (event) => {
  event.preventDefault();
};
const passwordMatchError = computed(() => {
  return password_confirmation.value !== newpassword.value;
});
// watchEffect(() => {
//   // console.log(isRtl.value);
//   document.documentElement.setAttribute("dir", isRtl.value ? "rtl" : "ltr");
// });
onMounted(() => {
  fetchUserDetails();
  // generateQRCodeWithLogo("123", logoUrl);
});
</script>

<style scoped>
.form-container {
  max-width: 500px;
  margin: auto;
}

.field {
  margin-bottom: 16px;
}

.p-fieldset-content {
  display: flex;
}

/* Add this CSS to your style section or external stylesheet */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.8s ease, transform 0.8s ease;
}

.fade-enter,
.fade-leave-to

/* .fade-leave-active in <2.1.8 */ {
  opacity: 0;
  transform: translateY(-10px);
  /* or scale(0.95) for a scaling effect */
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
