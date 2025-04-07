<template>
  <div class="w-full">
    <form @submit.prevent="submitForm" class="mt-2 md:mx-auto md:w-3/4 sm:mx-8 sm:w-full">
      <fieldset
        class="p-fieldset p-component w-full flex flex-wrap items-center border rounded-lg p-2 justify-start gap-x-2"
      >
        <legend>Add New Medical Image</legend>

        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full md:w-56">
            <InputText id="ref_number" v-model="medicalImage.ref_number" />
            <label for="ref_number">Reference Number</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full md:w-56">
            <InputText id="organ" v-model="medicalImage.organ" />
            <label for="organ">Organ</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full md:w-56">
            <InputText id="measurements" v-model="medicalImage.measurements" />
            <label for="measurements">Measurements</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full md:w-56">
            <Select
              v-model="medicalImage.type"
              :options="imageTypes"
              optionLabel="label"
              class="w-full"
            />
            <label for="type">Image Type</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full md:w-56">
            <DatePicker
              id="image_date"
              v-model="medicalImage.image_date"
              dateFormat="yy-mm-dd"
              class="w-full"
            />
            <label for="image_date">Date of Image</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full md:w-56">
            <Textarea id="description" v-model="medicalImage.description" />
            <label for="description">Description</label>
          </FloatLabel>
        </div>
        <Button type="submit" label="Add Medical Image" class="mt-4" />
      </fieldset>
    </form>
  </div>
</template>

<script setup>
import { ref } from "vue";
import InputText from "primevue/inputtext";
import Textarea from "primevue/textarea";
import DatePicker from "primevue/datepicker";
import Select from "primevue/select";
import FloatLabel from "primevue/floatlabel";
import Button from "primevue/button";
import axiosInstance from "@/axios";
import eventBus from "@/eventBus";
import { defineProps } from "vue";

const emit = defineEmits(["submitted"]);

const props = defineProps({
  medical_record_id: {
    type: Number,
    required: true,
  },
});

const medicalImage = ref({
  ref_number: "",
  description: "",
  organ: "",
  measurements: "",
  type: "",
  image_date: null,
});

const imageTypes = ref([
  { label: "Ultrasound", value: "Ultrasound" },
  { label: "X-ray", value: "X-ray" },
]);

// Form submission
const submitForm = async () => {
  const submissionData = {
    medical_record_id: props.medical_record_id,
    ref_number: medicalImage.value.ref_number,
    description: medicalImage.value.description,
    organ: medicalImage.value.organ,
    measurements: medicalImage.value.measurements,
    type: medicalImage.value.type.value,
    image_date: medicalImage.value.image_date
      ? medicalImage.value.image_date.toLocaleDateString("en-CA")
      : null,
  };
  // console.log(submissionData);
  try {
    const response = await axiosInstance.post("/medical-images", submissionData);
    eventBus.emit("show-toast", {
      severity: "success",
      summary: "Medical Image Added",
      detail: `Medical image added successfully.`,
      life: 5000,
    });

    // Emit the data back to the parent
    emit("NewImageAdded", response.data);
  } catch (error) {
    // console.log(error.response.data.message);
    eventBus.emit("show-toast", {
      severity: "error",
      summary: "Error",
      detail: error.response.data.message || "Failed to add medical image.",
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
