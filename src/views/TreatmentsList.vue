<template>
  <DataTable
    :value="loading ? skeletonRows : medicalRecords"
    class="mx-4 rounded-lg overflow-hidden text-xs mb-4"
    stripedRows
    scrollable
    scrollHeight="400px"
  >
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
    <Column field="description" header="Treatment Description" class="font-normal">
      <template v-if="loading" #body>
        <Skeleton width="100%" height="1rem" />
      </template>
      <template v-else #body="slotProps">
        {{ slotProps.data.description }}</template
      ></Column
    >
  </DataTable>
</template>
<script setup>
import { ref, onMounted } from "vue";
import DataTable from "primevue/datatable";
import Column from "primevue/column";
import Button from "primevue/button";
import Skeleton from "primevue/skeleton";
import eventBus from "@/eventBus";
import axiosInstance from "@/axios"; // Assuming axiosInstance is set up correctly
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
    // console.log(medicalRecords.value);

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
const refreshData = () => {
  loading.value = true; // Set loading state to true to show skeletons
  fetchTreatments(); // Fetch the pets data again
};
onMounted(() => {
  fetchTreatments();
  eventBus.on("newTreatmentAdded", () => {
    console.log("newTreatmentAdded");
    fetchTreatments();
  });
});
</script>
