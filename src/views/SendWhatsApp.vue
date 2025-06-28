<template>
  <div class="whatsapp-form-container px-4">
    <form @submit.prevent="submitForm" class="whatsapp-form">
      <Fieldset :legend="$t('whatsapp.title')" class="whatsapp-fieldset">
        <!-- Message Textarea -->
        <div class="field w-full mb-6">
          <FloatLabel>
            <Textarea
              v-model="messageText"
              rows="5"
              class="w-full"
              :autoResize="true"
              :disabled="loading"
              aria-describedby="message-help"
            />
            <label>{{ $t("whatsapp.fields.message") }}</label>
          </FloatLabel>
          <small id="message-help" class="text-gray-500 dark:text-gray-400">
            {{ $t("whatsapp.messages.too_short_detail") }}
          </small>
        </div>

        <!-- Submit Button -->
        <div class="flex justify-end">
          <Button
            type="submit"
            :label="loading ? '' : $t('whatsapp.buttons.send')"
            :disabled="loading || messageText.length < 5"
            class="send-button"
          >
            <template #icon>
              <i v-if="loading" class="pi pi-spinner pi-spin mr-2"></i>
              <i v-else class="pi pi-send mr-2"></i>
            </template>
          </Button>
        </div>
      </Fieldset>
    </form>
  </div>
</template>

<script setup>
import { ref } from "vue";
import { useI18n } from "vue-i18n";
import Fieldset from "primevue/fieldset";
import Textarea from "primevue/textarea";
import FloatLabel from "primevue/floatlabel";
import Button from "primevue/button";
import eventBus from "@/eventBus";
import axiosInstance from "@/axios";

const { t } = useI18n();
const props = defineProps({
  contactNumber: String,
  ownerID: String,
});

const emit = defineEmits(["submitted"]);

const loading = ref(false);
const messageText = ref("");

const submitForm = async () => {
  if (messageText.value.length < 5) return;

  loading.value = true;

  try {
    await sendMessage();

    // showSuccessToast();
    messageText.value = ""; // Clear form after successful submission
  } catch (error) {
    showErrorToast(error);
  } finally {
    loading.value = false;
  }
};

// const sendMessage = async () => {
//   const response = await axiosInstance.post("/whatsapp/send", {
//     contact_number: props.contactNumber,
//     message: messageText.value,
//     ownerid: props.ownerID,
//   });
//   
//   return response.data;
// };
const sendMessage = async () => {
  try {
    const response = await axiosInstance.post("/whatsapp/send", {
      contact_number: props.contactNumber,
      message: messageText.value,
      ownerid: props.ownerID,
    });
    emit("submitted");
    showSuccessToast();
  } catch (error) {
    
    if (error.response.data.message === "Subscription Required") {
      eventBus.emit("show-toast", {
        severity: "warn",
        summary: t("whatsapp.messages.subscription_header"),
        detail: t("whatsapp.messages.subscription_details"),
        life: 5000,
      });
      return;
    }
    // Handle network errors or server errors
    let errorMessage = "Failed to send message";

    if (error.response) {
      // The request was made and the server responded with a status code
      errorMessage =
        error.response.data.message || `Server error: ${error.response.status}`;
    } else if (error.request) {
      // The request was made but no response was received
      errorMessage = "Network error - no response from server";
    }

    return {
      success: false,
      errorType: "network",
      message: errorMessage,
    };
  }
};

const showSuccessToast = () => {
  eventBus.emit("show-toast", {
    severity: "success",
    summary: t("whatsapp.messages.sent"),
    detail: t("whatsapp.messages.sent_detail"),
    life: 5000,
  });
};

const showErrorToast = (error) => {
  eventBus.emit("show-toast", {
    severity: "error",
    summary: t("whatsapp.messages.error"),
    detail: error.message,
    life: 5000,
  });
};
</script>

<style scoped>
.whatsapp-form-container {
  max-width: 36rem;
  margin: 0 auto;
}

.whatsapp-form {
  transition: all 0.3s ease;
}

.whatsapp-fieldset {
  border-radius: 12px;
  background: var(--surface-card);
  border: 1px solid var(--surface-border);
  box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
}

:deep(.p-fieldset-legend) {
  background: var(--primary-color);
  color: white;
  border-radius: 6px;
  padding: 0.5rem 1rem;
}

.send-button {
  transition: all 0.2s ease;
}

.send-button:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
}

/* Dark mode adjustments */
body.dark {
  .whatsapp-fieldset {
    background: var(--surface-800);
    border-color: var(--surface-700);
  }

  :deep(.p-fieldset-legend) {
    background: var(--primary-600);
  }
}
</style>
