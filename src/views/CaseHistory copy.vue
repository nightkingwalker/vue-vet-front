<template>
  <div class="w-full">
    <fieldset
      class="p-fieldset p-component w-4/5 flex flex-wrap mx-auto gap-2 items-start border rounded-lg p-4"
    >
      <legend>Case History Details</legend>
      <div v-if="!hasCaseHistory">
        No Case History Added Yet.
        <Button
          label="Add Case History"
          icon="pi pi-plus"
          @click="showAddCaseHistoryModal(props.medical_record_id)"
          v-tooltip.bottom="`Add Case History`"
          class="p-button p-component !text-xs !h-8 ml-2"
        />
      </div>
      <Stepper :value="activeStep" class="w-full" v-else>
        <!-- Step List -->
        <StepList class="flex flex-wrap items-start w-full mx-auto">
          <Step value="1">Current Symptoms</Step>
          <Step value="2">General Health</Step>
          <Step value="3">Reproductive History</Step>
          <Step value="4">Itching & Skin</Step>
          <Step value="5">Diet & Water</Step>
          <Step value="6">Gastrointestinal</Step>
          <Step value="7">Neurological</Step>
          <Step value="8">Respiratory</Step>
          <Step value="9">Urinary</Step>
          <!-- <Step value="10">Review & Submit</Step> -->
        </StepList>

        <!-- Step Panels -->
        <StepPanels>
          <!-- Step 1: Current Symptoms -->
          <StepPanel v-slot="{ activateCallback }" value="1">
            <div class="flex flex-col gap-4">
              <h4 class="border-b-4 rounded border-b-violet-800 w-fit font-bold">
                Current Symptoms
              </h4>
            </div>
            <div class="flex flex-wrap gap-8">
              <div class="w-[48%]">
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <TextArea
                      disabled
                      fluid
                      autoResize
                      rows="4"
                      id="symptom_description"
                      v-model="formData.symptom_description"
                    />
                    <label for="symptom_description">Symptom Description</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <DatePicker
                      disabled
                      showIcon
                      id="start_date"
                      v-model="formData.start_date"
                      hourFormat="24"
                      fluid
                    />
                    <label for="start_date">Start Date</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <Select
                      disabled
                      fluid
                      optionLabel="label"
                      optionValue="value"
                      id="symptom_progression"
                      v-model="formData.symptom_progression"
                      :options="symptomProgressionOptions"
                    />
                    <label for="symptom_progression">Symptom Progression</label>
                  </FloatLabel>
                </div>
              </div>
              <div class="w-[48%]">
                <div class="field mt-6 w-2/3">
                  <!-- <FloatLabel> -->
                  <Checkbox
                    disabled
                    id="medication_given"
                    v-model="formData.medication_given"
                    binary
                    class="mx-2"
                  />
                  <label for="medication_given">Medication Given</label>
                  <!-- </FloatLabel> -->
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      disabled
                      fluid
                      id="medication_name"
                      v-model="formData.medication_name"
                    />
                    <label for="medication_name">Medication Name</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      disabled
                      fluid
                      id="medication_dosage"
                      v-model="formData.medication_dosage"
                    />
                    <label for="medication_dosage">Medication Dosage</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      disabled
                      fluid
                      id="prescribed_by"
                      v-model="formData.prescribed_by"
                    />
                    <label for="prescribed_by">Prescribed By</label>
                  </FloatLabel>
                </div>
              </div>
            </div>
            <div class="flex pt-6 justify-end">
              <Button
                label="Next"
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
                General Health
              </h4>
            </div>
            <div class="flex flex-wrap gap-8">
              <div class="w-[48%]">
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <Select
                      disabled
                      fluid
                      optionLabel="label"
                      optionValue="value"
                      id="activity_level"
                      v-model="formData.activity_level"
                      :options="activityLevelOptions"
                    />
                    <label for="activity_level">Activity Level</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <Select
                      disabled
                      fluid
                      optionLabel="label"
                      optionValue="value"
                      id="vaccination_status"
                      v-model="formData.vaccination_status"
                      :options="vaccinationStatusOptions"
                    />
                    <label for="vaccination_status">Vaccination Status</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <Select
                      disabled
                      fluid
                      optionLabel="label"
                      optionValue="value"
                      id="care_location"
                      v-model="formData.care_location"
                      :options="careLocationOptions"
                    />
                    <label for="care_location">Care Location</label>
                  </FloatLabel>
                </div>
              </div>
              <div class="w-[48%]">
                <div class="field mt-6 w-2/3">
                  <Checkbox
                    disabled
                    id="other_animals_in_household"
                    v-model="formData.other_animals_in_household"
                    binary
                    class="mx-2"
                  />
                  <label for="other_animals_in_household"
                    >Other Animals in Household</label
                  >
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      disabled
                      fluid
                      id="number_of_other_animals"
                      v-model="formData.number_of_other_animals"
                    />
                    <label for="number_of_other_animals">Number of Other Animals</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      disabled
                      fluid
                      id="types_of_other_animals"
                      v-model="formData.types_of_other_animals"
                    />
                    <label for="types_of_other_animals">Types of Other Animals</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      disabled
                      fluid
                      id="previous_diseases_in_other_animals"
                      v-model="formData.previous_diseases_in_other_animals"
                    />
                    <label for="previous_diseases_in_other_animals"
                      >Previous Diseases in Other Animals</label
                    >
                  </FloatLabel>
                </div>
              </div>
            </div>
            <div class="flex pt-6 justify-between">
              <Button
                label="Back"
                severity="secondary"
                icon="pi pi-arrow-left"
                @click="activateCallback('1')"
              />
              <Button
                label="Next"
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
                Reproductive History
              </h4>
            </div>
            <div class="field mt-6 w-[48%]">
              <FloatLabel>
                <DatePicker
                  disabled
                  showIcon
                  id="last_reproductive_cycle_date"
                  v-model="formData.last_reproductive_cycle_date"
                />
                <label for="last_reproductive_cycle_date"
                  >Last Reproductive Cycle Date</label
                >
              </FloatLabel>
            </div>
            <div class="field mt-6 w-[48%]">
              <FloatLabel>
                <InputText
                  disabled
                  fluid
                  id="cycle_length"
                  v-model="formData.cycle_length"
                />
                <label for="cycle_length">Cycle Length / Days</label>
              </FloatLabel>
            </div>
            <div class="field mt-6 w-[48%]">
              <FloatLabel>
                <InputText
                  disabled
                  fluid
                  id="notable_signs"
                  v-model="formData.notable_signs"
                />
                <label for="notable_signs">Notable Signs</label>
              </FloatLabel>
            </div>
            <div class="field mt-6 w-[48%]">
              <FloatLabel>
                <InputText
                  disabled
                  fluid
                  id="other_discharges"
                  v-model="formData.other_discharges"
                />
                <label for="other_discharges">Other Discharges</label>
              </FloatLabel>
            </div>
            <div class="flex pt-6 justify-between">
              <Button
                label="Back"
                severity="secondary"
                icon="pi pi-arrow-left"
                @click="activateCallback('2')"
              />
              <Button
                label="Next"
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
                Itching and Skin Condition
              </h4>
            </div>
            <div class="field mt-6 w-[48%]">
              <!-- <FloatLabel> -->
              <Checkbox
                disabled
                id="itching_present"
                class="mx-2"
                v-model="formData.itching_present"
                binary
              />
              <label for="itching_present">Itching Present</label>
              <!-- </FloatLabel> -->
            </div>
            <div class="field mt-6 w-[48%]">
              <FloatLabel>
                <InputText
                  disabled
                  fluid
                  id="itching_location"
                  v-model="formData.itching_location"
                />
                <label for="itching_location">Itching Location</label>
              </FloatLabel>
            </div>
            <div class="field mt-6 w-[48%]">
              <FloatLabel>
                <TextArea
                  disabled
                  fluid
                  autoResize
                  rows="4"
                  id="itching_description"
                  v-model="formData.itching_description"
                />
                <label for="itching_description">Itching Description</label>
              </FloatLabel>
            </div>
            <div class="field mt-6 w-[48%]">
              <FloatLabel>
                <TextArea
                  disabled
                  fluid
                  autoResize
                  rows="4"
                  id="skin_condition_description"
                  v-model="formData.skin_condition_description"
                />
                <label for="skin_condition_description">Skin Condition Description</label>
              </FloatLabel>
            </div>
            <div class="flex pt-6 justify-between">
              <Button
                label="Back"
                severity="secondary"
                icon="pi pi-arrow-left"
                @click="activateCallback('3')"
              />
              <Button
                label="Next"
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
                Diet & Water Intake
              </h4>
            </div>
            <div class="flex flex-wrap gap-8">
              <div class="w-[48%]">
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <Select
                      disabled
                      fluid
                      optionLabel="label"
                      optionValue="value"
                      id="diet_type"
                      v-model="formData.diet_type"
                      :options="dietTypeOptions"
                    />
                    <label for="diet_type">Diet Type</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      disabled
                      fluid
                      id="diet_details"
                      v-model="formData.diet_details"
                    />
                    <label for="diet_details">Diet Details</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      disabled
                      fluid
                      id="number_of_meals"
                      v-model="formData.number_of_meals"
                    />
                    <label for="number_of_meals">Number of Meals</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      disabled
                      fluid
                      id="meal_quantity"
                      v-model="formData.meal_quantity"
                    />
                    <label for="meal_quantity">Meal Quantity</label>
                  </FloatLabel>
                </div>
              </div>
              <div class="w-[48%]">
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <Select
                      disabled
                      fluid
                      optionLabel="label"
                      optionValue="value"
                      id="appetite"
                      v-model="formData.appetite"
                      :options="appetiteOptions"
                    />
                    <label for="appetite">Appetite</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <!-- <FloatLabel> -->
                  <Checkbox
                    disabled
                    class="mx-2"
                    id="recent_diet_change"
                    v-model="formData.recent_diet_change"
                    binary
                  />
                  <label for="recent_diet_change">Recent Diet Change</label>
                  <!-- </FloatLabel> -->
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <Select
                      disabled
                      fluid
                      optionLabel="label"
                      optionValue="value"
                      id="diet_change_type"
                      v-model="formData.diet_change_type"
                      :options="dietChangeTypeOptions"
                    />
                    <label for="diet_change_type">Diet Change Type</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      disabled
                      fluid
                      id="water_intake"
                      v-model="formData.water_intake"
                    />
                    <label for="water_intake">Water Intake</label>
                  </FloatLabel>
                </div>
              </div>
            </div>
            <div class="flex pt-6 justify-between">
              <Button
                label="Back"
                severity="secondary"
                icon="pi pi-arrow-left"
                @click="activateCallback('4')"
              />
              <Button
                label="Next"
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
                Gastrointestinal Symptoms
              </h4>
            </div>
            <div class="flex flex-wrap gap-8">
              <div class="w-[48%]">
                <div class="field mt-6 w-2/3">
                  <Checkbox
                    disabled
                    class="mx-2"
                    id="vomiting"
                    v-model="formData.vomiting"
                    binary
                  />
                  <label for="vomiting">Vomiting</label>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      disabled
                      fluid
                      id="vomit_color"
                      v-model="formData.vomit_color"
                    />
                    <label for="vomit_color">Vomit Color</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      disabled
                      fluid
                      id="vomit_contents"
                      v-model="formData.vomit_contents"
                    />
                    <label for="vomit_contents">Vomit Contents</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      disabled
                      fluid
                      id="vomit_smell"
                      v-model="formData.vomit_smell"
                    />
                    <label for="vomit_smell">Vomit Smell</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      disabled
                      fluid
                      id="vomiting_frequency"
                      v-model="formData.vomiting_frequency"
                    />
                    <label for="vomiting_frequency">Vomiting Frequency</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <Checkbox
                    disabled
                    class="mx-2"
                    id="vomiting_related_to_food"
                    v-model="formData.vomiting_related_to_food"
                    binary
                  />
                  <label for="vomiting_related_to_food">Vomiting Related to Food</label>
                </div>
              </div>
              <div class="w-[48%]">
                <div class="field mt-6 w-2/3">
                  <Checkbox
                    disabled
                    class="mx-2"
                    id="vomiting_related_to_diarrhea"
                    v-model="formData.vomiting_related_to_diarrhea"
                    binary
                  />
                  <label for="vomiting_related_to_diarrhea"
                    >Vomiting Related to Diarrhea</label
                  >
                </div>
                <div class="field mt-6 w-2/3">
                  <Checkbox
                    disabled
                    class="mx-2"
                    id="diarrhea_started_first"
                    v-model="formData.diarrhea_started_first"
                    binary
                  />
                  <label for="diarrhea_started_first">Diarrhea Started First</label>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <Select
                      disabled
                      fluid
                      optionLabel="label"
                      optionValue="value"
                      id="diet_change_type"
                      v-model="formData.stool_consistency"
                      :options="stoolConsistencyOptions"
                    />
                    <label for="stool_consistency">Stool Consistency</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      disabled
                      fluid
                      id="stool_color"
                      v-model="formData.stool_color"
                    />
                    <label for="stool_color">Stool Color</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      disabled
                      fluid
                      id="stool_frequency"
                      v-model="formData.stool_frequency"
                    />
                    <label for="stool_frequency">Stool Frequency</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      disabled
                      fluid
                      id="abnormal_stool_contents"
                      v-model="formData.abnormal_stool_contents"
                    />
                    <label for="abnormal_stool_contents">Abnormal Stool Contents</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <!-- <FloatLabel> -->
                  <Checkbox
                    disabled
                    class="mx-2"
                    id="excessive_licking_of_anus"
                    v-model="formData.excessive_licking_of_anus"
                    binary
                  />
                  <label for="excessive_licking_of_anus">Excessive Licking of Anus</label>
                  <!-- </FloatLabel> -->
                </div>
              </div>
            </div>
            <div class="flex pt-6 justify-between">
              <Button
                label="Back"
                severity="secondary"
                icon="pi pi-arrow-left"
                @click="activateCallback('5')"
              />
              <Button
                label="Next"
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
                Neurological Symptoms
              </h4>
            </div>
            <div class="flex flex-wrap gap-8">
              <div class="w-[48%]">
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      disabled
                      fluid
                      id="neurological_signs"
                      v-model="formData.neurological_signs"
                    />
                    <label for="neurological_signs">Neurological Signs</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      disabled
                      fluid
                      id="neurological_signs_frequency"
                      v-model="formData.neurological_signs_frequency"
                    />
                    <label for="neurological_signs_frequency">Frequency</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      disabled
                      fluid
                      id="associated_symptoms"
                      v-model="formData.associated_symptoms"
                    />
                    <label for="associated_symptoms">Associated Symptoms</label>
                  </FloatLabel>
                </div>
              </div>
              <div class="w-[48%]">
                <div class="field mt-6 w-2/3">
                  <!-- <FloatLabel> -->
                  <Checkbox
                    disabled
                    class="mx-2"
                    id="sudden_onset"
                    v-model="formData.sudden_onset"
                    binary
                  />
                  <label for="sudden_onset">Sudden Onset</label>
                  <!-- </FloatLabel> -->
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      disabled
                      fluid
                      id="related_to_eating_or_activity"
                      v-model="formData.related_to_eating_or_activity"
                    />
                    <label for="related_to_eating_or_activity"
                      >Related to Eating or Activity</label
                    >
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <TextArea
                      disabled
                      fluid
                      autoResize
                      rows="4"
                      id="additional_details"
                      v-model="formData.additional_details"
                    />
                    <label for="additional_details">Additional Details</label>
                  </FloatLabel>
                </div>
              </div>
            </div>
            <div class="flex pt-6 justify-between">
              <Button
                label="Back"
                severity="secondary"
                icon="pi pi-arrow-left"
                @click="activateCallback('6')"
              />
              <Button
                label="Next"
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
                Respiratory Symptoms
              </h4>
            </div>
            <div class="field mt-6 w-[48%]">
              <Checkbox
                disabled
                class="mx-2"
                id="cough"
                v-model="formData.cough"
                binary
              />
              <label for="cough">Cough</label>
            </div>
            <div class="field mt-6 w-[48%]">
              <FloatLabel>
                <DatePicker
                  disabled
                  showIcon
                  id="cough_start_date"
                  v-model="formData.cough_start_date"
                />
                <label for="cough_start_date">Cough Start Date</label>
              </FloatLabel>
            </div>
            <div class="field mt-6 w-[48%]">
              <FloatLabel>
                <InputText
                  disabled
                  fluid
                  id="cough_frequency"
                  v-model="formData.cough_frequency"
                />
                <label for="cough_frequency">Cough Frequency</label>
              </FloatLabel>
            </div>
            <div class="field mt-6 w-[48%]">
              <FloatLabel>
                <Select
                  disabled
                  fluid
                  optionLabel="label"
                  optionValue="value"
                  id="cough_type"
                  v-model="formData.cough_type"
                  :options="coughTypeOptions"
                />
                <label for="cough_type">Cough Type</label>
              </FloatLabel>
            </div>
            <div class="field mt-6 w-[48%]">
              <Checkbox
                disabled
                class="mx-2"
                id="breathing_difficulty"
                v-model="formData.breathing_difficulty"
                binary
              />
              <label for="breathing_difficulty">Breathing Difficulty</label>
            </div>
            <div class="field mt-6 w-[48%]">
              <Checkbox
                disabled
                class="mx-2"
                id="sneezing"
                v-model="formData.sneezing"
                binary
              />
              <label for="sneezing">Sneezing</label>
            </div>
            <div class="flex pt-6 justify-between">
              <Button
                label="Back"
                severity="secondary"
                icon="pi pi-arrow-left"
                @click="activateCallback('7')"
              />
              <Button
                label="Next"
                icon="pi pi-arrow-right"
                iconPos="right"
                @click="activateCallback('9')"
              />
            </div>
          </StepPanel>

          <!-- Step 9: Urinary -->
          <StepPanel v-slot="{ activateCallback }" value="9">
            <div class="flex flex-col gap-4">
              <h4 class="border-b-4 rounded border-b-violet-800 w-fit font-bold">
                Urinary Symptoms
              </h4>
            </div>
            <div class="flex flex-wrap gap-8">
              <div class="w-[48%]">
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      disabled
                      fluid
                      id="urination_frequency"
                      v-model="formData.urination_frequency"
                    />
                    <label for="urination_frequency">Urination Frequency</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      disabled
                      fluid
                      id="urine_volume"
                      v-model="formData.urine_volume"
                    />
                    <label for="urine_volume">Urine Volume</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      disabled
                      fluid
                      id="urine_color"
                      v-model="formData.urine_color"
                    />
                    <label for="urine_color">Urine Color</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <Select
                      disabled
                      fluid
                      optionLabel="label"
                      optionValue="value"
                      id="urination_type"
                      v-model="formData.urination_type"
                      :options="urinationTypeOptions"
                    />
                    <label for="urination_type">Urination Type</label>
                  </FloatLabel>
                </div>
              </div>
              <div class="w-[48%]">
                <div class="field mt-6 w-2/3">
                  <Checkbox
                    disabled
                    class="mx-2"
                    id="blood_in_urine"
                    v-model="formData.blood_in_urine"
                    binary
                  />
                  <label for="blood_in_urine">Blood in Urine</label>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <Select
                      disabled
                      fluid
                      optionLabel="label"
                      optionValue="value"
                      id="blood_location"
                      v-model="formData.blood_location"
                      :options="bloodLocationOptions"
                    />
                    <label for="blood_location">Blood Location</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      disabled
                      fluid
                      id="abnormal_urinary_discharge"
                      v-model="formData.abnormal_urinary_discharge"
                    />
                    <label for="abnormal_urinary_discharge"
                      >Abnormal Urinary Discharge</label
                    >
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      disabled
                      fluid
                      id="genital_discharge"
                      v-model="formData.genital_discharge"
                    />
                    <label for="genital_discharge">Genital Discharge</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <Checkbox
                    disabled
                    class="mx-2"
                    id="excessive_licking_of_genital_area"
                    v-model="formData.excessive_licking_of_genital_area"
                    binary
                  />
                  <label for="excessive_licking_of_genital_area"
                    >Excessive Licking of Genital Area</label
                  >
                </div>
              </div>
            </div>
            <div class="flex pt-6 justify-between">
              <Button
                label="Back"
                severity="secondary"
                icon="pi pi-arrow-left"
                @click="activateCallback('8')"
              />
              <Button
                label="Next"
                icon="pi pi-arrow-right"
                iconPos="right"
                @click="activateCallback('10')"
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
import { ref, onMounted } from "vue";
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
const activeStep = ref("1");
/*const formData = ref({
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
});
*/
const formData = ref({
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
  number_of_other_animals: 0,
  types_of_other_animals: "",
  previous_diseases_in_other_animals: "",
  last_reproductive_cycle_date: null,
  cycle_length: 0,
  notable_signs: "",
  other_discharges: "",
  itching_present: false,
  itching_location: "",
  itching_description: "",
  skin_condition_description: "",
  diet_type: "",
  diet_details: "",
  number_of_meals: 0,
  meal_quantity: "",
  appetite: "",
  recent_diet_change: false,
  diet_change_type: null,
  water_intake: "",
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
  neurological_signs: "",
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
});
const symptomProgressionOptions = [
  { label: "Increasing", value: "increasing" },
  { label: "Decreasing", value: "decreasing" },
  { label: "Constant", value: "constant" },
];
const stoolConsistencyOptions = [
  { label: "Normal", value: "normal" },
  { label: "Soft", value: "soft" },
  { label: "Watery", value: "watery" },
  { label: "Hard", value: "hard" },
];
const activityLevelOptions = [
  { label: "Active", value: "active" },
  { label: "Lethargic", value: "lethargic" },
  { label: "Sometimes Active", value: "sometimes_active" },
  { label: "Other", value: "other" },
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
const fetchHistory = async (medicalRecordId) => {
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
};
const submitForm = async () => {
  try {
    // Extract values from dropdown/select fields
    formData.value.symptom_progression =
      formData.value.symptom_progression?.value || null;
    formData.value.activity_level = formData.value.activity_level?.value || null;
    formData.value.vaccination_status = formData.value.vaccination_status?.value || null;
    formData.value.care_location = formData.value.care_location?.value || null;
    formData.value.diet_type = formData.value.diet_type?.value || null;
    formData.value.appetite = formData.value.appetite?.value || null;
    formData.value.urination_type = formData.value.urination_type?.value || null;
    formData.value.cough_type = formData.value.cough_type?.value || null;
    formData.value.stool_consistency = formData.value.stool_consistency?.value || null;
    formData.value.urine_volume = formData.value.urine_volume?.value || null;
    formData.value.blood_location = formData.value.blood_location?.value || null;
    formData.value.neurological_signs = formData.value.neurological_signs?.value || null;
    formData.value.diet_change_type = formData.value.diet_change_type?.value || null;

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
    // formData.value.diet_change_type = formData.value.diet_change_type || null;
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
    formData.value.cough_start_date = formData.value.cough_start_date || null;
    formData.value.cough_frequency = formData.value.cough_frequency || null;
    formData.value.urine_color = formData.value.urine_color || null;
    formData.value.abnormal_urinary_discharge =
      formData.value.abnormal_urinary_discharge || null;
    formData.value.genital_discharge = formData.value.genital_discharge || null;

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
      "/medical-records/history/31",
      formData.value
    );
    // console.log("Form submitted successfully:", response.data);
  } catch (error) {
    console.error("Error submitting form:", error);
  }
};
onMounted(() => {
  const medicalRecordId = 31; // Replace with the actual ID
  fetchHistory(medicalRecordId);
});
</script>
<style>
.p-step-active {
  color: navy !important;
}
:root {
  --color-violet-600: oklch(0.541 0.281 293.009);
  --p-inputtext-disabled-color: black !important;
}
.p-inputtext:disabled,
.p-checkbox-input:disabled,
.p-select-label,
.p-textarea:disabled,
.p-checkbox.p-disabled .p-checkbox-box .p-checkbox-icon {
  color: black !important;
}
.p-step-active .p-step-number {
  background: var(--p-primary-color) !important;

  color: var(--p-primary-contrast-color) !important;
}
</style>
