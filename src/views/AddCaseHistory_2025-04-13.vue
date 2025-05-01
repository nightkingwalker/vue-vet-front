<template>
  <div class="w-full">
    <fieldset
      class="p-fieldset p-component w-4/5 flex flex-wrap mx-auto gap-2 items-start border rounded-lg p-4"
    >
      <legend>{{ $t("case_history.title") }}</legend>
      <Stepper :value="activeStep" class="w-full">
        <!-- Step List -->
        <StepList class="flex flex-wrap items-start justify-between w-full mx-auto">
          <Step class="w-1/5" value="1">{{
            $t("case_history.steps.current_symptoms")
          }}</Step>
          <Step class="w-1/5" value="2">{{
            $t("case_history.steps.general_health")
          }}</Step>
          <Step class="w-1/5" value="3">{{
            $t("case_history.steps.reproductive_history")
          }}</Step>
          <Step class="w-1/5" value="4">{{ $t("case_history.steps.itching_skin") }}</Step>
          <Step class="w-1/5" value="5">{{ $t("case_history.steps.diet_water") }}</Step>
          <Step class="w-1/5" value="6">{{
            $t("case_history.steps.gastrointestinal")
          }}</Step>
          <Step class="w-1/5" value="7">{{ $t("case_history.steps.neurological") }}</Step>
          <Step class="w-1/5" value="8">{{ $t("case_history.steps.respiratory") }}</Step>
          <Step class="w-1/5" value="9">{{ $t("case_history.steps.urinary") }}</Step>
          <Step class="w-1/5" value="10">{{
            $t("case_history.steps.vaccination_medication")
          }}</Step>
          <!-- <Step class="w-1/5" value="11">{{ $t("case_history.actions.submit") }}</Step> -->
        </StepList>

        <!-- Step Panels -->

        <StepPanels>
          <!-- Step 1: Current Symptoms -->
          <StepPanel v-slot="{ activateCallback }" value="1">
            <div class="flex flex-col gap-4">
              <h4 class="border-b-4 rounded border-b-violet-800 w-fit font-bold">
                {{ $t("case_history.steps.current_symptoms") }}
              </h4>
            </div>
            <div class="flex flex-wrap gap-8">
              <div class="w-[48%]">
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <TextArea
                      required
                      fluid
                      autoResize
                      rows="4"
                      id="symptom_description"
                      v-model="formData.symptom_description"
                    />
                    <label for="symptom_description"
                      >{{ $t("case_history.fields.symptom_description") }}
                      <!--<span class="text-red-600">*</span>--></label
                    >
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <DatePicker
                      showIcon
                      iconDisplay="input"
                      showButtonBar
                      dateFormat="yy-mm-d"
                      id="start_date"
                      v-model="formData.start_date"
                      hourFormat="24"
                      fluid
                    />
                    <label for="start_date"
                      >{{ $t("case_history.fields.start_date") }}
                      <!--<span class="text-red-600">*</span>--></label
                    >
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <Select
                      fluid
                      required
                      optionLabel="label"
                      optionValue="value"
                      id="symptom_progression"
                      v-model="formData.symptom_progression"
                      :options="symptomProgressionOptions"
                    />
                    <label for="symptom_progression"
                      >{{ $t("case_history.fields.symptom_progression") }}
                      <!--<span class="text-red-600">*</span>--></label
                    >
                  </FloatLabel>
                </div>
              </div>
              <div class="w-[48%]">
                <div class="field mt-6 w-2/3">
                  <Checkbox
                    id="medication_given"
                    v-model="formData.medication_given"
                    binary
                    class="mx-2"
                  />
                  <label for="medication_given">{{
                    $t("case_history.fields.medication_given")
                  }}</label>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="medication_name"
                      v-model="formData.medication_name"
                    />
                    <label for="medication_name">{{
                      $t("case_history.fields.medication_name")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="medication_dosage"
                      v-model="formData.medication_dosage"
                    />
                    <label for="medication_dosage">{{
                      $t("case_history.fields.medication_dosage")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="prescribed_by"
                      v-model="formData.prescribed_by"
                    />
                    <label for="prescribed_by">{{
                      $t("case_history.fields.prescribed_by")
                    }}</label>
                  </FloatLabel>
                </div>
              </div>
            </div>
            <div class="flex pt-6 justify-end">
              <Button
                :label="$t('case_history.actions.next')"
                :icon="isRtl ? 'fa-solid fa-arrow-left' : 'fa-solid fa-arrow-right'"
                iconPos="left"
                @click="activateCallback('2')"
              />
            </div>
          </StepPanel>

          <!-- Step 2: General Health -->
          <StepPanel v-slot="{ activateCallback }" value="2">
            <div class="flex flex-col gap-4">
              <h4 class="border-b-4 rounded border-b-violet-800 w-fit font-bold">
                {{ $t("case_history.steps.general_health") }}
              </h4>
            </div>
            <div class="flex flex-wrap gap-8">
              <div class="w-[48%]">
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <Select
                      fluid
                      optionLabel="label"
                      optionValue="value"
                      id="activity_level"
                      v-model="formData.activity_level"
                      :options="activityLevelOptions"
                    />
                    <label for="activity_level">{{
                      $t("case_history.fields.activity_level")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <Select
                      fluid
                      optionLabel="label"
                      optionValue="value"
                      id="vaccination_status"
                      v-model="formData.vaccination_status"
                      :options="vaccinationStatusOptions"
                    />
                    <label for="vaccination_status">{{
                      $t("case_history.fields.vaccination_status")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <Select
                      fluid
                      optionLabel="label"
                      optionValue="value"
                      id="care_location"
                      v-model="formData.care_location"
                      :options="careLocationOptions"
                    />
                    <label for="care_location">{{
                      $t("case_history.fields.care_location")
                    }}</label>
                  </FloatLabel>
                </div>
              </div>
              <div class="w-[48%]">
                <div class="field mt-6 w-2/3">
                  <Checkbox
                    id="other_animals_in_household"
                    v-model="formData.other_animals_in_household"
                    binary
                    class="mx-2"
                  />
                  <label for="other_animals_in_household">{{
                    $t("case_history.fields.other_animals_in_household")
                  }}</label>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="number_of_other_animals"
                      v-model="formData.number_of_other_animals"
                    />
                    <label for="number_of_other_animals">{{
                      $t("case_history.fields.number_of_other_animals")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="types_of_other_animals"
                      v-model="formData.types_of_other_animals"
                    />
                    <label for="types_of_other_animals">{{
                      $t("case_history.fields.types_of_other_animals")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="previous_diseases_in_other_animals"
                      v-model="formData.previous_diseases_in_other_animals"
                    />
                    <label for="previous_diseases_in_other_animals">{{
                      $t("case_history.fields.previous_diseases_in_other_animals")
                    }}</label>
                  </FloatLabel>
                </div>
              </div>
            </div>
            <div class="flex pt-6 justify-between">
              <Button
                :label="$t('case_history.actions.back')"
                severity="secondary"
                :icon="!isRtl ? 'fa-solid fa-arrow-left' : 'fa-solid fa-arrow-right'"
                :iconPos="!isRtl ? 'right' : 'left'"
                @click="activateCallback('1')"
              />
              <Button
                :label="$t('case_history.actions.next')"
                :icon="isRtl ? 'fa-solid fa-arrow-left' : 'fa-solid fa-arrow-right'"
                iconPos="left"
                @click="activateCallback('3')"
              />
            </div>
          </StepPanel>

          <!-- Step 3: Reproductive History -->
          <StepPanel v-slot="{ activateCallback }" value="3">
            <div class="flex flex-col gap-4">
              <h4 class="border-b-4 rounded border-b-violet-800 w-fit font-bold">
                {{ $t("case_history.steps.reproductive_history") }}
              </h4>
            </div>
            <div class="field mt-6 w-[48%]">
              <FloatLabel>
                <DatePicker
                  showIcon
                  iconDisplay="input"
                  showButtonBar
                  dateFormat="yy-mm-d"
                  id="last_reproductive_cycle_date"
                  v-model="formData.last_reproductive_cycle_date"
                />
                <label for="last_reproductive_cycle_date">{{
                  $t("case_history.fields.last_reproductive_cycle_date")
                }}</label>
              </FloatLabel>
            </div>
            <div class="field mt-6 w-[48%]">
              <FloatLabel>
                <InputText fluid id="cycle_length" v-model="formData.cycle_length" />
                <label for="cycle_length">{{
                  $t("case_history.fields.cycle_length")
                }}</label>
              </FloatLabel>
            </div>
            <div class="field mt-6 w-[48%]">
              <FloatLabel>
                <InputText fluid id="notable_signs" v-model="formData.notable_signs" />
                <label for="notable_signs">{{
                  $t("case_history.fields.notable_signs")
                }}</label>
              </FloatLabel>
            </div>
            <div class="field mt-6 w-[48%]">
              <FloatLabel>
                <InputText
                  fluid
                  id="other_discharges"
                  v-model="formData.other_discharges"
                />
                <label for="other_discharges">{{
                  $t("case_history.fields.other_discharges")
                }}</label>
              </FloatLabel>
            </div>
            <div class="flex pt-6 justify-between">
              <Button
                :label="$t('case_history.actions.back')"
                severity="secondary"
                :icon="!isRtl ? 'fa-solid fa-arrow-left' : 'fa-solid fa-arrow-right'"
                :iconPos="!isRtl ? 'right' : 'left'"
                @click="activateCallback('2')"
              />
              <Button
                :label="$t('case_history.actions.next')"
                :icon="isRtl ? 'fa-solid fa-arrow-left' : 'fa-solid fa-arrow-right'"
                iconPos="left"
                @click="activateCallback('4')"
              />
            </div>
          </StepPanel>

          <!-- Step 4: Itching & Skin -->
          <StepPanel v-slot="{ activateCallback }" value="4">
            <div class="flex flex-col gap-4">
              <h4 class="border-b-4 rounded border-b-violet-800 w-fit font-bold">
                {{ $t("case_history.steps.itching_skin") }}
              </h4>
            </div>
            <div class="field mt-6 w-[48%]">
              <Checkbox
                id="itching_present"
                class="mx-2"
                v-model="formData.itching_present"
                binary
              />
              <label for="itching_present">{{
                $t("case_history.fields.itching_present")
              }}</label>
            </div>
            <div class="field mt-6 w-[48%]">
              <FloatLabel>
                <InputText
                  fluid
                  id="itching_location"
                  v-model="formData.itching_location"
                />
                <label for="itching_location">{{
                  $t("case_history.fields.itching_location")
                }}</label>
              </FloatLabel>
            </div>
            <div class="field mt-6 w-[48%]">
              <FloatLabel>
                <TextArea
                  fluid
                  autoResize
                  rows="4"
                  id="itching_description"
                  v-model="formData.itching_description"
                />
                <label for="itching_description">{{
                  $t("case_history.fields.itching_description")
                }}</label>
              </FloatLabel>
            </div>
            <div class="field mt-6 w-[48%]">
              <FloatLabel>
                <TextArea
                  fluid
                  autoResize
                  rows="4"
                  id="skin_condition_description"
                  v-model="formData.skin_condition_description"
                />
                <label for="skin_condition_description">{{
                  $t("case_history.fields.skin_condition_description")
                }}</label>
              </FloatLabel>
            </div>
            <div class="flex pt-6 justify-between">
              <Button
                :label="$t('case_history.actions.back')"
                severity="secondary"
                :icon="!isRtl ? 'fa-solid fa-arrow-left' : 'fa-solid fa-arrow-right'"
                :iconPos="!isRtl ? 'right' : 'left'"
                @click="activateCallback('3')"
              />
              <Button
                :label="$t('case_history.actions.next')"
                :icon="isRtl ? 'fa-solid fa-arrow-left' : 'fa-solid fa-arrow-right'"
                iconPos="left"
                @click="activateCallback('5')"
              />
            </div>
          </StepPanel>

          <!-- Step 5: Diet & Water -->
          <StepPanel v-slot="{ activateCallback }" value="5">
            <div class="flex flex-col gap-4">
              <h4 class="border-b-4 rounded border-b-violet-800 w-fit font-bold">
                {{ $t("case_history.steps.diet_water") }}
              </h4>
            </div>
            <div class="flex flex-wrap gap-8">
              <div class="w-[48%]">
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <Select
                      fluid
                      optionLabel="label"
                      optionValue="value"
                      id="diet_type"
                      v-model="formData.diet_type"
                      :options="dietTypeOptions"
                    />
                    <label for="diet_type">{{
                      $t("case_history.fields.diet_type")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText fluid id="diet_details" v-model="formData.diet_details" />
                    <label for="diet_details">{{
                      $t("case_history.fields.diet_details")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="number_of_meals"
                      v-model="formData.number_of_meals"
                    />
                    <label for="number_of_meals">{{
                      $t("case_history.fields.number_of_meals")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="meal_quantity"
                      v-model="formData.meal_quantity"
                    />
                    <label for="meal_quantity">{{
                      $t("case_history.fields.meal_quantity")
                    }}</label>
                  </FloatLabel>
                </div>
              </div>
              <div class="w-[48%]">
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <Select
                      fluid
                      optionLabel="label"
                      optionValue="value"
                      id="appetite"
                      v-model="formData.appetite"
                      :options="appetiteOptions"
                    />
                    <label for="appetite">{{ $t("case_history.fields.appetite") }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <Checkbox
                    class="mx-2"
                    id="recent_diet_change"
                    v-model="formData.recent_diet_change"
                    binary
                  />
                  <label for="recent_diet_change">{{
                    $t("case_history.fields.recent_diet_change")
                  }}</label>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <Select
                      fluid
                      optionLabel="label"
                      optionValue="value"
                      id="diet_change_type"
                      v-model="formData.diet_change_type"
                      :options="dietChangeTypeOptions"
                    />
                    <label for="diet_change_type">{{
                      $t("case_history.fields.diet_change_type")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText fluid id="water_intake" v-model="formData.water_intake" />
                    <label for="water_intake">{{
                      $t("case_history.fields.water_intake")
                    }}</label>
                  </FloatLabel>
                </div>
              </div>
            </div>
            <div class="flex pt-6 justify-between">
              <Button
                :label="$t('case_history.actions.back')"
                severity="secondary"
                :icon="!isRtl ? 'fa-solid fa-arrow-left' : 'fa-solid fa-arrow-right'"
                :iconPos="!isRtl ? 'right' : 'left'"
                @click="activateCallback('4')"
              />
              <Button
                :label="$t('case_history.actions.next')"
                :icon="isRtl ? 'fa-solid fa-arrow-left' : 'fa-solid fa-arrow-right'"
                iconPos="left"
                @click="activateCallback('6')"
              />
            </div>
          </StepPanel>

          <!-- Step 6: Gastrointestinal -->
          <StepPanel v-slot="{ activateCallback }" value="6">
            <div class="flex flex-col gap-4">
              <h4 class="border-b-4 rounded border-b-violet-800 w-fit font-bold">
                {{ $t("case_history.steps.gastrointestinal") }}
              </h4>
            </div>
            <div class="flex flex-wrap gap-8">
              <div class="w-[48%]">
                <div class="field mt-6 w-2/3">
                  <Checkbox
                    class="mx-2"
                    id="vomiting"
                    v-model="formData.vomiting"
                    binary
                  />
                  <label for="vomiting">{{ $t("case_history.fields.vomiting") }}</label>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText fluid id="vomit_color" v-model="formData.vomit_color" />
                    <label for="vomit_color">{{
                      $t("case_history.fields.vomit_color")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="vomit_contents"
                      v-model="formData.vomit_contents"
                    />
                    <label for="vomit_contents">{{
                      $t("case_history.fields.vomit_contents")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText fluid id="vomit_smell" v-model="formData.vomit_smell" />
                    <label for="vomit_smell">{{
                      $t("case_history.fields.vomit_smell")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="vomiting_frequency"
                      v-model="formData.vomiting_frequency"
                    />
                    <label for="vomiting_frequency">{{
                      $t("case_history.fields.vomiting_frequency")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <Checkbox
                    class="mx-2"
                    id="vomiting_related_to_food"
                    v-model="formData.vomiting_related_to_food"
                    binary
                  />
                  <label for="vomiting_related_to_food">{{
                    $t("case_history.fields.vomiting_related_to_food")
                  }}</label>
                </div>
              </div>

              <div class="w-[48%]">
                <div class="field mt-6 w-2/3">
                  <Checkbox
                    class="mx-2"
                    id="vomiting_related_to_diarrhea"
                    v-model="formData.vomiting_related_to_diarrhea"
                    binary
                  />
                  <label for="vomiting_related_to_diarrhea">{{
                    $t("case_history.fields.vomiting_related_to_diarrhea")
                  }}</label>
                </div>
                <div class="field mt-6 w-2/3">
                  <Checkbox
                    class="mx-2"
                    id="diarrhea_started_first"
                    v-model="formData.diarrhea_started_first"
                    binary
                  />
                  <label for="diarrhea_started_first">{{
                    $t("case_history.fields.diarrhea_started_first")
                  }}</label>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <Select
                      fluid
                      optionLabel="label"
                      optionValue="value"
                      id="stool_consistency"
                      v-model="formData.stool_consistency"
                      :options="stoolConsistencyOptions"
                    />
                    <label for="stool_consistency">{{
                      $t("case_history.fields.stool_consistency")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText fluid id="stool_color" v-model="formData.stool_color" />
                    <label for="stool_color">{{
                      $t("case_history.fields.stool_color")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="stool_frequency"
                      v-model="formData.stool_frequency"
                    />
                    <label for="stool_frequency">{{
                      $t("case_history.fields.stool_frequency")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="abnormal_stool_contents"
                      v-model="formData.abnormal_stool_contents"
                    />
                    <label for="abnormal_stool_contents">{{
                      $t("case_history.fields.abnormal_stool_contents")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <Checkbox
                    class="mx-2"
                    id="excessive_licking_of_anus"
                    v-model="formData.excessive_licking_of_anus"
                    binary
                  />
                  <label for="excessive_licking_of_anus">{{
                    $t("case_history.fields.excessive_licking_of_anus")
                  }}</label>
                </div>
              </div>
            </div>

            <div class="flex pt-6 justify-between">
              <Button
                :label="$t('case_history.actions.back')"
                severity="secondary"
                :icon="!isRtl ? 'fa-solid fa-arrow-left' : 'fa-solid fa-arrow-right'"
                :iconPos="!isRtl ? 'right' : 'left'"
                @click="activateCallback('5')"
              />
              <Button
                :label="$t('case_history.actions.next')"
                :icon="isRtl ? 'fa-solid fa-arrow-left' : 'fa-solid fa-arrow-right'"
                iconPos="left"
                @click="activateCallback('7')"
              />
            </div>
          </StepPanel>

          <!-- Step 7: Neurological -->
          <StepPanel v-slot="{ activateCallback }" value="7">
            <div class="flex flex-col gap-4">
              <h4 class="border-b-4 rounded border-b-violet-800 w-fit font-bold">
                {{ $t("case_history.steps.neurological") }}
              </h4>
            </div>
            <div class="flex flex-wrap gap-8">
              <div class="w-[48%]">
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="neurological_signs"
                      v-model="formData.neurological_signs"
                    />
                    <label for="neurological_signs">{{
                      $t("case_history.fields.neurological_signs")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="neurological_signs_frequency"
                      v-model="formData.neurological_signs_frequency"
                    />
                    <label for="neurological_signs_frequency">{{
                      $t("case_history.fields.neurological_signs_frequency")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="associated_symptoms"
                      v-model="formData.associated_symptoms"
                    />
                    <label for="associated_symptoms">{{
                      $t("case_history.fields.associated_symptoms")
                    }}</label>
                  </FloatLabel>
                </div>
              </div>
              <div class="w-[48%]">
                <div class="field mt-6 w-2/3">
                  <Checkbox
                    class="mx-2"
                    id="sudden_onset"
                    v-model="formData.sudden_onset"
                    binary
                  />
                  <label for="sudden_onset">{{
                    $t("case_history.fields.sudden_onset")
                  }}</label>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="related_to_eating_or_activity"
                      v-model="formData.related_to_eating_or_activity"
                    />
                    <label for="related_to_eating_or_activity">{{
                      $t("case_history.fields.related_to_eating_or_activity")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <TextArea
                      fluid
                      autoResize
                      rows="4"
                      id="additional_details"
                      v-model="formData.additional_details"
                    />
                    <label for="additional_details">{{
                      $t("case_history.fields.additional_details")
                    }}</label>
                  </FloatLabel>
                </div>
              </div>
            </div>
            <div class="flex pt-6 justify-between">
              <Button
                :label="$t('case_history.actions.back')"
                severity="secondary"
                :icon="!isRtl ? 'fa-solid fa-arrow-left' : 'fa-solid fa-arrow-right'"
                :iconPos="!isRtl ? 'right' : 'left'"
                @click="activateCallback('6')"
              />
              <Button
                :label="$t('case_history.actions.next')"
                :icon="isRtl ? 'fa-solid fa-arrow-left' : 'fa-solid fa-arrow-right'"
                iconPos="left"
                @click="activateCallback('8')"
              />
            </div>
          </StepPanel>

          <!-- Step 8: Respiratory -->
          <StepPanel v-slot="{ activateCallback }" value="8">
            <div class="flex flex-col gap-4">
              <h4 class="border-b-4 rounded border-b-violet-800 w-fit font-bold">
                {{ $t("case_history.steps.respiratory") }}
              </h4>
            </div>

            <div class="field mt-6 w-[48%]">
              <Checkbox class="mx-2" id="cough" v-model="formData.cough" binary />
              <label for="cough">{{ $t("case_history.fields.cough") }}</label>
            </div>

            <div class="field mt-6 w-[48%]">
              <FloatLabel>
                <DatePicker
                  showIcon
                  iconDisplay="input"
                  showButtonBar
                  dateFormat="yy-mm-d"
                  id="cough_start_date"
                  v-model="formData.cough_start_date"
                />
                <label for="cough_start_date">{{
                  $t("case_history.fields.cough_start_date")
                }}</label>
              </FloatLabel>
            </div>

            <div class="field mt-6 w-[48%]">
              <FloatLabel>
                <InputText
                  fluid
                  id="cough_frequency"
                  v-model="formData.cough_frequency"
                />
                <label for="cough_frequency">{{
                  $t("case_history.fields.cough_frequency")
                }}</label>
              </FloatLabel>
            </div>

            <div class="field mt-6 w-[48%]">
              <FloatLabel>
                <Select
                  fluid
                  optionLabel="label"
                  optionValue="value"
                  id="cough_type"
                  v-model="formData.cough_type"
                  :options="coughTypeOptions"
                />
                <label for="cough_type">{{ $t("case_history.fields.cough_type") }}</label>
              </FloatLabel>
            </div>

            <div class="field mt-6 w-[48%]">
              <Checkbox
                class="mx-2"
                id="breathing_difficulty"
                v-model="formData.breathing_difficulty"
                binary
              />
              <label for="breathing_difficulty">{{
                $t("case_history.fields.breathing_difficulty")
              }}</label>
            </div>

            <div class="field mt-6 w-[48%]">
              <Checkbox class="mx-2" id="sneezing" v-model="formData.sneezing" binary />
              <label for="sneezing">{{ $t("case_history.fields.sneezing") }}</label>
            </div>

            <div class="flex pt-6 justify-between">
              <Button
                :label="$t('case_history.actions.back')"
                severity="secondary"
                :icon="!isRtl ? 'fa-solid fa-arrow-left' : 'fa-solid fa-arrow-right'"
                :iconPos="!isRtl ? 'right' : 'left'"
                @click="activateCallback('7')"
              />
              <Button
                :label="$t('case_history.actions.next')"
                :icon="isRtl ? 'fa-solid fa-arrow-left' : 'fa-solid fa-arrow-right'"
                iconPos="left"
                @click="activateCallback('9')"
              />
            </div>
          </StepPanel>
          <!-- Step 9: Urinary -->
          <StepPanel v-slot="{ activateCallback }" value="9">
            <div class="flex flex-col gap-4">
              <h4 class="border-b-4 rounded border-b-violet-800 w-fit font-bold">
                {{ $t("case_history.steps.urinary") }}
              </h4>
            </div>
            <div class="flex flex-wrap gap-8">
              <div class="w-[48%]">
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="urination_frequency"
                      v-model="formData.urination_frequency"
                    />
                    <label for="urination_frequency">{{
                      $t("case_history.fields.urination_frequency")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <Select
                      fluid
                      optionLabel="label"
                      optionValue="value"
                      id="urine_volume"
                      v-model="formData.urine_volume"
                      :options="urineVolumeOptions"
                    />
                    <label for="urine_volume">{{
                      $t("case_history.fields.urine_volume")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText fluid id="urine_color" v-model="formData.urine_color" />
                    <label for="urine_color">{{
                      $t("case_history.fields.urine_color")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <Select
                      fluid
                      optionLabel="label"
                      optionValue="value"
                      id="urination_type"
                      v-model="formData.urination_type"
                      :options="urinationTypeOptions"
                    />
                    <label for="urination_type">{{
                      $t("case_history.fields.urination_type")
                    }}</label>
                  </FloatLabel>
                </div>
              </div>

              <div class="w-[48%]">
                <div class="field mt-6 w-2/3">
                  <Checkbox
                    class="mx-2"
                    id="blood_in_urine"
                    v-model="formData.blood_in_urine"
                    binary
                  />
                  <label for="blood_in_urine">{{
                    $t("case_history.fields.blood_in_urine")
                  }}</label>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <Select
                      fluid
                      optionLabel="label"
                      optionValue="value"
                      id="blood_location"
                      v-model="formData.blood_location"
                      :options="bloodLocationOptions"
                    />
                    <label for="blood_location">{{
                      $t("case_history.fields.blood_location")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="abnormal_urinary_discharge"
                      v-model="formData.abnormal_urinary_discharge"
                    />
                    <label for="abnormal_urinary_discharge">{{
                      $t("case_history.fields.abnormal_urinary_discharge")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="genital_discharge"
                      v-model="formData.genital_discharge"
                    />
                    <label for="genital_discharge">{{
                      $t("case_history.fields.genital_discharge")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <Checkbox
                    class="mx-2"
                    id="excessive_licking_of_genital_area"
                    v-model="formData.excessive_licking_of_genital_area"
                    binary
                  />
                  <label for="excessive_licking_of_genital_area">
                    {{ $t("case_history.fields.excessive_licking_of_genital_area") }}
                  </label>
                </div>
              </div>
            </div>

            <div class="flex pt-6 justify-between">
              <Button
                :label="$t('case_history.actions.back')"
                severity="secondary"
                :icon="!isRtl ? 'fa-solid fa-arrow-left' : 'fa-solid fa-arrow-right'"
                :iconPos="!isRtl ? 'right' : 'left'"
                @click="activateCallback('8')"
              />
              <Button
                :label="$t('case_history.actions.next')"
                :icon="isRtl ? 'fa-solid fa-arrow-left' : 'fa-solid fa-arrow-right'"
                iconPos="left"
                @click="activateCallback('10')"
              />
            </div>
          </StepPanel>

          <!-- Step 10: Vaccination & Medication -->
          <StepPanel v-slot="{ activateCallback }" value="10">
            <!-- <div class="flex flex-wrap"> -->
            <div class="flex flex-col gap-4">
              <h4 class="border-b-4 rounded border-b-violet-800 w-fit font-bold">
                {{ $t("case_history.steps.vaccination_medication") }}
              </h4>
            </div>
            <div class="flex flex-wrap gap-8">
              <!-- Vaccination History -->
              <div class="w-[48%] basis-1/2">
                <h5 class="font-semibold mt-6">
                  {{ $t("case_history.additional.vaccination_history") }}
                </h5>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText fluid id="vaccine_name" v-model="formData.vaccine_name" />
                    <label for="vaccine_name">{{
                      $t("case_history.fields.vaccine_name")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <DatePicker
                      showIcon
                      iconDisplay="input"
                      showButtonBar
                      dateFormat="yy-mm-d"
                      id="vaccine_date"
                      v-model="formData.vaccine_date"
                    />
                    <label for="vaccine_date">{{
                      $t("case_history.fields.vaccine_date")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <DatePicker
                      showIcon
                      iconDisplay="input"
                      showButtonBar
                      dateFormat="yy-mm-d"
                      id="next_due_date"
                      v-model="formData.next_due_date"
                    />
                    <label for="next_due_date">{{
                      $t("case_history.fields.next_due_date")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="administered_by"
                      v-model="formData.administered_by"
                    />
                    <label for="administered_by">{{
                      $t("case_history.fields.administered_by")
                    }}</label>
                  </FloatLabel>
                </div>
              </div>
              <!-- Antiparasitic Treatment -->
              <div class="w-[48%] basis-1/2 flex flex-wrap">
                <h5 class="font-semibold mt-6 w-2/3">
                  {{ $t("case_history.additional.antiparasitic_treatment") }}
                </h5>
                <div class="field mt-6 w-1/2">
                  <FloatLabel class="w-[90%]">
                    <InputText
                      fluid
                      id="treatment_name"
                      v-model="formData.treatment_name"
                    />
                    <label for="treatment_name">{{
                      $t("case_history.fields.treatment_name")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-1/2">
                  <FloatLabel class="w-[90%]">
                    <Select
                      fluid
                      optionLabel="label"
                      optionValue="value"
                      id="treatment_type"
                      v-model="formData.treatment_type"
                      :options="treatmentTypeOptions"
                    />
                    <label for="treatment_type">{{
                      $t("case_history.fields.treatment_type")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="treatment_dosage"
                      v-model="formData.treatment_dosage"
                    />
                    <label for="treatment_dosage">{{
                      $t("case_history.fields.dosage")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-1/2">
                  <FloatLabel class="w-[90%]">
                    <DatePicker
                      showIcon
                      fluid
                      iconDisplay="input"
                      showButtonBar
                      dateFormat="yy-mm-d"
                      id="administration_date"
                      v-model="formData.administration_date"
                    />
                    <label for="administration_date">{{
                      $t("case_history.fields.administration_date")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-1/2">
                  <FloatLabel class="w-[90%]">
                    <DatePicker
                      showIcon
                      fluid
                      iconDisplay="input"
                      showButtonBar
                      dateFormat="yy-mm-d"
                      id="next_due_date"
                      v-model="formData.treatment_next_due_date"
                    />
                    <label for="next_due_date">{{
                      $t("case_history.fields.next_due_date")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="administered_by"
                      v-model="formData.treatment_administered_by"
                    />
                    <label for="administered_by">{{
                      $t("case_history.fields.administered_by")
                    }}</label>
                  </FloatLabel>
                </div>
              </div>
              <!-- Medication History -->
              <div class="w-[48%] basis-1/2">
                <h5 class="font-semibold mt-6">
                  {{ $t("case_history.additional.medication_history") }}
                </h5>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="medication_name"
                      v-model="formData.medication_name"
                    />
                    <label for="medication_name">{{
                      $t("case_history.fields.medication_name")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <Select
                      fluid
                      optionLabel="label"
                      optionValue="value"
                      id="medication_type"
                      v-model="formData.medication_type"
                      :options="medicationTypeOptions"
                    />
                    <label for="medication_type">{{
                      $t("case_history.fields.medication_type")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText fluid id="dosage" v-model="formData.dosage" />
                    <label for="dosage">{{ $t("case_history.fields.dosage") }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText fluid id="frequency" v-model="formData.frequency" />
                    <label for="frequency">{{
                      $t("case_history.fields.frequency")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <DatePicker
                      showIcon
                      iconDisplay="input"
                      showButtonBar
                      dateFormat="yy-mm-d"
                      id="start_date"
                      v-model="formData.medication_start_date"
                    />
                    <label for="start_date">{{
                      $t("case_history.fields.medication_start_date")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <DatePicker
                      showIcon
                      iconDisplay="input"
                      showButtonBar
                      dateFormat="yy-mm-d"
                      id="end_date"
                      v-model="formData.medication_end_date"
                    />
                    <label for="end_date">{{
                      $t("case_history.fields.medication_end_date")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="prescribed_by"
                      v-model="formData.prescribed_by"
                    />
                    <label for="prescribed_by">{{
                      $t("case_history.fields.prescribed_by")
                    }}</label>
                  </FloatLabel>
                </div>
              </div>
              <!-- Additional Notes -->
              <div class="w-[48%] basis-1/2">
                <h5 class="font-semibold mt-6">
                  {{ $t("case_history.fields.additional_notes") }}
                </h5>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <TextArea
                      fluid
                      autoResize
                      rows="4"
                      id="additional_notes"
                      v-model="formData.additional_notes"
                    />
                    <label for="additional_notes">{{
                      $t("case_history.fields.additional_notes")
                    }}</label>
                  </FloatLabel>
                </div>
              </div>
              <!-- </div> -->
            </div>
            <div class="flex pt-6 justify-between">
              <Button
                :label="$t('case_history.actions.back')"
                severity="secondary"
                :icon="!isRtl ? 'fa-solid fa-arrow-left' : 'fa-solid fa-arrow-right'"
                :class="{ '!p-button-icon-left': isRtl, '!p-button-icon-righ': !isRtl }"
                @click="activateCallback('9')"
              />
              <Button :label="$t('case_history.actions.submit')" @click="submitForm" />
              <!-- <Button
                  :label="$t('case_history.actions.next')"
                  :icon="isRtl ? 'fa-solid fa-arrow-left' : 'fa-solid fa-arrow-right'"
                  iconPos="left"
                  @click="activateCallback('11')"
                /> -->
            </div>
          </StepPanel>
        </StepPanels>
      </Stepper>
    </fieldset>
  </div>
</template>

<script setup>
import { ref, computed } from "vue";
import Stepper from "primevue/stepper";
import StepList from "primevue/steplist";
import StepPanels from "primevue/steppanels";
import Step from "primevue/step";
import StepPanel from "primevue/steppanel";
import FloatLabel from "primevue/floatlabel";
import InputText from "primevue/inputtext";
import TextArea from "primevue/textarea";
import DatePicker from "primevue/datepicker";
import Select from "primevue/select";
import Checkbox from "primevue/checkbox";
import Button from "primevue/button";
import axiosInstance from "@/axios"; // Assuming you've created a global axios instance
import { useI18n } from "vue-i18n";
import { useToast } from "primevue/usetoast";

const { t, locale } = useI18n();
const activeStep = ref("1");
const emit = defineEmits();
const toast = useToast();
const props = defineProps({
  medical_record_id: {
    type: Number,
    required: true,
  },
});
const isRtl = computed(() => ["ar", "he", "fa"].includes(locale.value));
const formData = ref(
  /* {
    symptom_description: "No signs of pregnancy 6 weeks post-mating",
    start_date: "2025-03-10",
    symptom_progression: "constant",
    medication_given: false,
    medication_name: "",
    medication_dosage: "",
    prescribed_by: "",
    activity_level: "active",
    vaccination_status: "complete",
    care_location: "home",
    other_animals_in_household: true,
    number_of_other_animals: 2,
    types_of_other_animals: "1 male cat, 1 female dog",
    previous_diseases_in_other_animals: "None",
    last_reproductive_cycle_date: "2025-02-20",
    cycle_length: 7,
    notable_signs: "No nipple enlargement, no weight gain",
    other_discharges: "None",
    itching_present: false,
    itching_location: "",
    itching_description: "",
    skin_condition_description: "Normal",
    diet_type: "canned",
    diet_details: "Premium grain-free poultry",
    number_of_meals: 3,
    meal_quantity: "200g",
    appetite: "good",
    recent_diet_change: false,
    diet_change_type: "",
    water_intake: "normal",
    vomiting: false,
    vomit_color: "",
    vomit_contents: "",
    vomit_smell: "",
    vomiting_frequency: 0,
    vomiting_related_to_food: false,
    vomiting_related_to_diarrhea: false,
    diarrhea_started_first: false,
    stool_consistency: "normal",
    stool_color: "brown",
    stool_frequency: 1,
    abnormal_stool_contents: "",
    excessive_licking_of_anus: false,
    neurological_signs: null,
    neurological_signs_frequency: "",
    associated_symptoms: "",
    sudden_onset: false,
    related_to_eating_or_activity: "",
    additional_details: "Owner reports successful mating observed 6 weeks ago.",
    cough: false,
    cough_start_date: "",
    cough_frequency: "",
    cough_type: "",
    breathing_difficulty: false,
    sneezing: false,
    urination_frequency: 4,
    frequent_litter_box_visits: false,
    urine_volume: "small",
    urine_color: "pale yellow",
    urination_type: "continuous",
    blood_in_urine: false,
    blood_location: "",
    abnormal_urinary_discharge: "",
    genital_discharge: "None",
    excessive_licking_of_genital_area: false,
    vaccine_name: "FVRCP",
    vaccine_date: "2025-01-15",
    next_due_date: "2026-01-15",
    administered_by: "Dr. Lee",
    medication_type: "",
    dosage: "",
    frequency: "",
    medication_start_date: "",
    medication_end_date: "",
    treatment_name: "",
    treatment_type: "",
    treatment_dosage: "",
    administration_date: "",
    treatment_next_due_date: "",
    treatment_administered_by: "",
    additional_notes:
      "Recommend ultrasound to confirm pregnancy status. Rule out pseudopregnancy.",
  }*/
  {
    symptom_description: "",
    start_date: null,
    symptom_progression: "",
    medication_given: false,
    medication_name: "",
    medication_dosage: "",
    prescribed_by: "",
    activity_level: "",
    vaccination_status: "",
    care_location: "",
    other_animals_in_household: false,
    number_of_other_animals: null,
    types_of_other_animals: "",
    previous_diseases_in_other_animals: "",
    last_reproductive_cycle_date: null,
    cycle_length: null,
    notable_signs: "",
    other_discharges: "",
    itching_present: false,
    itching_location: "",
    itching_description: "",
    skin_condition_description: "",
    diet_type: "",
    diet_details: "",
    number_of_meals: null,
    meal_quantity: "",
    appetite: "",
    recent_diet_change: false,
    diet_change_type: "",
    water_intake: "",
    vomiting: false,
    vomit_color: "",
    vomit_contents: "",
    vomit_smell: "",
    vomiting_frequency: null,
    vomiting_related_to_food: false,
    vomiting_related_to_diarrhea: false,
    diarrhea_started_first: false,
    stool_consistency: "",
    stool_color: "",
    stool_frequency: null,
    abnormal_stool_contents: "",
    excessive_licking_of_anus: false,
    neurological_signs: null,
    neurological_signs_frequency: "",
    associated_symptoms: "",
    sudden_onset: false,
    related_to_eating_or_activity: "",
    additional_details: "",
    cough: false,
    cough_start_date: null,
    cough_frequency: "",
    cough_type: "",
    breathing_difficulty: false,
    sneezing: false,
    urination_frequency: null,
    frequent_litter_box_visits: false,
    urine_volume: null,
    urine_color: "",
    urination_type: "",
    blood_in_urine: false,
    blood_location: "",
    abnormal_urinary_discharge: "",
    genital_discharge: "",
    excessive_licking_of_genital_area: false,
    vaccine_name: "",
    vaccine_date: null,
    next_due_date: null,
    administered_by: "",
    medication_type: "",
    dosage: "",
    frequency: "",
    medication_start_date: null,
    medication_end_date: null,
    treatment_name: "",
    treatment_type: "",
    treatment_dosage: "",
    administration_date: null,
    treatment_next_due_date: null,
    treatment_administered_by: "",
    additional_notes: "",
  }
);

const symptomProgressionOptions = [
  { label: "Increasing", value: "increasing" },
  { label: "Decreasing", value: "decreasing" },
  { label: "Constant", value: "constant" },
];

const activityLevelOptions = [
  { label: "Active", value: "active" },
  { label: "Lethargic", value: "lethargic" },
  { label: "Sometimes Active", value: "sometimes_active" },
  { label: "Other", value: "other" },
];
const stoolConsistencyOptions = [
  { label: "Normal", value: "normal" },
  { label: "Soft", value: "soft" },
  { label: "Watery", value: "watery" },
  { label: "Hard", value: "hard" },
];
const vaccinationStatusOptions = [
  { label: "Complete", value: "complete" },
  { label: "Incomplete", value: "incomplete" },
];

const careLocationOptions = [
  { label: "Home", value: "home" },
  { label: "Home Garden", value: "home_garden" },
  { label: "Street", value: "street" },
  { label: "Indoor/Outdoor", value: "indoor_outdoor" },
];

const dietTypeOptions = [
  { label: "Dry", value: "dry" },
  { label: "Canned", value: "canned" },
  { label: "Home Cooked", value: "home_cooked" },
  { label: "Raw", value: "raw" },
  { label: "Mixed", value: "mixed" },
];

const appetiteOptions = [
  { label: "Good", value: "good" },
  { label: "Leaves Meal", value: "leaves_meal" },
  { label: "No Appetite", value: "no_appetite" },
];

const dietChangeTypeOptions = [
  { label: "Sudden", value: "sudden" },
  { label: "Gradual", value: "gradual" },
];

const coughTypeOptions = [
  { label: "Dry", value: "dry" },
  { label: "Productive", value: "productive" },
];

const urinationTypeOptions = [
  { label: "Continuous", value: "continuous" },
  { label: "Intermittent", value: "intermittent" },
];

const bloodLocationOptions = [
  { label: "Beginning", value: "beginning" },
  { label: "End", value: "end" },
  { label: "Throughout", value: "throughout" },
];
const urineVolumeOptions = [
  { label: "Small", value: "small" },
  { label: "Medium", value: "medium" },
  { label: "Large", value: "large" },
];
const medicationTypeOptions = [
  { label: "Antibiotic", value: "antibiotic" },
  { label: "Painkiller", value: "painkiller" },
  { label: "Anti-inflammatory", value: "anti-inflammatory" },
  { label: "Other", value: "other" },
];
const neurologicalSignsOptions = [
  { label: "Seizures", value: "seizures" },
  { label: "Fainting", value: "fainting" },
  { label: "Nystagmus", value: "nystagmus" },
  { label: "Other", value: "other" },
];
const treatmentTypeOptions = [
  { label: "Flea", value: "flea" },
  { label: "Tick", value: "tick" },
  { label: "Worm", value: "worm" },
  { label: "Other", value: "other" },
];

const submitForm = async () => {
  try {
    // Utility function to format dates
    const formatDate = (isoDateString) => {
      return isoDateString ? new Date(isoDateString).toISOString().split("T")[0] : null;
    };

    // Extract values from dropdown/select fields
    formData.value.symptom_progression = formData.value.symptom_progression
      ? formData.value.symptom_progression
      : null;
    formData.value.activity_level = formData.value.activity_level
      ? formData.value.activity_level
      : null;
    formData.value.vaccination_status = formData.value.vaccination_status
      ? formData.value.vaccination_status
      : null;
    formData.value.care_location = formData.value.care_location
      ? formData.value.care_location
      : null;
    formData.value.diet_type = formData.value.diet_type ? formData.value.diet_type : null;
    formData.value.appetite = formData.value.appetite ? formData.value.appetite : null;
    formData.value.urination_type = formData.value.urination_type
      ? formData.value.urination_type
      : null;
    formData.value.cough_type = formData.value.cough_type
      ? formData.value.cough_type
      : null;
    formData.value.stool_consistency = formData.value.stool_consistency
      ? formData.value.stool_consistency
      : null;
    formData.value.urine_volume = formData.value.urine_volume
      ? formData.value.urine_volume
      : null;
    formData.value.blood_location = formData.value.blood_location
      ? formData.value.blood_location
      : null;
    formData.value.neurological_signs = formData.value.neurological_signs
      ? formData.value.neurological_signs
      : null;
    formData.value.diet_change_type = formData.value.diet_change_type
      ? formData.value.diet_change_type
      : null;
    formData.value.medication_type = formData.value.medication_type
      ? formData.value.medication_type
      : null;
    formData.value.treatment_type = formData.value.treatment_type
      ? formData.value.treatment_type
      : null;

    // Convert numeric fields to integers
    formData.value.number_of_other_animals = formData.value.number_of_other_animals
      ? parseInt(formData.value.number_of_other_animals)
      : null;
    formData.value.cycle_length = formData.value.cycle_length
      ? parseInt(formData.value.cycle_length)
      : null;
    formData.value.number_of_meals = formData.value.number_of_meals
      ? parseInt(formData.value.number_of_meals)
      : null;
    formData.value.stool_frequency = formData.value.stool_frequency
      ? parseInt(formData.value.stool_frequency)
      : null;
    formData.value.vomiting_frequency = formData.value.vomiting_frequency
      ? parseInt(formData.value.vomiting_frequency)
      : null;
    formData.value.urination_frequency = formData.value.urination_frequency
      ? parseInt(formData.value.urination_frequency)
      : null;

    // Handle nullable fields
    formData.value.previous_diseases_in_other_animals =
      formData.value.previous_diseases_in_other_animals || null;
    formData.value.other_discharges = formData.value.other_discharges || null;
    formData.value.itching_location = formData.value.itching_location || null;
    formData.value.itching_description = formData.value.itching_description || null;
    formData.value.skin_condition_description =
      formData.value.skin_condition_description || null;
    formData.value.diet_details = formData.value.diet_details || null;
    formData.value.meal_quantity = formData.value.meal_quantity || null;
    formData.value.water_intake = formData.value.water_intake || null;
    formData.value.vomit_color = formData.value.vomit_color || null;
    formData.value.vomit_contents = formData.value.vomit_contents || null;
    formData.value.vomit_smell = formData.value.vomit_smell || null;
    formData.value.abnormal_stool_contents =
      formData.value.abnormal_stool_contents || null;
    formData.value.neurological_signs_frequency =
      formData.value.neurological_signs_frequency || null;
    formData.value.associated_symptoms = formData.value.associated_symptoms || null;
    formData.value.related_to_eating_or_activity =
      formData.value.related_to_eating_or_activity || null;
    formData.value.additional_details = formData.value.additional_details || null;
    formData.value.cough_frequency = formData.value.cough_frequency || null;
    formData.value.urine_color = formData.value.urine_color || null;
    formData.value.abnormal_urinary_discharge =
      formData.value.abnormal_urinary_discharge || null;
    formData.value.genital_discharge = formData.value.genital_discharge || null;

    // Format date fields
    formData.value.cough_start_date = formatDate(formData.value.cough_start_date);
    formData.value.vaccine_date = formatDate(formData.value.vaccine_date);
    formData.value.next_due_date = formatDate(formData.value.next_due_date);
    formData.value.medication_start_date = formatDate(
      formData.value.medication_start_date
    );
    formData.value.medication_end_date = formatDate(formData.value.medication_end_date);
    formData.value.administration_date = formatDate(formData.value.administration_date);
    formData.value.treatment_next_due_date = formatDate(
      formData.value.treatment_next_due_date
    );
    formData.value.last_reproductive_cycle_date = formatDate(
      formData.value.last_reproductive_cycle_date
    );
    formData.value.start_date = formatDate(formData.value.start_date);

    // Ensure boolean fields are sent as true/false
    formData.value.medication_given = !!formData.value.medication_given;
    formData.value.other_animals_in_household = !!formData.value
      .other_animals_in_household;
    formData.value.itching_present = !!formData.value.itching_present;
    formData.value.recent_diet_change = !!formData.value.recent_diet_change;
    formData.value.vomiting = !!formData.value.vomiting;
    formData.value.vomiting_related_to_food = !!formData.value.vomiting_related_to_food;
    formData.value.vomiting_related_to_diarrhea = !!formData.value
      .vomiting_related_to_diarrhea;
    formData.value.diarrhea_started_first = !!formData.value.diarrhea_started_first;
    formData.value.excessive_licking_of_anus = !!formData.value.excessive_licking_of_anus;
    formData.value.sudden_onset = !!formData.value.sudden_onset;
    formData.value.cough = !!formData.value.cough;
    formData.value.breathing_difficulty = !!formData.value.breathing_difficulty;
    formData.value.sneezing = !!formData.value.sneezing;
    formData.value.frequent_litter_box_visits = !!formData.value
      .frequent_litter_box_visits;
    formData.value.blood_in_urine = !!formData.value.blood_in_urine;
    formData.value.excessive_licking_of_genital_area = !!formData.value
      .excessive_licking_of_genital_area;

    // console.log(formData.value);

    // Send formData to the storeHistory endpoint
    const response = await axiosInstance.post(
      `/medical-records/history/${props.medical_record_id}`,
      formData.value
    );
    emit("CaseHistoryCreated");
    toast.add({
      severity: "success",
      summary: t("case_history.toast.case_history_added"),
      detail: t("case_history.toast.case_history_added_detail"),
      life: 5000,
    });

    // console.log("Form submitted successfully:", response.data);
  } catch (error) {
    console.error("Error submitting form:", error);
  }
};
</script>

<style scoped>
.p-step-active {
  color: navy !important;
}
:root {
  --color-violet-600: oklch(0.541 0.281 293.009);
}
</style>
