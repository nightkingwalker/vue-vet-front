<template>
  <div class="px-4">
    <Card v-if="medicalRecord.medical_examinations.length > 0">
      <template #title>
        <div class="flex justify-between">
          <span>Physical Examination Report</span>
          <!-- <Button
            v-tooltip.top="{
              value: 'Add Examination',
              pt: {
                arrow: {
                  style: {
                    borderTopColor: 'var(--p-primary-color)',
                  },
                },
                text:
                  '!bg-[var(--p-primary-color)] !font-thin 2xl:!text-lg lg:!text-xs shadow-md',
              },
            }"
            icon="pi pi-plus"
            @click="showNewPatientModal"
            class="p-button p-button-icon-only !text-sm !font-thin h-8"
          /> -->
        </div>
      </template>
      <!-- <template #subtitle>Medical Record ID: {{ medicalRecord.id }}</template> -->
      <template #content>
        <!-- General Information -->
        <div class="flex justify-between">
          <Panel class="w-[30%] border rounded-lg shadow p-4">
            <p><strong>Pet ID:</strong> {{ medicalRecord.pet_id }}</p>
            <p><strong>Pet Name:</strong> {{ props.pet_name }}</p>
            <p><strong>Branch ID:</strong> {{ medicalRecord.branch_id }}</p>
            <p><strong>Visit Date:</strong> {{ formatDate(medicalRecord.created_at) }}</p>
            <p><strong>Diagnosis:</strong> {{ medicalRecord.diagnosis }}</p>
          </Panel>
          <Panel class="w-[30%] border rounded-lg shadow p-4">
            <p><strong>Created At:</strong> {{ formatDate(medicalRecord.created_at) }}</p>
            <p><strong>Updated At:</strong> {{ formatDate(medicalRecord.updated_at) }}</p>
          </Panel>
        </div>

        <!-- Examination Details -->
        <Divider align="left" type="solid">
          <span class="text-xl font-bold">Examination Details</span>
        </Divider>

        <div
          v-for="(exam, index) in medicalRecord.medical_examinations"
          :key="index"
          class="grid"
        >
          <div class="w-full pb-4">
            <p>
              <strong>Examination Date:</strong> {{ formatDate(exam.examination_date) }}
            </p>
            <p><strong>Animal Weight:</strong> {{ exam.animal_weight }} kg</p>
            <p><strong>Temperature:</strong> {{ exam.temperature }} °C</p>
            <p><strong>Behavior:</strong> {{ exam.animal_behavior }}</p>
          </div>

          <div class="flex flex-wrap gap-4">
            <!-- Head and Neck Examination -->
            <Panel
              header="Head and Neck Examination"
              collapsed
              toggleable
              class="w-[30%] border rounded-lg shadow p-4"
            >
              <!-- <h3 class="text-lg font-bold">Head and Neck Examination</h3> -->
              <p><strong>Eyes:</strong> {{ exam.eyes }}</p>
              <p><strong>Eye Sunkenness:</strong> {{ exam.eye_sunkenness }}</p>
              <p><strong>Nose:</strong> {{ exam.nose }}</p>
              <p><strong>Nasal Discharge:</strong> {{ exam.nasal_discharge }}</p>
              <p><strong>Mouth:</strong> {{ exam.mouth }}</p>
              <p><strong>Teeth:</strong> {{ exam.teeth }}</p>
              <p><strong>Gums:</strong> {{ exam.gums }}</p>
              <p><strong>Tongue:</strong> {{ exam.tongue }}</p>
              <p><strong>Mucous Membranes:</strong> {{ exam.mucous_membranes }}</p>
              <p><strong>Ears:</strong> {{ exam.ears }}</p>
            </Panel>
            <!-- Vital Signs -->
            <Panel
              header="Vital Signs"
              collapsed
              toggleable
              class="w-[30%] border rounded-lg shadow p-4"
            >
              <!-- <h3 class="text-lg font-bold">Vital Signs</h3> -->
              <p><strong>Pulse Rate:</strong> {{ exam.pulse_rate }} bpm</p>
              <p><strong>Respiratory Rate:</strong> {{ exam.respiratory_rate }}</p>
              <p><strong>Breathing Pattern:</strong> {{ exam.breathing_pattern }}</p>
              <p><strong>Breath Sound:</strong> {{ exam.breath_sound }}</p>
              <p><strong>Oxygenation:</strong> {{ exam.oxygenation }}</p>
              <p>
                <strong>Capillary Refill Time:</strong> {{ exam.capillary_refill_time }}
              </p>
            </Panel>
            <!-- Nervous System and Skin -->
            <Panel
              header="Nervous System"
              collapsed
              toggleable
              class="w-[30%] border rounded-lg shadow p-4"
            >
              <!-- <h3 class="text-lg font-bold">Nervous System</h3> -->
              <p><strong>Nervous System:</strong> {{ exam.nervous_system }}</p>
            </Panel>
            <Panel
              header="Skin and Coat"
              collapsed
              toggleable
              class="w-[30%] border rounded-lg shadow p-4"
            >
              <!-- <h3 class="text-lg font-bold">Skin and Coat</h3> -->
              <p><strong>Skin:</strong> {{ exam.skin }}</p>
              <p>
                <strong>Skin Lumps or Infections:</strong>
                {{ exam.skin_lumps_or_infections }}
              </p>
              <p><strong>Skin Coat Condition:</strong> {{ exam.skin_coat_condition }}</p>
            </Panel>
            <!-- Abdominal and Lymph Nodes -->
            <Panel
              header="Abdominal Examination"
              collapsed
              toggleable
              class="w-[30%] border rounded-lg shadow p-4"
            >
              <!-- <h3 class="text-lg font-bold">Abdominal Examination</h3> -->
              <p><strong>Abdominal Palpation:</strong> {{ exam.abdominal_palpation }}</p>
              <p><strong>Lymph Nodes:</strong> {{ exam.lymph_nodes }}</p>
            </Panel>
            <!-- Body Condition and Hydration -->
            <Panel
              header="Body Condition"
              collapsed
              toggleable
              class="w-[30%] border rounded-lg shadow p-4"
            >
              <h3 class="text-lg font-bold">Body Condition</h3>
              <p>
                <strong>Body Condition Score:</strong> {{ exam.body_condition_score }}
              </p>
              <p><strong>Hydration Status:</strong> {{ exam.hydration_status }}</p>
            </Panel>
            <!-- Preliminary Diagnosis and Recommendations -->
            <div class="col-12">
              <!-- <h3 class="text-lg font-bold">Diagnosis and Recommendations</h3> -->
              <p>
                <strong>Preliminary Diagnosis:</strong> {{ exam.preliminary_diagnosis }}
              </p>
              <p><strong>Recommendations:</strong> {{ exam.recommendations }}</p>
              <p><strong>Notes:</strong> {{ exam.notes }}</p>
            </div>
          </div>
        </div>
      </template>
    </Card>
    <div v-else>
      No Exaination has been performed yet.
      <Button
        label="Add Physical Examination"
        icon="pi pi-plus"
        @click="showAddPhysicalExaminationModal(props.medical_record_id)"
        v-tooltip.bottom="`Add Physical Examination`"
        class="p-button p-component !text-xs !h-8 ml-2"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from "vue";
import Card from "primevue/card";
import Divider from "primevue/divider";
import Panel from "primevue/panel";
import Button from "primevue/button";
import axiosInstance from "@/axios"; // Assuming axiosInstance is set up correctly

const emit = defineEmits(); // Define the event to be emitted

const props = defineProps({
  medical_record_id: {
    type: Number,
    required: true,
  },
  pet_name: {
    type: String,
    required: true,
  },
});
// Sample JSON data
const medicalRecord = ref({
  medical_examinations: {},
});
/* {
  id: 44,
  pet_id: 9,
  branch_id: 1,
  visit_date: 62,
  diagnosis: "Test",
  created_at: "2025-03-18T17:43:03.000000Z",
  updated_at: "2025-03-18T17:43:03.000000Z",
  medical_examinations: [
    {
      ex_id: 2,
      medical_record_id: 44,
      examination_date: "2025-03-22T00:00:00.000000Z",
      animal_weight: "25.50",
      temperature: "38.50",
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
      respiratory_rate: "20 breaths/min",
      breathing_pattern: "Regular and unlabored",
      breath_sound: "Clear, no wheezing or crackles",
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
      created_at: "2025-03-22T13:15:39.000000Z",
      updated_at: "2025-03-22T13:15:39.000000Z",
    },
  ],
});*/

const fetchMedicalExamination = async () => {
  //   loading.value = true;
  console.log("Medical Record ID:", props.medical_record_id);
  try {
    // console.log("Medical Record ID:", props.medical_record_id);
    // Make the request using the axios instance with interceptors
    const response = await axiosInstance.get(
      `/medical-records/${props.medical_record_id}/examntn`
    );
    medicalRecord.value = response.data;
    console.log(medicalRecord.value);

    loading.value = false; // Stop loading once data is fetched
  } catch (error) {
    //     // showSuccess("warn", "Warning", "Couldent Fetch Data");
  } finally {
  }
};
// Helper function to format dates
const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString();
};
const showAddPhysicalExaminationModal = (medicalRecordId) => {
  emit("showAddPhysicalExaminationModal", medicalRecordId);
};
onMounted(() => {
  // console.log("Component mounted, setting up event listeners");
  fetchMedicalExamination();

  //   eventBus.on("newTreatmentAdded", () => {
  //     // console.log("Received newTreatmentAdded event");
  //     fetchTreatments();
  //   });

  //   eventBus.on("TreatmentUpdatedSuccessfully", () => {
  //     // console.log("Received TreatmentUpdatedSuccessfully event");
  //     fetchTreatments();
  //   });
});
</script>

<style scoped>
/* Add custom styles if needed */
</style>
