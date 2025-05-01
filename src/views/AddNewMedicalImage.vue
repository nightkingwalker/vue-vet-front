<template>
  <div class="w-full">
    <form @submit.prevent="submitForm" class="mt-2 md:mx-auto md:w-3/4 sm:mx-8 sm:w-full">
      <fieldset
        class="p-fieldset p-component w-full flex flex-wrap items-center border rounded-lg p-2 justify-start gap-x-2"
      >
        <legend>{{ $t("add_medical_image.title") }}</legend>

        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full">
            <InputText fluid id="ref_number" v-model="medicalImage.ref_number" />
            <label for="ref_number">{{
              $t("add_medical_image.fields.ref_number")
            }}</label>
          </FloatLabel>
        </div>
        <Button
          type="button"
          icon="pi pi-refresh"
          @click="generateRefNumber"
          :pt="{ root: { class: 'p-button-sm' } }"
          v-tooltip="$t('add_medical_image.generate_tooltip')"
        />
        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full">
            <InputText fluid id="organ" v-model="medicalImage.organ" />
            <label for="organ">{{ $t("add_medical_image.fields.organ") }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full">
            <InputText fluid id="measurements" v-model="medicalImage.measurements" />
            <label for="measurements">{{
              $t("add_medical_image.fields.measurements")
            }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full">
            <Select
              fluid
              v-model="medicalImage.type"
              :options="imageTypes"
              optionLabel="label"
              class="w-full"
            />
            <label for="type">{{ $t("add_medical_image.fields.type") }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full">
            <DatePicker
              showIcon
              iconDisplay="input"
              showButtonBar
              fluid
              id="image_date"
              v-model="medicalImage.image_date"
              dateFormat="yy-mm-d"
              class="w-full"
            />
            <label for="image_date">{{
              $t("add_medical_image.fields.image_date")
            }}</label>
          </FloatLabel>
        </div>
        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full">
            <Textarea fluid id="abnormalities" v-model="medicalImage.abnormalities" />
            <label for="abnormalities">{{
              $t("add_medical_image.fields.abnormalities")
            }}</label>
          </FloatLabel>
        </div>
        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full">
            <Textarea fluid id="description" v-model="medicalImage.description" />
            <label for="description">{{
              $t("add_medical_image.fields.description")
            }}</label>
          </FloatLabel>
        </div>
        <Button type="submit" :label="$t('add_medical_image.submit')" class="mt-4" />
      </fieldset>
    </form>
  </div>
</template>

<script setup>
import { ref } from "vue";
import { useI18n } from "vue-i18n";
import InputText from "primevue/inputtext";
import Textarea from "primevue/textarea";
import DatePicker from "primevue/datepicker";
import Select from "primevue/select";
import FloatLabel from "primevue/floatlabel";
import Button from "primevue/button";
import axiosInstance from "@/axios";
import eventBus from "@/eventBus";

const { t } = useI18n();
const emit = defineEmits(["submitted"]);

const props = defineProps({
  medical_record_id: {
    type: Number,
    required: true,
  },
});

const medicalImage = ref({
  ref_number: "",
  description: "",
  organ: "",
  measurements: "",
  type: "",
  abnormalities: "",

  image_date: null,
});
const generateRefNumber = () => {
  const prefix = medicalImage.value.type?.value
    ? medicalImage.value.type.value.substring(0, 2).toUpperCase()
    : "IM";
  const timestamp = new Date().getTime().toString().slice(-6);
  medicalImage.value.ref_number = `${prefix}-${timestamp}`;
};
const imageTypes = ref([
  { label: t("add_medical_image.image_types.ultrasound"), value: "Ultrasound" },
  { label: t("add_medical_image.image_types.xray"), value: "X-ray" },
]);

const submitForm = async () => {
  const submissionData = {
    medical_record_id: props.medical_record_id,
    ref_number: medicalImage.value.ref_number,
    description: medicalImage.value.description,
    organ: medicalImage.value.organ,
    measurements: medicalImage.value.measurements,
    type: medicalImage.value.type.value,
    abnormalities: medicalImage.value.abnormalities,

    image_date: medicalImage.value.image_date
      ? medicalImage.value.image_date.toLocaleDateString("en-CA")
      : null,
  };

  try {
    const response = await axiosInstance.post("/medical-images", submissionData);
    eventBus.emit("show-toast", {
      severity: "success",
      summary: t("add_medical_image.toast.title"),
      detail: t("add_medical_image.toast.success"),
      life: 5000,
    });

    emit("NewImageAdded", response.data);
  } catch (error) {
    eventBus.emit("show-toast", {
      severity: "error",
      summary: t("add_medical_image.toast.title"),
      detail: error.response?.data?.message || t("add_medical_image.toast.error"),
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
