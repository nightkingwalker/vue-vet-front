<template>
  <div class="w-full">
    <DataTable
      :value="loading ? skeletonRows : medicalImages"
      class="mx-4 rounded-lg overflow-hidden text-xs"
      stripedRows
      showGridlines
      scrollable
      scrollHeight="400px"
    >
      <template #empty> {{ $t("medical_images.no_images") }} </template>
      <template #loading> {{ $t("medical_images.loading") }} </template>
      <template #header>
        <div class="flex justify-between items-center !m-b-1">
          <div class="flex">
            <Button
              type="button"
              icon="pi pi-refresh !text-xs"
              label=""
              v-tooltip.bottom="$t('medical_images.refresh')"
              class="!text-xs ml-2 !w-8 !h-8"
              @click="refreshData"
            />
            <Button
              icon="pi pi-plus"
              @click="showAddMedicalImageModal"
              v-tooltip.bottom="$t('medical_images.add')"
              class="p-button p-component p-button-icon-only !text-xs !w-8 !h-8 ml-2"
            />
          </div>
          <h2 class="text-sm !mb-0 pb-0 flex">
            <i class="fa-solid fa-x-ray ltr:mr-2 rtl:ml-2"></i>
            {{ $t("medical_images.title") }}
          </h2>
        </div>
      </template>

      <Column field="type" :header="$t('medical_images.headers.type')" class="w-1/10">
        <template v-if="loading" #body>
          <Skeleton width="100%" height="1rem" />
        </template>
        <template v-else #body="slotProps">
          {{ slotProps.data.type }}
        </template>
      </Column>
      <Column
        field="image_date"
        :header="$t('medical_images.headers.date')"
        class="w-1/10"
      >
        <template v-if="loading" #body>
          <Skeleton width="100%" height="1rem" />
        </template>
        <template v-else #body="slotProps">
          {{ slotProps.data.image_date }}
        </template>
      </Column>

      <Column field="organ" :header="$t('medical_images.headers.organ')" class="w-1/10">
        <template v-if="loading" #body>
          <Skeleton width="100%" height="1rem" />
        </template>
        <template v-else #body="slotProps">
          {{ slotProps.data.organ }}
        </template>
      </Column>

      <Column
        field="measurements"
        :header="$t('medical_images.headers.measurements')"
        class="w-1/10"
      >
        <template v-if="loading" #body>
          <Skeleton width="100%" height="1rem" />
        </template>
        <template v-else #body="slotProps">
          {{ slotProps.data.measurements }}
        </template>
      </Column>

      <Column
        field="description"
        :header="$t('medical_images.headers.description')"
        class="w-2/5"
      >
        <template v-if="loading" #body>
          <Skeleton width="100%" height="1rem" />
        </template>
        <template v-else #body="slotProps">
          {{ slotProps.data.description }}
        </template>
      </Column>

      <Column
        field="ref_number"
        :header="$t('medical_images.headers.ref_number')"
        class="w-1/10"
      >
        <template v-if="loading" #body>
          <Skeleton width="100%" height="1rem" />
        </template>
        <template v-else #body="slotProps">
          {{ slotProps.data.ref_number }}
        </template>
      </Column>
      <Column header="" class="whitespace-nowrap w-1/10">
        <template #body="slotProps">
          <Button
            type="button"
            icon="fa-solid fa-pencil !text-primary"
            v-tooltip.top="{
              value: $t('medical_images.actions.edit'),
              pt: {
                arrow: {
                  style: {
                    borderTopColor: 'var(--p-primary-color)',
                  },
                },
                text:
                  '!bg-[var(--p-primary-color)] !text-primary-contrast !font-thin !text-xs',
              },
            }"
            rounded
            variant="text"
            size="small"
            class="!text-xs !text-primary"
            @click="showEditMedicalImageModal(slotProps.data.id)"
          />
          <Button
            icon="fa-solid fa-times !text-primary"
            v-tooltip.top="{
              value: $t('medical_images.actions.delete'),
              pt: {
                arrow: {
                  style: {
                    borderTopColor: 'var(--p-primary-color)',
                  },
                },
                text:
                  '!bg-[var(--p-primary-color)] !text-primary-contrast !font-thin !text-xs',
              },
            }"
            rounded
            variant="text"
            size="small"
            class="!text-x !text-primary"
            @click.prevent="confirmDelete(slotProps.data.id)"
            v-if="slotProps.data.type !== `Grooming`"
          />
        </template>
      </Column>
    </DataTable>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useI18n } from "vue-i18n";
import DataTable from "primevue/datatable";
import Column from "primevue/column";
import Skeleton from "primevue/skeleton";
import Button from "primevue/button";
import axiosInstance from "@/axios";
import eventBus from "@/eventBus";
import { useConfirm } from "primevue/useconfirm";

const { t } = useI18n();
const confirm = useConfirm();

const medicalImages = ref([]);
const loading = ref(false);
const isNewMedicalImageVisible = ref(false);
const skeletonRows = Array.from({ length: 4 }).map(() => ({
  type: "",
  organ: "",
  measurements: "",
  description: "",
  ref_number: "",
}));

const props = defineProps({
  medical_record_id: {
    type: Number,
    required: true,
  },
});

const fetchMedicalImages = async () => {
  loading.value = true;
  try {
    const response = await axiosInstance.get(
      `/medical-images/bymrid/${props.medical_record_id}`
    );
    medicalImages.value = response.data.data;
    loading.value = false;
  } catch (error) {
    console.error("Error fetching medical images:", error);
    loading.value = false;
  }
};

const emit = defineEmits();

const showAddMedicalImageModal = () => {
  emit("showAddMedicalImageModal");
};

const showEditMedicalImageModal = (medicalImageId) => {
  emit("showEditMedicalImageModal", medicalImageId);
};

const refreshData = () => {
  loading.value = true;
  fetchMedicalImages();
};

const handleSubmit = (newImageData) => {
  isNewMedicalImageVisible.value = false;
  medicalImages.value.push(newImageData);
  eventBus.emit("show-toast", {
    severity: "success",
    summary: t("medical_images.toast.title"),
    detail: t("medical_images.toast.success", { type: newImageData.type }),
    life: 5000,
  });
};

const confirmDelete = (medicalImageId) => {
  confirm.require({
    message: t("medical_images.delete_confirm.message"),
    header: t("medical_images.delete_confirm.header"),
    icon: "pi pi-exclamation-triangle",
    acceptClass: "p-button-danger",
    accept: () => {
      deleteImage(medicalImageId);
    },
    reject: () => {
      // console.log("Deletion cancelled");
    },
  });
};

const deleteImage = async (medicalImageId) => {
  try {
    const response = await axiosInstance.delete(`/medical-images/${medicalImageId}`);
    fetchMedicalImages();
    eventBus.emit("ImagetDeletedSuccessfully");
  } catch (error) {
    console.error("Failed to delete Image:", error);
  }
};

onMounted(() => {
  eventBus.on("newImageAdded", () => {
    fetchMedicalImages();
  });
  eventBus.on("MedicalImageUpdatedSuccessfully", () => {
    fetchMedicalImages();
  });
  fetchMedicalImages();
});
</script>

<style scoped>
/* Additional custom styles here */
</style>
