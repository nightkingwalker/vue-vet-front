<template>
  <div class="w-full">
    <form @submit.prevent="submitForm" class="mt-2 md:mx-auto md:w-3/4 sm:mx-8 sm:w-full">
      <fieldset
        class="p-fieldset p-component w-full flex flex-wrap items-center border rounded-lg p-2 justify-start gap-x-2"
      >
        <legend>Add New Treatment</legend>
        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full md:w-56">
            <InputText
              id="name"
              v-model="treatment.name"
              placeholder="Enter treatment name"
            />
            <label for="name">Name</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full md:w-56">
            <InputText
              id="dosage"
              v-model="treatment.dosage"
              placeholder="Enter dosage"
            />
            <label for="dosage">Dosage</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full md:w-56">
            <InputText
              id="description"
              v-model="treatment.description"
              placeholder="Enter description"
            />
            <label for="description">Description</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full md:w-56">
            <label for="treatment_date">Treatment Date</label>
            <DatePicker
              id="treatment_date"
              class="w-full"
              v-model="treatment.treatment_date"
              dateFormat="yy-mm-dd"
            />
          </FloatLabel>
        </div>
      </fieldset>
      <div class="flex justify-end">
        <Button type="submit" class="mt-4" label="Add Treatment" />
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref } from "vue";
import InputText from "primevue/inputtext";
import DatePicker from "primevue/datepicker";
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
// console.log(props.medical_record_id);
const treatment = ref({
  name: "",
  dosage: "",
  description: "",
  treatment_date: "",
});

// Form submission
const submitForm = async () => {
  const submissionData = {
    medical_record_id: props.medical_record_id,
    name: treatment.value.name,
    dosage: treatment.value.dosage,
    description: treatment.value.description,
    treatment_date: treatment.value.treatment_date
      ? treatment.value.treatment_date.toLocaleDateString("en-CA")
      : null,
  };
  console.log(submissionData);
  try {
    const response = await axiosInstance.post("/treatments", submissionData);
    console.log(response);
    eventBus.emit("show-toast", {
      severity: "success",
      summary: "Data Loaded",
      detail: `Treatment Added Successfully`,
      life: 5000,
    });
    emit("TreatmentAdded", response.data);
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
  /* max-width: 500px; */
  margin: auto;
}
.field {
  margin-bottom: 16px;
}
.p-fieldset-content {
  display: flex;
}
</style>
