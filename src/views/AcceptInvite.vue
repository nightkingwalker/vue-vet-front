<template>
  <div
    class="min-h-screen flex items-center justify-center bg-surface-50 dark:bg-surface-900 p-4"
  >
    <Card class="w-full max-w-md">
      <template #header>
        <div class="text-center p-4">
          <h2 class="text-2xl font-bold text-surface-900 dark:text-surface-0">
            Join {{ clinic.name }} as {{ role }}
          </h2>
        </div>
      </template>

      <template #content>
        <div v-if="validInvitation">
          <Message v-if="errorMessage" severity="error" class="mb-4">
            {{ errorMessage }}
          </Message>

          <form @submit.prevent="handleSubmit" class="space-y-4">
            <div class="flex flex-col gap-2">
              <label
                for="name"
                class="text-sm font-medium text-surface-600 dark:text-surface-300"
              >
                Your Name
              </label>
              <InputText
                id="name"
                v-model="form.name"
                required
                placeholder="Enter your full name"
                class="w-full"
                :class="{ 'p-invalid': formErrors.name }"
              />
              <small v-if="formErrors.name" class="p-error">{{ formErrors.name }}</small>
            </div>

            <div class="flex flex-col gap-2">
              <label
                for="password"
                class="text-sm font-medium text-surface-600 dark:text-surface-300"
              >
                Password
              </label>
              <!-- <Password
                id="password"
                v-model="form.password"
                required
                placeholder="Create a password"
                class="w-full"
                :class="{ 'p-invalid': formErrors.password }"
                toggleMask
                :feedback="true"
              /> -->
              <InputGroup
                class="!bg-surface-200 !dark:bg-surface-600 dark:!text-gray-200 !text-gray-800 flex rounded-md overflow-hidden"
              >
                <InputGroupAddon
                  class="!bg-surface-200 !dark:bg-surface-600 dark:!text-gray-200 !text-gray-800 px-4 flex flex-col item-center justify-center"
                  ><i class="pi pi-shield"></i
                ></InputGroupAddon>
                <InputText
                  v-model="form.password"
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

              <small v-if="formErrors.password" class="p-error">{{
                formErrors.password
              }}</small>
            </div>

            <Button
              type="submit"
              label="Complete Registration"
              class="w-full mt-4"
              :loading="loading"
              :disabled="loading"
            />
          </form>
        </div>

        <div v-if="!loading && !validInvitation" class="text-center py-6">
          <Message severity="error" class="mb-4">
            Invalid or expired invitation link
          </Message>
          <Button
            label="Return to homepage"
            icon="pi pi-home"
            class="p-button-text"
            @click="$router.push('/')"
          />
        </div>
      </template>

      <template #footer>
        <div class="text-center text-sm text-surface-500 dark:text-surface-400">
          Already have an account?
          <router-link
            to="/login"
            class="text-primary-500 hover:text-primary-700 dark:text-primary-400 dark:hover:text-primary-300 font-medium"
          >
            Sign in here
          </router-link>
        </div>
      </template>
    </Card>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRoute, useRouter } from "vue-router";
import axios from "@/axios";
import Card from "primevue/card";
import InputText from "primevue/inputtext";
import Password from "primevue/password";
import Button from "primevue/button";
import Message from "primevue/message";
import InputGroup from "primevue/inputgroup";
import InputGroupAddon from "primevue/inputgroupaddon";

const route = useRoute();
const router = useRouter();

const validInvitation = ref(false);
const clinic = ref({});
const role = ref("");
const loading = ref(false);
const form = ref({
  name: "",
  password: "",
});

const formErrors = ref({
  name: null,
  password: null,
});

const errorMessage = ref("");
// Validate token on component mount
onMounted(async () => {
  try {
    const response = await axios.get(`/invitations/validate?token=${route.query.token}`);
    
    clinic.value = response.data.clinic;
    role.value = response.data.role;
    validInvitation.value = true;
  } catch (error) {
    validInvitation.value = false;
  }
});
const isPassword = ref(true);
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

// Handle form submission
const handleSubmit = async () => {
  try {
    loading.value = true;
    const x = await axios.post("/invitations/accept", {
      token: route.query.token,
      name: form.value.name,
      password: form.value.password,
    });
    await router.push(`/`); // Redirect after success
  } catch (error) {
    alert("Registration failed. Please try again.");
  } finally {
    loading.value = false;
  }
};
</script>
