<template>
  <div class="px-4 lg:text-[12px]">
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
            <InputText
              fluid
              id="name"
              :invalid="invalid.owner.name"
              v-model="owner.name"
            />
            <label for="name"
              >{{ $t("add_owner.fields.name") }}
              <span class="text-red-600">*</span></label
            >
          </FloatLabel>
          <span class="text-[10px] text-red-600" v-if="invalid.owner.name">{{
            $t("form_messages.warnings.invalid_input")
          }}</span>
        </div>

        <!-- Email Field -->
        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <InputText fluid id="email" v-model="owner.email" type="email" class="ltr" />
            <label for="email">{{ $t("add_owner.fields.email") }} </label>
          </FloatLabel>
          <span class="text-[10px] text-red-600" v-if="invalid.owner.email">{{
            $t("form_messages.warnings.invalid_input")
          }}</span>
        </div>

        <!-- Phone Field -->
        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <vue-tel-input
              id="phone"
              v-model="rawPhoneInput"
              mode="international"
              :inputOptions="phoneInputOptions"
              :invalid="invalid.owner.phone"
              :dropdownOptions="phoneDropdownOptions"
              @validate="validatePhone"
              required
              class="phone-input rounded-[var(--p-inputtext-border-radius)] border-var(--p-inputtext-border-color) outline-0 ltr"
            />
            <label for="phone"
              >{{ $t("add_owner.fields.phone") }}
              <span class="text-red-600">*</span></label
            >
          </FloatLabel>
          <small v-if="phoneError" class="p-error text-[10px] text-red-600">{{
            phoneError
          }}</small>
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
              dateFormat="yy-mm-d"
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
            <TextArea
              autoResize
              fluid
              id="address"
              :invalid="invalid.owner.address"
              v-model="owner.address"
              rows="4"
            />
            <label for="address"
              >{{ $t("add_owner.fields.address") }}
              <span class="text-red-600">*</span></label
            >
          </FloatLabel>
          <span class="text-[10px] text-red-600" v-if="invalid.owner.name">{{
            $t("form_messages.warnings.invalid_input")
          }}</span>
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
          class="mt-4 w-full lg:text-[12px]"
        />
      </fieldset>
    </form>
  </div>
</template>

<script setup>
import axiosInstance from "@/axios";
import eventBus from "@/eventBus";
import Cookies from "js-cookie";
import Button from "primevue/button";
import DatePicker from "primevue/datepicker";
import FloatLabel from "primevue/floatlabel";
import InputText from "primevue/inputtext";
import TextArea from "primevue/textarea";
import { computed, ref } from "vue";
import { useI18n } from "vue-i18n";
import { VueTelInput } from "vue-tel-input";
import "vue-tel-input/vue-tel-input.css";

const { t } = useI18n();
const emit = defineEmits(["submitted"]);
const invalid = ref({ owner: {} });
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
  /**
   * Creates an initial owner object with default values.
   * @returns {{name: string, email: string, phone: string, landline: string, address: string, birth_date: null, facebook_link: string, instagram_link: string, referral: string, clinic_notes: string, branch_id: string}}
   */
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
  /**
   * Validates the phone number and updates the owner's phone property accordingly.
   * @param {{valid: boolean, number: string}} phoneData - The data returned from vue-tel-input.
   */
  if (!phoneData?.valid) {
    phoneError.value = t("add_owner.errors.invalid_phone");
    invalid.value.owner.phone = true;
    
    return;
  }

  // Clean the number while preserving international format:
  const formattedNumber = phoneData.number; // "+963 44 465 4654 123"
  owner.value.phone = formattedNumber.replace(/\D/g, ""); // "963444654654123"

  phoneError.value = null;
}

async function submitForm() {
  /**
   * Submits the form data to add a new owner.
   */
  invalid.value.owner = {
    name: owner.value.name === "" ? true : false,
    phone: owner.value.phone === "" ? true : false,
    address: owner.value.address === "" ? true : false,
  };

  if (
    invalid.value.owner.name ||
    invalid.value.owner.phone ||
    invalid.value.owner.address
  ) {
    return;
  }

  try {
    owner.value.birth_date = formatDate(owner.value.birth_date);
    const response = await axiosInstance.post("/owners", owner.value);

    emit("ownerAdded", response.data);
    showToast("success", t("add_owner.messages.success"));
  } catch (error) {
    console.error("Failed to add owner:", error);
    showToast("error", t("add_owner.messages.error"));
  }
}

function formatDate(isoDateString) {
  /**
   * Formats an ISO date string to a readable date format.
   * @param {string} isoDateString - The ISO date string to be formatted.
   * @returns {string|null} - The formatted date string or null if the input is falsy.
   */
  return isoDateString ? new Date(isoDateString).toISOString().split("T")[0] : null;
}

function showToast(severity, detail) {
  /**
   * Emits an event to display a toast notification with the given severity and detail.
   * @param {string} severity - The severity of the toast (e.g., "success", "error").
   * @param {string} detail - The detail message to be displayed in the toast.
   */
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
