<template>
  <div class="px-4">
    <form @submit.prevent="submitForm" class="mx-auto w-full max-w-md">
      <fieldset
        class="p-fieldset p-component w-full flex flex-wrap items-center border rounded-lg p-4"
      >
        <legend
          class="px-4 bg-gray-600 text-white dark:bg-zinc-200 dark:text-zinc-800 rounded"
        >
          New Client Details
        </legend>

        <div class="field w-full">
          <FloatLabel class="w-full">
            <InputText id="name" v-model="owner.name" />
            <label for="name">Name</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-full">
          <FloatLabel class="w-full">
            <InputText id="email" v-model="owner.email" />
            <label for="email">Email</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-full">
          <FloatLabel class="w-full">
            <InputText id="phone" v-model="owner.phone" />
            <label for="phone">Phone</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-full">
          <FloatLabel class="w-full">
            <TextArea id="address" v-model="owner.address" />
            <label for="address">Address</label>
          </FloatLabel>
        </div>

        <Button type="submit" label="Submit" icon="pi pi-check" class="mt-4 w-full" />
      </fieldset>
    </form>
  </div>
</template>

<script setup>
// import { ref } from "vue";
import { ref } from "vue"; // Import emit from Vue
import axiosInstance from "@/axios"; // Assuming axiosInstance is set up correctly
import InputText from "primevue/inputtext";
import TextArea from "primevue/textarea";
import FloatLabel from "primevue/floatlabel";
import Button from "primevue/button";
import eventBus from "@/eventBus";
import router from "@/router";
import Cookies from "js-cookie";
// Reactive properties for form data
const emit = defineEmits(["submitted"]); // Define the event to be emitted

const owner = ref({
  name: "",
  email: "",
  phone: "",
  address: "",
  branch_id: Cookies.get("M3K8g2387BahBaqyjDe6"),
});

// Function to handle form submission
const submitForm = async () => {
  try {
    // console.log(owner.value);
    // Make the POST request to the API to create a new client
    const response = await axiosInstance.post("/owners", owner.value);

    // Emit the submitted data back to the parent component
    emit("ownerAdded", response.data.data); // You may modify this based on your response structure
    eventBus.emit("ownerAdded", response.data.data);
    // Clear the form fields after successful submission
    owner.value = {
      name: "",
      email: "",
      phone: "",
      address: "",
    };

    // Optionally, show a success message or perform any other action
    eventBus.emit("show-toast", {
      severity: "success",
      summary: "Client Added",
      detail: "New client has been added successfully.",
      life: 5000,
    });
    await router.push("/owners");
  } catch (error) {
    // Handle the error
    console.error("Error adding new client:", error);
    eventBus.emit("show-toast", {
      severity: "error",
      summary: "Error",
      detail: "Failed to add new client.",
      life: 5000,
    });
  }
};
</script>

<style scoped>
/* Tailwind and Theming for light/dark modes */
body.dark .text-sm {
  color: #ccc; /* Example color for dark mode */
}
body .text-sm {
  color: #333; /* Example color for light mode */
}
</style>
