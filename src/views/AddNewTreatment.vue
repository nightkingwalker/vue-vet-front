<template>
  <div class="w-full">
    <form @submit.prevent="submitForm" class="mt-2 md:mx-auto md:w-3/4 sm:mx-8 sm:w-full">
      <fieldset
        class="p-fieldset p-component w-full flex flex-wrap items-center border rounded-lg p-2 justify-start gap-x-2"
      >
        <legend>{{ $t("add_treatment.title") }}</legend>
        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full">
            <!--             <InputText
              fluid
              id="name"
              :autocomplete="`treatment-name`"
              v-model="treatment.name"
            /> -->
            <AutoComplete
              autoFocus
              fluid
              required
              v-model="treatment.name"
              optionLabel="name"
              :suggestions="filteredTreatments"
              @complete="getTreatments"
              @item-select="onTreatmentSelect"
              class="w-full"
            >
              <template #option="slotProps">
                <div class="flex items-center">
                  <div>{{ slotProps.option.name }}</div>
                </div>
              </template>
              <!--               <template #footer>
                <Button
                  :label="$t('pet_form.buttons.add_new_owner')"
                  icon="pi pi-plus"
                  @click="addNewOwner"
                  class="p-button-text w-full"
                />
              </template> -->
            </AutoComplete>
            <label for="name"
              >{{ $t("add_treatment.fields.name") }}
              <span class="text-red-600">*</span></label
            >
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full">
            <InputText fluid id="dosage" v-model="treatment.dosage" />
            <label for="dosage"
              >{{ $t("add_treatment.fields.dosage") }}
              <span class="text-red-600">*</span></label
            >
          </FloatLabel>
        </div>
        <!-- Animal Weight -->
        <div class="field mt-6 w-1/ w-[49%]">
          <FloatLabel class="w-full">
            <InputNumber
              v-model="treatment.animal_weight"
              :step="0.25"
              inputId="animal_weight"
              showButtons
              mode="decimal"
              suffix=" kg"
              :min="0"
              :max="500"
              fluid
              :minFractionDigits="2"
            />
            <label for="animal_weight"
              >{{ $t("add_treatment.fields.animal_weight") }}
              <span class="text-red-600">*</span></label
            >
          </FloatLabel>
        </div>
        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full">
            <Select
              fluid
              v-model="treatment.administration"
              :options="medicineAdministrationMethods"
              optionLabel="label"
              class="w-full h-10"
            >
              <!-- <template #value="slotProps">
                <div v-if="slotProps.value" class="flex items-center">
                  <div>{{ slotProps.value.value }}</div>
                </div>
              </template>
              <template #option="slotProps">
                <div class="flex items-center">
                  <div>{{ slotProps.option.label }}</div>
                </div>
              </template> -->
            </Select>
            <label for="dd-city"
              >{{ $t("add_treatment.fields.delivery") }}
              <span class="text-red-600">*</span></label
            >
          </FloatLabel>
        </div>
        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full">
            <InputText fluid id="description" v-model="treatment.description" />
            <label for="description"
              >{{ $t("add_treatment.fields.description") }}
              <span class="text-red-600">*</span></label
            >
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full">
            <DatePicker
              showIcon
              iconDisplay="input"
              showButtonBar
              hourFormat="12"
              fluid
              id="treatment_date"
              class="w-full"
              v-model="treatment.treatment_date"
              dateFormat="yy-mm-d"
              mask="2025-04-04"
            />
            <label for="treatment_date"
              >{{ $t("add_treatment.fields.treatment_date") }}
              <span class="text-red-600">*</span></label
            >
          </FloatLabel>
        </div>

        <!-- New fields -->
        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full">
            <DatePicker
              showIcon
              iconDisplay="input"
              showButtonBar
              hourFormat="12"
              fluid
              id="treatment_next_date"
              class="w-full"
              v-model="treatment.treatment_next_date"
              dateFormat="yy-mm-d"
              mask="2025-04-04"
            />
            <label for="treatment_next_date">{{
              $t("add_treatment.fields.treatment_next_date")
            }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[49%] flex items-center">
          <ToggleSwitch
            v-model="treatment.treatment_has_reminder"
            :binary="true"
            inputId="treatment_has_reminder"
            class="rtl:ml-2 ltr:mr-2"
          />
          <label for="treatment_has_reminder" class="ml-2">
            {{ $t("add_treatment.fields.treatment_has_reminder") }}
          </label>
        </div>
      </fieldset>
      <div class="flex justify-end">
        <!-- <Button type="submit" class="mt-4" :label="$t('add_treatment.submit')" /> -->
        <Button type="submit" :disabled="isSubmitting ? true : false">
          <i class="fa-solid fa-spinner fa-spin" v-if="isSubmitting"></i>
          <span v-else>{{ $t("add_treatment.submit") }}</span>
        </Button>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref } from "vue";
import { useI18n } from "vue-i18n";
import InputText from "primevue/inputtext";
import AutoComplete from "primevue/autocomplete";
// import Cookies from "js-cookie";
// import InputMask from "primevue/inputmask";
import ToggleSwitch from "primevue/toggleswitch";
import DatePicker from "primevue/datepicker";
import Select from "primevue/select";
import InputNumber from "primevue/inputnumber";
import FloatLabel from "primevue/floatlabel";
import Button from "primevue/button";
import axiosInstance from "@/axios";
import eventBus from "@/eventBus";
import { useRoute } from "vue-router";
const treatements = ref([]);
const filteredTreatments = ref([]);
const { t } = useI18n();
const emit = defineEmits();
const route = useRoute();
const props = defineProps({
  medical_record_id: {
    type: Number,
    required: true,
  },
});
const isSubmitting = ref(false);
const treatment = ref({
  name: "",
  dosage: "",
  description: "",
  animal_weight: 0,
  administration: "",
  treatment_date: new Date(),
  treatment_next_date: null,
  treatment_has_reminder: false,
});

const medicineAdministrationMethods = ref([
  { label: t("add_treatment.administration_methods.oral"), value: "Oral" },
  {
    label: t("add_treatment.administration_methods.subcutaneous"),
    value: "Subcutaneous",
  },
  {
    label: t("add_treatment.administration_methods.intramuscular"),
    value: "Intramuscular",
  },
  { label: t("add_treatment.administration_methods.intravenous"), value: "Intravenous" },
  { label: t("add_treatment.administration_methods.topical"), value: "Topical" },
  { label: t("add_treatment.administration_methods.transdermal"), value: "Transdermal" },
  { label: t("add_treatment.administration_methods.ophthalmic"), value: "Ophthalmic" },
  { label: t("add_treatment.administration_methods.otic"), value: "Otic" },
  { label: t("add_treatment.administration_methods.inhalation"), value: "Inhalation" },
  { label: t("add_treatment.administration_methods.rectal"), value: "Rectal" },
  { label: t("add_treatment.administration_methods.sublingual"), value: "Sublingual" },
  { label: t("add_treatment.administration_methods.intranasal"), value: "Intranasal" },
  {
    label: t("add_treatment.administration_methods.intraosseous"),
    value: "Intraosseous",
  },
  {
    label: t("add_treatment.administration_methods.intraperitoneal"),
    value: "Intraperitoneal",
  },
  {
    label: t("add_treatment.administration_methods.intrauterine"),
    value: "Intrauterine",
  },
  {
    label: t("add_treatment.administration_methods.intraconjunctival"),
    value: "Intraconjunctival",
  },
  {
    label: t("add_treatment.administration_methods.intraarticular"),
    value: "Intraarticular",
  },
]);

async function getTreatments(event) {
  try {
    const response = await axiosInstance.get(`/treatments/search`, {
      params: { query: event.query },
    });
    filteredTreatments.value = response.data;
  } catch (error) {
    console.error("Failed to fetch treatments:", error);
  }
}
function onTreatmentSelect(event) {
  treatment.value.name = event.value.name;
}
const submitForm = async () => {
  if (isSubmitting.value) return;
  const submissionData = {
    medical_record_id: props.medical_record_id,
    name: treatment.value.name,
    dosage: treatment.value.dosage,
    administration: treatment.value.administration.value,
    pet_weight: treatment.value.animal_weight,
    description: treatment.value.description,
    treatment_date: treatment.value.treatment_date
      ? treatment.value.treatment_date.toLocaleDateString("en-CA")
      : null,
    treatment_next_date: treatment.value.treatment_next_date
      ? treatment.value.treatment_next_date.toLocaleDateString("en-CA")
      : null,
    treatment_has_reminder: treatment.value.treatment_has_reminder ? 1 : 0,
  };
  
  try {
    isSubmitting.value = true;
    const response = await axiosInstance.post("/treatments", submissionData);
    eventBus.emit("show-toast", {
      severity: "success",
      summary: t("add_treatment.title"),
      detail: t("add_treatment.toast.success"),
      life: 5000,
    });
    isSubmitting.value = false;
    emit("TreatmentAdded", response.data);
  } catch (error) {
    eventBus.emit("show-toast", {
      severity: "warn",
      summary: t("add_treatment.title"),
      detail: t("add_treatment.toast.error"),
      life: 5000,
    });
    isSubmitting.value = false;
  }
};
</script>

<style scoped>
.form-container {
  margin: auto;
}
.field {
  margin-bottom: 16px;
}
.p-fieldset-content {
  display: flex;
}
</style>
