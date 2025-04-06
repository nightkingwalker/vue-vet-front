<template>
  <div class="px-4">
    <form @submit.prevent="submitForm" class="mx-auto w-full max-w-md">
      <fieldset
        class="p-fieldset p-component w-4/5 flex flex-wrap mx-auto gap-2 items-start border rounded-lg p-4"
      >
        <legend
          class="px-4 bg-gray-600 text-white dark:bg-zinc-200 dark:text-zinc-800 rounded"
        >
          Edit Client Details
        </legend>

        <div class="field mt-6 w-full">
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
            <TextArea id="address" v-model="owner.address" fluid autoResize rows="2" />
            <label for="address">Address</label>
          </FloatLabel>
        </div>

        <Button type="submit" label="Update" icon="pi pi-check" class="mt-4 w-full" />
      </fieldset>
    </form>
  </div>
</template>

<script setup>
import { ref, watch } from "vue";
import axiosInstance from "@/axios"; // Assuming axiosInstance is set up correctly
import InputText from "primevue/inputtext";
import TextArea from "primevue/textarea";
import FloatLabel from "primevue/floatlabel";
import Button from "primevue/button";
import eventBus from "@/eventBus";
import router from "@/router";

// const emit = defineEmits(["updated", "close-dialog"]); // Define the events to be emitted

const props = defineProps({
  owner: {
    type: Object,
    required: true,
  },
});
const emit = defineEmits(); // Define the event to be emitted
const owner = ref({ ...props.owner }); // Create a local copy of the owner object

// Watch for changes in the owner prop (if the parent updates it)
watch(
  () => props.owner,
  (newOwner) => {
    owner.value = { ...newOwner }; // Update the local copy
  },
  { deep: true }
);

// Function to handle form submission
const submitForm = async () => {
  console.log(owner.value);
  try {
    // Make the PUT request to update the owner
    const response = await axiosInstance.put(`/owners/${owner.value.id}`, owner.value);

    // Emit the updated data back to the parent component
    emit("OwnerUpdated", response.data); // Notify the parent component
    emit("close-dialog"); // Close the dialog

    // Show a success message
    eventBus.emit("show-toast", {
      severity: "success",
      summary: "Client Updated",
      detail: "Client details have been updated successfully.",
      life: 5000,
    });

    // Optionally, redirect to the owners list
    await router.push("/owners");
  } catch (error) {
    console.error("Error updating client:", error);
    eventBus.emit("show-toast", {
      severity: "error",
      summary: "Error",
      detail: "Failed to update client details.",
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
