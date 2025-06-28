<template>
  <div class="w-full bg-[var(--p-content-background)] p-8 rounded-lg mt-4">
    <!-- User Profile Container -->
    <div
      class="grid grid-cols-2 grid-rows-2 gap-y-[10px] gap-x-[10px] lg:w-[70%] md:w-[80%] sm:w-full xl:w-[85%] 2xl:w-[75%] h-fit mx-auto">
      <fieldset
        class="row-1 row-2 col-1 col-2  border dark:border-gray-100 border-gray-400 rounded-xl p-6 bg-zinc-100 dark:bg-[var(--p-surface-500)] shadow-sm">
        <legend
          class="px-4 py-1 border dark:border-gray-100 border-gray-400 rounded-xl dark:text-gray-900 dark:bg-gray-400 bg-gray-600 text-white text-sm font-medium">
          <i class="fa-solid fa-address-card mr-2"></i> Profile Information
        </legend>
        <div class="flex items-start gap-6">
          <div class="relative group">
            <div class="w-20 h-20 rounded-full overflow-hidden border-2 border-gray-300 dark:border-gray-600">
              <img class="w-full h-full object-cover" :src="user.avatarUrl" alt="Profile Avatar" />
            </div>
            <button
              class="absolute -bottom-1 -right-1 inline-flex items-center justify-center w-7 h-7 text-xs font-bold text-white bg-gray-600 border-2 border-white rounded-full shadow-sm hover:bg-gray-200 hover:text-gray-800 hover:border-gray-500 transition-all duration-200"
              @click="showAvatarUploader = !showAvatarUploader">
              <i class="fa-solid fa-pencil text-xs"></i>
            </button>
          </div>
          <div class="flex-1">
            <h2 class="text-xl font-semibold text-gray-900 dark:text-gray-100">
              Personal Details
            </h2>
            <p class="mt-1 text-sm text-gray-600 dark:text-gray-400">
              Update your account's profile information
            </p>
            <form @submit.prevent="submitForm" class="mt-4 space-y-4">
              <div>
                <label class="block font-medium text-sm text-gray-700 dark:text-gray-300 mb-1" for="name">
                  Full Name
                </label>
                <InputText class="w-full" size="small" v-model="user.name" id="name" type="text" required />
              </div>
              <div>
                <label class="block font-medium text-sm text-gray-700 dark:text-gray-300 mb-1" for="email">
                  Email Address
                </label>
                <InputText class="w-full" size="small" v-model="user.email" id="email" type="email" readonly disabled />
              </div>
              <div class="flex justify-end">
                <button type="submit"
                  class="bg-gray-800 px-5 py-2.5 text-white rounded-lg hover:bg-gray-700 shadow-md text-sm font-medium transition-colors duration-200">
                  Save Changes
                </button>
              </div>
            </form>
          </div>
        </div>
      </fieldset>
      <!-- Update Password Section -->
      <fieldset
        class="row-1 row-2 col-1 col-2  border dark:border-gray-100 border-gray-400 rounded-xl p-6 bg-zinc-100 dark:bg-[var(--p-surface-500)] shadow-sm">
        <legend
          class="px-4 py-1 border dark:border-gray-100 border-gray-400 rounded-xl dark:text-gray-900 dark:bg-gray-400 bg-gray-600 text-white text-sm font-medium">
          <i class="fa-solid fa-lock mr-2"></i> Update Password
        </legend>
        <form @submit.prevent="updatePassword" class="space-y-4">
          <div>
            <label class="block font-medium text-sm text-gray-700 dark:text-gray-300 mb-1" for="current_password">
              Current Password
            </label>
            <InputText class="w-full" size="small" id="current_password" name="current_password"
              v-model="current_password" type="password" autocomplete="current-password" />
          </div>
          <div>
            <label class="block font-medium text-sm text-gray-700 dark:text-gray-300 mb-1" for="password_">
              New Password
            </label>
            <InputText class="w-full" size="small" type="password" v-model="newpassword" autocomplete="new-password" />
          </div>
          <div>
            <label class="block font-medium text-sm text-gray-700 dark:text-gray-300 mb-1" for="password_confirmation">
              Confirm Password
            </label>
            <InputText class="w-full" size="small" id="password_confirmation" name="password_confirmation"
              v-model="password_confirmation" type="password" :invalid="passwordMatchError"
              autocomplete="new-password" />
            <Message v-if="passwordMatchError" severity="error" class="mt-1 text-xs">
              Passwords do not match
            </Message>
          </div>
          <div class="flex justify-end">
            <button type="submit"
              class="bg-gray-800 px-5 py-2.5 text-white rounded-lg hover:bg-gray-700 shadow-md text-sm font-medium transition-colors duration-200">
              Update Password
            </button>
          </div>
        </form>
      </fieldset>
      <!-- User Preferences Section -->
      <fieldset
        class="row-1 row-2 col-1 col-2  border dark:border-gray-100 border-gray-400 rounded-xl p-6 bg-zinc-100 dark:bg-[var(--p-surface-500)] shadow-sm">
        <legend
          class="px-4 py-1 border dark:border-gray-100 border-gray-400 rounded-xl dark:text-gray-900 dark:bg-gray-400 bg-gray-600 text-white text-sm font-medium">
          <i class="fa-solid fa-user-cog mr-2"></i> Preferences
        </legend>
        <div class="space-y-6">
          <!-- Language Selection -->
          <div>
            <h3 class="text-sm font-medium text-gray-700 dark:text-gray-300 mb-3">Language</h3>
            <div class="flex gap-4">
              <div class="flex items-center">
                <input id="language-english" name="language" type="radio"
                  class="h-4 w-4 text-gray-600 focus:ring-gray-500 border-gray-300 dark:border-gray-600 dark:bg-gray-700"
                  checked>
                <label for="language-english" class="ml-2 block text-sm text-gray-700 dark:text-gray-300">
                  English
                </label>
              </div>
              <div class="flex items-center">
                <input id="language-arabic" name="language" type="radio"
                  class="h-4 w-4 text-gray-600 focus:ring-gray-500 border-gray-300 dark:border-gray-600 dark:bg-gray-700">
                <label for="language-arabic" class="ml-2 block text-sm text-gray-700 dark:text-gray-300">
                  العربية (Arabic)
                </label>
              </div>
            </div>
          </div>
          <!-- Theme Selection -->
          <div>
            <h3 class="text-sm font-medium text-gray-700 dark:text-gray-300 mb-3">Theme</h3>
            <div class="flex gap-4">
              <button @click="setTheme('light')"
                class="flex items-center justify-center gap-2 px-4 py-2 rounded-lg border border-gray-300 dark:border-gray-600 hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors"
                :class="{ 'bg-gray-200 dark:bg-gray-700': theme === 'light' }">
                <i class="fa-regular fa-sun text-yellow-500"></i>
                <span class="text-sm">Light</span>
              </button>
              <button @click="setTheme('dark')"
                class="flex items-center justify-center gap-2 px-4 py-2 rounded-lg border border-gray-300 dark:border-gray-600 hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors"
                :class="{ 'bg-gray-200 dark:bg-gray-700': theme === 'dark' }">
                <i class="fa-regular fa-moon text-indigo-400"></i>
                <span class="text-sm">Dark</span>
              </button>
              <button @click="setTheme('system')"
                class="flex items-center justify-center gap-2 px-4 py-2 rounded-lg border border-gray-300 dark:border-gray-600 hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors"
                :class="{ 'bg-gray-200 dark:bg-gray-700': theme === 'system' }">
                <i class="fa-solid fa-desktop text-gray-500"></i>
                <span class="text-sm">System</span>
              </button>
            </div>
          </div>
        </div>
      </fieldset>
      <!-- Two Factor Authentication Section -->
      <fieldset
        class="row-1 row-2 col-1 col-2  border dark:border-gray-100 border-gray-400 rounded-xl p-6 bg-zinc-100 dark:bg-[var(--p-surface-500)] shadow-sm">
        <legend
          class="px-4 py-1 border dark:border-gray-100 border-gray-400 rounded-xl dark:text-gray-900 dark:bg-gray-400 bg-gray-600 text-white text-sm font-medium">
          <i class="fa-solid fa-user-shield mr-2"></i> Two Factor Authentication
        </legend>
        <div class="space-y-4">
          <div class="flex items-center justify-between">
            <div>
              <h3 class="text-sm font-medium text-gray-700 dark:text-gray-300">Two-Factor Authentication</h3>
              <p class="text-xs text-gray-500 dark:text-gray-400 mt-1">
                Add an extra layer of security to your account
              </p>
            </div>
            <ToggleSwitch v-model="checked" />
          </div>
          <transition name="fade">
            <div v-if="checked"
              class="bg-gray-50 dark:bg-gray-700 p-4 rounded-lg border border-gray-200 dark:border-gray-600">
              <p class="text-xs text-green-500 mb-2">
                <i class="fa-solid fa-circle-info mr-1"></i> Scan the QR code with your authenticator app
              </p>
              <div class="flex flex-col items-center">
                <img v-if="checked" class="w-32 h-32 mb-3" :src="qrCodeUrl" alt="2FA QR Code" />
                <p class="text-xs text-gray-500 dark:text-gray-400 text-center mb-3">
                  Secret Key: <code
                    class="bg-gray-200 dark:bg-gray-600 px-1 rounded">{{ user.two_factor_secret }}</code>
                </p>
              </div>
              <form @submit.prevent="tfaEnabled" class="space-y-3">
                <div>
                  <label class="block text-xs text-gray-700 dark:text-gray-300 mb-1" for="2fa_code">
                    Enter verification code
                  </label>
                  <InputText class="w-full" size="small" type="text" placeholder="6-digit code" :required="checked"
                    v-model="tfa_code" />
                </div>
                <button type="submit"
                  class="w-full bg-gray-800 px-4 py-2 text-white rounded-lg hover:bg-gray-700 shadow-md text-xs font-medium transition-colors duration-200">
                  Verify & Activate
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
import { onMounted, ref, computed } from "vue";
import QRCode from "qrcode"; // Import the QRCode library
import PlaceHolder from "@/assets/placeholder-1.png";
import axiosInstance from "@/axios"; // Assuming axiosInstance is set up correctly
import ToggleSwitch from "primevue/toggleswitch";
import eventBus from "@/eventBus";
import InputText from "primevue/inputtext";
import Message from "primevue/message";
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
// Computed value for the QR code
const qrCodeValue = computed(() => {
  return `otpauth://totp/${appName.value}:${username.value}?secret=${secret.value}&issuer=${appName.value}`;
});

// Generate the QR code URL
const generateQRCode = async () => {
  try {
    qrCodeUrl.value = await QRCode.toDataURL(qrCodeValue.value);
  } catch (error) {
    console.error("Error generating QR code:", error);
  }
};
const tfaEnabled = async () => {
  
  loading.value = true;
  const submissionData = {
    two_factor_code: tfa_code.value,
  };

  try {
    const response = await axiosInstance.post(
      !checked.value ? `/2fa/disable` : `/2fa/enable`,
      submissionData
    );
    
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
  
  loading.value = true;
  const submissionData = {
    current_password: current_password.value,
    new_password: newpassword.value,
    new_password_confirmation: password_confirmation.value,
  };

  try {
    const response = await axiosInstance.put(`/user/password`, submissionData);
    
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

// Fetch user details and update the QR code
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
    secret.value = user.value.two_factor_secret;

    // Generate QR code with updated details
    await generateQRCode();

    loading.value = false; // Stop loading once data is fetched
  } catch (error) {
    console.error("Error fetching user details:", error);
  }
};

// Form submission handler
const submitForm = async () => {
  // try {
  //   
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
  
};

const dragOverHandler = (event) => {
  event.preventDefault();
};
const passwordMatchError = computed(() => {
  return password_confirmation.value !== newpassword.value;
});
onMounted(() => {
  fetchUserDetails();
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

/* .fade-leave-active in <2.1.8 */
  {
  opacity: 0;
  transform: translateY(-10px);
  /* or scale(0.95) for a scaling effect */
}
</style>
