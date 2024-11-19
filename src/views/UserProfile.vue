<template>
  <div class="w-full">
    <!-- User Profile Container -->
    <div
      class="dark:bg-gray-800 bg-gray-200 lg:w-[70%] md:w-[80%] sm:w-full xl:w-[85%] 2xl:w-[75%] h-fit mx-auto rounded-lg p-4 mb-4 flex flex-row"
    >
      <fieldset
        class="m-8 border dark:border-gray-100 border-gray-400 rounded-xl px-8 py-4 flex flex-col grow-1"
      >
        <!-- Profile Section -->
        <legend
          class="m-8 mb-2 border dark:border-gray-100 border-gray-400 rounded-xl px-4 dark:text-gray-900 dark:bg-gray-400 bg-gray-600 text-white text-sm"
        >
          <i class="fa-solid fa-address-card"></i> Profile Information
        </legend>

        <div class="max-w-xl">
          <section>
            <header>
              <!-- Profile Header -->
              <div class="flex flex-row">
                <div class="avatar w-32 relative">
                  <div class="rounded-[4rem] w-16 h-16 overflow-hidden">
                    <!-- Avatar Image -->
                    <img
                      class="w-16 h-auto rounded-full inline-block float-left"
                      :src="user.avatarUrl"
                      alt="Profile Avatar"
                    />
                  </div>
                  <!-- Edit Avatar Icon -->
                  <div
                    class="absolute inline-flex items-center justify-center w-6 h-6 text-xs font-bold text-white bg-gray-500 border-[1px] shadow-sm border-white rounded-[8px] top-[35px] left-12 hover:bg-gray-200 hover:text-gray-800 hover:border-gray-500 cursor-pointer"
                  >
                    <i class="fa-solid fa-pencil"></i>
                  </div>
                </div>
                <!-- Profile Info -->
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

            <!-- Profile Form -->
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
            <!-- Upload Avatar -->
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
  </div>
</template>

<script setup>
import { ref } from "vue";

// Mock user data for demonstration purposes
const user = ref({
  name: "Rawan Abas",
  email: "rsawah2@gmail.com",
  avatarUrl: "http://laravel.ids-tech.net:8001/assets/images/placeholder-1.jpg",
});

// Methods to handle form submission (update user profile)
const submitForm = async () => {
  try {
    // Simulate API call to update profile
    console.log("Profile updated with:", user.value);
    // Optionally call your API here with `axios`
    // Example: await axiosInstance.put("/user/profile", user.value);
  } catch (error) {
    console.error("Error updating profile:", error);
  }
};

// Avatar handling (optional for file uploads)
const dropHandler = (event) => {
  console.log("File dropped:", event);
  // Handle file drop
};

const dragOverHandler = (event) => {
  event.preventDefault();
  // Handle file drag over
};
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
