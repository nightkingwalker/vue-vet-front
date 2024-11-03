<template>
  <div class="px-4">
    <form @submit.prevent="submitForm" class="mx-auto w-full max-w-md">
      <fieldset
        class="p-fieldset p-component w-full flex flex-wrap items-center border rounded-lg p-4"
      >
        <legend
          class="px-4 bg-gray-600 text-white dark:bg-zinc-200 dark:text-zinc-800 rounded"
        >
          Send WhatsApp Message
        </legend>
        <div class="field mt-6 w-full">
          <input type="hidden" v-model="wahaMessageNumber" />
          <FloatLabel class="w-full">
            <Textarea v-model="wahaMessageText" rows="5" cols="30" fluid />
            <label for="address">Message</label>
          </FloatLabel>
        </div>

        <Button type="submit" label="Send" icon="pi pi-check" class="mt-4 w-full" />
      </fieldset>
    </form>
  </div>
</template>

<script setup>
// import { ref } from "vue";
import { ref } from "vue"; // Import emit from Vue
import Textarea from "primevue/textarea";
import FloatLabel from "primevue/floatlabel";
import Button from "primevue/button";
import eventBus from "@/eventBus";
import axios from "axios";

// Reactive properties for form data
const emit = defineEmits(["submitted"]); // Define the event to be emitted
const WAHA_API_KEY = import.meta.env.VITE_WAHA_API_KEY;
const WAHA_API_MESSAGE_URL = import.meta.env.VITE_WAHA_API_MESSAGE_URL;
const WAHA_API_SESSION = import.meta.env.VITE_WAHA_API_SESSION;
const owner = ref({
  name: "",
  email: "",
  phone: "",
  address: "",
});
const props = defineProps({
  contactNumber: String, // Replace `Object` with the correct data type
});

const wahaMessageText = ref("");
const wahaMessageNumber = props.contactNumber;
// Function to handle form submission
const submitForm = async () => {
  //   try {
  const data = JSON.stringify({
    chatId: `${props.contactNumber}@c.us`,
    reply_to: "",
    text: wahaMessageText.value,
    session: WAHA_API_SESSION,
  });

  const config = {
    method: "post",
    url: WAHA_API_MESSAGE_URL,
    headers: {
      "X-Api-Key": WAHA_API_KEY,
      Accept: "application/json",
      "Content-Type": "application/json",
    },
    data: data,
  };
  axios(config)
    .then((response) => {
      emit("submitted", response.data); // You may modify this based on your response structure
      eventBus.emit("show-toast", {
        severity: "success",
        summary: "Message sent",
        detail: "Message sent successfully.",
        life: 5000,
      });
      // Add any success handling here
    })
    .catch((error) => {
      // console.log(error);
      // Add error handling here
    });
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
