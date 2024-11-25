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
        <button
          type="submit"
          class="p-button p-button-content py-2 px-4 rounded focus:outline-none focus:shadow-outline h-8"
          :disabled="loading"
        >
          <i class="fa-solid fa-spinner fa-spin" v-if="loading"></i>
          <span v-else>Send</span>
        </button>
        <!-- <Button type="submit" class="mt-4 w-full" > -->
        <!-- <i class="fa-solid fa-spinner fa-spin" v-if="loading"></i> -->
      </fieldset>
    </form>
  </div>
</template>

<script setup>
// Import necessary modules from Vue and third-party libraries
import { ref } from "vue"; // Reactive data for form inputs
import Textarea from "primevue/textarea";
import FloatLabel from "primevue/floatlabel";
import Button from "primevue/button";
import eventBus from "@/eventBus";
import axios from "axios";

// Environment variables for API configuration
const WAHA_API_KEY = import.meta.env.VITE_WAHA_API_KEY;
const WAHA_API_URL = import.meta.env.VITE_WAHA_API_URL;
const WAHA_API_SESSION = import.meta.env.VITE_WAHA_API_SESSION;
const loading = ref(false);
// Define the form data with reactive properties
const owner = ref({
  name: "",
  email: "",
  phone: "",
  address: "",
});

// Define props passed into the component
const props = defineProps({
  contactNumber: String, // Expected contact number to send WhatsApp messages
});

// Initialize reactive variables for message and contact number
const wahaMessageText = ref("");
const wahaMessageNumber = props.contactNumber;

// Emit the 'submitted' event after form submission
const emit = defineEmits(["submitted"]);

// Utility function to simulate delay (sleep) for WhatsApp typing animation
const sleep = (milliseconds) =>
  new Promise((resolve) => setTimeout(resolve, milliseconds));

// Handle form submission
const submitForm = async () => {
  loading.value = true;
  whatsAppStartTyping(); // Begin the typing indicator

  // Random delay between 3-6 seconds
  const randomDelay = Math.floor(Math.random() * (6 - 3 + 1) + 3) * 1000;

  // Wait for a random delay, then stop typing and send the message
  await sleep(randomDelay);
  whatsAppStopTyping();
  whatsAppSendText();
  loading.value = false;
};

// Function to send a message via WhatsApp API
const whatsAppSendText = async () => {
  // Check if the message is too short
  if (wahaMessageText.value.length <= 5) {
    // Show an alert or toast message that the message is too short
    eventBus.emit("show-toast", {
      severity: "error",
      summary: "Message too short",
      detail: "Your message must be longer than 5 characters to be sent.",
      life: 5000, // Toast duration
    });
    return; // Exit the function early if the message is too short
  }

  // Proceed with sending the message if it's valid
  const data = JSON.stringify({
    chatId: `${props.contactNumber}@c.us`, // WhatsApp chat ID (formatted)
    reply_to: "", // Empty reply-to value (can be customized if needed)
    text: wahaMessageText.value, // Message content
    session: WAHA_API_SESSION, // Session ID for the API
  });

  const config = {
    method: "post",
    url: `${WAHA_API_URL}sendText`, // API endpoint to send a message
    headers: {
      "X-Api-Key": WAHA_API_KEY, // API key for authentication
      Accept: "application/json",
      "Content-Type": "application/json",
    },
    data: data, // The message data to be sent
  };

  // Perform the API request to send the message
  axios(config)
    .then((response) => {
      emit("submitted", response.data); // Emit success event with response data
      eventBus.emit("show-toast", {
        severity: "success",
        summary: "Message sent",
        detail: "Message sent successfully.",
        life: 5000, // Toast duration
      });
    })
    .catch((error) => {
      // Handle errors here if needed (e.g., show error toast)
      console.error("Error sending message:", error);
    });
};

// Function to start the typing indicator on WhatsApp
const whatsAppStartTyping = () => {
  const data = JSON.stringify({
    chatId: `${props.contactNumber}@c.us`, // WhatsApp chat ID
    session: WAHA_API_SESSION, // Session ID for the API
  });

  const config = {
    method: "post",
    url: `${WAHA_API_URL}startTyping`, // API endpoint to start typing animation
    headers: {
      "X-Api-Key": WAHA_API_KEY,
      Accept: "application/json",
      "Content-Type": "application/json",
    },
    data: data,
  };

  // Perform the API request to start typing animation
  axios(config)
    .then(() => {
      // Optional: Handle success or no response
    })
    .catch((error) => {
      // Handle errors here if needed
      console.error("Error starting typing:", error);
    });
};

// Function to stop the typing indicator on WhatsApp
const whatsAppStopTyping = () => {
  const data = JSON.stringify({
    chatId: `${props.contactNumber}@c.us`, // WhatsApp chat ID
    session: WAHA_API_SESSION, // Session ID for the API
  });

  const config = {
    method: "post",
    url: `${WAHA_API_URL}startTyping`, // API endpoint to stop typing animation
    headers: {
      "X-Api-Key": WAHA_API_KEY,
      Accept: "application/json",
      "Content-Type": "application/json",
    },
    data: data,
  };

  // Perform the API request to stop typing animation
  axios(config)
    .then(() => {
      // Optional: Handle success or no response
    })
    .catch((error) => {
      // Handle errors here if needed
      console.error("Error stopping typing:", error);
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
