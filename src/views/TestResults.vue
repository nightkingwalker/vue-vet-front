<template>
  <DataTable
    :value="loading ? skeletonRows : medicalRecords"
    class="mx-4 rounded-lg overflow-hidden text-xs"
    stripedRows
    scrollable
    scrollHeight="400px"
  >
    <Column field="test_type" header="Test" class="w-1/5">
      <template v-if="loading" #body>
        <Skeleton width="100%" height="1rem" />
      </template>
      <template v-else #body="slotProps">
        {{ slotProps.data.test_type }}</template
      ></Column
    >
    <Column field="result" header="Result" class="w-1/5">
      <template v-if="loading" #body>
        <Skeleton width="100%" height="1rem" />
      </template>
      <template v-else #body="slotProps">
        <div
          v-for="(entry, index) in parseResults(slotProps.data.result)"
          :key="index"
          class="flex gap-2"
        >
          <!-- </div> -->
          <!-- <strong>{{ key }}:</strong> {{ value }} -->
          <p class="!text-sm m-1">
            <strong>{{ entry.key }}:</strong> {{ entry.value }}
          </p>
        </div>
      </template>
    </Column>
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
  test_type: "",
  result: "",
}));
// Function to parse the results string into a usable object
const parseResults = (resultsString) => {
  if (!resultsString) return [];
  try {
    // Directly parse the JSON array
    const results = JSON.parse(resultsString);
    return results.map((result) => {
      const parts = result.split(":");
      // console.log(parts);
      return { key: parts[0].trim(), value: parts[1].trim() };
    });
  } catch (error) {
    console.error("Error parsing results:", error);
    return [];
  }
};
// // console.log("Medical Record ID:", props.medical_record_id);
const fetchTestResults = async () => {
  loading.value = true;
  try {
    // // console.log("Medical Record ID:", props.medical_record_id);
    // Make the request using the axios instance with interceptors
    const response = await axiosInstance.get(
      `/test-results/bymrid/${props.medical_record_id}`
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
  fetchTestResults();
});
</script>
