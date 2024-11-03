<template>
  <DataTable
    :value="loading ? skeletonRows : medicalRecords"
    class="mx-4 rounded-lg overflow-hidden text-xs"
    stripedRows
    scrollable
    scrollHeight="400px"
  >
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
import Skeleton from "primevue/skeleton";
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
onMounted(() => {
  fetchTreatments();
});
</script>
