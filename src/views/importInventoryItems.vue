<template>
  <FileUpload
    name="inventory_import"
    :multiple="false"
    accept=".xlsx,.xls"
    :maxFileSize="1000000"
    @select="onSelectedFiles"
    :auto="false"
  >
    <template #header="{ chooseCallback, clearCallback, files }">
      <div class="flex flex-wrap justify-between items-center flex-1 gap-4">
        <div class="flex gap-2">
          <Button
            @click="chooseCallback()"
            icon="pi pi-file-excel"
            rounded
            outlined
            severity="secondary"
          />
          <Button
            @click="uploadFile()"
            icon="pi pi-cloud-upload"
            rounded
            outlined
            severity="success"
            :disabled="!currentFile"
          />
          <Button
            @click="
              clearCallback();
              currentFile = null;
            "
            icon="pi pi-times"
            rounded
            outlined
            severity="danger"
            :disabled="!currentFile"
          />
          <Button
            :label="$t('inventory.import.download_template')"
            icon="pi pi-download"
            @click="downloadTemplate"
            severity="secondary"
          />
        </div>
        <ProgressBar
          :value="uploadProgress"
          :showValue="false"
          class="md:w-20rem h-1 w-full md:ml-auto"
        >
          <span class="whitespace-nowrap"
            >{{ currentFile ? formatSize(currentFile.size) : "0" }}B / 1Mb</span
          >
        </ProgressBar>
      </div>
    </template>

    <template #content="{ files, removeFileCallback }">
      <div class="flex flex-col gap-8 pt-4">
        <Message v-if="errorMessage" severity="error" class="mb-4">{{
          errorMessage
        }}</Message>

        <div v-if="files.length > 0">
          <h5>{{ $t("inventory.import.pending") }}</h5>
          <div class="flex flex-wrap gap-4">
            <div
              v-for="(file, index) of files"
              :key="file.name + file.type + file.size"
              class="p-8 rounded-border flex flex-col border border-surface items-center gap-4"
            >
              <div>
                <i class="pi pi-file-excel text-5xl text-blue-500" />
              </div>
              <span
                class="font-semibold text-ellipsis max-w-60 whitespace-nowrap overflow-hidden"
              >
                {{ file.name }}
              </span>
              <div>{{ formatSize(file.size) }}</div>
              <Badge value="Pending" severity="warn" />
              <Button
                icon="pi pi-times"
                @click="removeFileCallback(index)"
                outlined
                rounded
                severity="danger"
              />
            </div>
          </div>
        </div>

        <div v-if="importResults">
          <h5>{{ $t("inventory.import.results") }}</h5>
          <div class="p-4 border-round border-1 surface-border">
            <div class="grid">
              <div class="col-6">
                <div class="text-green-600 font-medium">
                  <i class="pi pi-check-circle mr-2"></i>
                  {{ $t("inventory.import.created") }}: {{ importResults.created }}
                </div>
              </div>
              <div class="col-6">
                <div class="text-blue-500 font-medium">
                  <i class="pi pi-sync mr-2"></i>
                  {{ $t("inventory.import.updated") }}: {{ importResults.updated }}
                </div>
              </div>
              <div class="col-6">
                <div class="text-orange-500 font-medium">
                  <i class="pi pi-exclamation-triangle mr-2"></i>
                  {{ $t("inventory.import.skipped") }}: {{ importResults.skipped }}
                </div>
              </div>
              <div class="col-6">
                <div class="font-medium">
                  <i class="pi pi-table mr-2"></i>
                  {{ $t("inventory.import.total_rows") }}: {{ importResults.total }}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </template>

    <template #empty>
      <div class="flex items-center justify-center flex-col">
        <i
          class="pi pi-cloud-upload !border-2 !rounded-full !p-8 !text-4xl !text-muted-color"
        />
        <p class="mt-6 mb-0">{{ $t("inventory.import.drag_drop") }}</p>
        <small class="text-500">{{ $t("inventory.import.excel_only") }}</small>
      </div>
    </template>
  </FileUpload>
</template>

<script setup>
import { ref, computed } from "vue";
import { useToast } from "primevue/usetoast";
import axiosInstance from "@/axios";
import { useI18n } from "vue-i18n";
import FileUpload from "primevue/fileupload";
import Message from "primevue/message";
import ProgressBar from "primevue/progressbar";
import Button from "primevue/button";
import Badge from "primevue/badge";

const { t } = useI18n();
const toast = useToast();
const emit = defineEmits(["submitted"]);

// const props = defineProps({
//   branchId: {
//     type: Number,
//     required: true,
//   },
// });

const uploadProgress = ref(0);
const errorMessage = ref(null);
const importResults = ref(null);
const currentFile = ref(null);
const isUploading = ref(false);

const formatSize = (bytes) => {
  if (bytes === 0) return "0 B";
  const k = 1024;
  const sizes = ["B", "KB", "MB", "GB"];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + " " + sizes[i];
};

const onSelectedFiles = (event) => {
  errorMessage.value = null;
  importResults.value = null;
  currentFile.value = event.files[0]; // Store the selected file
};

const uploadFile = async () => {
  if (!currentFile.value) return;

  isUploading.value = true;
  errorMessage.value = null;
  uploadProgress.value = 0;

  const formData = new FormData();
  formData.append("file", currentFile.value);
  //   formData.append("branch_id", props.branchId);

  try {
    const response = await axiosInstance.post("/inventory-items/import", formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
      onUploadProgress: (progressEvent) => {
        if (progressEvent.total) {
          uploadProgress.value = Math.round(
            (progressEvent.loaded * 100) / progressEvent.total
          );
        }
      },
    });

    importResults.value = response.data.stats;
    toast.add({
      severity: "success",
      summary: t("inventory.import.success"),
      detail: t("inventory.import.items_processed", {
        total: response.data.stats.total,
        created: response.data.stats.created,
        updated: response.data.stats.updated,
      }),
      life: 5000,
    });
    emit("submitted", response.data.stats);
  } catch (error) {
    errorMessage.value = error.response?.data?.message || error.message;
    toast.add({
      severity: "error",
      summary: t("inventory.import.error"),
      detail: errorMessage.value,
      life: 5000,
    });
    console.log(error);
  } finally {
    isUploading.value = false;
    uploadProgress.value = 0;
  }
};

const downloadTemplate = () => {
  // Sample data for the template
  const templateData = [
    {
      category: "pharmaceutical",
      type: "Antibiotic",
      name: "Amoxicillin 250mg",
      brand: "PetCare",
      description: "For bacterial infections",
      quantity: 100,
      cost_price: 2.5,
      selling_price: 5.0,
      minimum_stock_level: 20,
      expiry_date: "2024-12-31",
      barcode: "AMX250123",
    },
    {
      category: "food",
      type: "Dry Food",
      name: "Adult Dog Food",
      brand: "DogMaster",
      description: "20kg bag premium",
      quantity: 50,
      cost_price: 30.0,
      selling_price: 45.0,
      minimum_stock_level: 10,
      expiry_date: "2025-06-30",
      barcode: "DFD2024",
    },
  ];

  // Convert to CSV
  const headers = Object.keys(templateData[0]);
  let csv = headers.join(",") + "\n";
  templateData.forEach((row) => {
    csv += headers.map((header) => JSON.stringify(row[header])).join(",") + "\n";
  });

  // Create download link
  const blob = new Blob([csv], { type: "text/csv;charset=utf-8;" });
  const link = document.createElement("a");
  const url = URL.createObjectURL(blob);

  link.setAttribute("href", url);
  link.setAttribute("download", "inventory_import_template.csv");
  link.style.visibility = "hidden";

  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
};
</script>
