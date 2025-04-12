<template>
  <div class="w-full">
    <form @submit.prevent="submitForm" class="mt-2 md:mx-auto md:w-3/4 sm:mx-8 sm:w-full">
      <fieldset
        class="p-fieldset p-component w-full flex flex-wrap items-center border rounded-lg p-2 justify-start gap-x-2"
      >
        <legend>{{ $t("add_treatment.title") }}</legend>
        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full">
            <InputText fluid id="name" v-model="treatment.name" />
            <label for="name">{{ $t("add_treatment.fields.name") }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full">
            <InputText fluid id="dosage" v-model="treatment.dosage" />
            <label for="dosage">{{ $t("add_treatment.fields.dosage") }}</label>
          </FloatLabel>
        </div>
        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-[95%]">
            <Select
              fluid
              v-model="treatment.administration"
              :options="medicineAdministrationMethods"
              optionLabel="label"
              class="w-full h-10"
            >
              <template #value="slotProps">
                <div v-if="slotProps.value" class="flex items-center">
                  <div>{{ slotProps.value.value }}</div>
                </div>
                <!-- <span v-else>
                  {{ $t("add_treatment.fields.delivery") }}
                </span> -->
              </template>
              <template #option="slotProps">
                <div class="flex items-center">
                  <div>{{ slotProps.option.label }}</div>
                </div>
              </template>
            </Select>

            <label for="dd-city">{{ $t("add_treatment.fields.delivery") }}</label>
          </FloatLabel>
        </div>
        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full">
            <InputText fluid id="description" v-model="treatment.description" />
            <label for="description">{{ $t("add_treatment.fields.description") }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full">
            <DatePicker
              showIcon
              iconDisplay="input"
              showButtonBar
              showTime
              hourFormat="12"
              fluid
              id="treatment_date"
              class="w-full"
              v-model="treatment.treatment_date"
              dateFormat="yy-mm-dd"
            />
            <label for="treatment_date">{{
              $t("add_treatment.fields.treatment_date")
            }}</label>
          </FloatLabel>
        </div>
      </fieldset>
      <div class="flex justify-end">
        <Button type="submit" class="mt-4" :label="$t('add_treatment.submit')" />
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref } from "vue";
import { useI18n } from "vue-i18n";
import InputText from "primevue/inputtext";
import DatePicker from "primevue/datepicker";
import Select from "primevue/select";
import FloatLabel from "primevue/floatlabel";
import Button from "primevue/button";
import axiosInstance from "@/axios";
import eventBus from "@/eventBus";
import { useRoute } from "vue-router";

const { t } = useI18n();
const emit = defineEmits();
const route = useRoute();
const props = defineProps({
  medical_record_id: {
    type: Number,
    required: true,
  },
});

const treatment = ref({
  name: "",
  dosage: "",
  description: "",
  administration: "",
  treatment_date: "",
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
]);

const submitForm = async () => {
  const submissionData = {
    medical_record_id: props.medical_record_id,
    name: treatment.value.name,
    dosage: treatment.value.dosage,
    administration: treatment.value.administration.value,
    description: treatment.value.description,
    treatment_date: treatment.value.treatment_date
      ? treatment.value.treatment_date.toLocaleDateString("en-CA")
      : null,
  };

  try {
    const response = await axiosInstance.post("/treatments", submissionData);
    eventBus.emit("show-toast", {
      severity: "success",
      summary: t("add_treatment.title"),
      detail: t("add_treatment.toast.success"),
      life: 5000,
    });
    emit("TreatmentAdded", response.data);
  } catch (error) {
    eventBus.emit("show-toast", {
      severity: "warn",
      summary: t("add_treatment.title"),
      detail: t("add_treatment.toast.error"),
      life: 5000,
    });
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
