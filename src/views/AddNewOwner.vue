<template>
  <div class="px-4">
    <form @submit.prevent="submitForm" class="mx-auto w-full">
      <fieldset
        class="p-fieldset p-component w-full flex flex-wrap items-start border rounded-lg p-4 gap-4"
      >
        <legend
          class="px-4 bg-gray-600 text-white dark:bg-zinc-200 dark:text-zinc-800 rounded"
        >
          {{ $t("add_owner.title") }}
        </legend>

        <!-- Name Field -->
        <div class="field w-full">
          <FloatLabel class="w-full">
            <InputText fluid id="name" v-model="owner.name" />
            <label for="name">{{ $t("add_owner.fields.name") }}</label>
          </FloatLabel>
        </div>

        <!-- Email Field -->
        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <InputText fluid id="email" v-model="owner.email" type="email" class="ltr" />
            <label for="email">{{ $t("add_owner.fields.email") }}</label>
          </FloatLabel>
        </div>

        <!-- Phone Field -->
        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <vue-tel-input
              id="phone"
              v-model="rawPhoneInput"
              mode="international"
              :inputOptions="phoneInputOptions"
              :dropdownOptions="phoneDropdownOptions"
              @validate="validatePhone"
              class="phone-input rounded-[var(--p-inputtext-border-radius)] border-var(--p-inputtext-border-color) outline-0 ltr"
            />
            <label for="phone">{{ $t("add_owner.fields.phone") }}</label>
          </FloatLabel>
          <small v-if="phoneError" class="p-error">{{ phoneError }}</small>
        </div>
        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <InputText fluid id="landline" v-model="owner.landline" />
            <label for="landline">{{ $t("add_owner.fields.landline") }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <DatePicker
              showIcon
              iconDisplay="input"
              showButtonBar
              fluid
              id="birth_date"
              v-model="owner.birth_date"
              dateFormat="yy-mm-dd"
            />
            <label for="birth_date">{{ $t("add_owner.fields.birth_date") }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <InputText fluid id="facebook_link" v-model="owner.facebook_link" />
            <label for="facebook_link">{{ $t("add_owner.fields.facebook_link") }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <InputText fluid id="instagram_link" v-model="owner.instagram_link" />
            <label for="instagram_link">{{
              $t("add_owner.fields.instagram_link")
            }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-full">
          <FloatLabel class="w-full">
            <TextArea autoResize fluid id="referral" v-model="owner.referral" rows="4" />
            <label for="referral">{{ $t("add_owner.fields.referral") }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <TextArea autoResize fluid id="address" v-model="owner.address" rows="4" />
            <label for="address">{{ $t("add_owner.fields.address") }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <TextArea
              autoResize
              fluid
              id="clinic_notes"
              v-model="owner.clinic_notes"
              rows="4"
            />
            <label for="clinic_notes">{{ $t("add_owner.fields.clinic_notes") }}</label>
          </FloatLabel>
        </div>

        <Button
          type="submit"
          :label="$t('add_owner.actions.submit')"
          icon="pi pi-check"
          class="mt-4 w-full"
        />
      </fieldset>
    </form>
  </div>
</template>

<script setup>
import { ref, computed } from "vue";
import { useI18n } from "vue-i18n";
import axiosInstance from "@/axios";
import InputText from "primevue/inputtext";
import TextArea from "primevue/textarea";
import FloatLabel from "primevue/floatlabel";
import Button from "primevue/button";
import DatePicker from "primevue/datepicker";
import Calendar from "primevue/calendar";
import eventBus from "@/eventBus";
import router from "@/router";
import Cookies from "js-cookie";
import { VueTelInput } from "vue-tel-input";
import "vue-tel-input/vue-tel-input.css";

const { t } = useI18n();
const emit = defineEmits(["submitted"]);

// Refs
const rawPhoneInput = ref("");
const phoneError = ref(null);
const owner = ref(createInitialOwner());
const phoneInputOptions = ref({
  showDialCode: true,
  required: true,
  styleClasses: "w-full p-inputtext p-inputtext-fluid p-filled !border-0",
});

const phoneDropdownOptions = ref({
  showDialCodeInList: true,
  showFlags: true,
  tabindex: 0,
});

// Computed
const cleanedPhoneNumber = computed(() => {
  return rawPhoneInput.value.replace(/\D/g, "");
});

// Functions
function createInitialOwner() {
  return {
    name: "",
    email: "",
    phone: "",
    landline: "",
    address: "",
    birth_date: null,
    facebook_link: "",
    instagram_link: "",
    referral: "",
    clinic_notes: "",
    branch_id: Cookies.get("M3K8g2387BahBaqyjDe6"),
  };
}

function validatePhone(phoneData) {
  if (!phoneData?.valid) {
    phoneError.value = t("add_owner.errors.invalid_phone");
    return;
  }

  // 1. Get the properly formatted international number from vue-tel-input
  const formattedNumber = phoneData.number; // "+963 44 465 4654 123"

  // 2. Clean while preserving international format:
  // - Remove all whitespace
  // - Keep the + prefix
  // owner.value.phone = formattedNumber.replace(/\s+/g, ""); // "+963444654654123"

  // Alternative if you want to store without + prefix:
  owner.value.phone = formattedNumber.replace(/\D/g, ""); // "963444654654123"

  phoneError.value = null;
}
async function submitForm() {
  if (phoneError.value) return;
  try {
    owner.value.birth_date = formatDate(owner.value.birth_date);
    const response = await axiosInstance.post("/owners", owner.value);

    emit("ownerAdded", response.data);
    showToast("success", t("add_owner.messages.success"));
    await router.push("/owners");
  } catch (error) {
    console.error("Failed to add owner:", error);
    showToast("error", t("add_owner.messages.error"));
  }
}

function formatDate(isoDateString) {
  return isoDateString ? new Date(isoDateString).toISOString().split("T")[0] : null;
}

function showToast(severity, detail) {
  eventBus.emit("show-toast", {
    severity,
    summary: t("add_owner.title"),
    detail,
    life: 5000,
  });
}
</script>

<style scoped>
body.dark .text-sm {
  color: #ccc;
}
body .text-sm {
  color: #333;
}
</style>
