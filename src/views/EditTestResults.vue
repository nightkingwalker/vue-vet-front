<template>
  <div class="w-full">
    <form @submit.prevent="submitForm" class="mt-2 md:mx-auto md:w-3/4 sm:mx-8 sm:w-full">
      <fieldset
        class="p-fieldset p-component w-full flex flex-col items-center border rounded-lg p-2 justify-start gap-x-2"
      >
        <legend>Edit Test Result</legend>

        <div class="field mt-4 w-full">
          <FloatLabel class="w-full md:w-56">
            <InputText id="test_type" v-model="test.test_type" />
            <label for="test_type">Test Type</label>
          </FloatLabel>
        </div>

        <div class="flex flex-wrap gap-1 test-results-container w-full">
          <div
            v-for="(result, index) in test.results"
            :key="index"
            class="field lg:w-[48%] flex !gap-1 items-start mt-6 justify-between !text-xs"
          >
            <div class="flex flex-col md:w-[80%] sm:w-full">
              <FloatLabel class="max-w-[100%]">
                <InputText
                  :id="'label-' + index"
                  v-model="test.results[index].label"
                  class="md:w-[100%]"
                />
                <label :for="'label-' + index">Test Name {{ index + 1 }}</label>
              </FloatLabel>
              <FloatLabel class="max-w-[100%] mt-6">
                <InputText
                  :id="'value-' + index"
                  v-model="test.results[index].value"
                  class="md:w-[100%]"
                />
                <label :for="'value-' + index">Test Value {{ index + 1 }}</label>
              </FloatLabel>
            </div>
            <Button
              icon="pi pi-times"
              class="p-button-danger !text-[10px] m-0 w-6 h-8 p-2"
              @click="removeResult(index)"
            />
          </div>
        </div>

        <div class="flex items-center mt-4">
          <Button label="Add Result" @click="addResult" />
        </div>
      </fieldset>
      <div class="flex justify-end">
        <Button type="submit" class="mt-4" label="Update Test Result" />
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import InputText from "primevue/inputtext";
import FloatLabel from "primevue/floatlabel";
import Button from "primevue/button";
import axiosInstance from "@/axios";
import eventBus from "@/eventBus";

const emit = defineEmits(["updated", "close-dialog"]); // Define the events to be emitted

const props = defineProps({
  testResultId: {
    type: Number,
    required: true,
  },
});

const test = ref({
  id: null,
  medical_record_id: null,
  test_type: "",
  results: [{ label: "", value: "" }],
});

// Fetch the existing test result data
const fetchTestResult = async () => {
  try {
    const response = await axiosInstance.get(`/test-results/${props.testResultId}`);
    const data = response.data;

    // Parse the result string into an array of objects
    const results = JSON.parse(data.result.replace(/"/g, '"')).map((item) => {
      const [label, value] = item.split(": ");
      return { label, value };
    });

    // Populate the form fields with the fetched data
    test.value = {
      id: data.id,
      medical_record_id: data.medical_record_id,
      test_type: data.test_type,
      results,
    };
  } catch (error) {
    console.error("Failed to fetch test result:", error);
    eventBus.emit("show-toast", {
      severity: "error",
      summary: t("common.error"),
      detail: "Failed to fetch test result details.",
      life: 5000,
    });
  }
};

// Function to add a new input field for a result
const addResult = () => {
  test.value.results.push({ label: "", value: "" });
};

// Function to remove a result from the results array
const removeResult = (index) => {
  test.value.results.splice(index, 1);
};

// Form submission
const submitForm = async () => {
  // Format the results array into a string
  const formattedResults = test.value.results
    .filter((result) => result.label && result.value)
    .map((result) => `"${result.label}: ${result.value}"`)
    .join(", ");
  const resultString = `[${formattedResults}]`;

  const submissionData = {
    medical_record_id: test.value.medical_record_id,
    test_type: test.value.test_type,
    result: resultString,
  };

  try {
    const response = await axiosInstance.put(
      `/test-results/${test.value.id}`,
      submissionData
    );

    // Emit the updated data back to the parent component
    emit("TestResultUpdated", response.data); // Notify the parent component
    emit("close-dialog"); // Close the dialog

    // Show a success message
    eventBus.emit("show-toast", {
      severity: "success",
      summary: t("lab_result_updated_summary"),
      detail: t("lab_result_updated_detail"),
      life: 5000,
    });
  } catch (error) {
    console.error("Error updating test result:", error);
    eventBus.emit("show-toast", {
      severity: "error",
      summary: t("common.error"),
      detail: "Failed to update test result.",
      life: 5000,
    });
  }
};

// Fetch test result data when the component is mounted
onMounted(() => {
  fetchTestResult();
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
