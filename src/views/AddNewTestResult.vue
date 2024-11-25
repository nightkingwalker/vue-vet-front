<template>
  <div class="w-full">
    <form @submit.prevent="submitForm" class="mt-2 md:mx-auto md:w-3/4 sm:mx-8 sm:w-full">
      <fieldset
        class="p-fieldset p-component w-full flex flex-col items-center border rounded-lg p-2 justify-start gap-x-2"
      >
        <legend>Add New Test Result</legend>

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
        <Button type="submit" class="mt-4" label="Add Test Result" />
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref } from "vue";
import InputText from "primevue/inputtext";
import FloatLabel from "primevue/floatlabel";
import Button from "primevue/button";
import axiosInstance from "@/axios";
import eventBus from "@/eventBus";
import { useRoute } from "vue-router";
const emit = defineEmits(); // Define the event to be emitted

const route = useRoute();
const props = defineProps({
  medical_record_id: {
    type: Number,
    required: true,
  },
});

const test = ref({
  medical_record_id: props.medical_record_id,
  test_type: "",
  results: [{ label: "", value: "" }],
});

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
  console.log(submissionData);
  try {
    const response = await axiosInstance.post("/test-results", submissionData);
    console.log(response);
    eventBus.emit("show-toast", {
      severity: "success",
      summary: "Data Loaded",
      detail: `Test Result Added Successfully`,
      life: 5000,
    });
    emit("TestResultAdded", response.data);
  } catch (error) {
    eventBus.emit("show-toast", {
      severity: "warn",
      summary: "Error",
      detail: error,
      life: 5000,
    });
  }
};
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
