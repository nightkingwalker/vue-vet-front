<template>
  <div class="w-full">
    <!-- User Profile Container -->
    <div
      class="dark:bg-gray-800 bg-gray-200 lg:w-[70%] md:w-[80%] sm:w-full xl:w-[85%] 2xl:w-[75%] h-fit mx-auto rounded-lg p-4 mb-4 flex flex-row"
    >
      <!-- Profile Section -->
      <fieldset
        class="m-8 border dark:border-gray-100 border-gray-400 rounded-xl px-8 py-4 flex flex-col grow-1"
      >
        <legend
          class="m-8 mb-2 border dark:border-gray-100 border-gray-400 rounded-xl px-4 dark:text-gray-900 dark:bg-gray-400 bg-gray-600 text-white text-sm"
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
                  <input
                    v-model="user.name"
                    class="border-gray-300 dark:border-gray-700 dark:bg-gray-900 dark:text-gray-300 focus:border-transparent dark:focus:border-transparent focus:ring-0 dark:focus:ring-0 rounded-md shadow-sm block py-2 px-4 w-full"
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
                  <input
                    v-model="user.email"
                    class="border-gray-300 dark:border-gray-700 dark:bg-gray-900 dark:text-gray-300 focus:border-transparent dark:focus:border-transparent focus:ring-0 dark:focus:ring-0 rounded-md shadow-sm block py-2 px-4 w-full"
                    id="email"
                    type="email"
                    required
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
          class="m-8 mb-2 border dark:border-gray-100 border-gray-400 rounded-xl px-4 dark:text-gray-900 dark:bg-gray-400 bg-gray-600 text-white text-sm"
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
              <input id="file" name="file" type="file" class="hidden" />
            </label>
          </div>
        </div>
      </fieldset>
    </div>

    <!-- Update Password Section -->
    <div
      class="dark:bg-gray-800 bg-gray-200 lg:w-[70%] md:w-[80%] sm:w-full xl:w-[85%] 2xl:w-[75%] h-fit mx-auto rounded-lg p-4 mb-4 flex flex-row"
    >
      <fieldset
        class="m-8 border dark:border-gray-100 border-gray-400 rounded-xl px-8 py-4 flex flex-col w-1/2"
      >
        <legend
          class="m-8 mb-2 border dark:border-gray-100 border-gray-400 rounded-xl px-4 dark:text-gray-900 dark:bg-gray-400 bg-gray-600 text-white text-sm"
        >
          <i class="fa-solid fa-lock"></i> Update Password
        </legend>
        <div class="max-w-xl">
          <section>
            <header>
              <h2 class="text-lg font-medium text-gray-900 dark:text-gray-100">
                Update Password
              </h2>
              <p class="mt-1 text-sm text-gray-600 dark:text-gray-400">
                Ensure your account is using a long, random password to stay secure.
              </p>
            </header>

            <form
              method="post"
              action="http://laravel.ids-tech.net:8001/password"
              class="mt-6 space-y-6"
              data-bitwarden-watching="1"
            >
              <input
                type="hidden"
                name="_token"
                value="1LPkRPsw6tVRniaKRXelAR9kvpdUgzqGtvklfsKv"
              />
              <input type="hidden" name="_method" value="put" />
              <div>
                <label
                  class="block font-medium text-sm text-gray-700 dark:text-gray-300"
                  for="current_password"
                  >Current Password</label
                >
                <div class="textcontainer">
                  <input
                    class="border-gray-300 dark:border-gray-700 dark:bg-gray-900 dark:text-gray-300 focus:border-transparent dark:focus:border-transparent focus:ring-0 dark:focus:ring-0 rounded-md shadow-sm block py-2 px-4 w-full"
                    id="current_password"
                    name="current_password"
                    type="password"
                    autocomplete="current-password"
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
                  <input
                    class="border-gray-300 dark:border-gray-700 dark:bg-gray-900 dark:text-gray-300 focus:border-transparent dark:focus:border-transparent focus:ring-0 dark:focus:ring-0 rounded-md shadow-sm block py-2 px-4 w-full"
                    id="password_"
                    name="password"
                    type="password"
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
                  <input
                    class="border-gray-300 dark:border-gray-700 dark:bg-gray-900 dark:text-gray-300 focus:border-transparent dark:focus:border-transparent focus:ring-0 dark:focus:ring-0 rounded-md shadow-sm block py-2 px-4 w-full"
                    id="password_confirmation"
                    name="password_confirmation"
                    type="password"
                    autocomplete="new-password"
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

      <fieldset
        class="m-8 border dark:border-gray-100 border-gray-400 rounded-xl px-8 py-4 flex flex-col w-1/2"
      >
        <legend
          class="m-8 mb-2 border dark:border-gray-100 border-gray-400 rounded-xl px-4 dark:text-gray-900 dark:bg-gray-400 bg-gray-600 text-white text-sm"
        >
          <i class="fa-solid fa-user-shield"></i> Two Factor Authentication
        </legend>
        <div class="max-w-xl">
          <section class="space-y-6">
            <header>
              <h2 class="text-lg font-medium text-gray-900 dark:text-gray-100">
                Activate Two Factor Authentication
              </h2>
              <p class="mt-1 text-sm text-gray-600 dark:text-gray-400">
                To add another layer of security to your account, please activate
                two-factor authentication.
              </p>
            </header>
            <label class="relative inline-flex items-center cursor-pointer">
              <input type="checkbox" value="" class="sr-only peer" id="enable_tfa" />
              <div
                class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-0 peer-focus:ring-0 dark:peer-focus:ring-0 rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-blue-600"
              ></div>
              <span class="ml-3 text-sm font-medium text-gray-900 dark:text-gray-300"
                ><span id="tfa_status">Enable</span> Two Factor Authentication</span
              >
            </label>

            <div class="flex items-end">
              <div class="pr-4">
                <div class="visible-print text-center">
                  <h6 class="dark:text-gray-200 text-gray-800 text-left mb-4">
                    2FA CODE: JUOGHEZQQS46O3FB
                  </h6>
                  <img class="w-32" :src="TFA" />
                </div>
                <form action="/user/2fa" method="post">
                  <input
                    type="hidden"
                    name="_token"
                    value="1LPkRPsw6tVRniaKRXelAR9kvpdUgzqGtvklfsKv"
                  />
                  <input type="hidden" name="code_generated" value="JUOGHEZQQS46O3FB" />
                  <label
                    class="block font-medium text-sm text-gray-700 dark:text-gray-300 mt-4"
                    for="2fa_code"
                    >Two Factor Authentication Code</label
                  >
                  <div class="textcontainer">
                    <input
                      class="border-gray-300 dark:border-gray-700 dark:bg-gray-900 dark:text-gray-300 focus:border-transparent dark:focus:border-transparent focus:ring-0 dark:focus:ring-0 rounded-md shadow-sm block py-2 px-4 w-[350px]"
                      id="2fa_code"
                      type="text"
                      name="2fa_code"
                      placeholder="2FA Code"
                      required
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
            </div>
          </section>
        </div>
      </fieldset>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref } from "vue";
import PlaceHolder from "@/assets/placeholder-1.png";
import TFA from "@/assets/otpauth_totp_ve_.png";
const loading = ref(true);
const user = ref({
  id: 1,
  name: "tarek",
  email: "t.sawah@gmail.com",
  two_factor_secret: "JUOGHEZQQS46O3FB",
  avatarUrl: PlaceHolder,
});

// Methods to handle form submission (update user profile)
const submitForm = async () => {
  try {
    console.log("Profile updated with:", user.value);
  } catch (error) {
    console.error("Error updating profile:", error);
  }
};

// Avatar handling (optional for file uploads)
const dropHandler = (event) => {
  console.log("File dropped:", event);
};

const dragOverHandler = (event) => {
  event.preventDefault();
};
const fetchUserDetails = async () => {
  loading.value = true;
  try {
    // Make the request using the axios instance with interceptors
    const response = await axiosInstance.get(`/user-profile`);
    // // console.log(medical_records.value);
    user.value = response.data;
    console.log(user.value);
    loading.value = false; // Stop loading once data is fetched
    // // console.log(findRecordById(4));
  } catch (error) {
    //     // showSuccess("warn", "Warning", "Couldent Fetch Data");
  } finally {
  }
};
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
</style>
