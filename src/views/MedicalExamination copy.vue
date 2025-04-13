<template>
  <div class="px-4">
    <Card v-if="medicalRecord.medical_examinations.length > 0">
      <template #title>
        <div class="flex justify-between">
          <span>{{ $t("medical_examination.title") }}</span>
        </div>
      </template>
      <template #content>
        <!-- General Information -->
        <div class="flex justify-between">
          <Panel class="w-[30%] border rounded-lg shadow p-4">
            <!-- <p>
              <strong>{{ $t("medical_examination.general_info.pet_id") }}:</strong>
              {{ medicalRecord.pet_id }}
            </p> -->
            <p>
              <strong>{{ $t("medical_examination.general_info.branch_name") }}:</strong>
              {{ props.branch_name }}
            </p>
            <p>
              <strong>{{ $t("medical_examination.general_info.pet_name") }}:</strong>
              {{ props.pet_name }}
            </p>
            <!-- <p>
              <strong>{{ $t("medical_examination.general_info.branch_id") }}:</strong>
              {{ medicalRecord.branch_id }}
            </p> -->
            <p>
              <strong>{{ $t("medical_examination.general_info.visit_date") }}:</strong>
              {{ formatDate(medicalRecord.created_at) }}
            </p>
            <p>
              <strong>{{ $t("medical_examination.general_info.diagnosis") }}:</strong>
              {{ medicalRecord.diagnosis }}
            </p>
          </Panel>
          <Panel class="w-[30%] border rounded-lg shadow p-4">
            <p>
              <strong>{{ $t("medical_examination.general_info.created_at") }}:</strong>
              {{ formatDate(medicalRecord.created_at) }}
            </p>
            <p>
              <strong>{{ $t("medical_examination.general_info.updated_at") }}:</strong>
              {{ formatDate(medicalRecord.updated_at) }}
            </p>
          </Panel>
        </div>

        <!-- Examination Details -->
        <Divider :align="!isRtl ? `left` : `right`" type="solid">
          <span class="text-xl font-bold">{{
            $t("medical_examination.examination_details")
          }}</span>
        </Divider>

        <div
          v-for="(exam, index) in medicalRecord.medical_examinations"
          :key="index"
          class="grid"
        >
          <div class="w-full pb-4">
            <p>
              <strong>{{ $t("medical_examination.exam_data.examination_date") }}:</strong>
              {{ formatDate(exam.examination_date) }}
            </p>
            <p>
              <strong>{{ $t("medical_examination.exam_data.animal_weight") }}:</strong>
              {{ exam.animal_weight }} kg
            </p>
            <p>
              <strong>{{ $t("medical_examination.exam_data.temperature") }}:</strong>
              {{ exam.temperature }} °C
            </p>
            <p>
              <strong>{{ $t("medical_examination.exam_data.behavior") }}:</strong>
              {{ exam.animal_behavior }}
            </p>
          </div>

          <div class="flex flex-wrap gap-4">
            <!-- Head and Neck Examination -->
            <Panel
              :header="$t('medical_examination.sections.head_neck')"
              collapsed
              toggleable
              class="w-[30%] border rounded-lg shadow p-4"
            >
              <p>
                <strong>{{ $t("medical_examination.sections.eyes") }}:</strong>
                {{ exam.eyes }}
              </p>
              <p>
                <strong>{{ $t("medical_examination.sections.eye_sunkenness") }}:</strong>
                {{ exam.eye_sunkenness }}
              </p>
              <p>
                <strong>{{ $t("medical_examination.sections.nose") }}:</strong>
                {{ exam.nose }}
              </p>
              <p>
                <strong>{{ $t("medical_examination.sections.nasal_discharge") }}:</strong>
                {{ exam.nasal_discharge }}
              </p>
              <p>
                <strong>{{ $t("medical_examination.sections.mouth") }}:</strong>
                {{ exam.mouth }}
              </p>
              <p>
                <strong>{{ $t("medical_examination.sections.teeth") }}:</strong>
                {{ exam.teeth }}
              </p>
              <p>
                <strong>{{ $t("medical_examination.sections.gums") }}:</strong>
                {{ exam.gums }}
              </p>
              <p>
                <strong>{{ $t("medical_examination.sections.tongue") }}:</strong>
                {{ exam.tongue }}
              </p>
              <p>
                <strong
                  >{{ $t("medical_examination.sections.mucous_membranes") }}:</strong
                >
                {{ exam.mucous_membranes }}
              </p>
              <p>
                <strong>{{ $t("medical_examination.sections.ears") }}:</strong>
                {{ exam.ears }}
              </p>
            </Panel>
            <!-- Vital Signs -->
            <Panel
              :header="$t('medical_examination.sections.vital_signs')"
              collapsed
              toggleable
              class="w-[30%] border rounded-lg shadow p-4"
            >
              <p>
                <strong>{{ $t("medical_examination.sections.pulse_rate") }}:</strong>
                {{ exam.pulse_rate }} bpm
              </p>
              <p>
                <strong
                  >{{ $t("medical_examination.sections.respiratory_rate") }}:</strong
                >
                {{ exam.respiratory_rate }}
              </p>
              <p>
                <strong
                  >{{ $t("medical_examination.sections.breathing_pattern") }}:</strong
                >
                {{ exam.breathing_pattern }}
              </p>
              <p>
                <strong>{{ $t("medical_examination.sections.breath_sound") }}:</strong>
                {{ exam.breath_sound }}
              </p>
              <p>
                <strong>{{ $t("medical_examination.sections.oxygenation") }}:</strong>
                {{ exam.oxygenation }}
              </p>
              <p>
                <strong
                  >{{ $t("medical_examination.sections.capillary_refill_time") }}:</strong
                >
                {{ exam.capillary_refill_time }}
              </p>
            </Panel>
            <!-- Nervous System and Skin -->
            <Panel
              :header="$t('medical_examination.sections.nervous_system')"
              collapsed
              toggleable
              class="w-[30%] border rounded-lg shadow p-4"
            >
              <p>
                <strong>{{ $t("medical_examination.sections.nervous_system") }}:</strong>
                {{ exam.nervous_system }}
              </p>
            </Panel>
            <Panel
              :header="$t('medical_examination.sections.skin_coat')"
              collapsed
              toggleable
              class="w-[30%] border rounded-lg shadow p-4"
            >
              <p>
                <strong>{{ $t("medical_examination.sections.skin") }}:</strong>
                {{ exam.skin }}
              </p>
              <p>
                <strong
                  >{{
                    $t("medical_examination.sections.skin_lumps_or_infections")
                  }}:</strong
                >
                {{ exam.skin_lumps_or_infections }}
              </p>
              <p>
                <strong
                  >{{ $t("medical_examination.sections.skin_coat_condition") }}:</strong
                >
                {{ exam.skin_coat_condition }}
              </p>
            </Panel>
            <!-- Abdominal and Lymph Nodes -->
            <Panel
              :header="$t('medical_examination.sections.abdominal')"
              collapsed
              toggleable
              class="w-[30%] border rounded-lg shadow p-4"
            >
              <p>
                <strong
                  >{{ $t("medical_examination.sections.abdominal_palpation") }}:</strong
                >
                {{ exam.abdominal_palpation }}
              </p>
              <p>
                <strong>{{ $t("medical_examination.sections.lymph_nodes") }}:</strong>
                {{ exam.lymph_nodes }}
              </p>
            </Panel>
            <!-- Body Condition and Hydration -->
            <Panel
              :header="$t('medical_examination.sections.body_condition')"
              collapsed
              toggleable
              class="w-[30%] border rounded-lg shadow p-4"
            >
              <p>
                <strong
                  >{{ $t("medical_examination.sections.body_condition_score") }}:</strong
                >
                {{ exam.body_condition_score }}
              </p>
              <p>
                <strong
                  >{{ $t("medical_examination.sections.hydration_status") }}:</strong
                >
                {{ exam.hydration_status }}
              </p>
            </Panel>
            <!-- Preliminary Diagnosis and Recommendations -->
            <div class="col-12">
              <p>
                <strong
                  >{{ $t("medical_examination.sections.preliminary_diagnosis") }}:</strong
                >
                {{ exam.preliminary_diagnosis }}
              </p>
              <p>
                <strong>{{ $t("medical_examination.sections.recommendations") }}:</strong>
                {{ exam.recommendations }}
              </p>
              <p>
                <strong>{{ $t("medical_examination.sections.notes") }}:</strong>
                {{ exam.notes }}
              </p>
            </div>
          </div>
        </div>
      </template>
    </Card>
    <div v-else>
      {{ $t("medical_examination.no_examination") }}
      <Button
        :label="$t('medical_examination.add_examination')"
        icon="pi pi-plus"
        @click="showAddPhysicalExaminationModal(props.medical_record_id)"
        v-tooltip.bottom="$t('medical_examination.add_examination')"
        class="p-button p-component !text-xs !h-8 ml-2"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from "vue";
import { useI18n } from "vue-i18n";
import Card from "primevue/card";
import Divider from "primevue/divider";
import Panel from "primevue/panel";
import Button from "primevue/button";
import axiosInstance from "@/axios";
import Cookies from "js-cookie";

const { t, locale } = useI18n();
const emit = defineEmits();

const props = defineProps({
  medical_record_id: {
    type: Number,
    required: true,
  },
  pet_name: {
    type: String,
    required: true,
  },
  branch_name: {
    type: String,
    required: true,
  },
});
const isRtl = computed(() => ["ar", "he", "fa"].includes(locale.value));
const medicalRecord = ref({
  medical_examinations: {},
});

const fetchMedicalExamination = async () => {
  try {
    const response = await axiosInstance.get(
      `/medical-records/${props.medical_record_id}/examntn`
    );
    medicalRecord.value = response.data;
  } catch (error) {
    console.error("Error fetching medical examination:", error);
  }
};

const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString();
};

const showAddPhysicalExaminationModal = (medicalRecordId) => {
  emit("showAddPhysicalExaminationModal", medicalRecordId);
};

onMounted(() => {
  fetchMedicalExamination();
});
</script>

<style scoped>
/* Add custom styles if needed */
</style>
