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
          <Step class="w-1/6 text-sm" :data-p-invalid="invalid.symptoms.step" value="1">{{
            $t("case_history.steps.current_symptoms")
          }}</Step>
          <Step
            class="w-1/6 text-sm"
            :class="{
              invalid: invalid.general_health.step,
            }"
            :data-p-invalid="invalid.general_health.step"
            value="2"
            >{{ $t("case_history.steps.general_health") }}</Step
          >
          <Step class="w-1/6 text-sm" value="3">{{
            $t("case_history.steps.reproductive_history")
          }}</Step>
          <Step class="w-1/6 text-sm" value="4">{{
            $t("case_history.steps.itching_skin")
          }}</Step>
          <Step
            class="w-1/6 text-sm"
            :data-p-invalid="invalid.diet.step"
            :class="{
              invalid: invalid.diet.step,
            }"
            value="5"
            >{{ $t("case_history.steps.diet_water") }}</Step
          >
          <Step class="w-1/6 text-sm" value="6">{{
            $t("case_history.steps.gastrointestinal")
          }}</Step>
          <Step class="w-1/6 text-sm" value="7">{{
            $t("case_history.steps.neurological")
          }}</Step>
          <Step class="w-1/6 text-sm" value="8">{{
            $t("case_history.steps.respiratory")
          }}</Step>
          <Step class="w-1/6 text-sm" value="9">{{
            $t("case_history.steps.urinary")
          }}</Step>
          <Step class="w-1/6 text-sm" value="10">{{
            $t("case_history.steps.musculoskeletal")
          }}</Step>
          <Step
            class="w-1/6 text-sm"
            :data-p-invalid="invalid.vaccine.step"
            :class="{
              invalid: invalid.vaccine.step,
            }"
            value="11"
            >{{ $t("case_history.steps.vaccination_medication") }}</Step
          >
        </StepList>
        <!-- Step Panels -->

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
                      :invalid="invalid.symptoms.symptom_description"
                    />
                    <label for="symptom_description"
                      >{{ $t("case_history.fields.symptom_description") }}
                      <span class="text-red-600">*</span>
                    </label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <DatePicker
                      :disabled="!isEditable"
                      showIcon
                      iconDisplay="input"
                      showButtonBar
                      dateFormat="yy-mm-d"
                      id="start_date"
                      v-model="formData.start_date"
                      hourFormat="24"
                      fluid
                      :invalid="invalid.symptoms.start_date"
                    />
                    <label for="start_date"
                      >{{ $t("case_history.fields.start_date") }}
                      <span class="text-red-600">*</span></label
                    >
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
                      :invalid="invalid.symptoms.symptom_progression"
                    />
                    <label for="symptom_progression"
                      >{{ $t("case_history.fields.symptom_progression") }}
                      <span class="text-red-600">*</span></label
                    >
                  </FloatLabel>
                </div>
              </div>
              <div class="w-[48%]">
                <div class="field mt-6 w-2/3">
                  <ToggleSwitch
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
                :icon="isRtl ? 'fa-solid fa-arrow-left' : 'fa-solid fa-arrow-right'"
                :iconPos="!isRtl ? 'right' : 'left'"
                @click="
                  () => {
                    if (validateStep(1)) activateCallback('2');
                  }
                "
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
                      :invalid="invalid.general_health.activity_level"
                    />
                    <label for="activity_level"
                      >{{ $t("case_history.fields.activity_level") }}
                      <span class="text-red-600">*</span></label
                    >
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
                      :invalid="invalid.general_health.vaccination_status"
                    />
                    <label for="vaccination_status"
                      >{{ $t("case_history.fields.vaccination_status") }}
                      <span class="text-red-600">*</span></label
                    >
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
                      :invalid="invalid.general_health.care_location"
                    />
                    <label for="care_location"
                      >{{ $t("case_history.fields.care_location") }}
                      <span class="text-red-600">*</span></label
                    >
                  </FloatLabel>
                </div>
              </div>
              <div class="w-[48%]">
                <div class="field mt-6 w-2/3">
                  <ToggleSwitch
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
                :icon="isRtl ? 'fa-solid fa-arrow-right ' : 'fa-solid fa-arrow-left'"
                :iconPos="!isRtl ? 'left' : 'right'"
                @click="
                  () => {
                    if (validateStep(2)) activateCallback('1');
                  }
                "
              />
              <Button
                :label="$t('case_history.actions.next')"
                :icon="isRtl ? 'fa-solid fa-arrow-left' : 'fa-solid fa-arrow-right'"
                :iconPos="!isRtl ? 'right' : 'left'"
                @click="
                  () => {
                    if (validateStep(2)) activateCallback('3');
                  }
                "
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
            <!-- pet_neutered -->
            <div class="flex items-start mt-6">
              <span class="text-sm"
                >{{ $t("case_history.options.pet_neutered.pet_neutered_label") }}:
              </span>
              <Tag
                :severity="props.pet_neutered === `Y` ? `success` : `danger`"
                :value="$t('case_history.options.pet_neutered.' + props.pet_neutered)"
                class="!text-s"
              ></Tag>
            </div>
            <div class="field mt-6 w-[48%]">
              <FloatLabel>
                <DatePicker
                  :disabled="!isEditable"
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
                :icon="isRtl ? 'fa-solid fa-arrow-right ' : 'fa-solid fa-arrow-left'"
                :iconPos="!isRtl ? 'left' : 'right'"
                @click="activateCallback('2')"
              />
              <Button
                :label="$t('case_history.actions.next')"
                :icon="isRtl ? 'fa-solid fa-arrow-left' : 'fa-solid fa-arrow-right'"
                :iconPos="!isRtl ? 'right' : 'left'"
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
              <ToggleSwitch
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
                :icon="isRtl ? 'fa-solid fa-arrow-right ' : 'fa-solid fa-arrow-left'"
                :iconPos="!isRtl ? 'left' : 'right'"
                @click="activateCallback('3')"
              />
              <Button
                :label="$t('case_history.actions.next')"
                :icon="isRtl ? 'fa-solid fa-arrow-left' : 'fa-solid fa-arrow-right'"
                :iconPos="!isRtl ? 'right' : 'left'"
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
                      :invalid="invalid.diet.diet_type"
                    />
                    <label for="diet_type"
                      >{{ $t("case_history.fields.diet_type") }}
                      <span class="text-red-600">*</span></label
                    >
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
                      :invalid="invalid.diet.appetite"
                    />
                    <label for="appetite"
                      >{{ $t("case_history.fields.appetite") }}
                      <span class="text-red-600">*</span></label
                    >
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <ToggleSwitch
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
                :icon="isRtl ? 'fa-solid fa-arrow-right ' : 'fa-solid fa-arrow-left'"
                :iconPos="!isRtl ? 'left' : 'right'"
                @click="
                  () => {
                    if (validateStep(5)) activateCallback('4');
                  }
                "
              />
              <Button
                :label="$t('case_history.actions.next')"
                :icon="isRtl ? 'fa-solid fa-arrow-left' : 'fa-solid fa-arrow-right'"
                :iconPos="!isRtl ? 'right' : 'left'"
                @click="
                  () => {
                    if (validateStep(5)) activateCallback('6');
                  }
                "
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
                  <ToggleSwitch
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
                  <ToggleSwitch
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
                  <ToggleSwitch
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
                  <ToggleSwitch
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
                  <ToggleSwitch
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
                :icon="isRtl ? 'fa-solid fa-arrow-right ' : 'fa-solid fa-arrow-left'"
                :iconPos="!isRtl ? 'left' : 'right'"
                @click="activateCallback('5')"
              />
              <Button
                :label="$t('case_history.actions.next')"
                :icon="isRtl ? 'fa-solid fa-arrow-left' : 'fa-solid fa-arrow-right'"
                :iconPos="!isRtl ? 'right' : 'left'"
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
                  <ToggleSwitch
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
                :icon="isRtl ? 'fa-solid fa-arrow-right ' : 'fa-solid fa-arrow-left'"
                :iconPos="!isRtl ? 'left' : 'right'"
                @click="activateCallback('6')"
              />
              <Button
                :label="$t('case_history.actions.next')"
                :icon="isRtl ? 'fa-solid fa-arrow-left' : 'fa-solid fa-arrow-right'"
                :iconPos="!isRtl ? 'right' : 'left'"
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
              <ToggleSwitch
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
                  :disabled="!isEditable"
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
              <ToggleSwitch
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
              <ToggleSwitch
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
                :icon="isRtl ? 'fa-solid fa-arrow-right ' : 'fa-solid fa-arrow-left'"
                :iconPos="!isRtl ? 'left' : 'right'"
                @click="activateCallback('7')"
              />
              <Button
                :label="$t('case_history.actions.next')"
                :icon="isRtl ? 'fa-solid fa-arrow-left' : 'fa-solid fa-arrow-right'"
                :iconPos="!isRtl ? 'right' : 'left'"
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
                      :disabled="!isEditable"
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
                      :disabled="!isEditable"
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
                    <InputText
                      :disabled="!isEditable"
                      fluid
                      id="urine_color"
                      v-model="formData.urine_color"
                    />
                    <label for="urine_color">{{
                      $t("case_history.fields.urine_color")
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
                  <ToggleSwitch
                    :disabled="!isEditable"
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
                      :disabled="!isEditable"
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
                      :disabled="!isEditable"
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
                      :disabled="!isEditable"
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
                  <ToggleSwitch
                    :disabled="!isEditable"
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
                :icon="isRtl ? 'fa-solid fa-arrow-right ' : 'fa-solid fa-arrow-left'"
                :iconPos="!isRtl ? 'left' : 'right'"
                @click="activateCallback('8')"
              />
              <Button
                :label="$t('case_history.actions.next')"
                :icon="isRtl ? 'fa-solid fa-arrow-left' : 'fa-solid fa-arrow-right'"
                :iconPos="!isRtl ? 'right' : 'left'"
                @click="activateCallback('10')"
              />
            </div>
          </StepPanel>

          <!-- Step 10: Musculoskeletal System - Owner Observations -->
          <StepPanel v-slot="{ activateCallback }" value="10">
            <div class="flex flex-col gap-4">
              <h4 class="border-b-4 rounded border-b-violet-800 w-fit font-bold">
                {{ $t("case_history.steps.musculoskeletal") }}
              </h4>
            </div>

            <div class="flex flex-wrap gap-8">
              <!-- Left Column -->
              <div class="w-[48%]">
                <!-- Primary Symptoms -->
                <div class="field mt-6">
                  <ToggleSwitch
                    :disabled="!isEditable"
                    id="limping"
                    v-model="formData.limping"
                    binary
                    class="mx-2"
                  />
                  <label for="limping">{{ $t("case_history.fields.limping") }}</label>
                </div>

                <div class="field mt-6">
                  <ToggleSwitch
                    :disabled="!isEditable"
                    id="pain"
                    v-model="formData.pain"
                    binary
                    class="mx-2"
                  />
                  <label for="pain">{{ $t("case_history.fields.pain") }}</label>
                </div>

                <div class="field mt-6">
                  <FloatLabel>
                    <TextArea
                      :disabled="!isEditable"
                      fluid
                      autoResize
                      rows="2"
                      id="pain_description"
                      v-model="formData.pain_description"
                    />
                    <label for="pain_description">
                      {{ $t("case_history.fields.pain_description") }}
                    </label>
                  </FloatLabel>
                </div>

                <div class="field mt-6">
                  <ToggleSwitch
                    :disabled="!isEditable"
                    id="swelling"
                    v-model="formData.swelling"
                    binary
                    class="mx-2"
                  />
                  <label for="swelling">{{ $t("case_history.fields.swelling") }}</label>
                </div>

                <div class="field mt-6">
                  <FloatLabel>
                    <InputText
                      :disabled="!isEditable"
                      fluid
                      id="swelling_location"
                      v-model="formData.swelling_location"
                    />
                    <label for="swelling_location">
                      {{ $t("case_history.fields.swelling_location") }}
                    </label>
                  </FloatLabel>
                </div>

                <div class="field mt-6">
                  <ToggleSwitch
                    :disabled="!isEditable"
                    id="visible_deformity"
                    v-model="formData.visible_deformity"
                    binary
                    class="mx-2"
                  />
                  <label for="visible_deformity">
                    {{ $t("case_history.fields.visible_deformity") }}
                  </label>
                </div>

                <div class="field mt-6">
                  <FloatLabel>
                    <TextArea
                      :disabled="!isEditable"
                      fluid
                      autoResize
                      rows="2"
                      id="deformity_description"
                      v-model="formData.deformity_description"
                    />
                    <label for="deformity_description">
                      {{ $t("case_history.fields.deformity_description") }}
                    </label>
                  </FloatLabel>
                </div>

                <!-- Affected Limbs -->
                <div class="field mt-6">
                  <label class="block mb-2 font-medium">
                    {{ $t("case_history.fields.affected_limbs") }}
                  </label>
                  <div class="flex flex-wrap gap-4">
                    <ToggleSwitch
                      :disabled="!isEditable"
                      v-model="formData.affected_limbs_FL"
                      inputId="fl"
                      name="limbs"
                      value="FL"
                    />
                    <label for="fl" class="mr-4">FL</label>
                    <ToggleSwitch
                      :disabled="!isEditable"
                      v-model="formData.affected_limbs_FR"
                      inputId="fr"
                      name="limbs"
                      value="FR"
                    />
                    <label for="fr" class="mr-4">FR</label>
                    <ToggleSwitch
                      :disabled="!isEditable"
                      v-model="formData.affected_limbs_HL"
                      inputId="hl"
                      name="limbs"
                      value="HL"
                    />
                    <label for="hl" class="mr-4">HL</label>
                    <ToggleSwitch
                      :disabled="!isEditable"
                      v-model="formData.affected_limbs_HR"
                      inputId="hr"
                      name="limbs"
                      value="HR"
                    />
                    <label for="hr">HR</label>
                  </div>
                </div>

                <div class="field mt-6">
                  <FloatLabel>
                    <Select
                      :disabled="!isEditable"
                      fluid
                      optionLabel="label"
                      optionValue="value"
                      id="weight_bearing"
                      v-model="formData.weight_bearing"
                      :options="weightBearingOptions"
                    />
                    <label for="weight_bearing">
                      {{ $t("case_history.fields.weight_bearing") }}
                    </label>
                  </FloatLabel>
                </div>
              </div>

              <!-- Right Column -->
              <div class="w-[48%]">
                <!-- Symptom Details -->
                <div class="field mt-6">
                  <FloatLabel>
                    <InputText
                      :disabled="!isEditable"
                      fluid
                      id="symptom_start"
                      v-model="formData.symptom_start"
                    />
                    <label for="symptom_start">
                      {{ $t("case_history.fields.symptom_start") }}
                    </label>
                  </FloatLabel>
                </div>

                <div class="field mt-6">
                  <FloatLabel>
                    <Select
                      :disabled="!isEditable"
                      fluid
                      optionLabel="label"
                      optionValue="value"
                      id="progression"
                      v-model="formData.progression"
                      :options="progressionOptions"
                    />
                    <label for="progression">
                      {{ $t("case_history.fields.progression") }}
                    </label>
                  </FloatLabel>
                </div>

                <!-- Trauma History -->
                <div class="field mt-6">
                  <ToggleSwitch
                    :disabled="!isEditable"
                    id="trauma_history"
                    v-model="formData.trauma_history"
                    binary
                    class="mx-2"
                  />
                  <label for="trauma_history">
                    {{ $t("case_history.fields.trauma_history") }}
                  </label>
                </div>

                <div class="field mt-6">
                  <FloatLabel>
                    <TextArea
                      :disabled="!isEditable"
                      fluid
                      autoResize
                      rows="2"
                      id="trauma_details"
                      v-model="formData.trauma_details"
                    />
                    <label for="trauma_details">
                      {{ $t("case_history.fields.trauma_details") }}
                    </label>
                  </FloatLabel>
                </div>

                <div class="flex flex-wrap">
                  <!-- Functional Impact -->
                  <div class="field mt-6">
                    <ToggleSwitch
                      :disabled="!isEditable"
                      id="exercise_induced"
                      v-model="formData.exercise_induced"
                      binary
                      class="mx-2"
                    />
                    <label for="exercise_induced">
                      {{ $t("case_history.fields.exercise_induced") }}
                    </label>
                  </div>
                  <div class="field mt-6">
                    <ToggleSwitch
                      :disabled="!isEditable"
                      id="worse_after_rest"
                      v-model="formData.worse_after_rest"
                      binary
                      class="mx-2"
                    />
                    <label for="worse_after_rest">
                      {{ $t("case_history.fields.worse_after_rest") }}
                    </label>
                  </div>
                  <div class="field mt-6">
                    <ToggleSwitch
                      :disabled="!isEditable"
                      id="difficulty_jumping"
                      v-model="formData.difficulty_jumping"
                      binary
                      class="mx-2"
                    />
                    <label for="difficulty_jumping">
                      {{ $t("case_history.fields.difficulty_jumping") }}
                    </label>
                  </div>
                  <div class="field mt-6">
                    <ToggleSwitch
                      :disabled="!isEditable"
                      id="difficulty_stairs"
                      v-model="formData.difficulty_stairs"
                      binary
                      class="mx-2"
                    />
                    <label for="difficulty_stairs">
                      {{ $t("case_history.fields.difficulty_stairs") }}
                    </label>
                  </div>
                  <div class="field mt-6">
                    <ToggleSwitch
                      :disabled="!isEditable"
                      id="difficulty_rising"
                      v-model="formData.difficulty_rising"
                      binary
                      class="mx-2"
                    />
                    <label for="difficulty_rising">
                      {{ $t("case_history.fields.difficulty_rising") }}
                    </label>
                  </div>
                </div>

                <div class="field mt-6">
                  <FloatLabel>
                    <Select
                      :disabled="!isEditable"
                      fluid
                      optionLabel="label"
                      optionValue="value"
                      id="exercise_tolerance"
                      v-model="formData.exercise_tolerance"
                      :options="exerciseToleranceOptions"
                    />
                    <label for="exercise_tolerance">
                      {{ $t("case_history.fields.exercise_tolerance") }}
                    </label>
                  </FloatLabel>
                </div>

                <!-- Current Management -->
                <div class="field mt-6">
                  <ToggleSwitch
                    :disabled="!isEditable"
                    id="pain_meds_given"
                    v-model="formData.pain_meds_given"
                    binary
                    class="mx-2"
                  />
                  <label for="pain_meds_given">
                    {{ $t("case_history.fields.pain_meds_given") }}
                  </label>
                </div>

                <div class="field mt-6">
                  <FloatLabel>
                    <TextArea
                      :disabled="!isEditable"
                      fluid
                      autoResize
                      rows="2"
                      id="pain_meds_details"
                      v-model="formData.pain_meds_details"
                    />
                    <label for="pain_meds_details">
                      {{ $t("case_history.fields.pain_meds_details") }}
                    </label>
                  </FloatLabel>
                </div>
              </div>
            </div>

            <!-- Navigation Buttons -->
            <div class="flex pt-6 justify-between">
              <Button
                :label="$t('case_history.actions.back')"
                severity="secondary"
                :icon="isRtl ? 'fa-solid fa-arrow-right ' : 'fa-solid fa-arrow-left'"
                :iconPos="!isRtl ? 'left' : 'right'"
                @click="activateCallback('9')"
              />
              <Button
                :label="$t('case_history.actions.next')"
                :icon="isRtl ? 'fa-solid fa-arrow-left' : 'fa-solid fa-arrow-right'"
                :iconPos="!isRtl ? 'right' : 'left'"
                @click="activateCallback('11')"
              />
            </div>
          </StepPanel>
          <!-- Step 11: Vaccination & Medication -->

          <StepPanel v-slot="{ activateCallback }" value="11">
            <!-- <div class="flex flex-wrap"></div> -->
            <!-- <div class="flex flex-wrap"> -->
            <div class="flex flex-col gap-4">
              <h4 class="border-b-4 rounded border-b-violet-800 w-fit font-bold">
                {{ $t("case_history.steps.vaccination_medication") }}
              </h4>
            </div>
            <div class="flex flex-wrap gap-4">
              <!-- Vaccination History -->
              <div class="w-[48%]">
                <h5 class="font-semibold mt-6">
                  {{ $t("case_history.additional.vaccination_history") }}
                </h5>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      :disabled="!isEditable"
                      fluid
                      id="vaccine_name"
                      v-model="formData.vaccine_name"
                      :invalid="invalid.vaccine.vaccine_name"
                    />
                    <label for="vaccine_name"
                      >{{ $t("case_history.fields.vaccine_name") }}
                      <span class="text-red-600">*</span></label
                    >
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <DatePicker
                      :disabled="!isEditable"
                      showIcon
                      iconDisplay="input"
                      showButtonBar
                      dateFormat="yy-mm-d"
                      id="vaccine_date"
                      :invalid="invalid.vaccine.vaccine_date"
                      v-model="formData.vaccine_date"
                    />
                    <label for="vaccine_date"
                      >{{ $t("case_history.fields.vaccine_date") }}
                      <span class="text-red-600">*</span></label
                    >
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <DatePicker
                      :disabled="!isEditable"
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
                      :disabled="!isEditable"
                      fluid
                      id="administered_by"
                      v-model="formData.administered_by"
                    />
                    <label for="administered_by">{{
                      $t("case_history.fields.administered_by")
                    }}</label>
                  </FloatLabel>
                </div>

                <!-- Antiparasitic Treatment -->

                <h5 class="font-semibold mt-6 w-2/3">
                  {{ $t("case_history.additional.antiparasitic_treatment") }}
                </h5>
                <div class="field mt-6 w-1/2">
                  <FloatLabel class="w-[90%]">
                    <InputText
                      :disabled="!isEditable"
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
                      :disabled="!isEditable"
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
                      :disabled="!isEditable"
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
                      :disabled="!isEditable"
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
                      :disabled="!isEditable"
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
                      :disabled="!isEditable"
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
              <div class="w-[48%]">
                <h5 class="font-semibold mt-6">
                  {{ $t("case_history.additional.medication_history") }}
                </h5>
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
                    <Select
                      :disabled="!isEditable"
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
                    <InputText
                      :disabled="!isEditable"
                      fluid
                      id="dosage"
                      v-model="formData.dosage"
                    />
                    <label for="dosage">{{ $t("case_history.fields.dosage") }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      :disabled="!isEditable"
                      fluid
                      id="frequency"
                      v-model="formData.frequency"
                    />
                    <label for="frequency">{{
                      $t("case_history.fields.frequency")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <DatePicker
                      :disabled="!isEditable"
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
                      :disabled="!isEditable"
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
                <!-- Additional Notes -->
                <h5 class="font-semibold mt-6">
                  {{ $t("case_history.fields.additional_notes") }}
                </h5>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <TextArea
                      :disabled="!isEditable"
                      fluid
                      autoResize
                      rows="4"
                      id="additional_notes"
                      v-model="formData.additional_notes"
                      :invalid="invalid.vaccine.additional_notes"
                    />
                    <label for="additional_notes"
                      >{{ $t("case_history.fields.additional_notes") }}
                      <span class="text-red-600">*</span></label
                    >
                  </FloatLabel>
                </div>
              </div>
              <!-- </div> -->
            </div>
            <!-- </div> -->
            <div class="flex pt-6 justify-between">
              <Button
                :label="$t('case_history.actions.back')"
                severity="secondary"
                :icon="isRtl ? 'fa-solid fa-arrow-right ' : 'fa-solid fa-arrow-left'"
                :iconPos="!isRtl ? 'left' : 'right'"
                @click="
                  () => {
                    if (validateStep(11)) activateCallback('10');
                  }
                "
              />
              <Button
                :label="$t('case_history.actions.submit')"
                @click="submitForm"
                v-if="isEditable"
              />
              <!-- <Button
                  :label="$t('case_history.actions.next')"
                  :icon="isRtl ? 'fa-solid fa-arrow-left' : 'fa-solid fa-arrow-right'"
                  :iconPos="!isRtl ? 'right' : 'left'"
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
import { ref, onMounted, nextTick, computed } from "vue";
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
import ToggleSwitch from "primevue/toggleswitch";
import Tag from "primevue/tag";
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
const isRtl = computed(() => ["ar", "he", "fa"].includes(locale.value));

const isEditable = ref(false);
const activeStep = ref("1");
const formData = ref(
  /*{
    symptom_description: "No signs of pregnancy 6 weeks post-mating",
    start_date: "2025-03-10",
    symptom_progression: "constant",
    medication_given: false,
    medication_name: null,
    medication_dosage: null,
    prescribed_by: null,
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
    itching_location: null,
    itching_description: null,
    skin_condition_description: "Normal",
    diet_type: "canned",
    diet_details: "Premium grain-free poultry",
    number_of_meals: 3,
    meal_quantity: "200g",
    appetite: "good",
    recent_diet_change: false,
    diet_change_type: null,
    water_intake: "normal",
    vomiting: false,
    vomit_color: null,
    vomit_contents: null,
    vomit_smell: null,
    vomiting_frequency: 0,
    vomiting_related_to_food: false,
    vomiting_related_to_diarrhea: false,
    diarrhea_started_first: false,
    stool_consistency: "normal",
    stool_color: "brown",
    stool_frequency: 1,
    abnormal_stool_contents: null,
    excessive_licking_of_anus: false,
    neurological_signs: "other",
    neurological_signs_frequency: "once this month",
    associated_symptoms: "Mild disorientation",
    sudden_onset: true,
    related_to_eating_or_activity: "Signs appear after high activity",
    additional_details: "Owner reports successful mating observed 6 weeks ago.",
    cough: false,
    cough_start_date: null,
    cough_frequency: null,
    cough_type: null,
    breathing_difficulty: false,
    sneezing: false,
    urination_frequency: 4,
    frequent_litter_box_visits: false,
    urine_volume: "small",
    urine_color: "pale yellow",
    urination_type: "continuous",
    blood_in_urine: false,
    blood_location: null,
    abnormal_urinary_discharge: null,
    genital_discharge: "None",
    excessive_licking_of_genital_area: false,
    vaccine_name: "FVRCP",
    vaccine_date: "2025-01-15",
    next_due_date: "2026-01-15",
    administered_by: "Dr. Lee",
    medication_type: "other",
    dosage: "10mg",
    frequency: "Once daily",
    medication_start_date: "2025-02-01",
    medication_end_date: "2025-02-10",
    treatment_name: "Advocate Spot-On",
    treatment_type: "flea",
    treatment_dosage: "1 pipette",
    administration_date: "2025-03-01",
    treatment_next_due_date: "2025-04-01",
    treatment_administered_by: "Nurse Sara",
    additional_notes:
      "Recommend ultrasound to confirm pregnancy status. Rule out pseudopregnancy.",
    limping: true,
    pain: true,
    pain_description: "Mild pain in hind left leg when walking",
    swelling: false,
    swelling_location: null,
    visible_deformity: false,
    deformity_description: null,
    affected_limbs: ["HL"],
    weight_bearing: "partial",
    symptom_start: "2025-03-08 after playtime",
    progression: "static",
    trauma_history: true,
    trauma_details: "Jumped off high surface 5 days ago",
    exercise_induced: true,
    worse_after_rest: false,
    difficulty_jumping: true,
    difficulty_stairs: false,
    difficulty_rising: false,
    exercise_tolerance: "reduced",
    pain_meds_given: true,
    pain_meds_details: "Meloxicam oral, 0.05mg/kg SID for 5 days",
    other_treatments: "Cold compress on affected limb",
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
    // Musculoskeletal Fields
    limping: false,
    pain: false,
    pain_description: "",
    swelling: false,
    swelling_location: "",
    visible_deformity: false,
    deformity_description: "",
    affected_limbs_FL: false,
    affected_limbs_FR: false,
    affected_limbs_HL: false,
    affected_limbs_HR: false,
    weight_bearing: null,
    symptom_start: "",
    progression: null,
    trauma_history: false,
    trauma_details: "",
    exercise_induced: false,
    worse_after_rest: false,
    difficulty_jumping: false,
    difficulty_stairs: false,
    difficulty_rising: false,
    exercise_tolerance: null,
    pain_meds_given: false,
    pain_meds_details: "",
  }
);
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
  {
    label: t("case_history.options.symptom_progression.comes_n_goes"),
    en_label: "Intermittent",
    value: "comes_n_goes",
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
const invalid = ref({
  symptoms: {
    // symptom_description: false,
    // symptom_progression: false,
    // start_date: false
  },
  general_health: {
    // activity_level: false,
    // care_location: false,
    // vaccination_status: false
  },
  diet: {
    // appetite: false,
    // diet_type: false
  },
  vaccine: {
    // vaccine_date: false,
    // vaccine_name: false
    // additional_notes: false
  },
});
/* const validateStep = (step) => {
  let isValid = true;

  switch (step) {
    case 1: // Symptoms step
      invalid.value.symptoms = {
        symptom_description: !formData.value.symptom_description?.trim(),
        start_date: !formData.value.start_date,
        symptom_progression: !formData.value.symptom_progression,
      };
      isValid = !Object.values(invalid.value.symptoms).some(Boolean);
      break;

    case 2: // General health step
      invalid.value.general_health = {
        activity_level: !formData.value.activity_level,
        care_location: !formData.value.care_location,
        vaccination_status: !formData.value.vaccination_status,
      };
      isValid = !Object.values(invalid.value.general_health).some(Boolean);
      break;

    case 5: // Diet step
      invalid.value.diet = {
        appetite: !formData.value.appetite,
        diet_type: !formData.value.diet_type,
      };
      isValid = !Object.values(invalid.value.diet).some(Boolean);
      break;

    case 11: // Diet step
      invalid.value.vaccine = {
        vaccine_date: !formData.value.vaccine_date,
        vaccine_name: !formData.value.vaccine_name,
        additional_notes: !formData.value.additional_notes,
      };
      isValid = !Object.values(invalid.value.vaccine).some(Boolean);
      break;

    default:
      isValid = true;
  }

  // console.log(`Step ${step} validation:`, { isValid, invalid: invalid.value });
  return isValid;
};
 */

const validateStep = (step) => {
  let isValid = true;

  switch (step) {
    case 1: // Symptoms step
      invalid.value.symptoms = {
        symptom_description: !formData.value.symptom_description?.trim(),
        start_date: !formData.value.start_date,
        symptom_progression: !formData.value.symptom_progression,
      };
      isValid = !Object.values(invalid.value.symptoms).some(Boolean);
      invalid.value.symptoms.step = Object.values(invalid.value.symptoms).some(Boolean);
      break;

    case 2: // General health step
      invalid.value.general_health = {
        activity_level: !formData.value.activity_level,
        care_location: !formData.value.care_location,
        vaccination_status: !formData.value.vaccination_status,
      };
      isValid = !Object.values(invalid.value.general_health).some(Boolean);
      invalid.value.general_health.step = Object.values(
        invalid.value.general_health
      ).some(Boolean);
      break;

    case 5: // Diet step
      invalid.value.diet = {
        appetite: !formData.value.appetite,
        diet_type: !formData.value.diet_type,
      };
      isValid = !Object.values(invalid.value.diet).some(Boolean);
      invalid.value.diet.step = Object.values(invalid.value.diet).some(Boolean);
      break;

    case 11: // Diet step
      invalid.value.vaccine = {
        vaccine_date: !formData.value.vaccine_date,
        vaccine_name: !formData.value.vaccine_name,
        additional_notes: !formData.value.additional_notes,
      };
      isValid = !Object.values(invalid.value.vaccine).some(Boolean);
      invalid.value.vaccine.step = Object.values(invalid.value.vaccine).some(Boolean);
      break;

    default:
      isValid = true;
  }

  // console.log(`Step ${step} validation:`, { isValid, invalid: invalid.value });
  return isValid;
};
const fetchHistory = async (medicalRecordId) => {
  try {
    const response = await axiosInstance.get(
      `/medical-records/${props.medical_record_id}/history`
    );
    const history = response.data;

    if (history.current_symptom.length > 0) {
      hasCaseHistory.value = true;
    }

    if (history.current_symptom?.length > 0) {
      const current = history.current_symptom[0];
      formData.value.symptom_description = current.symptom_description;
      formData.value.start_date = formatDate(current.start_date);
      formData.value.symptom_progression = current.symptom_progression;
      formData.value.medication_given = current.medication_given;
      formData.value.medication_name = current.medication_name;
      formData.value.medication_dosage = current.medication_dosage;
      formData.value.prescribed_by = current.prescribed_by;
    }

    if (history.general_health?.length > 0) {
      const health = history.general_health[0];
      formData.value.activity_level = health.activity_level;
      formData.value.vaccination_status = health.vaccination_status;
      formData.value.care_location = health.care_location;
      formData.value.other_animals_in_household = health.other_animals_in_household;
      formData.value.number_of_other_animals = health.number_of_other_animals;
      formData.value.types_of_other_animals = health.types_of_other_animals;
      formData.value.previous_diseases_in_other_animals =
        health.previous_diseases_in_other_animals;
    }

    if (history.reproductive_history?.length > 0) {
      const reproductive = history.reproductive_history[0];
      formData.value.last_reproductive_cycle_date = formatDate(
        reproductive.last_reproductive_cycle_date
      );
      formData.value.cycle_length = reproductive.cycle_length;
      formData.value.notable_signs = reproductive.notable_signs;
      formData.value.other_discharges = reproductive.other_discharges;
    }

    if (history.itching_skin_condition?.length > 0) {
      const skin = history.itching_skin_condition[0];
      formData.value.itching_present = skin.itching_present;
      formData.value.itching_location = skin.itching_location;
      formData.value.itching_description = skin.itching_description;
      formData.value.skin_condition_description = skin.skin_condition_description;
    }

    if (history.diet_water_intake?.length > 0) {
      const diet = history.diet_water_intake[0];
      formData.value.diet_type = diet.diet_type;
      formData.value.diet_details = diet.diet_details;
      formData.value.number_of_meals = diet.number_of_meals;
      formData.value.meal_quantity = diet.meal_quantity;
      formData.value.appetite = diet.appetite;
      formData.value.recent_diet_change = diet.recent_diet_change;
      formData.value.diet_change_type = diet.diet_change_type ?? "";
      formData.value.water_intake = diet.water_intake;
    }

    if (history.gastrointestinal_symptom?.length > 0) {
      const gastro = history.gastrointestinal_symptom[0];
      formData.value.vomiting = gastro.vomiting;
      formData.value.vomit_color = gastro.vomit_color;
      formData.value.vomit_contents = gastro.vomit_contents;
      formData.value.vomit_smell = gastro.vomit_smell;
      formData.value.vomiting_frequency = gastro.vomiting_frequency;
      formData.value.vomiting_related_to_food = gastro.vomiting_related_to_food;
      formData.value.vomiting_related_to_diarrhea = gastro.vomiting_related_to_diarrhea;
      formData.value.diarrhea_started_first = gastro.diarrhea_started_first;
      formData.value.stool_consistency = gastro.stool_consistency ?? "";
      formData.value.stool_color = gastro.stool_color;
      formData.value.stool_frequency = gastro.stool_frequency;
      formData.value.abnormal_stool_contents = gastro.abnormal_stool_contents;
      formData.value.excessive_licking_of_anus = gastro.excessive_licking_of_anus;
    }

    if (history.neurological_symptom?.length > 0) {
      const neuro = history.neurological_symptom[0];
      formData.value.neurological_signs = neuro.neurological_signs;
      formData.value.neurological_signs_frequency = neuro.neurological_signs_frequency;
      formData.value.associated_symptoms = neuro.associated_symptoms;
      formData.value.sudden_onset = neuro.sudden_onset;
      formData.value.related_to_eating_or_activity = neuro.related_to_eating_or_activity;
      formData.value.additional_details = neuro.additional_details;
    }

    if (history.respiratory_symptom?.length > 0) {
      const resp = history.respiratory_symptom[0];
      formData.value.cough = resp.cough;
      formData.value.cough_start_date = formatDate(resp.cough_start_date);
      formData.value.cough_frequency = resp.cough_frequency;
      formData.value.cough_type = resp.cough_type;
      formData.value.breathing_difficulty = resp.breathing_difficulty;
      formData.value.sneezing = resp.sneezing;
    }

    if (history.urinary_symptom?.length > 0) {
      const urine = history.urinary_symptom[0];
      formData.value.urination_frequency = urine.urination_frequency;
      formData.value.frequent_litter_box_visits = urine.frequent_litter_box_visits;
      formData.value.urine_volume = urine.urine_volume;
      formData.value.urine_color = urine.urine_color;
      formData.value.urination_type = urine.urination_type;
      formData.value.blood_in_urine = urine.blood_in_urine;
      formData.value.blood_location = urine.blood_location;
      formData.value.abnormal_urinary_discharge = urine.abnormal_urinary_discharge;
      formData.value.genital_discharge = urine.genital_discharge;
      formData.value.excessive_licking_of_genital_area =
        urine.excessive_licking_of_genital_area;
    }

    if (history.vaccination_history?.length > 0) {
      const vax = history.vaccination_history[0];
      formData.value.vaccine_name = vax.vaccine_name;
      formData.value.vaccine_date = formatDate(vax.vaccine_date);
      formData.value.next_due_date = formatDate(vax.next_due_date);
      formData.value.administered_by = vax.administered_by;
    }

    if (history.medication_history?.length > 0) {
      const med = history.medication_history[0];
      formData.value.medication_name = med.medication_name;
      formData.value.medication_type = med.medication_type;
      formData.value.dosage = med.dosage;
      formData.value.frequency = med.frequency;
      formData.value.medication_start_date = formatDate(med.start_date);
      formData.value.medication_end_date = formatDate(med.end_date);
      formData.value.prescribed_by = med.prescribed_by;
    }

    if (history.antiparasitic_treatment?.length > 0) {
      const parasite = history.antiparasitic_treatment[0];
      formData.value.treatment_name = parasite.treatment_name;
      formData.value.treatment_type = parasite.treatment_type;
      formData.value.treatment_dosage = parasite.dosage;
      formData.value.administration_date = formatDate(parasite.administration_date);
      formData.value.treatment_next_due_date = formatDate(parasite.next_due_date);
      formData.value.treatment_administered_by = parasite.administered_by;
    }

    if (history.additional_note?.length > 0) {
      formData.value.additional_notes = history.additional_note[0].notes;
    }

    if (history.mascular_sekeleton?.length > 0) {
      const musc = history.mascular_sekeleton[0];
      formData.value.limping = musc.limping;
      formData.value.pain = musc.pain;
      formData.value.pain_description = musc.pain_description;
      formData.value.swelling = musc.swelling;
      formData.value.swelling_location = musc.swelling_location;
      formData.value.visible_deformity = musc.visible_deformity;
      formData.value.deformity_description = musc.deformity_description;
      formData.value.symptom_start = musc.symptom_start;
      formData.value.progression = musc.progression;
      formData.value.trauma_history = musc.trauma_history;
      formData.value.trauma_details = musc.trauma_details;
      formData.value.exercise_induced = musc.exercise_induced;
      formData.value.worse_after_rest = musc.worse_after_rest;
      formData.value.difficulty_jumping = musc.difficulty_jumping;
      formData.value.difficulty_stairs = musc.difficulty_stairs;
      formData.value.difficulty_rising = musc.difficulty_rising;
      formData.value.exercise_tolerance = musc.exercise_tolerance;
      formData.value.pain_meds_given = musc.pain_meds_given;
      formData.value.pain_meds_details = musc.pain_meds_details;
      formData.value.other_treatments = musc.other_treatments;
      formData.value.weight_bearing = musc.weight_bearing;

      let affectedLimbs = [];

      if (Array.isArray(musc.affected_limbs)) {
        affectedLimbs = musc.affected_limbs;
      } else if (typeof musc.affected_limbs === "string") {
        affectedLimbs = musc.affected_limbs.split(",");
      }
      // console.log(affectedLimbs);
      // console.log("FH", affectedLimbs.includes("FL"));
      // console.log("FH", affectedLimbs.includes("FR"));
      // console.log("FH", affectedLimbs.includes("HL"));
      // console.log("FH", affectedLimbs.includes("FL"));
      formData.value.affected_limbs_FL = affectedLimbs.includes("FL");
      formData.value.affected_limbs_FR = affectedLimbs.includes("FR");
      formData.value.affected_limbs_HL = affectedLimbs.includes("HL");
      formData.value.affected_limbs_HR = affectedLimbs.includes("HR");
    }

    // console.log("Fetched history and updated formData:", formData.value);
  } catch (error) {
    console.error("Error fetching history:", error);
  }
};

const submitForm = async () => {
  const stepsToValidate = [1, 2, 5, 11];

  let hasErrors = false;

  stepsToValidate.forEach((step) => {
    if (!validateStep(step)) {
      hasErrors = true;
    }
  });

  if (hasErrors) {
    toast.add({
      severity: "error",
      summary: "Validation Error",
      detail: "Please complete all required fields before submitting",
      life: 5000,
    });
    return; // Stop execution if any step is invalid
  }

  try {
    // Extract values from dropdown/select fields
    const safeValue = (val) => (val !== "" && val !== undefined ? val : null);

    formData.value.symptom_progression = safeValue(formData.value.symptom_progression);
    formData.value.activity_level = safeValue(formData.value.activity_level);
    formData.value.vaccination_status = safeValue(formData.value.vaccination_status);
    formData.value.care_location = safeValue(formData.value.care_location);
    formData.value.diet_type = safeValue(formData.value.diet_type);
    formData.value.appetite = safeValue(formData.value.appetite);
    formData.value.urination_type = safeValue(formData.value.urination_type);
    formData.value.cough_type = safeValue(formData.value.cough_type);
    formData.value.stool_consistency = safeValue(formData.value.stool_consistency);
    formData.value.urine_volume = safeValue(formData.value.urine_volume);
    formData.value.blood_location = safeValue(formData.value.blood_location);
    formData.value.neurological_signs = safeValue(formData.value.neurological_signs);
    formData.value.diet_change_type = safeValue(formData.value.diet_change_type);
    formData.value.medication_type = safeValue(formData.value.medication_type);
    formData.value.treatment_type = safeValue(formData.value.treatment_type);

    // Convert numeric fields
    formData.value.number_of_other_animals =
      parseInt(formData.value.number_of_other_animals) || null;
    formData.value.cycle_length = parseInt(formData.value.cycle_length) || null;
    formData.value.number_of_meals = parseInt(formData.value.number_of_meals) || null;
    formData.value.stool_frequency = parseInt(formData.value.stool_frequency) || null;
    formData.value.vomiting_frequency =
      parseInt(formData.value.vomiting_frequency) || null;
    formData.value.urination_frequency =
      parseInt(formData.value.urination_frequency) || null;

    // Nullables
    const nullableFields = [
      "previous_diseases_in_other_animals",
      "other_discharges",
      "itching_location",
      "itching_description",
      "skin_condition_description",
      "diet_details",
      "meal_quantity",
      "water_intake",
      "vomit_color",
      "vomit_contents",
      "vomit_smell",
      "abnormal_stool_contents",
      "neurological_signs_frequency",
      "associated_symptoms",
      "related_to_eating_or_activity",
      "additional_details",
      "cough_frequency",
      "urine_color",
      "abnormal_urinary_discharge",
      "genital_discharge",
      "pain_description",
      "swelling_location",
      "deformity_description",
      "trauma_details",
      "pain_meds_details",
      "other_treatments",
      "weight_bearing",
      "progression",
      "exercise_tolerance",
      "symptom_start",
    ];

    nullableFields.forEach((key) => {
      formData.value[key] = formData.value[key] || null;
    });

    // Format date fields
    const dateFields = [
      "cough_start_date",
      "vaccine_date",
      "next_due_date",
      "medication_start_date",
      "medication_end_date",
      "administration_date",
      "treatment_next_due_date",
      "last_reproductive_cycle_date",
      "start_date",
    ];

    dateFields.forEach((field) => {
      formData.value[field] = formatDate(formData.value[field]);
    });

    // Ensure boolean values
    const booleanFields = [
      "medication_given",
      "other_animals_in_household",
      "itching_present",
      "recent_diet_change",
      "vomiting",
      "vomiting_related_to_food",
      "vomiting_related_to_diarrhea",
      "diarrhea_started_first",
      "excessive_licking_of_anus",
      "sudden_onset",
      "cough",
      "breathing_difficulty",
      "sneezing",
      "frequent_litter_box_visits",
      "blood_in_urine",
      "excessive_licking_of_genital_area",
      "limping",
      "pain",
      "swelling",
      "visible_deformity",
      "trauma_history",
      "exercise_induced",
      "worse_after_rest",
      "difficulty_jumping",
      "difficulty_stairs",
      "difficulty_rising",
      "pain_meds_given",
      "affected_limbs_FL",
      "affected_limbs_FR",
      "affected_limbs_HL",
      "affected_limbs_HR",
    ];

    booleanFields.forEach((field) => {
      formData.value[field] = !!formData.value[field];
    });
    const payload = { ...formData.value };

    // Convert affected limbs booleans to array
    const limbs = [];
    if (payload.affected_limbs_FL) limbs.push("FL");
    if (payload.affected_limbs_FR) limbs.push("FR");
    if (payload.affected_limbs_HL) limbs.push("HL");
    if (payload.affected_limbs_HR) limbs.push("HR");
    payload.affected_limbs = limbs.length ? limbs : null;

    // Now explicitly remove the extra fields from the payload
    delete payload.affected_limbs_FL;
    delete payload.affected_limbs_FR;
    delete payload.affected_limbs_HL;
    delete payload.affected_limbs_HR;

    // console.log("Final payload:", JSON.stringify(payload, null, 2));
    // Submit to backend
    const response = await axiosInstance.put(
      `/medical-records/history/${props.medical_record_id}`,
      // formData.value
      payload
    );

    // console.log("CaseHistoryUpdated", response.data);
    emit("CaseHistoryUpdated", response.data);

    eventBus.emit("show-toast", {
      severity: "success",
      summary: t("case_history.title"),
      detail: t("case_history.messages.success"),
      life: 5000,
    });
  } catch (error) {
    console.error("Error submitting form:", error);
  }
};
function setActivePanel(panel) {
  // console.log("Panel" + panel);
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
div[data-p-invalid="true"] > button > .p-step-number {
  background: red !important;
  color: white !important;
}
</style>
