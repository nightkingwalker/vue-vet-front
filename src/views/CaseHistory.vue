<template>
  <div class="w-full">
    <fieldset
      class="p-fieldset p-component w-4/5 flex flex-wrap mx-auto gap-2 items-start border rounded-lg p-4"
    >
      <legend>
        {{ $t("case_history.title") }}
        <Button
          type="button"
          icon="fa-solid fa-pencil !text-primary"
          v-tooltip.top="{
            value: $t('case_history.edit_button'),
            pt: {
              arrow: {
                style: {
                  borderTopColor: 'var(--p-primary-color)',
                },
              },
              text:
                '!bg-[var(--p-primary-color)] !text-primary-contrast !font-thin !text-xs',
            },
          }"
          rounded
          size="small"
          class="!text-xs !text-primary mx-2"
          @click="isEditable = !isEditable"
        />
      </legend>

      <div v-if="!hasCaseHistory">
        {{ $t("case_history.no_history") }}
        <Button
          :label="$t('case_history.add_button')"
          icon="pi pi-plus"
          @click="showAddCaseHistoryModal(props.medical_record_id)"
          class="p-button p-component !text-xs !h-8 ml-2"
        />
      </div>

      <Stepper :value="activeStep" :key="activeStep" class="w-full" v-else>
        <StepList class="flex flex-wrap items-start w-full mx-auto">
          <Step value="1">{{ $t("case_history.steps.current_symptoms") }}</Step>
          <Step value="2">{{ $t("case_history.steps.general_health") }}</Step>
          <Step value="3">{{ $t("case_history.steps.reproductive_history") }}</Step>
          <Step value="4">{{ $t("case_history.steps.itching_skin") }}</Step>
          <Step value="5">{{ $t("case_history.steps.diet_water") }}</Step>
          <Step value="6">{{ $t("case_history.steps.gastrointestinal") }}</Step>
          <Step value="7">{{ $t("case_history.steps.neurological") }}</Step>
          <Step value="8">{{ $t("case_history.steps.respiratory") }}</Step>
          <Step value="9">{{ $t("case_history.steps.urinary") }}</Step>
          <Step value="10">{{ $t("case_history.steps.vaccination_medication") }}</Step>
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
                      :disabled="!isEditable"
                      fluid
                      autoResize
                      rows="4"
                      id="symptom_description"
                      v-model="formData.symptom_description"
                    />
                    <label for="symptom_description">{{
                      $t("case_history.fields.symptom_description")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <DatePicker
                      showIcon
                      iconDisplay="input"
                      showButtonBar
                      :disabled="!isEditable"
                      id="start_date"
                      v-model="formData.start_date"
                      hourFormat="24"
                      fluid
                    />
                    <label for="start_date">{{
                      $t("case_history.fields.start_date")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <Select
                      :disabled="!isEditable"
                      fluid
                      optionLabel="label"
                      optionValue="value"
                      id="symptom_progression"
                      v-model="formData.symptom_progression"
                      :options="symptomProgressionOptions"
                    />
                    <label for="symptom_progression">{{
                      $t("case_history.fields.symptom_progression")
                    }}</label>
                  </FloatLabel>
                </div>
              </div>
              <div class="w-[48%]">
                <div class="field mt-6 w-2/3">
                  <Checkbox
                    :disabled="!isEditable"
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
                      :disabled="!isEditable"
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
                      :disabled="!isEditable"
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
                      :disabled="!isEditable"
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
                icon="pi pi-arrow-right"
                iconPos="right"
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
                      :disabled="!isEditable"
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
                      :disabled="!isEditable"
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
                      :disabled="!isEditable"
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
                    :disabled="!isEditable"
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
                      :disabled="!isEditable"
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
                      :disabled="!isEditable"
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
                      :disabled="!isEditable"
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
                icon="pi pi-arrow-left"
                @click="activateCallback('1')"
              />
              <Button
                :label="$t('case_history.actions.next')"
                icon="pi pi-arrow-right"
                iconPos="right"
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
                  :disabled="!isEditable"
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
                <InputText
                  :disabled="!isEditable"
                  fluid
                  id="cycle_length"
                  v-model="formData.cycle_length"
                />
                <label for="cycle_length">{{
                  $t("case_history.fields.cycle_length")
                }}</label>
              </FloatLabel>
            </div>
            <div class="field mt-6 w-[48%]">
              <FloatLabel>
                <InputText
                  :disabled="!isEditable"
                  fluid
                  id="notable_signs"
                  v-model="formData.notable_signs"
                />
                <label for="notable_signs">{{
                  $t("case_history.fields.notable_signs")
                }}</label>
              </FloatLabel>
            </div>
            <div class="field mt-6 w-[48%]">
              <FloatLabel>
                <InputText
                  :disabled="!isEditable"
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
                icon="pi pi-arrow-left"
                @click="activateCallback('2')"
              />
              <Button
                :label="$t('case_history.actions.next')"
                icon="pi pi-arrow-right"
                iconPos="right"
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
                :disabled="!isEditable"
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
                  :disabled="!isEditable"
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
                  :disabled="!isEditable"
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
                  :disabled="!isEditable"
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
                icon="pi pi-arrow-left"
                @click="activateCallback('3')"
              />
              <Button
                :label="$t('case_history.actions.next')"
                icon="pi pi-arrow-right"
                iconPos="right"
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
                      :disabled="!isEditable"
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
                    <InputText
                      :disabled="!isEditable"
                      fluid
                      id="diet_details"
                      v-model="formData.diet_details"
                    />
                    <label for="diet_details">{{
                      $t("case_history.fields.diet_details")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      :disabled="!isEditable"
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
                      :disabled="!isEditable"
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
                      :disabled="!isEditable"
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
                    :disabled="!isEditable"
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
                      :disabled="!isEditable"
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
                    <InputText
                      :disabled="!isEditable"
                      fluid
                      id="water_intake"
                      v-model="formData.water_intake"
                    />
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
                icon="pi pi-arrow-left"
                @click="activateCallback('4')"
              />
              <Button
                :label="$t('case_history.actions.next')"
                icon="pi pi-arrow-right"
                iconPos="right"
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
                    :disabled="!isEditable"
                    class="mx-2"
                    id="vomiting"
                    v-model="formData.vomiting"
                    binary
                  />
                  <label for="vomiting">{{ $t("case_history.fields.vomiting") }}</label>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      :disabled="!isEditable"
                      fluid
                      id="vomit_color"
                      v-model="formData.vomit_color"
                    />
                    <label for="vomit_color">{{
                      $t("case_history.fields.vomit_color")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      :disabled="!isEditable"
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
                    <InputText
                      :disabled="!isEditable"
                      fluid
                      id="vomit_smell"
                      v-model="formData.vomit_smell"
                    />
                    <label for="vomit_smell">{{
                      $t("case_history.fields.vomit_smell")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      :disabled="!isEditable"
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
                    :disabled="!isEditable"
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
                    :disabled="!isEditable"
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
                    :disabled="!isEditable"
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
                      :disabled="!isEditable"
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
                    <InputText
                      :disabled="!isEditable"
                      fluid
                      id="stool_color"
                      v-model="formData.stool_color"
                    />
                    <label for="stool_color">{{
                      $t("case_history.fields.stool_color")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      :disabled="!isEditable"
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
                      :disabled="!isEditable"
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
                    :disabled="!isEditable"
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
                icon="pi pi-arrow-left"
                @click="activateCallback('5')"
              />
              <Button
                :label="$t('case_history.actions.next')"
                icon="pi pi-arrow-right"
                iconPos="right"
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
                      :disabled="!isEditable"
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
                      :disabled="!isEditable"
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
                      :disabled="!isEditable"
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
                    :disabled="!isEditable"
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
                      :disabled="!isEditable"
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
                      :disabled="!isEditable"
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
                icon="pi pi-arrow-left"
                @click="activateCallback('6')"
              />
              <Button
                :label="$t('case_history.actions.next')"
                icon="pi pi-arrow-right"
                iconPos="right"
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
              <Checkbox
                :disabled="!isEditable"
                class="mx-2"
                id="cough"
                v-model="formData.cough"
                binary
              />
              <label for="cough">{{ $t("case_history.fields.cough") }}</label>
            </div>
            <div class="field mt-6 w-[48%]">
              <FloatLabel>
                <DatePicker
                  showIcon
                  iconDisplay="input"
                  showButtonBar
                  :disabled="!isEditable"
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
                  :disabled="!isEditable"
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
                  :disabled="!isEditable"
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
                :disabled="!isEditable"
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
              <Checkbox
                :disabled="!isEditable"
                class="mx-2"
                id="sneezing"
                v-model="formData.sneezing"
                binary
              />
              <label for="sneezing">{{ $t("case_history.fields.sneezing") }}</label>
            </div>
            <div class="flex pt-6 justify-between">
              <Button
                :label="$t('case_history.actions.back')"
                severity="secondary"
                icon="pi pi-arrow-left"
                @click="activateCallback('7')"
              />
              <Button
                :label="$t('case_history.actions.next')"
                icon="pi pi-arrow-right"
                iconPos="right"
                @click="activateCallback('9')"
              />
            </div>
          </StepPanel>

          <!-- Step 10: Review & Submit -->
          <!-- <StepPanel v-slot="{ activateCallback }" value="10">
            <div class="flex flex-col gap-4">
              <h3 class="text-xl font-bold">Review Your Entries</h3>
              <pre>{{ formData }}</pre>
            </div>
            <div class="flex pt-6 justify-between">
              <Button
                label="Back"
                severity="secondary"
                icon="pi pi-arrow-left"
                @click="activateCallback('9')"
              />
              <Button label="Submit" @click="submitForm" />
            </div>
          </StepPanel> -->
        </StepPanels>
      </Stepper>
    </fieldset>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from "vue";
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
import eventBus from "@/eventBus";
import { setActivePinia } from "pinia";
import { useI18n } from "vue-i18n";

const { t, locale } = useI18n();
const emit = defineEmits(); // Define the event to be emitted

const hasCaseHistory = ref(false);
const props = defineProps({
  medical_record_id: {
    type: Number,
    required: true,
  },
});
const showAddCaseHistoryModal = (MedicalRecordId) => {
  emit("showAddCaseHistoryModal", MedicalRecordId);
};
const formatDate = (isoDateString) => {
  return isoDateString ? new Date(isoDateString).toISOString().split("T")[0] : null;
};
const isEditable = ref(false);
const activeStep = ref("1");
const formData = ref({
  // Step 1: Current Symptoms
  symptom_description: "",
  start_date: null,
  symptom_progression: "",
  medication_given: false,
  medication_name: "",
  medication_dosage: "",
  prescribed_by: "",

  // Step 2: General Health
  activity_level: "",
  vaccination_status: "",
  care_location: "",
  other_animals_in_household: false,
  number_of_other_animals: 0,
  types_of_other_animals: "",
  previous_diseases_in_other_animals: "",

  // Step 3: Reproductive History
  last_reproductive_cycle_date: null,
  cycle_length: 0,
  notable_signs: "",
  other_discharges: "",

  // Step 4: Itching & Skin
  itching_present: false,
  itching_location: "",
  itching_description: "",
  skin_condition_description: "",

  // Step 5: Diet & Water
  diet_type: "",
  diet_details: "",
  number_of_meals: 0,
  meal_quantity: "",
  appetite: "",
  recent_diet_change: false,
  diet_change_type: "",
  water_intake: "",

  // Step 6: Gastrointestinal
  vomiting: false,
  vomit_color: "",
  vomit_contents: "",
  vomit_smell: "",
  vomiting_frequency: 0,
  vomiting_related_to_food: false,
  vomiting_related_to_diarrhea: false,
  diarrhea_started_first: false,
  stool_consistency: "",
  stool_color: "",
  stool_frequency: 0,
  abnormal_stool_contents: "",
  excessive_licking_of_anus: false,

  // Step 7: Neurological
  neurological_signs: "",
  neurological_signs_frequency: "",
  associated_symptoms: "",
  sudden_onset: false,
  related_to_eating_or_activity: "",
  additional_details: "",

  // Step 8: Respiratory
  cough: false,
  cough_start_date: null,
  cough_frequency: "",
  cough_type: "",
  breathing_difficulty: false,
  sneezing: false,

  // Step 9: Urinary
  urination_frequency: 0,
  frequent_litter_box_visits: false,
  urine_volume: "",
  urine_color: "",
  urination_type: "",
  blood_in_urine: false,
  blood_location: "",
  abnormal_urinary_discharge: "",
  genital_discharge: "",
  excessive_licking_of_genital_area: false,

  // Step 10: Vaccination History
  vaccine_name: "",
  vaccine_date: null,
  next_due_date: null,
  administered_by: "",

  // Step 11: Medication History
  medication_name: "",
  medication_type: "",
  dosage: "",
  frequency: "",
  medication_start_date: null,
  medication_end_date: null,
  prescribed_by: "",

  //Step 12: Antiparasitic Treatment
  treatment_name: "",
  treatment_type: "",
  treatment_dosage: "",
  administration_date: null,
  treatment_next_due_date: null,
  treatment_administered_by: "",

  // Step 13: Additional Notes
  additional_notes: "",
});
const symptomProgressionOptions = [
  {
    label: t("case_history.options.symptom_progression.increasing"),
    en_label: "Increasing",
    value: "increasing",
  },
  {
    label: t("case_history.options.symptom_progression.decreasing"),
    en_label: "Decreasing",
    value: "decreasing",
  },
  {
    label: t("case_history.options.symptom_progression.constant"),
    en_label: "Constant",
    value: "constant",
  },
];

const activityLevelOptions = [
  {
    label: t("case_history.options.activity_level.active"),
    en_label: "Active",
    value: "active",
  },
  {
    label: t("case_history.options.activity_level.lethargic"),
    en_label: "Lethargic",
    value: "lethargic",
  },
  {
    label: t("case_history.options.activity_level.sometimes_active"),
    en_label: "Sometimes Active",
    value: "sometimes_active",
  },
  {
    label: t("case_history.options.activity_level.other"),
    en_label: "Other",
    value: "other",
  },
];

const stoolConsistencyOptions = [
  {
    label: t("case_history.options.stool_consistency.normal"),
    en_label: "Normal",
    value: "normal",
  },
  {
    label: t("case_history.options.stool_consistency.soft"),
    en_label: "Soft",
    value: "soft",
  },
  {
    label: t("case_history.options.stool_consistency.watery"),
    en_label: "Watery",
    value: "watery",
  },
  {
    label: t("case_history.options.stool_consistency.hard"),
    en_label: "Hard",
    value: "hard",
  },
];

const vaccinationStatusOptions = [
  {
    label: t("case_history.options.vaccination_status.complete"),
    en_label: "Complete",
    value: "complete",
  },
  {
    label: t("case_history.options.vaccination_status.incomplete"),
    en_label: "Incomplete",
    value: "incomplete",
  },
];

const careLocationOptions = [
  {
    label: t("case_history.options.care_location.home"),
    en_label: "Home",
    value: "home",
  },
  {
    label: t("case_history.options.care_location.home_garden"),
    en_label: "Home Garden",
    value: "home_garden",
  },
  {
    label: t("case_history.options.care_location.street"),
    en_label: "Street",
    value: "street",
  },
  {
    label: t("case_history.options.care_location.indoor_outdoor"),
    en_label: "Indoor/Outdoor",
    value: "indoor_outdoor",
  },
];

const dietTypeOptions = [
  { label: t("case_history.options.diet_type.dry"), en_label: "Dry", value: "dry" },
  {
    label: t("case_history.options.diet_type.canned"),
    en_label: "Canned",
    value: "canned",
  },
  {
    label: t("case_history.options.diet_type.home_cooked"),
    en_label: "Home Cooked",
    value: "home_cooked",
  },
  { label: t("case_history.options.diet_type.raw"), en_label: "Raw", value: "raw" },
  { label: t("case_history.options.diet_type.mixed"), en_label: "Mixed", value: "mixed" },
];

const appetiteOptions = [
  { label: t("case_history.options.appetite.good"), en_label: "Good", value: "good" },
  {
    label: t("case_history.options.appetite.leaves_meal"),
    en_label: "Leaves Meal",
    value: "leaves_meal",
  },
  {
    label: t("case_history.options.appetite.no_appetite"),
    en_label: "No Appetite",
    value: "no_appetite",
  },
];

const dietChangeTypeOptions = [
  {
    label: t("case_history.options.diet_change_type.sudden"),
    en_label: "Sudden",
    value: "sudden",
  },
  {
    label: t("case_history.options.diet_change_type.gradual"),
    en_label: "Gradual",
    value: "gradual",
  },
];

const coughTypeOptions = [
  { label: t("case_history.options.cough_type.dry"), en_label: "Dry", value: "dry" },
  {
    label: t("case_history.options.cough_type.productive"),
    en_label: "Productive",
    value: "productive",
  },
];

const urinationTypeOptions = [
  {
    label: t("case_history.options.urination_type.continuous"),
    en_label: "Continuous",
    value: "continuous",
  },
  {
    label: t("case_history.options.urination_type.intermittent"),
    en_label: "Intermittent",
    value: "intermittent",
  },
];

const bloodLocationOptions = [
  {
    label: t("case_history.options.blood_location.beginning"),
    en_label: "Beginning",
    value: "beginning",
  },
  { label: t("case_history.options.blood_location.end"), en_label: "End", value: "end" },
  {
    label: t("case_history.options.blood_location.throughout"),
    en_label: "Throughout",
    value: "throughout",
  },
];

const urineVolumeOptions = [
  { label: "Large", en_label: "Large", value: "large" },
  { label: "Small", en_label: "Small", value: "small" },
  { label: "Medium", en_label: "Medium", value: "medium" },
];

const medicationTypeOptions = [
  {
    label: t("case_history.options.medication_type.antibiotic"),
    en_label: "Antibiotic",
    value: "antibiotic",
  },
  {
    label: t("case_history.options.medication_type.painkiller"),
    en_label: "Painkiller",
    value: "painkiller",
  },
  {
    label: t("case_history.options.medication_type.anti-inflammatory"),
    en_label: "Anti-inflammatory",
    value: "anti-inflammatory",
  },
  {
    label: t("case_history.options.medication_type.other"),
    en_label: "Other",
    value: "other",
  },
];

const neurologicalSignsOptions = [
  { label: "Seizures", en_label: "Seizures", value: "seizures" },
  { label: "Fainting", en_label: "Fainting", value: "fainting" },
  { label: "Nystagmus", en_label: "Nystagmus", value: "nystagmus" },
  { label: "Other", en_label: "Other", value: "other" },
];

const treatmentTypeOptions = [
  {
    label: t("case_history.options.treatment_type.flea"),
    en_label: "Flea",
    value: "flea",
  },
  {
    label: t("case_history.options.treatment_type.tick"),
    en_label: "Tick",
    value: "tick",
  },
  {
    label: t("case_history.options.treatment_type.worm"),
    en_label: "Worm",
    value: "worm",
  },
  {
    label: t("case_history.options.treatment_type.other"),
    en_label: "Other",
    value: "other",
  },
];
/*const fetchHistory = async (medicalRecordId) => {
  try {
    // console.log("MID" + props.medical_record_id);
    const response = await axiosInstance.get(
      `/medical-records/${props.medical_record_id}/history`
    );
    const history = response.data;
    if (history.current_symptom.length > 0) {
      hasCaseHistory.value = true;
    }
    // Helper function to find the corresponding option
    const findOption = (options, value) =>
      options.find((option) => option.value === value);

    // Map the API response to formData
    if (history.current_symptom && history.current_symptom.length > 0) {
      formData.value.symptom_description = history.current_symptom[0].symptom_description;
      formData.value.start_date = history.current_symptom[0].start_date;
      formData.value.symptom_progression = history.current_symptom[0].symptom_progression;
      formData.value.medication_given = history.current_symptom[0].medication_given;
      formData.value.medication_name = history.current_symptom[0].medication_name;
      formData.value.medication_dosage = history.current_symptom[0].medication_dosage;
      formData.value.prescribed_by = history.current_symptom[0].prescribed_by;
    }

    if (history.general_health && history.general_health.length > 0) {
      formData.value.activity_level = history.general_health[0].activity_level;
      formData.value.vaccination_status = history.general_health[0].vaccination_status;
      formData.value.care_location = history.general_health[0].care_location;
      formData.value.other_animals_in_household =
        history.general_health[0].other_animals_in_household;
      formData.value.number_of_other_animals =
        history.general_health[0].number_of_other_animals;
      formData.value.types_of_other_animals =
        history.general_health[0].types_of_other_animals;
      formData.value.previous_diseases_in_other_animals =
        history.general_health[0].previous_diseases_in_other_animals;
    }

    if (history.reproductive_history && history.reproductive_history.length > 0) {
      formData.value.last_reproductive_cycle_date =
        history.reproductive_history[0].last_reproductive_cycle_date;
      formData.value.cycle_length = history.reproductive_history[0].cycle_length;
      formData.value.notable_signs = history.reproductive_history[0].notable_signs;
      formData.value.other_discharges = history.reproductive_history[0].other_discharges;
    }

    if (history.itching_skin_condition && history.itching_skin_condition.length > 0) {
      formData.value.itching_present = history.itching_skin_condition[0].itching_present;
      formData.value.itching_location =
        history.itching_skin_condition[0].itching_location;
      formData.value.itching_description =
        history.itching_skin_condition[0].itching_description;
      formData.value.skin_condition_description =
        history.itching_skin_condition[0].skin_condition_description;
    }

    if (history.diet_water_intake && history.diet_water_intake.length > 0) {
      formData.value.diet_type = history.diet_water_intake[0].diet_type;
      formData.value.diet_details = history.diet_water_intake[0].diet_details;
      formData.value.number_of_meals = history.diet_water_intake[0].number_of_meals;
      formData.value.meal_quantity = history.diet_water_intake[0].meal_quantity;
      formData.value.appetite = history.diet_water_intake[0].appetite;
      formData.value.recent_diet_change = history.diet_water_intake[0].recent_diet_change;
      formData.value.diet_change_type =
        history.diet_water_intake[0].diet_change_type !== null
          ? history.diet_water_intake[0].diet_change_type
          : "";
      formData.value.water_intake = history.diet_water_intake[0].water_intake;
    }

    if (history.gastrointestinal_symptom && history.gastrointestinal_symptom.length > 0) {
      formData.value.vomiting = history.gastrointestinal_symptom[0].vomiting;
      formData.value.vomit_color = history.gastrointestinal_symptom[0].vomit_color;
      formData.value.vomit_contents = history.gastrointestinal_symptom[0].vomit_contents;
      formData.value.vomit_smell = history.gastrointestinal_symptom[0].vomit_smell;
      formData.value.vomiting_frequency =
        history.gastrointestinal_symptom[0].vomiting_frequency;
      formData.value.vomiting_related_to_food =
        history.gastrointestinal_symptom[0].vomiting_related_to_food;
      formData.value.vomiting_related_to_diarrhea =
        history.gastrointestinal_symptom[0].vomiting_related_to_diarrhea;
      formData.value.diarrhea_started_first =
        history.gastrointestinal_symptom[0].diarrhea_started_first;
      formData.value.stool_consistency =
        history.gastrointestinal_symptom &&
        history.gastrointestinal_symptom[0] &&
        history.gastrointestinal_symptom[0].stool_consistency !== null
          ? history.gastrointestinal_symptom[0].stool_consistency
          : "";
      //   // console.log(history.gastrointestinal_symptom[0].stool_consistency + "CONST");
      formData.value.stool_color = history.gastrointestinal_symptom[0].stool_color;
      formData.value.stool_frequency =
        history.gastrointestinal_symptom[0].stool_frequency;
      formData.value.abnormal_stool_contents =
        history.gastrointestinal_symptom[0].abnormal_stool_contents;
      formData.value.excessive_licking_of_anus =
        history.gastrointestinal_symptom[0].excessive_licking_of_anus;
    }

    if (history.neurological_symptom && history.neurological_symptom.length > 0) {
      formData.value.neurological_signs =
        history.neurological_symptom[0].neurological_signs;
      formData.value.neurological_signs_frequency =
        history.neurological_symptom[0].neurological_signs_frequency;
      formData.value.associated_symptoms =
        history.neurological_symptom[0].associated_symptoms;
      formData.value.sudden_onset = history.neurological_symptom[0].sudden_onset;
      formData.value.related_to_eating_or_activity =
        history.neurological_symptom[0].related_to_eating_or_activity;
      formData.value.additional_details =
        history.neurological_symptom[0].additional_details;
    }

    if (history.respiratory_symptom && history.respiratory_symptom.length > 0) {
      formData.value.cough = history.respiratory_symptom[0].cough;
      formData.value.cough_start_date = history.respiratory_symptom[0].cough_start_date;
      formData.value.cough_frequency = history.respiratory_symptom[0].cough_frequency;
      formData.value.cough_type = history.respiratory_symptom[0].cough_type;
      formData.value.breathing_difficulty =
        history.respiratory_symptom[0].breathing_difficulty;
      formData.value.sneezing = history.respiratory_symptom[0].sneezing;
    }

    if (history.urinary_symptom && history.urinary_symptom.length > 0) {
      formData.value.urination_frequency = history.urinary_symptom[0].urination_frequency;
      formData.value.frequent_litter_box_visits =
        history.urinary_symptom[0].frequent_litter_box_visits;
      formData.value.urine_volume = history.urinary_symptom[0].urine_volume;
      formData.value.urine_color = history.urinary_symptom[0].urine_color;
      formData.value.urination_type = history.urinary_symptom[0].urination_type;
      formData.value.blood_in_urine = history.urinary_symptom[0].blood_in_urine;
      formData.value.blood_location = history.urinary_symptom[0].blood_location;
      formData.value.abnormal_urinary_discharge =
        history.urinary_symptom[0].abnormal_urinary_discharge;
      formData.value.genital_discharge = history.urinary_symptom[0].genital_discharge;
      formData.value.excessive_licking_of_genital_area =
        history.urinary_symptom[0].excessive_licking_of_genital_area;
    }

    // console.log("Fetched history and updated formData:", formData.value);
  } catch (error) {
    console.error("Error fetching history:", error);
  }
};*/
const fetchHistory = async (medicalRecordId) => {
  try {
    // // console.log("MID" + props.medical_record_id);
    const response = await axiosInstance.get(
      `/medical-records/${props.medical_record_id}/history`
    );
    const history = response.data;
    if (history.current_symptom.length > 0) {
      hasCaseHistory.value = true;
    }
    // // console.log(history);
    // Helper function to find the corresponding option
    const findOption = (options, value) =>
      options.find((option) => option.value === value);

    // Map the API response to formData
    if (history.current_symptom && history.current_symptom.length > 0) {
      formData.value.symptom_description = history.current_symptom[0].symptom_description;
      formData.value.start_date = history.current_symptom[0].start_date;
      formData.value.symptom_progression = history.current_symptom[0].symptom_progression;
      formData.value.medication_given = history.current_symptom[0].medication_given;
      formData.value.medication_name = history.current_symptom[0].medication_name;
      formData.value.medication_dosage = history.current_symptom[0].medication_dosage;
      formData.value.prescribed_by = history.current_symptom[0].prescribed_by;
    }

    if (history.general_health && history.general_health.length > 0) {
      formData.value.activity_level = history.general_health[0].activity_level;
      formData.value.vaccination_status = history.general_health[0].vaccination_status;
      formData.value.care_location = history.general_health[0].care_location;
      formData.value.other_animals_in_household =
        history.general_health[0].other_animals_in_household;
      formData.value.number_of_other_animals =
        history.general_health[0].number_of_other_animals;
      formData.value.types_of_other_animals =
        history.general_health[0].types_of_other_animals;
      formData.value.previous_diseases_in_other_animals =
        history.general_health[0].previous_diseases_in_other_animals;
    }

    if (history.reproductive_history && history.reproductive_history.length > 0) {
      formData.value.last_reproductive_cycle_date = formatDate(
        history.reproductive_history[0].last_reproductive_cycle_date
      );
      formData.value.cycle_length = history.reproductive_history[0].cycle_length;
      formData.value.notable_signs = history.reproductive_history[0].notable_signs;
      formData.value.other_discharges = history.reproductive_history[0].other_discharges;
    }

    if (history.itching_skin_condition && history.itching_skin_condition.length > 0) {
      formData.value.itching_present = history.itching_skin_condition[0].itching_present;
      formData.value.itching_location =
        history.itching_skin_condition[0].itching_location;
      formData.value.itching_description =
        history.itching_skin_condition[0].itching_description;
      formData.value.skin_condition_description =
        history.itching_skin_condition[0].skin_condition_description;
    }

    if (history.diet_water_intake && history.diet_water_intake.length > 0) {
      formData.value.diet_type = history.diet_water_intake[0].diet_type;
      formData.value.diet_details = history.diet_water_intake[0].diet_details;
      formData.value.number_of_meals = history.diet_water_intake[0].number_of_meals;
      formData.value.meal_quantity = history.diet_water_intake[0].meal_quantity;
      formData.value.appetite = history.diet_water_intake[0].appetite;
      formData.value.recent_diet_change = history.diet_water_intake[0].recent_diet_change;
      formData.value.diet_change_type =
        history.diet_water_intake[0].diet_change_type !== null
          ? history.diet_water_intake[0].diet_change_type
          : "";
      formData.value.water_intake = history.diet_water_intake[0].water_intake;
    }

    if (history.gastrointestinal_symptom && history.gastrointestinal_symptom.length > 0) {
      formData.value.vomiting = history.gastrointestinal_symptom[0].vomiting;
      formData.value.vomit_color = history.gastrointestinal_symptom[0].vomit_color;
      formData.value.vomit_contents = history.gastrointestinal_symptom[0].vomit_contents;
      formData.value.vomit_smell = history.gastrointestinal_symptom[0].vomit_smell;
      formData.value.vomiting_frequency =
        history.gastrointestinal_symptom[0].vomiting_frequency;
      formData.value.vomiting_related_to_food =
        history.gastrointestinal_symptom[0].vomiting_related_to_food;
      formData.value.vomiting_related_to_diarrhea =
        history.gastrointestinal_symptom[0].vomiting_related_to_diarrhea;
      formData.value.diarrhea_started_first =
        history.gastrointestinal_symptom[0].diarrhea_started_first;
      formData.value.stool_consistency =
        history.gastrointestinal_symptom &&
        history.gastrointestinal_symptom[0] &&
        history.gastrointestinal_symptom[0].stool_consistency !== null
          ? history.gastrointestinal_symptom[0].stool_consistency
          : "";
      formData.value.stool_color = history.gastrointestinal_symptom[0].stool_color;
      formData.value.stool_frequency =
        history.gastrointestinal_symptom[0].stool_frequency;
      formData.value.abnormal_stool_contents =
        history.gastrointestinal_symptom[0].abnormal_stool_contents;
      formData.value.excessive_licking_of_anus =
        history.gastrointestinal_symptom[0].excessive_licking_of_anus;
    }

    if (history.neurological_symptom && history.neurological_symptom.length > 0) {
      formData.value.neurological_signs =
        history.neurological_symptom[0].neurological_signs;
      formData.value.neurological_signs_frequency =
        history.neurological_symptom[0].neurological_signs_frequency;
      formData.value.associated_symptoms =
        history.neurological_symptom[0].associated_symptoms;
      formData.value.sudden_onset = history.neurological_symptom[0].sudden_onset;
      formData.value.related_to_eating_or_activity =
        history.neurological_symptom[0].related_to_eating_or_activity;
      formData.value.additional_details =
        history.neurological_symptom[0].additional_details;
    }

    if (history.respiratory_symptom && history.respiratory_symptom.length > 0) {
      formData.value.cough = history.respiratory_symptom[0].cough;
      formData.value.cough_start_date = history.respiratory_symptom[0].cough_start_date;
      formData.value.cough_frequency = history.respiratory_symptom[0].cough_frequency;
      formData.value.cough_type = history.respiratory_symptom[0].cough_type;
      formData.value.breathing_difficulty =
        history.respiratory_symptom[0].breathing_difficulty;
      formData.value.sneezing = history.respiratory_symptom[0].sneezing;
    }

    if (history.urinary_symptom && history.urinary_symptom.length > 0) {
      formData.value.urination_frequency = history.urinary_symptom[0].urination_frequency;
      formData.value.frequent_litter_box_visits =
        history.urinary_symptom[0].frequent_litter_box_visits;
      formData.value.urine_volume = history.urinary_symptom[0].urine_volume;
      formData.value.urine_color = history.urinary_symptom[0].urine_color;
      formData.value.urination_type = history.urinary_symptom[0].urination_type;
      formData.value.blood_in_urine = history.urinary_symptom[0].blood_in_urine;
      formData.value.blood_location = history.urinary_symptom[0].blood_location;
      formData.value.abnormal_urinary_discharge =
        history.urinary_symptom[0].abnormal_urinary_discharge;
      formData.value.genital_discharge = history.urinary_symptom[0].genital_discharge;
      formData.value.excessive_licking_of_genital_area =
        history.urinary_symptom[0].excessive_licking_of_genital_area;
    }

    // Step 10: Vaccination History
    if (history.vaccination_history && history.vaccination_history.length > 0) {
      formData.value.vaccine_name = history.vaccination_history[0].vaccine_name;
      formData.value.vaccine_date = formatDate(
        history.vaccination_history[0].vaccine_date
      );
      formData.value.next_due_date = formatDate(
        history.vaccination_history[0].next_due_date
      );
      formData.value.administered_by = history.vaccination_history[0].administered_by;
    }

    // Step 11: Medication History
    if (history.medication_history && history.medication_history.length > 0) {
      formData.value.medication_name = history.medication_history[0].medication_name;
      formData.value.medication_type = history.medication_history[0].medication_type;
      formData.value.dosage = history.medication_history[0].dosage;
      formData.value.frequency = history.medication_history[0].frequency;
      formData.value.medication_start_date = formatDate(
        history.medication_history[0].start_date
      );
      formData.value.medication_end_date = formatDate(
        history.medication_history[0].end_date
      );
      formData.value.prescribed_by = history.medication_history[0].prescribed_by;
    }

    // Step 12: Antiparasitic Treatment
    if (history.antiparasitic_treatment && history.antiparasitic_treatment.length > 0) {
      formData.value.treatment_name = history.antiparasitic_treatment[0].treatment_name;
      formData.value.treatment_type = history.antiparasitic_treatment[0].treatment_type;
      formData.value.treatment_dosage = history.antiparasitic_treatment[0].dosage;
      formData.value.administration_date = formatDate(
        history.antiparasitic_treatment[0].administration_date
      );
      formData.value.treatment_next_due_date = formatDate(
        history.antiparasitic_treatment[0].next_due_date
      );
      formData.value.treatment_administered_by =
        history.antiparasitic_treatment[0].administered_by;
    }

    // Step 13: Additional Notes
    if (history.additional_note && history.additional_note.length > 0) {
      formData.value.additional_notes = history.additional_note[0].notes;
    }

    // // console.log("Fetched history and updated formData:", formData.value);
  } catch (error) {
    console.error("Error fetching history:", error);
  }
};
const submitForm = async () => {
  try {
    // Utility function to format dates

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

    // // console.log(formData.value);

    // Send formData to the storeHistory endpoint
    const response = await axiosInstance.put(
      `/medical-records/history/${props.medical_record_id}`,
      formData.value
    );
    emit("CaseHistoryUpdated", response.data); // Emit event to notify parent component
    eventBus.emit("show-toast", {
      severity: "success",
      summary: t("case_history.title"), // e.g., "Case History Details"
      detail: t("case_history.messages.success"), // e.g., "Case history updated successfully"
      life: 5000,
    });
    // // console.log("Form updated successfully:", response.data);
  } catch (error) {
    console.error("Error submitting form:", error);
  }
};
function setActivePanel(panel) {
  // // console.log("Panel" + panel);
  activeStep.value = "panel";
}
onMounted(() => {
  const medicalRecordId = 31; // Replace with the actual ID
  fetchHistory(medicalRecordId);
  eventBus.on("handleCaseHistorySuccessfully", async () => {
    // console.log("Event bus triggered: handleCaseHistorySuccessfully");
    await fetchHistory(medicalRecordId);
    // console.log("activeStep Original Value:", activeStep.value); // Debugging
    activeStep.value = "2"; // Move to step 1
    await nextTick(); // Wait for the DOM to update

    activeStep.value = "1"; // Move to step 1
    // console.log("activeStep updated to:", activeStep.value); // Debugging
    isEditable.value = false;
  });
});
</script>
<style>
:root {
  --color-violet-600: oklch(0.541 0.281 293.009);
  --p-inputtext-disabled-color: black !important;
}
.p-inputtext:disabled,
.p-checkbox-input:disabled,
.p-select-label,
.p-textarea:disabled,
.p-select.p-disabled,
.p-datepicker-dropdown,
.p-checkbox.p-disabled .p-checkbox-box .p-checkbox-icon {
  color: black !important;
  /* background: transparent !important; */
  /* border: 0px !important; */
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
