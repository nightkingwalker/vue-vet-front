<template>
  <div class="w-full">
    <form @submit.prevent="submitForm" class="mt-2 md:mx-auto md:w-3/4 sm:mx-8 sm:w-full">
      <fieldset
        class="p-fieldset p-component w-full flex flex-wrap items-center border rounded-lg p-2 justify-start gap-x-2">
        <legend>{{ $t("add_medical_image.title") }}</legend>

        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full">
            <InputText fluid id="ref_number" v-model="medicalImage.ref_number" />
            <label for="ref_number">{{
              $t("add_medical_image.fields.ref_number")
            }}</label>
          </FloatLabel>
        </div>
        <Button type="button" icon="pi pi-refresh" @click="generateRefNumber" :pt="{ root: { class: 'p-button-sm' } }"
          v-tooltip="$t('add_medical_image.generate_tooltip')" />
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
            <Select fluid v-model="medicalImage.type" :options="imageTypes" optionLabel="label" class="w-full" />
            <label for="type">{{ $t("add_medical_image.fields.type") }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full">
            <DatePicker showIcon iconDisplay="input" showButtonBar fluid id="image_date"
              v-model="medicalImage.image_date" dateFormat="yy-mm-d" class="w-full" />
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
        <!-- <div class="field m-8 mt-6 w-full border borde-gray-200 p-8">
          <FileUpload mode="basic" name="demo[]" url="/api/upload" accept="image/*" :maxFileSize="1000000"
            @upload="onUpload" :auto="true" chooseLabel="Browse" />
        </div> -->
        <div class="field m-8 !mt-6 w-full border borde-gray-500 p-8 rounded-lg">
          <label class="block mb-2">{{ $t("add_medical_image.fields.file") }}</label>
          <FileUpload name="files[]" :multiple="true" accept="image/*" :maxFileSize="1000000" :customUpload="true"
            @select="onFileSelect" :fileLimit="5" chooseLabel="Select Files">
            <template #empty>
              <p>{{ $t('add_medical_image.drag_and_drop') }}</p>
            </template>
            <template #content="{ files, removeFileCallback }">
              <div v-if="files.length > 0" class="my-3">
                <div v-for="(file, index) in files" :key="file.name + index"
                  class="flex items-center justify-between p-2 border rounded mb-2">
                  <span>{{ file.name }}</span>
                  <Button icon="pi pi-times" @click="removeFileCallback(index)" text rounded severity="danger"
                    size="small" />
                </div>
              </div>
            </template>
          </FileUpload>

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
import FileUpload from "primevue/fileupload";

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
// const medicalImage = ref({
//   ref_number: "US-100246",
//   description: "Ultrasound of left kidney reveals a 2cm x 3cm mass; no hydronephrosis.",
//   organ: "Left Kidney",
//   measurements: "2cm x 3cm",
//   type: "Ultrasound",
//   abnormalities: "Mass detected; needs further evaluation (biopsy recommended)",
//   image_date: new Date("2025-03-06T12:36:19"),

// });
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
const uploadedFiles = ref([]);

const onFileSelect = (event) => {
  // Store the selected files
  uploadedFiles.value = event.files;
};

const submitForm = async () => {
  const submissionData = new FormData();

  submissionData.append("medical_record_id", props.medical_record_id);
  submissionData.append("ref_number", medicalImage.value.ref_number);
  submissionData.append("description", medicalImage.value.description);
  submissionData.append("organ", medicalImage.value.organ);
  submissionData.append("measurements", medicalImage.value.measurements);
  submissionData.append("type", medicalImage.value.type.value);
  submissionData.append("abnormalities", medicalImage.value.abnormalities);
  if (medicalImage.value.image_date) {
    submissionData.append(
      "image_date",
      medicalImage.value.image_date.toLocaleDateString("en-CA")
    );
  }

  // Append all selected files
  uploadedFiles.value.forEach((file) => {
    submissionData.append("files[]", file);
  });

  try {
    const response = await axiosInstance.post("/medical-images", submissionData, {
      headers: { "Content-Type": "multipart/form-data" },
    });
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
