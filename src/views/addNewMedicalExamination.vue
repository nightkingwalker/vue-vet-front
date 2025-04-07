<template>
  <div class="w-full">
    <fieldset
      class="p-fieldset p-component w-4/5 flex flex-wrap mx-auto gap-2 items-start border rounded-lg p-4"
    >
      <legend>Case History Details</legend>
      <Stepper :value="activeStep" class="w-full">
        <StepList class="mb-4">
          <Step value="1">General Info</Step>
          <Step value="2">Head & Neck</Step>
          <Step value="3">Vital Signs</Step>
          <Step value="4">Nervous & Skin</Step>
          <Step value="5">Abdomen & Lymph</Step>
          <Step value="6">Body Condition</Step>
          <Step value="7">Diagnosis</Step>
        </StepList>

        <StepPanels>
          <!-- Step 1 -->
          <StepPanel value="1" v-slot="{ activateCallback }">
            <div class="flex flex-col gap-4">
              <h4 class="border-b-4 rounded border-b-violet-800 w-fit font-bold">
                General Info
              </h4>
            </div>
            <div class="grid grid-cols-2 gap-6">
              <div class="field mt-6 w-2/3">
                <FloatLabel>
                  <label for="examination_date">Examination Date</label>
                  <DatePicker
                    fluid
                    id="examination_date"
                    v-model="examination.examination_date"
                    showTime
                    hourFormat="12"
                    showIcon
                    dateFormat="yy-mm-dd"
                  />
                </FloatLabel>
              </div>
              <div class="field mt-6 w-2/3">
                <FloatLabel>
                  <InputNumber
                    fluid
                    v-model="examination.animal_weight"
                    :step="0.25"
                    inputId="animal_weight"
                    showButtons
                    mode="decimal"
                    suffix=" kg"
                    :min="0"
                    :max="500"
                  />
                  <label for="animal_weight">Animal Weight</label>
                </FloatLabel>
              </div>
              <div class="field mt-6 w-2/3">
                <FloatLabel>
                  <InputNumber
                    fluid
                    v-model="examination.temperature"
                    :step="0.5"
                    showButtons
                    inputId="temperature"
                    mode="decimal"
                    suffix=" ℃"
                    :min="0"
                    :max="45"
                  />
                  <label for="temperature">Temperature</label>
                </FloatLabel>
              </div>
              <div class="field mt-6 w-2/3">
                <FloatLabel>
                  <Textarea
                    fluid
                    id="animal_behavior"
                    rows="2"
                    autoResize
                    v-model="examination.animal_behavior"
                  />
                  <label for="animal_behavior">Animal Behavior</label>
                </FloatLabel>
              </div>
            </div>
            <div class="flex justify-end pt-4">
              <Button label="Next" @click="activateCallback('2')" />
            </div>
          </StepPanel>

          <!-- Step 2 -->
          <StepPanel value="2" v-slot="{ activateCallback }">
            <fieldset class="p-4 border rounded-lg">
              <div class="flex flex-col gap-4">
                <h4 class="border-b-4 rounded border-b-violet-800 w-fit font-bold">
                  Head and Neck
                </h4>
              </div>
              <div class="grid grid-cols-2 gap-6">
                <div class="field mt-6 w-2/3">
                  <FloatLabel
                    ><Textarea
                      fluid
                      id="eyes"
                      rows="2"
                      autoResize
                      v-model="examination.eyes"
                    /><label for="eyes">Eyes</label></FloatLabel
                  >
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel
                    ><Select
                      v-model="examination.eye_sunkenness"
                      :options="yesno"
                      optionLabel="label"
                      optionValue="value"
                    /><label for="eye_sunkenness">Eye Sunkenness</label></FloatLabel
                  >
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel
                    ><Textarea
                      fluid
                      id="nose"
                      rows="2"
                      autoResize
                      v-model="examination.nose"
                    /><label for="nose">Nose</label></FloatLabel
                  >
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel
                    ><Textarea
                      fluid
                      id="nasal_discharge"
                      rows="2"
                      autoResize
                      v-model="examination.nasal_discharge"
                    /><label for="nasal_discharge">Nasal Discharge</label></FloatLabel
                  >
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel
                    ><Textarea
                      fluid
                      id="mouth"
                      rows="2"
                      autoResize
                      v-model="examination.mouth"
                    /><label for="mouth">Mouth</label></FloatLabel
                  >
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel
                    ><Textarea
                      fluid
                      id="teeth"
                      rows="2"
                      autoResize
                      v-model="examination.teeth"
                    /><label for="teeth">Teeth</label></FloatLabel
                  >
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel
                    ><Textarea
                      fluid
                      id="gums"
                      rows="2"
                      autoResize
                      v-model="examination.gums"
                    /><label for="gums">Gums</label></FloatLabel
                  >
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel
                    ><Textarea
                      fluid
                      id="tongue"
                      rows="2"
                      autoResize
                      v-model="examination.tongue"
                    /><label for="tongue">Tongue</label></FloatLabel
                  >
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel
                    ><Textarea
                      fluid
                      id="mucous_membranes"
                      rows="2"
                      autoResize
                      v-model="examination.mucous_membranes"
                    /><label for="mucous_membranes">Mucous Membranes</label></FloatLabel
                  >
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel
                    ><Textarea
                      fluid
                      id="ears"
                      rows="2"
                      autoResize
                      v-model="examination.ears"
                    /><label for="ears">Ears</label></FloatLabel
                  >
                </div>
              </div>
              <div class="flex justify-between pt-4">
                <Button
                  label="Back"
                  @click="activateCallback('1')"
                  severity="secondary"
                />
                <Button label="Next" @click="activateCallback('3')" />
              </div>
            </fieldset>
          </StepPanel>

          <!-- Step 3 -->
          <StepPanel value="3" v-slot="{ activateCallback }">
            <fieldset class="p-4 border rounded-lg">
              <div class="flex flex-col gap-4">
                <h4 class="border-b-4 rounded border-b-violet-800 w-fit font-bold">
                  Vital Signs
                </h4>
              </div>
              <div class="grid grid-cols-2 gap-6">
                <div class="field mt-6 w-2/3">
                  <FloatLabel
                    ><InputNumber
                      fluid
                      v-model="examination.pulse_rate"
                      showButtons
                      suffix=" bpm"
                      :min="0"
                      :max="300"
                    /><label for="pulse_rate">Pulse Rate</label></FloatLabel
                  >
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel
                    ><InputNumber
                      fluid
                      v-model="examination.respiratory_rate"
                      showButtons
                      suffix=" breaths/min"
                      :min="0"
                      :max="100"
                    /><label for="respiratory_rate">Respiratory Rate</label></FloatLabel
                  >
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel
                    ><Textarea
                      fluid
                      id="breathing_pattern"
                      rows="2"
                      autoResize
                      v-model="examination.breathing_pattern"
                    /><label for="breathing_pattern">Breathing Pattern</label></FloatLabel
                  >
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel
                    ><Textarea
                      fluid
                      id="breath_sound"
                      rows="2"
                      autoResize
                      v-model="examination.breath_sound"
                    /><label for="breath_sound">Breath Sound</label></FloatLabel
                  >
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel
                    ><Textarea
                      fluid
                      id="oxygenation"
                      rows="2"
                      autoResize
                      v-model="examination.oxygenation"
                    /><label for="oxygenation">Oxygenation</label></FloatLabel
                  >
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel
                    ><Textarea
                      fluid
                      id="capillary_refill_time"
                      rows="2"
                      autoResize
                      v-model="examination.capillary_refill_time"
                    /><label for="capillary_refill_time"
                      >Capillary Refill Time (CRT)</label
                    ></FloatLabel
                  >
                </div>
              </div>
              <div class="flex justify-between pt-4">
                <Button
                  label="Back"
                  @click="activateCallback('2')"
                  severity="secondary"
                />
                <Button label="Next" @click="activateCallback('4')" />
              </div>
            </fieldset>
          </StepPanel>

          <!-- Step 4 -->
          <StepPanel value="4" v-slot="{ activateCallback }">
            <fieldset class="p-4 border rounded-lg">
              <div class="flex flex-col gap-4">
                <h4 class="border-b-4 rounded border-b-violet-800 w-fit font-bold">
                  Nervous System & Skin
                </h4>
              </div>
              <div class="grid grid-cols-2 gap-6">
                <div class="field mt-6 w-2/3">
                  <FloatLabel
                    ><Textarea
                      fluid
                      id="nervous_system"
                      rows="2"
                      autoResize
                      v-model="examination.nervous_system"
                    /><label for="nervous_system">Nervous System</label></FloatLabel
                  >
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel
                    ><Textarea
                      fluid
                      id="skin"
                      rows="2"
                      autoResize
                      v-model="examination.skin"
                    /><label for="skin">Skin</label></FloatLabel
                  >
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel
                    ><Textarea
                      fluid
                      id="skin_lumps_or_infections"
                      rows="2"
                      autoResize
                      v-model="examination.skin_lumps_or_infections"
                    /><label for="skin_lumps_or_infections"
                      >Skin Lumps or Infections</label
                    ></FloatLabel
                  >
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel
                    ><Textarea
                      fluid
                      id="skin_coat_condition"
                      rows="2"
                      autoResize
                      v-model="examination.skin_coat_condition"
                    /><label for="skin_coat_condition"
                      >Skin Coat Condition</label
                    ></FloatLabel
                  >
                </div>
              </div>
              <div class="flex justify-between pt-4">
                <Button
                  label="Back"
                  @click="activateCallback('3')"
                  severity="secondary"
                />
                <Button label="Next" @click="activateCallback('5')" />
              </div>
            </fieldset>
          </StepPanel>

          <!-- Step 5 -->
          <StepPanel value="5" v-slot="{ activateCallback }">
            <fieldset class="p-4 border rounded-lg">
              <div class="flex flex-col gap-4">
                <h4 class="border-b-4 rounded border-b-violet-800 w-fit font-bold">
                  Abdomen & Lymph Nodes
                </h4>
              </div>
              <div class="grid grid-cols-2 gap-6">
                <div class="field mt-6 w-2/3">
                  <FloatLabel
                    ><Textarea
                      fluid
                      id="abdominal_palpation"
                      rows="2"
                      autoResize
                      v-model="examination.abdominal_palpation"
                    /><label for="abdominal_palpation"
                      >Abdominal Palpation</label
                    ></FloatLabel
                  >
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel
                    ><Textarea
                      fluid
                      id="lymph_nodes"
                      rows="2"
                      autoResize
                      v-model="examination.lymph_nodes"
                    /><label for="lymph_nodes">Lymph Nodes</label></FloatLabel
                  >
                </div>
              </div>
              <div class="flex justify-between pt-4">
                <Button
                  label="Back"
                  @click="activateCallback('4')"
                  severity="secondary"
                />
                <Button label="Next" @click="activateCallback('6')" />
              </div>
            </fieldset>
          </StepPanel>

          <!-- Step 6 -->
          <StepPanel value="6" v-slot="{ activateCallback }">
            <fieldset class="p-4 border rounded-lg">
              <div class="flex flex-col gap-4">
                <h4 class="border-b-4 rounded border-b-violet-800 w-fit font-bold">
                  Body Condition & Hydration
                </h4>
              </div>
              <div class="grid grid-cols-2 gap-6">
                <div class="field mt-6 w-2/3">
                  <FloatLabel
                    ><InputNumber
                      fluid
                      v-model="examination.body_condition_score"
                      showButtons
                      :min="1"
                      :max="10"
                    /><label for="body_condition_score"
                      >Body Condition Score (BCS)</label
                    ></FloatLabel
                  >
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel
                    ><Textarea
                      fluid
                      id="hydration_status"
                      rows="2"
                      autoResize
                      v-model="examination.hydration_status"
                    /><label for="hydration_status">Hydration Status</label>
                  </FloatLabel>
                </div>
              </div>
              <div class="flex justify-between pt-4">
                <Button
                  label="Back"
                  @click="activateCallback('5')"
                  severity="secondary"
                />
                <Button label="Next" @click="activateCallback('7')" />
              </div>
            </fieldset>
          </StepPanel>

          <!-- Step 7 -->
          <StepPanel value="7" v-slot="{ activateCallback }">
            <div class="flex flex-col gap-4">
              <h4 class="border-b-4 rounded border-b-violet-800 w-fit font-bold">
                Diagnosis and Recommendations
              </h4>
            </div>
            <div class="grid grid-cols-2 gap-6">
              <div class="field mt-6 w-2/3">
                <FloatLabel
                  ><Textarea
                    fluid
                    id="preliminary_diagnosis"
                    rows="2"
                    autoResize
                    v-model="examination.preliminary_diagnosis"
                  /><label for="preliminary_diagnosis"
                    >Preliminary Diagnosis</label
                  ></FloatLabel
                >
              </div>
              <div class="field mt-6 w-2/3">
                <FloatLabel
                  ><Textarea
                    fluid
                    id="recommendations"
                    rows="2"
                    autoResize
                    v-model="examination.recommendations"
                  /><label for="recommendations">Recommendations</label></FloatLabel
                >
              </div>
              <div class="field mt-6 w-2/3">
                <FloatLabel
                  ><Textarea
                    fluid
                    id="notes"
                    rows="2"
                    autoResize
                    v-model="examination.notes"
                  /><label for="notes">Notes</label></FloatLabel
                >
              </div>
            </div>
            <div class="flex justify-between pt-4">
              <Button label="Back" @click="activateCallback('6')" severity="secondary" />
              <Button label="Submit" type="submit" @click="submitForm" />
            </div>
          </StepPanel>
        </StepPanels>
      </Stepper>
    </fieldset>
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
import Stepper from "primevue/stepper";
import StepList from "primevue/steplist";
import StepPanels from "primevue/steppanels";
import Step from "primevue/step";
import StepPanel from "primevue/steppanel";

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
const activeStep = ref("1");

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
  console.log(submissionData);
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
