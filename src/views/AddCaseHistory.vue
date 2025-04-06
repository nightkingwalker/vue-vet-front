<template>
  <div class="w-full">
    <fieldset
      class="p-fieldset p-component w-4/5 flex flex-wrap mx-auto gap-2 items-start border rounded-lg p-4"
    >
      <legend>Case History Details</legend>
      <Stepper :value="activeStep" class="w-full">
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
          <Step value="10">Vaccination & Medication</Step>
          <Step value="11">Review & Submit</Step>
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
                      showButtonBar
                      dateFormat="yy-mm-dd"
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
                  showButtonBar
                  dateFormat="yy-mm-dd"
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
                <InputText fluid id="cycle_length" v-model="formData.cycle_length" />
                <label for="cycle_length">Cycle Length / Days</label>
              </FloatLabel>
            </div>
            <div class="field mt-6 w-[48%]">
              <FloatLabel>
                <InputText fluid id="notable_signs" v-model="formData.notable_signs" />
                <label for="notable_signs">Notable Signs</label>
              </FloatLabel>
            </div>
            <div class="field mt-6 w-[48%]">
              <FloatLabel>
                <InputText
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
                    <InputText fluid id="diet_details" v-model="formData.diet_details" />
                    <label for="diet_details">Diet Details</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
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
                    <InputText fluid id="water_intake" v-model="formData.water_intake" />
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
                    class="mx-2"
                    id="vomiting"
                    v-model="formData.vomiting"
                    binary
                  />
                  <label for="vomiting">Vomiting</label>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText fluid id="vomit_color" v-model="formData.vomit_color" />
                    <label for="vomit_color">Vomit Color</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="vomit_contents"
                      v-model="formData.vomit_contents"
                    />
                    <label for="vomit_contents">Vomit Contents</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText fluid id="vomit_smell" v-model="formData.vomit_smell" />
                    <label for="vomit_smell">Vomit Smell</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="vomiting_frequency"
                      v-model="formData.vomiting_frequency"
                    />
                    <label for="vomiting_frequency">Vomiting Frequency</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <Checkbox
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
                    <InputText fluid id="stool_color" v-model="formData.stool_color" />
                    <label for="stool_color">Stool Color</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
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
              <Checkbox class="mx-2" id="cough" v-model="formData.cough" binary />
              <label for="cough">Cough</label>
            </div>
            <div class="field mt-6 w-[48%]">
              <FloatLabel>
                <DatePicker
                  showButtonBar
                  dateFormat="yy-mm-dd"
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
                class="mx-2"
                id="breathing_difficulty"
                v-model="formData.breathing_difficulty"
                binary
              />
              <label for="breathing_difficulty">Breathing Difficulty</label>
            </div>
            <div class="field mt-6 w-[48%]">
              <Checkbox class="mx-2" id="sneezing" v-model="formData.sneezing" binary />
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
                      fluid
                      id="urination_frequency"
                      v-model="formData.urination_frequency"
                    />
                    <label for="urination_frequency">Urination Frequency</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText fluid id="urine_volume" v-model="formData.urine_volume" />
                    <label for="urine_volume">Urine Volume</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText fluid id="urine_color" v-model="formData.urine_color" />
                    <label for="urine_color">Urine Color</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <Select
                      fluid
                      optionLabel="label"
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
                      fluid
                      id="genital_discharge"
                      v-model="formData.genital_discharge"
                    />
                    <label for="genital_discharge">Genital Discharge</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <Checkbox
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

          <!-- Step 10: Vaccination & Medication -->
          <StepPanel v-slot="{ activateCallback }" value="10">
            <div class="flex flex-col gap-4">
              <h4 class="border-b-4 rounded border-b-violet-800 w-fit font-bold">
                Vaccination & Medication
              </h4>
            </div>
            <div class="flex flex-col flex-wrap gap-8">
              <!-- Vaccination History -->
              <div class="w-[48%] basis-1/2">
                <h5 class="font-semibold mt-6">Vaccination History</h5>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText fluid id="vaccine_name" v-model="formData.vaccine_name" />
                    <label for="vaccine_name">Vaccine Name</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <DatePicker
                      showButtonBar
                      dateFormat="yy-mm-dd"
                      showIcon
                      id="vaccine_date"
                      v-model="formData.vaccine_date"
                    />
                    <label for="vaccine_date">Vaccine Date</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <DatePicker
                      showButtonBar
                      dateFormat="yy-mm-dd"
                      showIcon
                      id="next_due_date"
                      v-model="formData.next_due_date"
                    />
                    <label for="next_due_date">Next Due Date</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="administered_by"
                      v-model="formData.administered_by"
                    />
                    <label for="administered_by">Administered By</label>
                  </FloatLabel>
                </div>
              </div>

              <!-- Medication History -->
              <div class="w-[48%] basis-1/2">
                <h5 class="font-semibold mt-6">Medication History</h5>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="medication_name"
                      v-model="formData.medication_name"
                    />
                    <label for="medication_name">Medication Name</label>
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
                    <label for="medication_type">Medication Type</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText fluid id="dosage" v-model="formData.dosage" />
                    <label for="dosage">Dosage</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText fluid id="frequency" v-model="formData.frequency" />
                    <label for="frequency">Frequency</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <DatePicker
                      showButtonBar
                      dateFormat="yy-mm-dd"
                      showIcon
                      id="start_date"
                      v-model="formData.medication_start_date"
                    />
                    <label for="start_date">Start Date</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <DatePicker
                      showButtonBar
                      dateFormat="yy-mm-dd"
                      showIcon
                      id="end_date"
                      v-model="formData.medication_end_date"
                    />
                    <label for="end_date">End Date</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="prescribed_by"
                      v-model="formData.prescribed_by"
                    />
                    <label for="prescribed_by">Prescribed By</label>
                  </FloatLabel>
                </div>
              </div>

              <!-- Antiparasitic Treatment -->
              <div class="w-[48%] basis-1/2">
                <h5 class="font-semibold mt-6">Antiparasitic Treatment</h5>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="treatment_name"
                      v-model="formData.treatment_name"
                    />
                    <label for="treatment_name">Treatment Name</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <Select
                      fluid
                      optionLabel="label"
                      optionValue="value"
                      id="treatment_type"
                      v-model="formData.treatment_type"
                      :options="treatmentTypeOptions"
                    />
                    <label for="treatment_type">Treatment Type</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="treatment_dosage"
                      v-model="formData.treatment_dosage"
                    />
                    <label for="treatment_dosage">Dosage</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <DatePicker
                      showButtonBar
                      dateFormat="yy-mm-dd"
                      showIcon
                      id="administration_date"
                      v-model="formData.administration_date"
                    />
                    <label for="administration_date">Administration Date</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <DatePicker
                      showButtonBar
                      dateFormat="yy-mm-dd"
                      showIcon
                      id="next_due_date"
                      v-model="formData.treatment_next_due_date"
                    />
                    <label for="next_due_date">Next Due Date</label>
                  </FloatLabel>
                </div>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <InputText
                      fluid
                      id="administered_by"
                      v-model="formData.treatment_administered_by"
                    />
                    <label for="administered_by">Administered By</label>
                  </FloatLabel>
                </div>
              </div>

              <!-- Additional Notes -->
              <div class="w-[48%] basis-1/2">
                <h5 class="font-semibold mt-6">Additional Notes</h5>
                <div class="field mt-6 w-2/3">
                  <FloatLabel>
                    <TextArea
                      fluid
                      autoResize
                      rows="4"
                      id="additional_notes"
                      v-model="formData.additional_notes"
                    />
                    <label for="additional_notes">Additional Notes</label>
                  </FloatLabel>
                </div>
              </div>
            </div>
            <div class="flex pt-6 justify-between">
              <Button
                label="Back"
                severity="secondary"
                icon="pi pi-arrow-left"
                @click="activateCallback('9')"
              />
              <Button
                label="Next"
                icon="pi pi-arrow-right"
                iconPos="right"
                @click="activateCallback('11')"
              />
            </div>
          </StepPanel>

          <!-- Step 11: Review & Submit -->
          <StepPanel v-slot="{ activateCallback }" value="11">
            <div class="flex flex-col gap-4">
              <h3 class="text-xl font-bold">Review Your Entries</h3>
              <pre>{{ formData }}</pre>
            </div>
            <div class="flex pt-6 justify-between">
              <Button
                label="Back"
                severity="secondary"
                icon="pi pi-arrow-left"
                @click="activateCallback('10')"
              />
              <Button label="Submit" @click="submitForm" />
            </div>
          </StepPanel>
        </StepPanels>
      </Stepper>
    </fieldset>
  </div>
</template>

<script setup>
import { ref } from "vue";
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

const activeStep = ref("1");
const props = defineProps({
  medical_record_id: {
    type: Number,
    required: true,
  },
});
const formData = ref({
  symptom_description: "Test",
  start_date: "2025-03-15",
  symptom_progression: "increasing",
  medication_given: true,
  medication_name: "test",
  medication_dosage: "test",
  prescribed_by: "sdfsdf",
  activity_level: "active",
  vaccination_status: "complete",
  care_location: "home",
  other_animals_in_household: true,
  number_of_other_animals: 4,
  types_of_other_animals: "wer",
  previous_diseases_in_other_animals: "wer",
  last_reproductive_cycle_date: "2025-03-09",
  cycle_length: 5,
  notable_signs: "asd",
  other_discharges: "asd",
  itching_present: true,
  itching_location: "asd",
  itching_description: "asd",
  skin_condition_description: "asd",
  diet_type: "dry",
  diet_details: "asdasd",
  number_of_meals: 4,
  meal_quantity: "23",
  appetite: "good",
  recent_diet_change: true,
  diet_change_type: "sudden",
  water_intake: "werwer",
  vomiting: true,
  vomit_color: "wer",
  vomit_contents: "wer",
  vomit_smell: "wer",
  vomiting_frequency: 3,
  vomiting_related_to_food: false,
  vomiting_related_to_diarrhea: true,
  diarrhea_started_first: false,
  stool_consistency: "normal",
  stool_color: "werwer",
  stool_frequency: null,
  abnormal_stool_contents: "werewr",
  excessive_licking_of_anus: true,
  neurological_signs: null,
  neurological_signs_frequency: "wer",
  associated_symptoms: "wer",
  sudden_onset: false,
  related_to_eating_or_activity: "wer",
  additional_details: "wer",
  cough: true,
  cough_start_date: "2025-03-10",
  cough_frequency: "wwer",
  cough_type: "dry",
  breathing_difficulty: true,
  sneezing: false,
  urination_frequency: 4,
  frequent_litter_box_visits: false,
  urine_volume: null,
  urine_color: "wer",
  urination_type: "intermittent",
  blood_in_urine: true,
  blood_location: "beginning",
  abnormal_urinary_discharge: "wer",
  genital_discharge: "wer",
  excessive_licking_of_genital_area: false,
  vaccine_name: "wer",
  vaccine_date: "2025-03-10",
  next_due_date: "2025-03-14",
  administered_by: "wer",
  medication_type: "antibiotic",
  dosage: "wer",
  frequency: "wer",
  medication_start_date: "2025-03-11",
  medication_end_date: "2025-03-12",
  treatment_name: "wer",
  treatment_type: "flea",
  treatment_dosage: "wer",
  administration_date: "2025-03-11",
  treatment_next_due_date: "2025-04-15",
  treatment_administered_by: "werwer",
  additional_notes: "werwerwer",
});

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
  { label: "Large", value: "large" },
  { label: "Small", value: "small" },
  { label: "Medium", value: "medium" },
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

    console.log(formData.value);

    // Send formData to the storeHistory endpoint
    const response = await axiosInstance.post(
      `/medical-records/history/${props.medical_record_id}`,
      formData.value
    );
    console.log("Form submitted successfully:", response.data);
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
