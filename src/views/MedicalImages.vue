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
      <template #empty> No Images Found. </template>
      <template #loading> Loading Images data. Please wait. </template>
      <template #header>
        <div class="flex justify-between items-center !m-b-1">
          <div class="flex">
            <Button
              type="button"
              icon="pi pi-refresh !text-xs"
              label=""
              v-tooltip.bottom="`Refresh Data`"
              class="!text-xs ml-2 !w-8 !h-8"
              @click="refreshData"
            />
            <Button
              icon="pi pi-plus"
              @click="showAddMedicalImageModal"
              v-tooltip.bottom="`Add New Medical Image`"
              class="p-button p-component p-button-icon-only !text-xs !w-8 !h-8 ml-2"
            />
          </div>
          <h2 class="text-sm !mb-0 pb-0 flex">
            <i class="fa-solid fa-x-ray mr-2"></i> Medical Images
          </h2>
        </div>
      </template>

      <Column field="type" header="Type" class="w-1/10">
        <template v-if="loading" #body>
          <Skeleton width="100%" height="1rem" />
        </template>
        <template v-else #body="slotProps">
          {{ slotProps.data.type }}
        </template>
      </Column>
      <Column field="image_date" header="Date" class="w-1/10">
        <template v-if="loading" #body>
          <Skeleton width="100%" height="1rem" />
        </template>
        <template v-else #body="slotProps">
          {{ slotProps.data.image_date }}
        </template>
      </Column>

      <Column field="organ" header="Organ" class="w-1/10">
        <template v-if="loading" #body>
          <Skeleton width="100%" height="1rem" />
        </template>
        <template v-else #body="slotProps">
          {{ slotProps.data.organ }}
        </template>
      </Column>

      <Column field="measurements" header="Measurements" class="w-1/10">
        <template v-if="loading" #body>
          <Skeleton width="100%" height="1rem" />
        </template>
        <template v-else #body="slotProps">
          {{ slotProps.data.measurements }}
        </template>
      </Column>

      <Column field="description" header="Description" class="w-2/5">
        <template v-if="loading" #body>
          <Skeleton width="100%" height="1rem" />
        </template>
        <template v-else #body="slotProps">
          {{ slotProps.data.description }}
        </template>
      </Column>

      <Column field="ref_number" header="Reference #" class="w-1/10">
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
              value: 'Edit Details',
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
              value: 'Delete',
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
import DataTable from "primevue/datatable";
import Column from "primevue/column";
import Skeleton from "primevue/skeleton";
import Button from "primevue/button";
import axiosInstance from "@/axios"; // Assuming axiosInstance is set up correctly
import eventBus from "@/eventBus";
import { useConfirm } from "primevue/useconfirm";

const confirm = useConfirm(); // Initialize the confirmation service

// Reactive properties for medical images data
const medicalImages = ref([]);
const loading = ref(false);
const isNewMedicalImageVisible = ref(false); // Set the medical record ID from the parent or elsewhere
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
const medicalRecordId = `${props.medical_record_id}`;
// Function to fetch medical images
const fetchMedicalImages = async () => {
  loading.value = true;
  try {
    const response = await axiosInstance.get(
      `/medical-images/bymrid/${props.medical_record_id}`
    );
    medicalImages.value = response.data.data;
    console.log(response.data.data);
    loading.value = false;
  } catch (error) {
    console.error("Error fetching medical images:", error);
    loading.value = false;
  }
};

// Show the modal for adding new medical image

const emit = defineEmits(); // Define the event to be emitted

const showAddMedicalImageModal = () => {
  emit("showAddMedicalImageModal");
};
const showEditMedicalImageModal = (medicalImageId) => {
  emit("showEditMedicalImageModal", medicalImageId);
};

// Refresh the medical images data
const refreshData = () => {
  loading.value = true; // Set loading state to true to show skeletons
  fetchMedicalImages(); // Fetch the data again
};

// Handle the submit event after adding a new medical image
const handleSubmit = (newImageData) => {
  isNewMedicalImageVisible.value = false;
  medicalImages.value.push(newImageData); // Add the new image to the table
  eventBus.emit("show-toast", {
    severity: "success",
    summary: "New Medical Image Added",
    detail: `Medical image for ${newImageData.type} added successfully.`,
    life: 5000,
  });
};
const confirmDelete = (medicalImageId) => {
  confirm.require({
    message: "Are you sure you want to delete this Image?",
    header: "Delete Confirmation",
    icon: "pi pi-exclamation-triangle",
    acceptClass: "p-button-danger",
    accept: () => {
      deleteImage(medicalImageId); // Call the delete function if the user confirms
    },
    reject: () => {
      console.log("Deletion cancelled");
    },
  });
};

const deleteImage = async (medicalImageId) => {
  try {
    const response = await axiosInstance.delete(`/medical-images/${medicalImageId}`);
    console.log("Image deleted:", response.data);
    fetchMedicalImages(); // Refresh the treatments list
    eventBus.emit("ImagetDeletedSuccessfully"); // Emit an event if needed
  } catch (error) {
    console.error("Failed to delete Image:", error);
  }
};
// OnMounted fetch the initial data
onMounted(() => {
  eventBus.on("newImageAdded", () => {
    console.log("newImageAdded");
    fetchMedicalImages();
  });
  eventBus.on("MedicalImageUpdatedSuccessfully", () => {
    console.log("MedicalImageUpdatedSuccessfully");
    fetchMedicalImages();
  });
  fetchMedicalImages();
});
</script>

<style scoped>
/* Additional custom styles here */
</style>
