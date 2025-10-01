<template>
  <div class="w-full">
    <form @submit.prevent="submitForm" class="mt-2 md:mx-auto md:w-3/4 sm:mx-8 sm:w-full">
      <fieldset
        class="p-fieldset p-component w-full flex flex-wrap items-center border rounded-lg p-2 justify-start gap-x-2"
      >
        <legend>Edit Treatment</legend>
        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full md:w-56">
            <InputText id="name" v-model="treatment.name" />
            <label for="name">Name</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full md:w-56">
            <InputText id="dosage" v-model="treatment.dosage" />
            <label for="dosage">Dosage</label>
          </FloatLabel>
        </div>
        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-[95%]">
            <Select
              v-model="treatment.administration"
              :options="medicineAdministrationMethods"
              optionLabel="label"
              class="w-full h-10"
            >
              <template #value="slotProps">
                <div v-if="slotProps.value" class="flex items-center">
                  <div>{{ slotProps.value.value }}</div>
                </div>
                <span v-else>
                  {{ slotProps.placeholder }}
                </span>
              </template>
              <template #option="slotProps">
                <div class="flex items-center">
                  <div>{{ slotProps.option.label }}</div>
                </div>
              </template>
            </Select>

            <label for="dd-city">Delivery</label>
          </FloatLabel>
        </div>
        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full md:w-56">
            <InputText id="description" v-model="treatment.description" />
            <label for="description">Description</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[49%]">
          <FloatLabel class="w-full md:w-56">
            <label for="treatment_date">Treatment Date</label>
            <DatePicker
              showIcon
              iconDisplay="input"
              showButtonBar
              showTime
              hourFormat="12"
              fluid
              id="treatment_date"
              class="w-full"
              v-model="treatment.treatment_date"
              dateFormat="yy-mm-d"
            />
          </FloatLabel>
        </div>
      </fieldset>
      <div class="flex justify-end">
        <Button type="submit" class="mt-4" label="Update Treatment" />
      </div>
    </form>
  </div>
</template>
<script setup>
import { ref, onMounted } from "vue";
import InputText from "primevue/inputtext";
import DatePicker from "primevue/datepicker";
import Select from "primevue/select";
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
  treatmentId: {
    type: Number,
    required: true,
  },
});

const treatment = ref({
  name: "",
  dosage: "",
  description: "",
  administration: "",
  treatment_date: "",
});

const medicineAdministrationMethods = ref([
  { label: "Oral (Pills, Tablets, Capsules, Syrups, Suspensions)", value: "Oral" },
  { label: "Subcutaneous Injection (Under the Skin)", value: "Subcutaneous" },
  { label: "Intramuscular Injection (Into the Muscle)", value: "Intramuscular" },
  { label: "Intravenous Injection (Into the Vein)", value: "Intravenous" },
  { label: "Topical (Creams, Ointments, Gels)", value: "Topical" },
  { label: "Transdermal (Patches, Absorption through Skin)", value: "Transdermal" },
  { label: "Ophthalmic (Eye Drops, Ointments)", value: "Ophthalmic" },
  { label: "Otic (Ear Drops, Medications)", value: "Otic" },
  { label: "Inhalation (Nebulizers, Inhalers)", value: "Inhalation" },
  { label: "Rectal (Suppositories, Enemas)", value: "Rectal" },
  { label: "Sublingual (Under the Tongue)", value: "Sublingual" },
  { label: "Intranasal (Nasal Sprays, Drops)", value: "Intranasal" },
  { label: "Intraosseous (Into the Bone)", value: "Intraosseous" },
]);

// Fetch the existing treatment data
const fetchTreatment = async () => {
  try {
    const response = await axiosInstance.get(`/treatments/${props.treatmentId}`);
    const data = response.data;
    treatment.value = {
      name: data.name,
      dosage: data.dosage,
      description: data.description,
      administration: medicineAdministrationMethods.value.find(
        (method) => method.value === data.administration
      ),
      treatment_date: new Date(data.treatment_date),
    };
  } catch (error) {
    eventBus.emit("show-toast", {
      severity: "warn",
      summary: t("common.error"),
      detail: error,
      life: 5000,
    });
  }
};

// Fetch treatment data when the component is mounted
onMounted(() => {
  fetchTreatment();
});

// Form submission
const submitForm = async () => {
  const submissionData = {
    medical_record_id: props.medical_record_id,
    name: treatment.value.name,
    dosage: treatment.value.dosage,
    administration: treatment.value.administration.value,
    description: treatment.value.description,
    treatment_date: treatment.value.treatment_date
      ? treatment.value.treatment_date.toLocaleDateString("en-CA")
      : null,
  };
  
  try {
    const response = await axiosInstance.put(
      `/treatments/${props.treatmentId}`,
      submissionData
    );
    eventBus.emit("show-toast", {
      severity: "success",
      summary: t("common.data_updated"),
      detail: `Treatment Updated Successfully`,
      life: 5000,
    });
    emit("TreatmentUpdated", response.data);
  } catch (error) {
    eventBus.emit("show-toast", {
      severity: "warn",
      summary: t("common.error"),
      detail: error,
      life: 5000,
    });
  }
};
</script>
