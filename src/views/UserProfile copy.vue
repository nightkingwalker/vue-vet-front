<template>
  <div class="w-full bg-[var(--p-content-background)] p-8 rounded-lg mt-4">
    <!-- User Profile Container -->
    <div
      class="lg:w-[70%] md:w-[80%] sm:w-full xl:w-[85%] 2xl:w-[75%] h-fit mx-auto rounded-lg mb-4 flex flex-row"
    >
      <!-- Profile Section -->
      <fieldset
        class="border dark:border-gray-100 border-gray-400 rounded-xl px-8 py-4 flex flex-col grow-1 bg-zinc-100 dark:bg-[var(--p-surface-500)]"
      >
        <legend
          class="m-8 mb-2 border dark:border-gray-100 border-gray-400 rounded-xl px-4 dark:text-gray-900 dark:bg-gray-400 bg-gray-600 text-white text-xs"
        >
          <i class="fa-solid fa-address-card"></i> Profile Information
        </legend>

        <div class="max-w-xl">
          <section>
            <header>
              <div class="flex flex-row">
                <div class="avatar w-32 relative">
                  <div class="rounded-[4rem] w-16 h-16 overflow-hidden">
                    <img
                      class="w-16 h-auto rounded-full inline-block float-left"
                      :src="user.avatarUrl"
                      alt="Profile Avatar"
                    />
                  </div>
                  <div
                    class="absolute inline-flex items-center justify-center w-6 h-6 text-xs font-bold text-white bg-gray-500 border-[1px] shadow-sm border-white rounded-[8px] top-[35px] left-12 hover:bg-gray-200 hover:text-gray-800 hover:border-gray-500 cursor-pointer"
                  >
                    <i class="fa-solid fa-pencil"></i>
                  </div>
                </div>
                <div>
                  <h2 class="text-lg font-medium text-gray-900 dark:text-gray-100">
                    Profile Information
                  </h2>
                  <p class="mt-1 text-sm text-gray-600 dark:text-gray-400">
                    Update your account's profile information and email address.
                  </p>
                </div>
              </div>
            </header>

            <form @submit.prevent="submitForm" method="post" class="mt-6 space-y-6">
              <div>
                <label
                  class="block font-medium text-sm text-gray-700 dark:text-gray-300"
                  for="name"
                  >Name</label
                >
                <div class="textcontainer">
                  <InputText
                    size="small"
                    v-model="user.name"
                    id="name"
                    type="text"
                    required
                  />
                  <div class="borderx"></div>
                </div>
              </div>

              <div>
                <label
                  class="block font-medium text-sm text-gray-700 dark:text-gray-300"
                  for="email"
                  >Email</label
                >
                <div class="textcontainer">
                  <InputText
                    size="small"
                    v-model="user.email"
                    id="email"
                    type="email"
                    readonly
                    disabled
                  />
                  <div class="borderx"></div>
                </div>
              </div>

              <div class="flex items-center gap-4">
                <button
                  type="submit"
                  class="bg-gray-900 px-4 py-2 text-white rounded hover:bg-gray-700 shadow-md text-xs"
                >
                  Save
                </button>
              </div>
            </form>
          </section>
        </div>
      </fieldset>

      <!-- Avatar Section -->
      <fieldset
        id="image-uploader"
        class="m-8 border dark:border-gray-100 border-gray-400 rounded-xl px-8 py-4 flex flex-col hidden"
      >
        <legend
          class="m-8 mb-2 border dark:border-gray-100 border-gray-400 rounded-xl px-4 dark:text-gray-900 dark:bg-gray-400 bg-gray-600 text-white text-xs"
        >
          <i class="fa-solid fa-camera"></i> Avatar
        </legend>

        <div class="max-w-xl">
          <div
            id="uploader-container"
            @drop="dropHandler"
            @dragover="dragOverHandler"
            class="flex items-center flex-col justify-center w-full"
          >
            <label
              for="file"
              id="uploader-form"
              class="flex flex-col items-center justify-center w-full h-64 border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 dark:bg-gray-700 hover:bg-gray-100 dark:border-gray-600"
            >
              <div
                id="upload-insentive"
                class="flex flex-col items-center justify-center pt-5 pb-6"
              >
                <svg
                  viewBox="0 0 20 20"
                  version="1.1"
                  xmlns="http://www.w3.org/2000/svg"
                  id="dribbble-up"
                  width="64"
                >
                  <g
                    id="Page-1"
                    stroke="none"
                    stroke-width="1"
                    fill="none"
                    fill-rule="evenodd"
                  >
                    <g transform="translate(-300.000000, -3479.000000)" fill="#9ca3af">
                      <g id="icons" transform="translate(56.000000, 160.000000)">
                        <path
                          d="M254.006515,3325.00497 L250.302249,3328.71065 L251.715206,3330.12415 L253.007252,3328.83161 L253.007252,3339 L255.005777,3339 L255.005777,3328.83161 L256.297824,3330.12415 L257.710781,3328.71065 L254.006515,3325.00497 Z"
                          id="cloud_up-[#1062]"
                        ></path>
                      </g>
                    </g>
                  </g>
                </svg>
                <p class="mb-2 text-sm text-gray-500 dark:text-gray-400">
                  <span class="font-semibold">Click to upload</span> or drag and drop
                </p>
                <p class="text-xs text-gray-500 dark:text-gray-400">JPG/PNG only</p>
              </div>
              <InputText size="small" id="file" name="file" type="file" class="hidden" />
            </label>
          </div>
        </div>
      </fieldset>
    </div>

    <!-- Update Password Section -->
    <div
      class="lg:w-[70%] md:w-[80%] sm:w-full xl:w-[85%] 2xl:w-[75%] h-fit mx-auto rounded-lg mb-4 flex flex-row gap-1 justify-center items-start"
    >
      <fieldset
        class="border dark:border-gray-100 border-gray-400 rounded-xl px-8 py-4 flex flex-col w-1/2 bg-zinc-100 dark:bg-[var(--p-surface-500)]"
      >
        <legend
          class="border dark:border-gray-100 border-gray-400 rounded-xl px-4 dark:text-gray-900 dark:bg-gray-400 bg-gray-600 text-white text-xs"
        >
          <i class="fa-solid fa-lock"></i> Update Password
        </legend>
        <div class="max-w-xl">
          <section>
            <header>
              <p class="mt-1 text-xs text-gray-600 dark:text-gray-400">
                Ensure your account is using a long, random password to stay secure.
              </p>
            </header>

            <form
              @submit.prevent="updatePassword"
              class="mt-6 space-y-2"
              data-bitwarden-watching="1"
            >
              <div>
                <label
                  class="block font-medium text-sm text-gray-700 dark:text-gray-300"
                  for="current_password"
                  >Current Password</label
                >
                <div class="textcontainer">
                  <InputText
                    size="small"
                    id="current_password"
                    name="current_password"
                    v-model="current_password"
                    type="password"
                  />
                  <div class="borderx"></div>
                </div>
              </div>

              <div>
                <label
                  class="block font-medium text-sm text-gray-700 dark:text-gray-300"
                  for="password_"
                  >New Password</label
                >
                <div class="textcontainer">
                  <InputText
                    size="small"
                    type="password"
                    v-model="newpassword"
                    autocomplete="new-password"
                  />
                  <div class="borderx"></div>
                </div>
              </div>

              <div>
                <label
                  class="block font-medium text-sm text-gray-700 dark:text-gray-300"
                  for="password_confirmation"
                  >Confirm Password</label
                >
                <div class="textcontainer">
                  <InputText
                    size="small"
                    id="password_confirmation"
                    name="password_confirmation"
                    v-model="password_confirmation"
                    type="password"
                    :invalid="passwordMatchError"
                    autocomplete="new-password"
                  />
                  <Message
                    size="small"
                    severity="danger"
                    variant="simple"
                    class="text-[11px] text-red-500"
                    v-if="passwordMatchError"
                    >Passwords do not match.</Message
                  >
                </div>
              </div>

              <div class="flex items-center gap-4">
                <button
                  type="submit"
                  class="bg-gray-900 px-4 py-2 text-white rounded hover:bg-gray-700 shadow-md text-xs"
                >
                  Save
                </button>
              </div>
            </form>
          </section>
        </div>
      </fieldset>

      <fieldset
        class="border dark:border-gray-100 border-gray-400 rounded-xl px-8 py-4 flex flex-col w-1/2 bg-zinc-100 dark:bg-[var(--p-surface-500)]"
      >
        <legend
          class="m-8 mb-2 border dark:border-gray-100 border-gray-400 rounded-xl px-4 dark:text-gray-900 dark:bg-gray-400 bg-gray-600 text-white text-xs"
        >
          <i class="fa-solid fa-user-shield"></i> Two Factor Authentication
        </legend>
        <div class="max-w-xl">
          <section class="space-y-6">
            <header>
              <p class="mt-1 text-xs text-gray-600 dark:text-gray-400">
                Activate two-factor authentication.
              </p>
            </header>
            <label class="relative inline-flex items-center cursor-pointer">
              <ToggleSwitch v-model="checked" />
              <span class="ml-3 text-sm font-medium"
                ><span id="tfa_status">Enable</span> Two Factor Authentication</span
              >
            </label>

            <div class="flex items-end">
              <transition name="fade">
                <div class="pr-4" v-if="checked">
                  <div class="visible-print text-center">
                    <p class="text-left text-[10pt] text-green-500">
                      Scan The QR CODE In Authenticator App
                    </p>
                    <h6 class="text-left mb-4">2FA CODE: {{ user.two_factor_secret }}</h6>
                    <img v-if="checked" class="w-32" :src="qrCodeUrl" alt="2FA QR Code" />
                  </div>
                  <form @submit.prevent="tfaEnabled">
                    <label
                      class="block text-xs text-gray-700 dark:text-gray-300 mt-4"
                      for="2fa_code"
                      >Confirm OTP From Your Authenticator App</label
                    >
                    <div class="textcontainer">
                      <InputText
                        size="small"
                        type="text"
                        placeholder="2FA Code"
                        :required="checked.value"
                        v-model="tfa_code"
                      />
                      <div class="borderx"></div>
                    </div>
                    <button
                      type="submit"
                      class="bg-gray-900 px-4 py-2 text-white mt-4 rounded hover:bg-gray-700 shadow-md text-xs"
                    >
                      Activate 2FA
                    </button>
                  </form>
                </div>
              </transition>
            </div>
          </section>
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
const dropHandler = (event) => {};

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

.fade-enter, .fade-leave-to /* .fade-leave-active in <2.1.8 */ {
  opacity: 0;
  transform: translateY(-10px); /* or scale(0.95) for a scaling effect */
}
</style>
