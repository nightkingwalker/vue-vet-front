<template>
  <DataTable
    :value="loading ? skeletonRows : medicalRecords"
    class="mx-4 rounded-lg overflow-hidden text-xs"
    stripedRows
    showGridlines
    scrollable
    scrollHeight="400px"
  >
    <template #empty> No Test Results Found. </template>

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
            @click="showAddTestResultModal"
            v-tooltip.bottom="`Add New Test Result`"
            class="p-button p-component p-button-icon-only !text-xs !w-8 !h-8 ml-2"
          />
        </div>
        <h2 class="text-sm !mb-0 pb-0 flex">
          <i class="fa-solid fa-paw ltr:mr-2 rtl:ml-2"></i> Test Results
        </h2>
      </div>
    </template>

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
    <Column header="Data" class="whitespace-nowrap w-[10%]">
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
          @click="showEditTestResultModal(slotProps.data.id)"
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
import { ref, onMounted } from "vue";
import DataTable from "primevue/datatable";
import Column from "primevue/column";
import Skeleton from "primevue/skeleton";
import Button from "primevue/button";
import eventBus from "@/eventBus";
import axiosInstance from "@/axios"; // Assuming axiosInstance is set up correctly
import { useConfirm } from "primevue/useconfirm";

const confirm = useConfirm(); // Initialize the confirmation service
const medicalRecords = ref();
const loading = ref(false);
const emit = defineEmits(); // Define the event to be emitted

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
      // // console.log(parts);
      return { key: parts[0].trim(), value: parts[1].trim() };
    });
  } catch (error) {
    console.error("Error parsing results:", error);
    return [];
  }
};
// // // console.log("Medical Record ID:", props.medical_record_id);
const fetchTestResults = async () => {
  loading.value = true;
  try {
    // // // console.log("Medical Record ID:", props.medical_record_id);
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
const showAddTestResultModal = () => {
  emit("showAddTestResultModal");
};
const showEditTestResultModal = (testResultId) => {
  emit("showEditTestResultModal", testResultId);
};
const refreshData = () => {
  loading.value = true; // Set loading state to true to show skeletons
  fetchTestResults(); // Fetch the pets data again
};
const confirmDelete = (testResultId) => {
  confirm.require({
    message: "Are you sure you want to delete this result?",
    header: "Delete Confirmation",
    icon: "pi pi-exclamation-triangle",
    acceptClass: "p-button-danger",
    accept: () => {
      deleteTestResult(testResultId); // Call the delete function if the user confirms
    },
    reject: () => {
      // console.log("Deletion cancelled");
    },
  });
};

const deleteTestResult = async (testResultId) => {
  try {
    const response = await axiosInstance.delete(`/test-results/${testResultId}`);
    // console.log("Treatment deleted:", response.data);
    fetchTestResults(); // Refresh the treatments list
    eventBus.emit("TestResultDeletedSuccessfully"); // Emit an event if needed
  } catch (error) {
    console.error("Failed to delete treatment:", error);
  }
};
onMounted(() => {
  fetchTestResults();
  eventBus.on("newTestResultAdded", () => {
    // console.log("newTestResultAdded");
    fetchTestResults();
  });
  eventBus.on("handleTestResultUpdatedSuccessfully", () => {
    // console.log("newTestResultAdded");
    fetchTestResults();
  });
});
</script>
