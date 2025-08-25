<template>
  <div class="w-full">
    <DataTable :value="loading ? skeletonRows : medicalImages" class="mx-4 rounded-lg overflow-hidden text-xs"
      stripedRows showGridlines scrollable scrollHeight="400px">
      <template #empty> {{ $t("medical_images.no_images") }} </template>
      <template #loading> {{ $t("medical_images.loading") }} </template>
      <template #header>
        <div class="flex justify-between items-center !m-b-1">
          <div class="flex">
            <Button type="button" icon="pi pi-refresh !text-xs" label="" v-tooltip.bottom="$t('medical_images.refresh')"
              class="!text-xs ml-2 !w-8 !h-8" @click="refreshData" />
            <Button icon="pi pi-plus" @click="showAddMedicalImageModal" v-tooltip.bottom="$t('medical_images.add')"
              class="p-button p-component p-button-icon-only !text-xs !w-8 !h-8 ml-2" />
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
      <Column field="image_date" :header="$t('medical_images.headers.date')" class="w-1/10">
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

      <Column field="measurements" :header="$t('medical_images.headers.measurements')" class="w-1/10">
        <template v-if="loading" #body>
          <Skeleton width="100%" height="1rem" />
        </template>
        <template v-else #body="slotProps">
          {{ slotProps.data.measurements }}
        </template>
      </Column>

      <Column field="description" :header="$t('medical_images.headers.description')" class="w-2/5">
        <template v-if="loading" #body>
          <Skeleton width="100%" height="1rem" />
        </template>
        <template v-else #body="slotProps">
          {{ slotProps.data.description }}
        </template>
      </Column>

      <Column field="ref_number" :header="$t('medical_images.headers.ref_number')" class="w-1/10">
        <!--         <template v-if="loading" #body>
          <Skeleton width="100%" height="1rem" />
        </template>
        <template v-else #body="slotProps">
          {{ slotProps.data.ref_number }}
        </template> -->
        <template v-if="loading" #body>
          <Skeleton width="100%" height="1rem" />
        </template>
        <template v-else #body="slotProps">
          <Button type="button" icon="fa-solid fa-x-ray" v-tooltip.top="{
            value: $t('pet_details.view_images'),
            pt: {
              arrow: {
                style: {
                  borderTopColor: 'var(--p-primary-color)',
                },
              },
              text:
                '!bg-[var(--p-primary-color)] !text-primary-contrast !font-thin !text-xs',
            },
          }" raised rounded variant="text" size="small" class="p-component !text-sm ml-2"
            v-if="slotProps.data.type !== `Grooming` && slotProps.data.files.length > 0"
            @click.prevent="showImageGallery(slotProps.data.files)" />
          <span v-else-if="slotProps.data.ref_number">{{ slotProps.data.ref_number }}</span>
        </template>
      </Column>

      <Column header="" class="whitespace-nowrap w-1/10">
        <template #body="slotProps">
          <Button type="button" icon="fa-solid fa-pencil !text-primary" v-tooltip.top="{
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
          }" rounded variant="text" size="small" class="!text-xs !text-primary"
            @click="showEditMedicalImageModal(slotProps.data.id)" />
          <Button icon="fa-solid fa-times !text-primary" v-tooltip.top="{
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
          }" rounded variant="text" size="small" class="!text-x !text-primary"
            @click.prevent="confirmDelete(slotProps.data.id)" v-if="slotProps.data.type !== `Grooming`" />
        </template>
      </Column>
    </DataTable>
    <!-- Image Gallery Dialog -->
    <Dialog v-model:visible="displayGallery" :style="{ width: '700px' }" :header="$t('medical_images.gallery.title')"
      :modal="true">
      <Galleria :value="galleryImages" :numVisible="5" containerStyle="max-width: 640px" :showThumbnails="false"
        :showIndicators="true" :changeItemOnIndicatorHover="true" :showIndicatorsOnItem="inside"
        :indicatorsPosition="position" :activeIndex="activeImageIndex" @update:activeIndex="activeImageIndex = $event">
        <template #item="slotProps">
          <img :src="`https://vet-api.ids-tech.net/storage/${slotProps.item.file_path}`"
            :alt="'Medical image ' + (slotProps.index + 1)"
            style="width: 100%; display: block; max-height: 400px; object-fit: contain;" />
        </template>
      </Galleria>

      <template #footer>
        <Button :label="$t('common.close')" icon="pi pi-times" @click="displayGallery = false" class="p-button-text" />
      </template>
    </Dialog>
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
import Dialog from "primevue/dialog";
import Galleria from "primevue/galleria";

const { t } = useI18n();
const confirm = useConfirm();

const medicalImages = ref([]);
const loading = ref(false);
const displayGallery = ref(false);
const galleryImages = ref([]);
const activeImageIndex = ref(0);
const isNewMedicalImageVisible = ref(false);
const inside = ref(true);
const position = ref('bottom');
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
const showImageGallery = (files) => {
  galleryImages.value = files;
  activeImageIndex.value = 0;
  displayGallery.value = true;
};

const getImageUrl = (filePath) => {
  // Assuming your backend serves images from the storage path
  return `${axiosInstance.defaults.baseURL}/${filePath}`;
};
const fetchMedicalImages = async () => {
  loading.value = true;
  try {
    const response = await axiosInstance.get(
      `/medical-images/bymrid/${props.medical_record_id}`
    );
    // console.log(response.data.data)
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
const listImages = (files) => {
  // console.log(files[0].file_path)
}
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
