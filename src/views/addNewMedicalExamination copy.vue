<template>
  <div class="w-full">
    <form @submit.prevent="submitForm" class="mx-auto w-full">
      <fieldset
        class="p-fieldset p-component w-4/5 flex flex-wrap mx-auto items-top border rounded-lg p-4"
      >
        <legend>Add New Medical Examination</legend>
        <input
          type="hidden"
          id="medical_record_id"
          v-model="examination.medical_record_id"
        />

        <!-- Examination Date -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <label for="examination_date">Examination Date</label>
            <DatePicker showIcon  iconDisplay="input" showButtonBar
              showTime
              hourFormat="12"
              id="examination_date"
              v-model="examination.examination_date"
              dateFormat="yy-mm-dd"
            />
          </FloatLabel>
        </div>

        <!-- Animal Weight -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <InputNumber
              v-model="examination.animal_weight"
              :step="0.25"
              inputId="animal_weight"
              showButtons
              mode="decimal"
              suffix=" kg"
              :min="0"
              :max="500"
              fluid
            />
            <label for="animal_weight">Animal Weight</label>
          </FloatLabel>
        </div>

        <!-- Animal Behavior -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <Textarea
              class="w-full"
              rows="2"
              fluid
              autoResize
              id="animal_behavior"
              v-model="examination.animal_behavior"
            />
            <label for="animal_behavior">Animal Behavior</label>
          </FloatLabel>
        </div>

        <!-- Eyes -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <Textarea
              class="w-full"
              rows="2"
              fluid
              autoResize
              id="eyes"
              v-model="examination.eyes"
            />
            <label for="eyes">Eyes</label>
          </FloatLabel>
        </div>

        <!-- Eye Sunkenness -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <Select
              fluid
              optionLabel="label"
              optionValue="value"
              v-model="examination.eye_sunkenness"
              :options="yesno"
            />
            <label for="eye_sunkenness">Eye Sunkenness</label>
          </FloatLabel>
        </div>

        <!-- Nose -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <Textarea
              class="w-full"
              rows="2"
              fluid
              autoResize
              id="nose"
              v-model="examination.nose"
            />
            <label for="nose">Nose</label>
          </FloatLabel>
        </div>

        <!-- Nasal Discharge -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <Textarea
              class="w-full"
              rows="2"
              fluid
              autoResize
              id="nasal_discharge"
              v-model="examination.nasal_discharge"
            />
            <label for="nasal_discharge">Nasal Discharge</label>
          </FloatLabel>
        </div>

        <!-- Mouth -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <Textarea
              class="w-full"
              rows="2"
              fluid
              autoResize
              id="mouth"
              v-model="examination.mouth"
            />
            <label for="mouth">Mouth</label>
          </FloatLabel>
        </div>

        <!-- Teeth -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <Textarea
              class="w-full"
              rows="2"
              fluid
              autoResize
              id="teeth"
              v-model="examination.teeth"
            />
            <label for="teeth">Teeth</label>
          </FloatLabel>
        </div>

        <!-- Gums -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <Textarea
              class="w-full"
              rows="2"
              fluid
              autoResize
              id="gums"
              v-model="examination.gums"
            />
            <label for="gums">Gums</label>
          </FloatLabel>
        </div>

        <!-- Tongue -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <Textarea
              class="w-full"
              rows="2"
              fluid
              autoResize
              id="tongue"
              v-model="examination.tongue"
            />
            <label for="tongue">Tongue</label>
          </FloatLabel>
        </div>

        <!-- Mucous Membranes -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <Textarea
              class="w-full"
              rows="2"
              fluid
              autoResize
              id="mucous_membranes"
              v-model="examination.mucous_membranes"
            />
            <label for="mucous_membranes">Mucous Membranes</label>
          </FloatLabel>
        </div>

        <!-- Ears -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <Textarea
              class="w-full"
              rows="2"
              fluid
              autoResize
              id="ears"
              v-model="examination.ears"
            />
            <label for="ears">Ears</label>
          </FloatLabel>
        </div>

        <!-- Pulse Rate -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <InputNumber
              v-model="examination.pulse_rate"
              showButtons
              inputId="pulse_rate"
              suffix=" bpm"
              :min="0"
              :max="300"
              fluid
            />
            <label for="pulse_rate">Pulse Rate</label>
          </FloatLabel>
        </div>

        <!-- Respiratory Rate -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <InputNumber
              showButtons
              v-model="examination.respiratory_rate"
              inputId="respiratory_rate"
              suffix=" breaths/min"
              :min="0"
              :max="100"
              fluid
            />
            <label for="respiratory_rate">Respiratory Rate</label>
          </FloatLabel>
        </div>

        <!-- Breathing Pattern -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <Textarea
              class="w-full"
              rows="2"
              fluid
              autoResize
              id="breathing_pattern"
              v-model="examination.breathing_pattern"
            />
            <label for="breathing_pattern">Breathing Pattern</label>
          </FloatLabel>
        </div>

        <!-- Breath Sound -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <Textarea
              class="w-full"
              rows="2"
              fluid
              autoResize
              id="breath_sound"
              v-model="examination.breath_sound"
            />
            <label for="breath_sound">Breath Sound</label>
          </FloatLabel>
        </div>

        <!-- Temperature -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <InputNumber
              v-model="examination.temperature"
              :step="0.5"
              showButtons
              inputId="temperature"
              mode="decimal"
              suffix=" ℃"
              :min="0"
              :max="45"
              fluid
            />
            <label for="temperature">Temperature</label>
          </FloatLabel>
        </div>

        <!-- Oxygenation -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <Textarea
              class="w-full"
              rows="2"
              fluid
              autoResize
              id="oxygenation"
              v-model="examination.oxygenation"
            />
            <label for="oxygenation">Oxygenation</label>
          </FloatLabel>
        </div>

        <!-- Nervous System -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <Textarea
              class="w-full"
              rows="2"
              fluid
              autoResize
              id="nervous_system"
              v-model="examination.nervous_system"
            />
            <label for="nervous_system">Nervous System</label>
          </FloatLabel>
        </div>

        <!-- Skin -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <Textarea
              class="w-full"
              rows="2"
              fluid
              autoResize
              id="skin"
              v-model="examination.skin"
            />
            <label for="skin">Skin</label>
          </FloatLabel>
        </div>

        <!-- Skin Lumps or Infections -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <Textarea
              class="w-full"
              rows="2"
              fluid
              autoResize
              id="skin_lumps_or_infections"
              v-model="examination.skin_lumps_or_infections"
            />
            <label for="skin_lumps_or_infections">Skin Lumps or Infections</label>
          </FloatLabel>
        </div>

        <!-- Skin Coat Condition -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <Textarea
              class="w-full"
              rows="2"
              fluid
              autoResize
              id="skin_coat_condition"
              v-model="examination.skin_coat_condition"
            />
            <label for="skin_coat_condition">Skin Coat Condition</label>
          </FloatLabel>
        </div>

        <!-- Abdominal Palpation -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <Textarea
              class="w-full"
              rows="2"
              fluid
              autoResize
              id="abdominal_palpation"
              v-model="examination.abdominal_palpation"
            />
            <label for="abdominal_palpation">Abdominal Palpation</label>
          </FloatLabel>
        </div>

        <!-- Lymph Nodes -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <Textarea
              class="w-full"
              rows="2"
              fluid
              autoResize
              id="lymph_nodes"
              v-model="examination.lymph_nodes"
            />
            <label for="lymph_nodes">Lymph Nodes</label>
          </FloatLabel>
        </div>

        <!-- Body Condition Score -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <InputNumber
              v-model="examination.body_condition_score"
              showButtons
              inputId="body_condition_score"
              :min="1"
              :max="10"
              fluid
            />
            <label for="body_condition_score">Body Condition Score (BCS)</label>
          </FloatLabel>
        </div>

        <!-- Hydration Status -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <Textarea
              class="w-full"
              rows="2"
              fluid
              autoResize
              id="hydration_status"
              v-model="examination.hydration_status"
            />
            <label for="hydration_status">Hydration Status</label>
          </FloatLabel>
        </div>

        <!-- Capillary Refill Time -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <Textarea
              class="w-full"
              rows="2"
              fluid
              autoResize
              id="capillary_refill_time"
              v-model="examination.capillary_refill_time"
            />
            <label for="capillary_refill_time">Capillary Refill Time (CRT)</label>
          </FloatLabel>
        </div>

        <!-- Preliminary Diagnosis -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <Textarea
              class="w-full"
              rows="2"
              fluid
              autoResize
              id="preliminary_diagnosis"
              v-model="examination.preliminary_diagnosis"
            />
            <label for="preliminary_diagnosis">Preliminary Diagnosis</label>
          </FloatLabel>
        </div>

        <!-- Recommendations -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <Textarea
              class="w-full"
              rows="2"
              fluid
              autoResize
              id="recommendations"
              v-model="examination.recommendations"
            />
            <label for="recommendations">Recommendations</label>
          </FloatLabel>
        </div>

        <!-- Notes -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <Textarea
              id="notes"
              class="w-full"
              rows="2"
              autoResize
              fluid
              v-model="examination.notes"
            />
            <label for="notes">Notes</label>
          </FloatLabel>
        </div>

        <!-- Submit Button -->
        <div class="field mt-6 w-1/2">
          <Button type="submit" label="Submit" />
        </div>
      </fieldset>
    </form>
  </div>
</template>

<script setup>
import { ref } from "vue";
import InputNumber from "primevue/inputnumber";
import DatePicker from "primevue/datepicker";
import Fieldset from "primevue/fieldset";
import Select from "primevue/select";
import FloatLabel from "primevue/floatlabel";
import Button from "primevue/button";
import Textarea from "primevue/textarea";
import axiosInstance from "@/axios"; // Assuming you've created a global axios instance
import eventBus from "@/eventBus";
import router from "@/router";
const props = defineProps({
  medical_record_id: {
    type: Number,
    required: true,
  },
});
const emit = defineEmits(["submitted"]); // Define the event to be emitted

const examination = ref(
  /*{
    medical_record_id: props.medical_record_id,
    examination_date: "",
    animal_weight: null,
    animal_behavior: "",
    eyes: "",
    eye_sunkenness: "",
    nose: "",
    nasal_discharge: "",
    mouth: "",
    teeth: "",
    gums: "",
    tongue: "",
    mucous_membranes: "",
    ears: "",
    pulse_rate: null,
    respiratory_rate: null,
    breathing_pattern: "",
    breath_sound: "",
    temperature: null,
    oxygenation: "",
    nervous_system: "",
    skin: "",
    skin_lumps_or_infections: "",
    skin_coat_condition: "",
    abdominal_palpation: "",
    lymph_nodes: "",
    body_condition_score: null,
    hydration_status: "",
    capillary_refill_time: "",
    preliminary_diagnosis: "",
    recommendations: "",
    notes: "",
  }*/
  {
    medical_record_id: props.medical_record_id,
    examination_date: "2025-03-22",
    animal_weight: 25.5,
    animal_behavior: "Calm and cooperative during examination",
    eyes: "Clear, no discharge or redness observed",
    eye_sunkenness: "no",
    nose: "No nasal discharge, normal breathing",
    nasal_discharge: "None",
    mouth: "Healthy gums, no lesions or abnormalities",
    teeth: "No dental issues, clean and intact",
    gums: "Pink and healthy, no signs of inflammation",
    tongue: "Normal color and texture",
    mucous_membranes: "Moist and pink, no abnormalities",
    ears: "Clean, no signs of infection or parasites",
    pulse_rate: 80,
    respiratory_rate: 20,
    breathing_pattern: "Regular and unlabored",
    breath_sound: "Clear, no wheezing or crackles",
    temperature: 38.5,
    oxygenation: "Normal, SpO2 98%",
    nervous_system: "Normal reflexes, no neurological deficits",
    skin: "Healthy, no lesions or rashes",
    skin_lumps_or_infections: "None",
    skin_coat_condition: "Shiny and smooth, no signs of parasites",
    abdominal_palpation: "Soft, no pain or abnormalities",
    lymph_nodes: "Normal size, no swelling",
    body_condition_score: 5,
    hydration_status: "Normal, skin elasticity good",
    capillary_refill_time: "2 seconds",
    preliminary_diagnosis: "No significant abnormalities detected",
    recommendations: "Continue regular diet and exercise. Monitor for any changes.",
    notes: "Patient appears to be in good health. No immediate concerns.",
  }
);

const yesno = ref([
  { label: "Yes", value: "yes" },
  { label: "No", value: "no" },
]);

// Form submission
const submitForm = async () => {
  const submissionData = {
    ...examination.value,
    medical_record_id: props.medical_record_id,
    eye_sunkenness: examination.value.eye_sunkenness,
    respiratory_rate: examination.value.respiratory_rate + "breaths/min",
  };
  // console.log(submissionData);
  try {
    const response = await axiosInstance.post("/medical-examinations", submissionData);
    emit("submitted", response.data); // You may modify this based on your response structure

    eventBus.emit("show-toast", {
      severity: "success",
      summary: "Data Loaded",
      detail: `Medical Examination Added Successfully`,
      life: 5000,
    });
  } catch (error) {
    eventBus.emit("show-toast", {
      severity: "warn",
      summary: "Error",
      detail: error,
      life: 5000,
    });
    console.error("Error submitting form:", error);
  }
};
</script>

<style scoped>
.form-container {
  max-width: 500px;
  margin: auto;
}
.field {
  margin-bottom: 16px;
}
.p-fieldset-content {
  display: flex;
}
</style>
