<template>
  <div class="px-4 lg:!text-[14px]">
    <Card v-if="medicalRecord.medical_examinations.length > 0">
      <template #title>
        <div class="flex justify-between">
          <span>{{ $t("medical_examination.title") }}</span>
          <Button type="button" icon="fa-solid fa-pencil !text-primary" v-tooltip.top="{
            value: $t('medical_examination.edit_button'),
            pt: {
              arrow: {
                style: {
                  borderTopColor: 'var(--p-primary-color)',
                },
              },
              text:
                '!bg-[var(--p-primary-color)] !text-primary-contrast !font-thin !text-xs',
            },
          }" rounded size="small" class="!text-xs !text-primary mx-2" @click="isEditable = !isEditable" />
        </div>
      </template>
      <template #content>
        <!-- General Information -->
        <!--         <div class="flex justify-between">
          <Panel class="w-[30%] border rounded-lg shadow p-4">
            <p>
              <strong>{{ $t("medical_examination.general_info.branch_name") }}:</strong>
              {{ props.branch_name }}
            </p>
            <p>
              <strong>{{ $t("medical_examination.general_info.pet_name") }}:</strong>
              {{ props.pet_name }}
            </p>
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
 -->
        <!-- Examination Details -->
        <Divider :align="!isRtl ? `left` : `right`" type="solid">
          <span class="text-xl font-bold">{{
            $t("medical_examination.examination_details")
          }}</span>
        </Divider>

        <div v-for="(exam, index) in medicalRecord.medical_examinations" :key="index" class="w-full">
          <fieldset class="p-fieldset p-component w-4/5 flex flex-wrap mx-auto gap-2 items-start border rounded-lg p-4">
            <Stepper :value="activeStep" class="w-full">
              <StepList class="flex flex-wrap mb-4">
                <Step class="w-1/7" value="1">{{
                  $t("medical_examination_form.steps.general_info")
                }}</Step>
                <Step class="w-1/7" value="2">{{
                  $t("medical_examination_form.steps.head_neck")
                }}</Step>
                <Step class="w-1/7" value="3">{{
                  $t("medical_examination_form.steps.vital_signs")
                }}</Step>
                <Step class="w-1/7" value="4">{{
                  $t("medical_examination_form.steps.nervous_skin")
                }}</Step>
                <Step class="w-1/7" value="5">{{
                  $t("medical_examination_form.steps.abdomen_lymph")
                }}</Step>
                <Step class="w-1/7" value="6">{{
                  $t("medical_examination_form.steps.body_condition")
                }}</Step>
                <Step class="w-1/7" value="7">{{
                  $t("medical_examination_form.steps.diagnosis")
                }}</Step>
              </StepList>

              <StepPanels>
                <!-- Step 1 -->
                <StepPanel value="1" v-slot="{ activateCallback }">
                  <div class="flex flex-col gap-4">
                    <h4 class="border-b-4 rounded border-b-violet-800 w-fit font-bold">
                      {{ $t("medical_examination_form.section_titles.general_info") }}
                    </h4>
                  </div>
                  <div class="grid grid-cols-2 gap-2 mt-3">
                    <div class="field mt-3 w-2/3">
                      <FloatLabel>
                        <DatePicker showIcon iconDisplay="input" showButtonBar fluid id="examination_date"
                          v-model="exam.examination_date" showTime hourFormat="12" dateFormat="yy-mm-dd"
                          :disabled="!isEditable" />
                        <label for="examination_date">{{
                          $t("medical_examination_form.fields.examination_date")
                        }}</label>
                      </FloatLabel>
                    </div>
                    <div class="field mt-3 w-2/3">
                      <FloatLabel>
                        <InputNumber fluid v-model="exam.animal_weight" :step="0.25" inputId="animal_weight" showButtons
                          mode="decimal" :min="0" :max="500" :minFractionDigits="2" :disabled="!isEditable" />
                        <label for="animal_weight">{{
                          $t("medical_examination_form.fields.animal_weight")
                        }}</label>
                      </FloatLabel>
                    </div>
                    <div class="field mt-3 w-2/3">
                      <FloatLabel>
                        <InputNumber fluid v-model="exam.temperature" :minFractionDigits="1" :step="0.5" showButtons
                          inputId="temperature" mode="decimal" suffix=" ℃" :min="0" :max="45" :disabled="!isEditable" />
                        <label for="temperature">{{
                          $t("medical_examination_form.fields.temperature")
                        }}</label>
                      </FloatLabel>
                    </div>
                    <div class="field mt-3 w-2/3">
                      <FloatLabel>
                        <Textarea fluid id="animal_behavior" rows="2" autoResize v-model="exam.animal_behavior"
                          :disabled="!isEditable" />
                        <label for="animal_behavior">{{
                          $t("medical_examination_form.fields.animal_behavior")
                        }}</label>
                      </FloatLabel>
                    </div>
                  </div>
                  <div class="flex justify-end pt-4">
                    <Button :label="$t('medical_examination_form.buttons.next')" @click="activateCallback('2')" />
                  </div>
                </StepPanel>

                <!-- Step 2 -->
                <StepPanel value="2" v-slot="{ activateCallback }">
                  <fieldset class="p-4 border rounded-lg">
                    <div class="flex flex-col gap-4">
                      <h4 class="border-b-4 rounded border-b-violet-800 w-fit font-bold">
                        {{ $t("medical_examination_form.section_titles.head_neck") }}
                      </h4>
                    </div>
                    <div class="grid grid-cols-2 gap-2 mt-3">
                      <div class="field mt-3 w-2/3">
                        <FloatLabel>
                          <Textarea fluid id="eyes" rows="2" autoResize v-model="exam.eyes" :disabled="!isEditable" />
                          <label for="eyes">{{
                            $t("medical_examination_form.fields.eyes")
                          }}</label>
                        </FloatLabel>
                      </div>
                      <div class="field mt-3 w-2/3">
                        <FloatLabel>
                          <Select v-model="exam.eye_sunkenness" :options="yesno" fluid optionLabel="label"
                            optionValue="value" :disabled="!isEditable" />
                          <label for="eye_sunkenness">{{
                            $t("medical_examination_form.fields.eye_sunkenness")
                          }}</label>
                        </FloatLabel>
                      </div>
                      <div class="field mt-3 w-2/3">
                        <FloatLabel>
                          <Textarea fluid id="nose" rows="2" autoResize v-model="exam.nose" :disabled="!isEditable" />
                          <label for="nose">{{
                            $t("medical_examination_form.fields.nose")
                          }}</label>
                        </FloatLabel>
                      </div>
                      <div class="field mt-3 w-2/3">
                        <FloatLabel>
                          <Textarea fluid id="nasal_discharge" rows="2" autoResize v-model="exam.nasal_discharge"
                            :disabled="!isEditable" />
                          <label for="nasal_discharge">{{
                            $t("medical_examination_form.fields.nasal_discharge")
                          }}</label>
                        </FloatLabel>
                      </div>
                      <div class="field mt-3 w-2/3">
                        <FloatLabel>
                          <Textarea fluid id="mouth" rows="2" autoResize v-model="exam.mouth" :disabled="!isEditable" />
                          <label for="mouth">{{
                            $t("medical_examination_form.fields.mouth")
                          }}</label>
                        </FloatLabel>
                      </div>
                      <div class="field mt-3 w-2/3">
                        <FloatLabel>
                          <Textarea fluid id="teeth" rows="2" autoResize v-model="exam.teeth" :disabled="!isEditable" />
                          <label for="teeth">{{
                            $t("medical_examination_form.fields.teeth")
                          }}</label>
                        </FloatLabel>
                      </div>
                      <div class="field mt-3 w-2/3">
                        <FloatLabel>
                          <Textarea fluid id="gums" rows="2" autoResize v-model="exam.gums" :disabled="!isEditable" />
                          <label for="gums">{{
                            $t("medical_examination_form.fields.gums")
                          }}</label>
                        </FloatLabel>
                      </div>
                      <div class="field mt-3 w-2/3">
                        <FloatLabel>
                          <Textarea fluid id="tongue" rows="2" autoResize v-model="exam.tongue"
                            :disabled="!isEditable" />
                          <label for="tongue">{{
                            $t("medical_examination_form.fields.tongue")
                          }}</label>
                        </FloatLabel>
                      </div>
                      <div class="field mt-3 w-2/3">
                        <FloatLabel>
                          <Textarea fluid id="mucous_membranes" rows="2" autoResize v-model="exam.mucous_membranes"
                            :disabled="!isEditable" />
                          <label for="mucous_membranes">{{
                            $t("medical_examination_form.fields.mucous_membranes")
                          }}</label>
                        </FloatLabel>
                      </div>
                      <div class="field mt-3 w-2/3">
                        <FloatLabel>
                          <Textarea fluid id="ears" rows="2" autoResize v-model="exam.ears" :disabled="!isEditable" />
                          <label for="ears">{{
                            $t("medical_examination_form.fields.ears")
                          }}</label>
                        </FloatLabel>
                      </div>
                    </div>
                    <div class="flex justify-between pt-4">
                      <Button :label="$t('medical_examination_form.buttons.back')" @click="activateCallback('1')"
                        severity="secondary" />
                      <Button :label="$t('medical_examination_form.buttons.next')" @click="activateCallback('3')" />
                    </div>
                  </fieldset>
                </StepPanel>

                <!-- Step 3 -->
                <StepPanel value="3" v-slot="{ activateCallback }">
                  <fieldset class="p-4 border rounded-lg">
                    <div class="flex flex-col gap-4">
                      <h4 class="border-b-4 rounded border-b-violet-800 w-fit font-bold">
                        {{ $t("medical_examination_form.section_titles.vital_signs") }}
                      </h4>
                    </div>
                    <div class="grid grid-cols-2 gap-2 mt-3">
                      <div class="field mt-3 w-2/3">
                        <FloatLabel>
                          <InputNumber fluid v-model="exam.pulse_rate" showButtons suffix=" bpm" :min="0" :max="300"
                            :disabled="!isEditable" />
                          <label for="pulse_rate">{{
                            $t("medical_examination_form.fields.pulse_rate")
                          }}</label>
                        </FloatLabel>
                      </div>
                      <div class="field mt-3 w-2/3">
                        <FloatLabel>
                          <InputNumber fluid v-model="exam.respiratory_rate" showButtons suffix=" breaths/min" :min="0"
                            :max="100" :disabled="!isEditable" />
                          <label for="respiratory_rate">{{
                            $t("medical_examination_form.fields.respiratory_rate")
                          }}</label>
                        </FloatLabel>
                      </div>
                      <div class="field mt-3 w-2/3">
                        <FloatLabel>
                          <Textarea fluid id="breathing_pattern" rows="2" autoResize v-model="exam.breathing_pattern"
                            :disabled="!isEditable" />
                          <label for="breathing_pattern">{{
                            $t("medical_examination_form.fields.breathing_pattern")
                          }}</label>
                        </FloatLabel>
                      </div>
                      <div class="field mt-3 w-2/3">
                        <FloatLabel>
                          <Textarea fluid id="breath_sound" rows="2" autoResize v-model="exam.breath_sound"
                            :disabled="!isEditable" />
                          <label for="breath_sound">{{
                            $t("medical_examination_form.fields.breath_sound")
                          }}</label>
                        </FloatLabel>
                      </div>
                      <div class="field mt-3 w-2/3">
                        <FloatLabel>
                          <Textarea fluid id="oxygenation" rows="2" autoResize v-model="exam.oxygenation"
                            :disabled="!isEditable" />
                          <label for="oxygenation">{{
                            $t("medical_examination_form.fields.oxygenation")
                          }}</label>
                        </FloatLabel>
                      </div>
                      <div class="field mt-3 w-2/3">
                        <FloatLabel>
                          <Textarea fluid id="capillary_refill_time" rows="2" autoResize
                            v-model="exam.capillary_refill_time" :disabled="!isEditable" />
                          <label for="capillary_refill_time">{{
                            $t("medical_examination_form.fields.capillary_refill_time")
                          }}</label>
                        </FloatLabel>
                      </div>
                    </div>
                    <div class="flex justify-between pt-4">
                      <Button :label="$t('medical_examination_form.buttons.back')" @click="activateCallback('2')"
                        severity="secondary" />
                      <Button :label="$t('medical_examination_form.buttons.next')" @click="activateCallback('4')" />
                    </div>
                  </fieldset>
                </StepPanel>

                <!-- Step 4 -->
                <StepPanel value="4" v-slot="{ activateCallback }">
                  <fieldset class="p-4 border rounded-lg">
                    <div class="flex flex-col gap-4">
                      <h4 class="border-b-4 rounded border-b-violet-800 w-fit font-bold">
                        {{ $t("medical_examination_form.section_titles.nervous_skin") }}
                      </h4>
                    </div>
                    <div class="grid grid-cols-2 gap-2 mt-3">
                      <div class="field mt-3 w-2/3">
                        <FloatLabel>
                          <Textarea fluid id="nervous_system" rows="2" autoResize v-model="exam.nervous_system"
                            :disabled="!isEditable" />
                          <label for="nervous_system">{{
                            $t("medical_examination_form.fields.nervous_system")
                          }}</label>
                        </FloatLabel>
                      </div>
                      <div class="field mt-3 w-2/3">
                        <FloatLabel>
                          <Textarea fluid id="skin" rows="2" autoResize v-model="exam.skin" :disabled="!isEditable" />
                          <label for="skin">{{
                            $t("medical_examination_form.fields.skin")
                          }}</label>
                        </FloatLabel>
                      </div>
                      <div class="field mt-3 w-2/3">
                        <FloatLabel>
                          <Textarea fluid id="skin_lumps_or_infections" rows="2" autoResize
                            v-model="exam.skin_lumps_or_infections" :disabled="!isEditable" />
                          <label for="skin_lumps_or_infections">{{
                            $t("medical_examination_form.fields.skin_lumps_or_infections")
                          }}</label>
                        </FloatLabel>
                      </div>
                      <div class="field mt-3 w-2/3">
                        <FloatLabel>
                          <Textarea fluid id="skin_coat_condition" rows="2" autoResize
                            v-model="exam.skin_coat_condition" :disabled="!isEditable" />
                          <label for="skin_coat_condition">{{
                            $t("medical_examination_form.fields.skin_coat_condition")
                          }}</label>
                        </FloatLabel>
                      </div>
                    </div>
                    <div class="flex justify-between pt-4">
                      <Button :label="$t('medical_examination_form.buttons.back')" @click="activateCallback('3')"
                        severity="secondary" />
                      <Button :label="$t('medical_examination_form.buttons.next')" @click="activateCallback('5')" />
                    </div>
                  </fieldset>
                </StepPanel>
                <!-- Step 5 -->
                <StepPanel value="5" v-slot="{ activateCallback }">
                  <fieldset class="p-4 border rounded-lg">
                    <div class="flex flex-col gap-4">
                      <h4 class="border-b-4 rounded border-b-violet-800 w-fit font-bold">
                        {{ $t("medical_examination_form.section_titles.abdomen_lymph") }}
                      </h4>
                    </div>
                    <div class="grid grid-cols-2 gap-2 mt-3">
                      <div class="field mt-3 w-2/3">
                        <FloatLabel>
                          <Textarea fluid id="abdominal_palpation" rows="2" autoResize
                            v-model="exam.abdominal_palpation" :disabled="!isEditable" />
                          <label for="abdominal_palpation">
                            {{
                              $t("medical_examination_form.fields.abdominal_palpation")
                            }}
                          </label>
                        </FloatLabel>
                      </div>
                      <div class="field mt-3 w-2/3">
                        <FloatLabel>
                          <Textarea fluid id="lymph_nodes" rows="2" autoResize v-model="exam.lymph_nodes"
                            :disabled="!isEditable" />
                          <label for="lymph_nodes">
                            {{ $t("medical_examination_form.fields.lymph_nodes") }}
                          </label>
                        </FloatLabel>
                      </div>
                    </div>
                    <div class="flex justify-between pt-4">
                      <Button :label="$t('medical_examination_form.buttons.back')" @click="activateCallback('4')"
                        severity="secondary" />
                      <Button :label="$t('medical_examination_form.buttons.next')" @click="activateCallback('6')" />
                    </div>
                  </fieldset>
                </StepPanel>

                <!-- Step 6 -->
                <StepPanel value="6" v-slot="{ activateCallback }">
                  <fieldset class="p-4 border rounded-lg">
                    <div class="flex flex-col gap-4">
                      <h4 class="border-b-4 rounded border-b-violet-800 w-fit font-bold">
                        {{ $t("medical_examination_form.section_titles.body_condition") }}
                      </h4>
                    </div>
                    <div class="grid grid-cols-2 gap-2 mt-3">
                      <div class="field mt-3 w-2/3">
                        <FloatLabel>
                          <InputNumber fluid v-model="exam.body_condition_score" showButtons :min="1" :max="10"
                            :disabled="!isEditable" />
                          <label for="body_condition_score">
                            {{
                              $t("medical_examination_form.fields.body_condition_score")
                            }}
                          </label>
                        </FloatLabel>
                      </div>
                      <div class="field mt-3 w-2/3">
                        <FloatLabel>
                          <Textarea fluid id="hydration_status" rows="2" autoResize v-model="exam.hydration_status"
                            :disabled="!isEditable" />
                          <label for="hydration_status">
                            {{ $t("medical_examination_form.fields.hydration_status") }}
                          </label>
                        </FloatLabel>
                      </div>
                    </div>
                    <div class="flex justify-between pt-4">
                      <Button :label="$t('medical_examination_form.buttons.back')" @click="activateCallback('5')"
                        severity="secondary" />
                      <Button :label="$t('medical_examination_form.buttons.next')" @click="activateCallback('7')" />
                    </div>
                  </fieldset>
                </StepPanel>

                <!-- Step 7 -->
                <StepPanel value="7" v-slot="{ activateCallback }">
                  <div class="flex flex-col gap-4">
                    <h4 class="border-b-4 rounded border-b-violet-800 w-fit font-bold">
                      {{ $t("medical_examination_form.section_titles.diagnosis") }}
                    </h4>
                  </div>
                  <div class="grid grid-cols-2 gap-2 mt-3">
                    <div class="field mt-3 w-2/3">
                      <FloatLabel>
                        <Textarea fluid id="preliminary_diagnosis" rows="2" autoResize
                          v-model="exam.preliminary_diagnosis" :disabled="!isEditable" />
                        <label for="preliminary_diagnosis">
                          {{
                            $t("medical_examination_form.fields.preliminary_diagnosis")
                          }}
                        </label>
                      </FloatLabel>
                    </div>
                    <div class="field mt-3 w-2/3">
                      <FloatLabel>
                        <Textarea fluid id="recommendations" rows="2" autoResize v-model="exam.recommendations"
                          :disabled="!isEditable" />
                        <label for="recommendations">
                          {{ $t("medical_examination_form.fields.recommendations") }}
                        </label>
                      </FloatLabel>
                    </div>
                    <div class="field mt-3 w-2/3">
                      <FloatLabel>
                        <Textarea fluid id="notes" rows="2" autoResize v-model="exam.notes" :disabled="!isEditable" />
                        <label for="notes">
                          {{ $t("medical_examination_form.fields.notes") }}
                        </label>
                      </FloatLabel>
                    </div>
                  </div>
                  <div class="flex justify-between pt-4">
                    <Button :label="$t('medical_examination_form.buttons.back')" @click="activateCallback('6')"
                      severity="secondary" />
                    <Button :label="$t('medical_examination_form.buttons.submit')" type="submit"
                      @click="submitForm(exam)" v-if="isEditable" />
                  </div>
                </StepPanel>
              </StepPanels>
            </Stepper>
          </fieldset>
        </div>
      </template>
    </Card>
    <div v-else>
      {{ $t("medical_examination.no_examination") }}
      <Button :label="$t('medical_examination.add_examination')" icon="pi pi-plus"
        @click="showAddPhysicalExaminationModal(props.medical_record_id)"
        v-tooltip.bottom="$t('medical_examination.add_examination')" class="p-button p-component !text-xs !h-8 ml-2" />
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
import InputNumber from "primevue/inputnumber";
import DatePicker from "primevue/datepicker";
import Fieldset from "primevue/fieldset";
import Select from "primevue/select";
import FloatLabel from "primevue/floatlabel";
import Textarea from "primevue/textarea";
import Stepper from "primevue/stepper";
import StepList from "primevue/steplist";
import StepPanels from "primevue/steppanels";
import Step from "primevue/step";
import StepPanel from "primevue/steppanel";
import axiosInstance from "@/axios";
import eventBus from "@/eventBus";

const { t, locale } = useI18n();
const isRtl = computed(() => ["ar", "he", "fa"].includes(locale.value));
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

const emit = defineEmits(["showAddPhysicalExaminationModal"]);

const medicalRecord = ref({
  medical_examinations: [],
});

const activeStep = ref("1");
const isEditable = ref(false);
const yesno = ref([
  { label: t("medical_examination_form.options.yes"), value: "yes" },
  { label: t("medical_examination_form.options.no"), value: "no" },
]);

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
  return dateString ? new Date(dateString).toLocaleDateString() : null;
};

const showAddPhysicalExaminationModal = (medicalRecordId) => {
  emit("showAddPhysicalExaminationModal", medicalRecordId);
};

const submitForm = async (exam) => {
  try {
    const response = await axiosInstance.put(`/medical-examinations/${exam.id}`, exam);

    eventBus.emit("show-toast", {
      severity: "success",
      summary: t("medical_examination_form.messages.success_title"),
      detail: t("medical_examination_form.messages.success"),
      life: 5000,
    });

    isEditable.value = false;
    await fetchMedicalExamination();
  } catch (error) {
    eventBus.emit("show-toast", {
      severity: "error",
      summary: t("medical_examination_form.messages.error_title"),
      detail:
        error.response?.data?.message || t("medical_examination_form.messages.error"),
      life: 5000,
    });
    console.error("Error submitting form:", error);
  }
};

onMounted(() => {
  fetchMedicalExamination();
});
</script>

<style scoped>
.p-inputtext:disabled,
.p-checkbox-input:disabled,
.p-select-label,
.p-textarea:disabled,
.p-select.p-disabled,
.p-datepicker-dropdown,
.p-checkbox.p-disabled .p-checkbox-box .p-checkbox-icon {
  color: black !important;
}

.p-step-active .p-step-number {
  background: var(--p-primary-color) !important;
  color: var(--p-primary-contrast-color) !important;
}

.p-steppanel {
  background: transparent !important;
  padding: 0.5rem;
}
</style>
