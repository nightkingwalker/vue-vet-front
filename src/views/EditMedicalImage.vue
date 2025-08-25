<template>
  <div class="w-full">
    <form @submit.prevent="submitForm" class="mt-2 md:mx-auto md:w-3/4 sm:mx-8 sm:w-full">
      <fieldset
        class="p-fieldset p-component w-full flex flex-wrap items-center border rounded-lg p-2 justify-start gap-x-2">
        <legend>{{ $t("add_medical_image.title") }}</legend>

        <div class="field mt-6 w-[49%] flex items-center gap-2">
          <FloatLabel class="w-full">
            <InputText id="ref_number" v-model="medicalImage.ref_number" />
            <label for="ref_number">{{ $t("add_medical_image.fields.ref_number") }}</label>
          </FloatLabel>
          <Button type="button" icon="pi pi-refresh" @click="generateRefNumber" :pt="{ root: { class: 'p-button-sm' } }"
            v-tooltip="$t('add_medical_image.generate_tooltip')" />
        </div>

        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full">
            <InputText id="organ" v-model="medicalImage.organ" />
            <label for="organ">{{ $t("add_medical_image.fields.organ") }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full">
            <InputText id="measurements" v-model="medicalImage.measurements" />
            <label for="measurements">{{ $t("add_medical_image.fields.measurements") }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full">
            <Select v-model="medicalImage.type" :options="imageTypes" optionLabel="label" class="w-full" />
            <label for="type">{{ $t("add_medical_image.fields.type") }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full">
            <DatePicker showIcon iconDisplay="input" showButtonBar id="image_date" v-model="medicalImage.image_date"
              dateFormat="yy-mm-dd" class="w-full" />
            <label for="image_date">{{ $t("add_medical_image.fields.image_date") }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full">
            <Textarea id="abnormalities" v-model="medicalImage.abnormalities" />
            <label for="abnormalities">{{ $t("add_medical_image.fields.abnormalities") }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full">
            <Textarea id="description" v-model="medicalImage.description" />
            <label for="description">{{ $t("add_medical_image.fields.description") }}</label>
          </FloatLabel>
        </div>

        <!-- Existing Files Section -->
        <div class="field mt-6 w-full border border-gray-300 p-4 rounded-lg" v-if="existingFiles.length > 0">
          <label class="block mb-2 font-medium">{{ $t("add_medical_image.fields.existing_files") }}</label>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
            <div v-for="(file, index) in existingFiles" :key="file.id"
              class="flex items-center justify-between p-3 border rounded-lg bg-gray-50">
              <div class="flex items-center">
                <i class="pi pi-image mr-3 text-primary text-lg"></i>
                <div>
                  <img :src="`https://vet-api.ids-tech.net/storage/${file.file_path}`"
                    :alt="'Medical image ' + (file.file_name)"
                    style="width: 100%; display: block; max-height: 200px; object-fit: contain;" />
                  <p class="text-xs text-gray-500">{{ formatFileDate(file.created_at) }}</p>
                </div>
              </div>
              <div class="flex gap-1">
                <Button icon="pi pi-eye" @click="previewFile(file.file_path)" text rounded size="small"
                  v-tooltip="$t('add_medical_image.preview_file_tooltip')" />
                <Button icon="pi pi-trash" @click="confirmDeleteFile(file.id)" text rounded severity="danger"
                  size="small" v-tooltip="$t('add_medical_image.delete_file_tooltip')" />
              </div>
            </div>
          </div>
        </div>

        <!-- New File Upload Section -->
        <div class="field mt-6 w-full border border-gray-300 p-4 rounded-lg">
          <label class="block mb-2 font-medium">{{ $t("add_medical_image.fields.new_files") }}</label>

          <FileUpload name="files[]" :multiple="true" accept="image/*" :maxFileSize="1000000" :customUpload="true"
            @select="onFileSelect" :fileLimit="5" chooseLabel="Select Files" :showUploadButton="false"
            :showCancelButton="false">
            <template #empty>
              <div class="flex flex-col items-center justify-center py-4 text-gray-500">
                <i class="pi pi-cloud-upload text-3xl mb-2"></i>
                <p>{{ $t('add_medical_image.drag_and_drop') }}</p>
                <p class="text-xs mt-1">{{ $t('add_medical_image.file_limit') }}</p>
              </div>
            </template>
            <template #content="{ files, removeFileCallback }">
              <div v-if="files.length > 0" class="my-3">
                <div v-for="(file, index) in files" :key="file.name + index"
                  class="flex items-center justify-between p-2 border rounded mb-2 bg-blue-50">
                  <div class="flex items-center">
                    <i class="pi pi-file mr-2"></i>
                    <span class="text-sm">{{ file.name }}</span>
                    <span class="text-xs text-gray-500 ml-2">({{ formatFileSize(file.size) }})</span>
                  </div>
                  <Button icon="pi pi-times" @click="removeFileCallback(index)" text rounded severity="danger"
                    size="small" />
                </div>
              </div>
            </template>
          </FileUpload>
        </div>

        <div class="field mt-6 w-full flex justify-end">
          <Button type="submit" :label="$t('add_medical_image.submit')" icon="pi pi-check" :loading="submitting"
            class="min-w-[200px]" />
        </div>
      </fieldset>
    </form>

    <!-- Image Preview Dialog -->
    <Dialog v-model:visible="showPreview" :style="{ width: '80vw', maxWidth: '800px' }"
      :header="$t('add_medical_image.preview_title')" :modal="true">
      <div class="flex justify-center">
        <img :src="previewImageUrl" :alt="$t('add_medical_image.preview_alt')"
          class="max-w-full max-h-[70vh] object-contain" />
      </div>
      <template #footer>
        <Button :label="$t('common.close')" icon="pi pi-times" @click="showPreview = false" class="p-button-text" />
        <Button :label="$t('add_medical_image.download')" icon="pi pi-download"
          @click="downloadFile(previewImageUrl)" />
      </template>
    </Dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useI18n } from "vue-i18n";
import InputText from "primevue/inputtext";
import Textarea from "primevue/textarea";
import DatePicker from "primevue/datepicker";
import Select from "primevue/select";
import FloatLabel from "primevue/floatlabel";
import Button from "primevue/button";
import FileUpload from "primevue/fileupload";
import Dialog from "primevue/dialog";
import { useConfirm } from "primevue/useconfirm";
import axiosInstance from "@/axios";
import eventBus from "@/eventBus";

const { t } = useI18n();
const confirm = useConfirm();
const emit = defineEmits(["updated"]);

const props = defineProps({
  medicalImageId: {
    type: Number,
    required: true,
  },
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

const imageTypes = ref([
  { label: t("add_medical_image.image_types.ultrasound"), value: "Ultrasound" },
  { label: t("add_medical_image.image_types.xray"), value: "X-ray" },
]);

const uploadedFiles = ref([]);
const existingFiles = ref([]);
const submitting = ref(false);
const showPreview = ref(false);
const previewImageUrl = ref("");

// Fetch the existing medical image data
const fetchMedicalImage = async () => {
  try {
    const response = await axiosInstance.get(`/medical-images/${props.medicalImageId}`);
    const data = response.data;
    // console.log(data)
    medicalImage.value = {
      ...data,
      type: imageTypes.value.find((type) => type.value === data.type),
    };

    // Get existing files
    if (data.files && data.files.length > 0) {
      existingFiles.value = data.files;
    }
  } catch (error) {
    console.error("Failed to fetch medical image:", error);
    eventBus.emit("show-toast", {
      severity: "error",
      summary: t("add_medical_image.toast.error_fetch_title"),
      detail: t("add_medical_image.toast.error_fetch_detail"),
      life: 5000,
    });
  }
};

const generateRefNumber = () => {
  const prefix = medicalImage.value.type?.value
    ? medicalImage.value.type.value.substring(0, 2).toUpperCase()
    : "IM";
  const timestamp = new Date().getTime().toString().slice(-6);
  medicalImage.value.ref_number = `${prefix}-${timestamp}`;
};

const onFileSelect = (event) => {
  uploadedFiles.value = event.files;
};

const getFileName = (filePath) => {
  return filePath.split('/').pop();
};

const formatFileDate = (dateString) => {
  return new Date(dateString).toLocaleDateString();
};

const formatFileSize = (bytes) => {
  if (bytes === 0) return '0 Bytes';
  const k = 1024;
  const sizes = ['Bytes', 'KB', 'MB', 'GB'];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
};

const previewFile = (filePath) => {
  previewImageUrl.value = `https://vet-api.ids-tech.net/storage/${filePath}`;
  showPreview.value = true;
};

const downloadFile = (url) => {
  const link = document.createElement('a');
  link.href = url;
  link.download = url.split('/').pop();
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
};

const confirmDeleteFile = (fileId) => {
  confirm.require({
    message: t('add_medical_image.delete_file_confirm'),
    header: t('add_medical_image.delete_file_header'),
    icon: 'pi pi-exclamation-triangle',
    accept: () => {
      deleteFile(fileId);
    }
  });
};

const deleteFile = async (fileId) => {
  try {
    await axiosInstance.delete(`/medical-images/files/${fileId}`);

    // Remove from existing files list
    existingFiles.value = existingFiles.value.filter(file => file.id !== fileId);

    eventBus.emit("show-toast", {
      severity: "success",
      summary: t("add_medical_image.toast.file_deleted_title"),
      detail: t("add_medical_image.toast.file_deleted_detail"),
      life: 5000,
    });
  } catch (error) {
    console.error("Failed to delete file:", error);
    eventBus.emit("show-toast", {
      severity: "error",
      summary: t("add_medical_image.toast.error_file_delete_title"),
      detail: t("add_medical_image.toast.error_file_delete_detail"),
      life: 5000,
    });
  }
};

// Form submission for updating
const submitForm = async () => {
  submitting.value = true;
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
      typeof medicalImage.value.image_date === 'string'
        ? medicalImage.value.image_date
        : medicalImage.value.image_date.toLocaleDateString("en-CA")
    );
  }

  // Append new files
  uploadedFiles.value.forEach((file) => {
    submissionData.append("files[]", file);
  });

  // Use PUT method for update
  submissionData.append("_method", "PUT");

  try {
    const response = await axiosInstance.post(
      `/medical-images/${props.medicalImageId}`,
      submissionData,
      {
        headers: {
          "Content-Type": "multipart/form-data",
        },
      }
    );

    eventBus.emit("show-toast", {
      severity: "success",
      summary: t("add_medical_image.toast.success_title"),
      detail: t("add_medical_image.toast.success_detail"),
      life: 5000,
    });

    // Emit the updated data back to the parent
    emit("MedicalImageUpdated", response.data);
  } catch (error) {
    console.error("Failed to update medical image:", error);
    eventBus.emit("show-toast", {
      severity: "error",
      summary: t("add_medical_image.toast.error_title"),
      detail: error.response?.data?.message || t("add_medical_image.toast.error_detail"),
      life: 5000,
    });
  } finally {
    submitting.value = false;
  }
};

// Fetch the medical image data when the component is mounted
onMounted(() => {
  fetchMedicalImage();
});
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