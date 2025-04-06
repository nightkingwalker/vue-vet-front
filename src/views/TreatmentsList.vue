<template>
  <DataTable
    :value="loading ? skeletonRows : medicalRecords"
    class="mx-4 rounded-lg overflow-hidden text-xs mb-4"
    stripedRows
    scrollable
    showGridlines
    scrollHeight="400px"
  >
    <template #empty> No Treatments Found. </template>
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
            @click="showAddTreatmentModal"
            v-tooltip.bottom="`Add New Treatment`"
            class="p-button p-component p-button-icon-only !text-xs !w-8 !h-8 ml-2"
          />
        </div>
        <h2 class="text-sm !mb-0 pb-0 flex">
          <i class="fa-solid fa-paw mr-2"></i> Treatments
        </h2>
      </div>
    </template>

    <Column field="treatment_date" header="Date" class="w-1/5">
      <template v-if="loading" #body>
        <Skeleton width="100%" height="1rem" />
      </template>
      <template v-else #body="slotProps">
        {{ slotProps.data.treatment_date }}</template
      ></Column
    >
    <Column field="name" header="Treatment" class="w-1/5">
      <template v-if="loading" #body>
        <Skeleton width="100%" height="1rem" />
      </template>
      <template v-else #body="slotProps"> {{ slotProps.data.name }}</template>
    </Column>
    <Column field="dosage" header="Dosage" class="w-1/5">
      <template v-if="loading" #body>
        <Skeleton width="100%" height="1rem" />
      </template>
      <template v-else #body="slotProps"> {{ slotProps.data.dosage }}</template>
    </Column>
    <Column field="administration" header="Delivery" class="w-1/5">
      <template v-if="loading" #body>
        <Skeleton width="100%" height="1rem" />
      </template>
      <template v-else #body="slotProps"> {{ slotProps.data.administration }}</template>
    </Column>
    <Column field="description" header="Description" class="font-normal">
      <template v-if="loading" #body>
        <Skeleton width="100%" height="1rem" />
      </template>
      <template v-else #body="slotProps">
        {{ slotProps.data.description }}</template
      ></Column
    >
    <Column header="Data" class="whitespace-nowrap">
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
          @click="showEditTreatmentModal(slotProps.data.id)"
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
</template>
<script setup>
import { ref, onMounted, onUnmounted } from "vue";
import DataTable from "primevue/datatable";
import Column from "primevue/column";
import Button from "primevue/button";
import Skeleton from "primevue/skeleton";
import eventBus from "@/eventBus";
import axiosInstance from "@/axios"; // Assuming axiosInstance is set up correctly
import { useConfirm } from "primevue/useconfirm";

const confirm = useConfirm(); // Initialize the confirmation service
const medicalRecords = ref();
const loading = ref(false);
const props = defineProps({
  medical_record_id: {
    type: Number,
    required: true,
  },
});
const skeletonRows = Array.from({ length: 4 }).map(() => ({
  treatment_date: "",
  name: "",
  dosage: "",
  description: "",
}));
// // console.log("Medical Record ID:", props.medical_record_id);
const fetchTreatments = async () => {
  loading.value = true;
  try {
    // console.log("Medical Record ID:", props.medical_record_id);
    // Make the request using the axios instance with interceptors
    const response = await axiosInstance.get(
      `/treatments/bymrid/${props.medical_record_id}`
    );
    medicalRecords.value = response.data.data;
    console.log(medicalRecords.value);

    loading.value = false; // Stop loading once data is fetched
  } catch (error) {
    //     // showSuccess("warn", "Warning", "Couldent Fetch Data");
  } finally {
  }
};
const emit = defineEmits(); // Define the event to be emitted

const showAddTreatmentModal = () => {
  emit("showAddTreatmentModal");
};
const showEditTreatmentModal = (treatmentId) => {
  console.log("CLICKED", treatmentId); // Log the treatment ID for debugging
  emit("showEditTreatmentModal", treatmentId); // Pass the treatment ID as a payload
};
const refreshData = () => {
  loading.value = true; // Set loading state to true to show skeletons
  fetchTreatments(); // Fetch the pets data again
};
const confirmDelete = (treatmentId) => {
  confirm.require({
    message: "Are you sure you want to delete this treatment?",
    header: "Delete Confirmation",
    icon: "pi pi-exclamation-triangle",
    acceptClass: "p-button-danger",
    accept: () => {
      deleteTreatment(treatmentId); // Call the delete function if the user confirms
    },
    reject: () => {
      console.log("Deletion cancelled");
    },
  });
};

const deleteTreatment = async (treatmentId) => {
  try {
    const response = await axiosInstance.delete(`/treatments/${treatmentId}`);
    console.log("Treatment deleted:", response.data);
    fetchTreatments(); // Refresh the treatments list
    eventBus.emit("TreatmentDeletedSuccessfully"); // Emit an event if needed
  } catch (error) {
    console.error("Failed to delete treatment:", error);
  }
};
onMounted(() => {
  // console.log("Component mounted, setting up event listeners");
  fetchTreatments();

  eventBus.on("newTreatmentAdded", () => {
    // console.log("Received newTreatmentAdded event");
    fetchTreatments();
  });

  eventBus.on("TreatmentUpdatedSuccessfully", () => {
    // console.log("Received TreatmentUpdatedSuccessfully event");
    fetchTreatments();
  });
});

onUnmounted(() => {
  // console.log("Component unmounted, cleaning up event listeners");
  eventBus.off("newTreatmentAdded");
  eventBus.off("TreatmentUpdatedSuccessfully");
});
</script>
