<template>
  <div class="w-full">
    <form @submit.prevent="submitForm" class="mt-2 md:mx-auto md:w-3/4 sm:mx-8 sm:w-full">
      <fieldset
        class="p-fieldset p-component w-full flex flex-wrap items-center border rounded-lg p-2 justify-start gap-x-2"
      >
        <legend>Edit Medical Image</legend>

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
              showIcon
              iconDisplay="input"
              showButtonBar
              id="image_date"
              v-model="medicalImage.image_date"
              dateFormat="yy-mm-d"
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
        <Button type="submit" label="Update Medical Image" class="mt-4" />
      </fieldset>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import InputText from "primevue/inputtext";
import Textarea from "primevue/textarea";
import DatePicker from "primevue/datepicker";
import Select from "primevue/select";
import FloatLabel from "primevue/floatlabel";
import Button from "primevue/button";
import axiosInstance from "@/axios";
import eventBus from "@/eventBus";
// import { defineProps } from "vue";

const emit = defineEmits(["updated"]);

const props = defineProps({
  medicalImageId: {
    type: Number,
    required: true,
  },
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

// Fetch the existing medical image data
const fetchMedicalImage = async () => {
  try {
    const response = await axiosInstance.get(`/medical-images/${props.medicalImageId}`);
    const data = response.data;
    // medicalImage.value = {
    //   ref_number: data.ref_number,
    //   description: data.description,
    //   organ: data.organ,
    //   measurements: data.measurements,
    //   type: imageTypes.value.find((type) => type.value === data.type),
    //   image_date: data.image_date,
    // };
    medicalImage.value = {
      ...data,
      type: imageTypes.value.find((type) => type.value === data.type),
      //   status: appointmentStatus.value.find((status) => status.value === data.status),
    };
    
  } catch (error) {
    console.error("Failed to fetch medical image:", error);
    eventBus.emit("show-toast", {
      severity: "error",
      summary: "Error",
      detail: "Failed to fetch medical image data.",
      life: 5000,
    });
  }
};

// Form submission for updating
const submitForm = async () => {
  const submissionData = {
    medical_record_id: props.medical_record_id,
    ref_number: medicalImage.value.ref_number,
    description: medicalImage.value.description,
    organ: medicalImage.value.organ,
    measurements: medicalImage.value.measurements,
    type: medicalImage.value.type.value,
    image_date: medicalImage.value.image_date ? medicalImage.value.image_date : null,
  };

  try {
    const response = await axiosInstance.put(
      `/medical-images/${props.medicalImageId}`,
      submissionData
    );
    eventBus.emit("show-toast", {
      severity: "success",
      summary: "Medical Image Updated",
      detail: `Medical image updated successfully.`,
      life: 5000,
    });

    // Emit the updated data back to the parent
    emit("MedicalImageUpdated", response.data);
  } catch (error) {
    console.error("Failed to update medical image:", error);
    eventBus.emit("show-toast", {
      severity: "error",
      summary: "Error",
      detail: error.response?.data?.message || "Failed to update medical image.",
      life: 5000,
    });
  }
};

// Fetch the medical image data when the component is mounted
onMounted(() => {
  fetchMedicalImage();
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
