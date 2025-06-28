<template>
  <div class="w-full">
    <fieldset
      class="p-fieldset p-component w-4/5 flex flex-wrap mx-auto gap-2 items-start border rounded-lg p-4"
    >
      <legend>Case History Details</legend>
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
                  <DatePicker
                    showIcon
                    iconDisplay="input"
                    showButtonBar
                    fluid
                    id="examination_date"
                    v-model="examination.examination_date"
                    showTime
                    hourFormat="12"
                    dateFormat="yy-mm-d"
                  />
                  <label for="examination_date">{{
                    $t("medical_examination_form.fields.examination_date")
                  }}</label>
                </FloatLabel>
              </div>
              <div class="field mt-3 w-2/3">
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
                    :minFractionDigits="2"
                  />
                  <label for="animal_weight">{{
                    $t("medical_examination_form.fields.animal_weight")
                  }}</label>
                </FloatLabel>
              </div>
              <div class="field mt-3 w-2/3">
                <FloatLabel>
                  <InputNumber
                    fluid
                    v-model="examination.temperature"
                    :minFractionDigits="1"
                    :step="0.5"
                    showButtons
                    inputId="temperature"
                    mode="decimal"
                    suffix=" ℃"
                    :min="0"
                    :max="45"
                  />
                  <label for="temperature">{{
                    $t("medical_examination_form.fields.temperature")
                  }}</label>
                </FloatLabel>
              </div>
              <div class="field mt-3 w-2/3">
                <FloatLabel>
                  <Textarea
                    fluid
                    id="animal_behavior"
                    rows="2"
                    autoResize
                    v-model="examination.animal_behavior"
                  />
                  <label for="animal_behavior">{{
                    $t("medical_examination_form.fields.animal_behavior")
                  }}</label>
                </FloatLabel>
              </div>
            </div>
            <div class="flex justify-end pt-4">
              <Button
                :label="$t('medical_examination_form.buttons.next')"
                @click="activateCallback('2')"
              />
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
                    <Textarea
                      fluid
                      id="eyes"
                      rows="2"
                      autoResize
                      v-model="examination.eyes"
                    />
                    <label for="eyes">{{
                      $t("medical_examination_form.fields.eyes")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-3 w-2/3">
                  <FloatLabel>
                    <Select
                      v-model="examination.eye_sunkenness"
                      :options="yesno"
                      fluid
                      optionLabel="label"
                      optionValue="value"
                    />
                    <label for="eye_sunkenness">{{
                      $t("medical_examination_form.fields.eye_sunkenness")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-3 w-2/3">
                  <FloatLabel>
                    <Textarea
                      fluid
                      id="nose"
                      rows="2"
                      autoResize
                      v-model="examination.nose"
                    />
                    <label for="nose">{{
                      $t("medical_examination_form.fields.nose")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-3 w-2/3">
                  <FloatLabel>
                    <Textarea
                      fluid
                      id="nasal_discharge"
                      rows="2"
                      autoResize
                      v-model="examination.nasal_discharge"
                    />
                    <label for="nasal_discharge">{{
                      $t("medical_examination_form.fields.nasal_discharge")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-3 w-2/3">
                  <FloatLabel>
                    <Textarea
                      fluid
                      id="mouth"
                      rows="2"
                      autoResize
                      v-model="examination.mouth"
                    />
                    <label for="mouth">{{
                      $t("medical_examination_form.fields.mouth")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-3 w-2/3">
                  <FloatLabel>
                    <Textarea
                      fluid
                      id="teeth"
                      rows="2"
                      autoResize
                      v-model="examination.teeth"
                    />
                    <label for="teeth">{{
                      $t("medical_examination_form.fields.teeth")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-3 w-2/3">
                  <FloatLabel>
                    <Textarea
                      fluid
                      id="gums"
                      rows="2"
                      autoResize
                      v-model="examination.gums"
                    />
                    <label for="gums">{{
                      $t("medical_examination_form.fields.gums")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-3 w-2/3">
                  <FloatLabel>
                    <Textarea
                      fluid
                      id="tongue"
                      rows="2"
                      autoResize
                      v-model="examination.tongue"
                    />
                    <label for="tongue">{{
                      $t("medical_examination_form.fields.tongue")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-3 w-2/3">
                  <FloatLabel>
                    <Textarea
                      fluid
                      id="mucous_membranes"
                      rows="2"
                      autoResize
                      v-model="examination.mucous_membranes"
                    />
                    <label for="mucous_membranes">{{
                      $t("medical_examination_form.fields.mucous_membranes")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-3 w-2/3">
                  <FloatLabel>
                    <Textarea
                      fluid
                      id="ears"
                      rows="2"
                      autoResize
                      v-model="examination.ears"
                    />
                    <label for="ears">{{
                      $t("medical_examination_form.fields.ears")
                    }}</label>
                  </FloatLabel>
                </div>
              </div>
              <div class="flex justify-between pt-4">
                <Button
                  :label="$t('medical_examination_form.buttons.back')"
                  @click="activateCallback('1')"
                  severity="secondary"
                />
                <Button
                  :label="$t('medical_examination_form.buttons.next')"
                  @click="activateCallback('3')"
                />
              </div>
            </fieldset>
          </StepPanel>

          <!-- Step 3 -->
          <!--           <StepPanel value="3" v-slot="{ activateCallback }">
            <fieldset class="p-4 border rounded-lg">
              <div class="flex flex-col gap-4">
                <h4 class="border-b-4 rounded border-b-violet-800 w-fit font-bold">
                  {{ $t("medical_examination_form.section_titles.vital_signs") }}
                </h4>
              </div>
              <div class="grid grid-cols-2 gap-2 mt-3">
                <div class="field mt-3 w-2/3">
                  <FloatLabel>
                    <InputNumber
                      fluid
                      v-model="examination.pulse_rate"
                      showButtons
                      suffix=" bpm"
                      :min="0"
                      :max="300"
                    />
                    <label for="pulse_rate">{{
                      $t("medical_examination_form.fields.pulse_rate")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-3 w-2/3">
                  <FloatLabel>
                    <InputNumber
                      fluid
                      v-model="examination.respiratory_rate"
                      showButtons
                      suffix=" breaths/min"
                      :min="0"
                      :max="100"
                    />
                    <label for="respiratory_rate">{{
                      $t("medical_examination_form.fields.respiratory_rate")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-3 w-2/3">
                  <FloatLabel>
                    <Textarea
                      fluid
                      id="breathing_pattern"
                      rows="2"
                      autoResize
                      v-model="examination.breathing_pattern"
                    />
                    <label for="breathing_pattern">{{
                      $t("medical_examination_form.fields.breathing_pattern")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-3 w-2/3">
                  <FloatLabel>
                    <Textarea
                      fluid
                      id="breath_sound"
                      rows="2"
                      autoResize
                      v-model="examination.breath_sound"
                    />
                    <label for="breath_sound">{{
                      $t("medical_examination_form.fields.breath_sound")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-3 w-2/3">
                  <FloatLabel>
                    <Textarea
                      fluid
                      id="oxygenation"
                      rows="2"
                      autoResize
                      v-model="examination.oxygenation"
                    />
                    <label for="oxygenation">{{
                      $t("medical_examination_form.fields.oxygenation")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-3 w-2/3">
                  <FloatLabel>
                    <Textarea
                      fluid
                      id="capillary_refill_time"
                      rows="2"
                      autoResize
                      v-model="examination.capillary_refill_time"
                    />
                    <label for="capillary_refill_time">{{
                      $t("medical_examination_form.fields.capillary_refill_time")
                    }}</label>
                  </FloatLabel>
                </div>
              </div>
              <div class="flex justify-between pt-4">
                <Button
                  :label="$t('medical_examination_form.buttons.back')"
                  @click="activateCallback('2')"
                  severity="secondary"
                />
                <Button
                  :label="$t('medical_examination_form.buttons.next')"
                  @click="activateCallback('4')"
                />
              </div>
            </fieldset>
          </StepPanel>
 -->
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
                    <InputNumber
                      fluid
                      v-model="examination.pulse_rate"
                      showButtons
                      suffix=" bpm"
                      :min="0"
                      :max="300"
                    />
                    <label for="pulse_rate">{{
                      $t("medical_examination_form.fields.pulse_rate")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-3 w-2/3">
                  <FloatLabel>
                    <InputNumber
                      fluid
                      v-model="examination.respiratory_rate"
                      showButtons
                      suffix=" breaths/min"
                      :min="0"
                      :max="100"
                    />
                    <label for="respiratory_rate">{{
                      $t("medical_examination_form.fields.respiratory_rate")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-3 w-2/3">
                  <FloatLabel>
                    <Select
                      v-model="examination.breathing_pattern"
                      :options="breathingPatterns"
                      optionLabel="label"
                      optionValue="value"
                      class="w-full"
                    />
                    <label>{{
                      $t("medical_examination_form.fields.breathing_pattern")
                    }}</label>
                  </FloatLabel>
                </div>

                <!-- Breathing Pattern Toggle -->
                <div class="field mt-3 col-span-2">
                  <div class="flex items-center gap-3">
                    <label class="font-medium">
                      {{
                        $t("medical_examination_form.fields.abnormal_breathing_pattern")
                      }}:
                    </label>
                    <ToggleSwitch
                      v-model="examination.abnormal_breathing_pattern"
                      :true-value="'abnormal'"
                      :false-value="'normal'"
                    />
                  </div>
                </div>

                <!-- Abnormal Breathing Fields (shown only when breathing_pattern is abnormal) -->
                <div
                  v-if="
                    examination.breathing_pattern === 'paradoxical' ||
                    examination.abnormal_breathing_pattern === 'abnormal'
                  "
                  class="col-span-2 grid grid-cols-2 gap-4 bg-gray-100 rounded-xl py-6 px-4 mt-3"
                >
                  <!-- Type Select -->
                  <div class="field mt-3 w-2/3">
                    <FloatLabel>
                      <Select
                        v-model="examination.abnormal_breathing_type"
                        :options="breathingTypes"
                        optionLabel="label"
                        optionValue="value"
                        class="w-full"
                      />
                      <label>{{
                        $t("medical_examination_form.fields.abnormal_breathing_type")
                      }}</label>
                    </FloatLabel>
                  </div>

                  <!-- Severity Select -->
                  <div class="field mt-3 w-2/3">
                    <FloatLabel>
                      <Select
                        v-model="examination.abnormal_breathing_severity"
                        :options="breathingSeverities"
                        optionLabel="label"
                        optionValue="value"
                        class="w-full"
                      />
                      <label>{{
                        $t("medical_examination_form.fields.abnormal_breathing_severity")
                      }}</label>
                    </FloatLabel>
                  </div>

                  <!-- Location Select -->
                  <div class="field mt-3 w-2/3">
                    <FloatLabel>
                      <Select
                        v-model="examination.abnormal_breathing_location"
                        :options="breathingLocations"
                        optionLabel="label"
                        optionValue="value"
                        class="w-full"
                      />
                      <label>{{
                        $t("medical_examination_form.fields.abnormal_breathing_location")
                      }}</label>
                    </FloatLabel>
                  </div>

                  <!-- Breathing Notes -->
                  <div class="field mt-3 w-2/3">
                    <FloatLabel>
                      <Textarea
                        fluid
                        id="breathing_notes"
                        rows="2"
                        autoResize
                        v-model="examination.breathing_notes"
                      />
                      <label for="breathing_notes">{{
                        $t("medical_examination_form.fields.breathing_notes")
                      }}</label>
                    </FloatLabel>
                  </div>
                </div>

                <!-- Existing fields -->
                <!--                 <div class="field mt-3 w-2/3">
                  <FloatLabel>
                    <Textarea
                      fluid
                      id="breath_sound"
                      rows="2"
                      autoResize
                      v-model="examination.breath_sound"
                    />
                    <label for="breath_sound">{{
                      $t("medical_examination_form.fields.breath_sound")
                    }}</label>
                  </FloatLabel>
                </div> -->
                <div class="field mt-3 w-2/3">
                  <FloatLabel>
                    <Textarea
                      fluid
                      id="oxygenation"
                      rows="2"
                      autoResize
                      v-model="examination.oxygenation"
                    />
                    <label for="oxygenation">{{
                      $t("medical_examination_form.fields.oxygenation")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-3 w-2/3">
                  <FloatLabel>
                    <Textarea
                      fluid
                      id="capillary_refill_time"
                      rows="2"
                      autoResize
                      v-model="examination.capillary_refill_time"
                    />
                    <label for="capillary_refill_time">{{
                      $t("medical_examination_form.fields.capillary_refill_time")
                    }}</label>
                  </FloatLabel>
                </div>
              </div>
              <div class="flex justify-between pt-4">
                <Button
                  :label="$t('medical_examination_form.buttons.back')"
                  @click="activateCallback('2')"
                  severity="secondary"
                />
                <Button
                  :label="$t('medical_examination_form.buttons.next')"
                  @click="activateCallback('4')"
                />
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
                    <Textarea
                      fluid
                      id="nervous_system"
                      rows="2"
                      autoResize
                      v-model="examination.nervous_system"
                    />
                    <label for="nervous_system">{{
                      $t("medical_examination_form.fields.nervous_system")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-3 w-2/3">
                  <FloatLabel>
                    <Textarea
                      fluid
                      id="skin"
                      rows="2"
                      autoResize
                      v-model="examination.skin"
                    />
                    <label for="skin">{{
                      $t("medical_examination_form.fields.skin")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-3 w-2/3">
                  <FloatLabel>
                    <Textarea
                      fluid
                      id="skin_lumps_or_infections"
                      rows="2"
                      autoResize
                      v-model="examination.skin_lumps_or_infections"
                    />
                    <label for="skin_lumps_or_infections">{{
                      $t("medical_examination_form.fields.skin_lumps_or_infections")
                    }}</label>
                  </FloatLabel>
                </div>
                <div class="field mt-3 w-2/3">
                  <FloatLabel>
                    <Textarea
                      fluid
                      id="skin_coat_condition"
                      rows="2"
                      autoResize
                      v-model="examination.skin_coat_condition"
                    />
                    <label for="skin_coat_condition">{{
                      $t("medical_examination_form.fields.skin_coat_condition")
                    }}</label>
                  </FloatLabel>
                </div>
              </div>
              <div class="flex justify-between pt-4">
                <Button
                  :label="$t('medical_examination_form.buttons.back')"
                  @click="activateCallback('3')"
                  severity="secondary"
                />
                <Button
                  :label="$t('medical_examination_form.buttons.next')"
                  @click="activateCallback('5')"
                />
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
                    <Textarea
                      fluid
                      id="abdominal_palpation"
                      rows="2"
                      autoResize
                      v-model="examination.abdominal_palpation"
                    />
                    <label for="abdominal_palpation">
                      {{ $t("medical_examination_form.fields.abdominal_palpation") }}
                    </label>
                  </FloatLabel>
                </div>
                <div class="field mt-3 w-2/3">
                  <FloatLabel>
                    <Textarea
                      fluid
                      id="lymph_nodes"
                      rows="2"
                      autoResize
                      v-model="examination.lymph_nodes"
                    />
                    <label for="lymph_nodes">
                      {{ $t("medical_examination_form.fields.lymph_nodes") }}
                    </label>
                  </FloatLabel>
                </div>
              </div>
              <div class="flex justify-between pt-4">
                <Button
                  :label="$t('medical_examination_form.buttons.back')"
                  @click="activateCallback('4')"
                  severity="secondary"
                />
                <Button
                  :label="$t('medical_examination_form.buttons.next')"
                  @click="activateCallback('6')"
                />
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
                    <InputNumber
                      fluid
                      v-model="examination.body_condition_score"
                      showButtons
                      :min="1"
                      :max="10"
                    />
                    <label for="body_condition_score">
                      {{ $t("medical_examination_form.fields.body_condition_score") }}
                    </label>
                  </FloatLabel>
                </div>
                <div class="field mt-3 w-2/3">
                  <FloatLabel>
                    <Textarea
                      fluid
                      id="hydration_status"
                      rows="2"
                      autoResize
                      v-model="examination.hydration_status"
                    />
                    <label for="hydration_status">
                      {{ $t("medical_examination_form.fields.hydration_status") }}
                    </label>
                  </FloatLabel>
                </div>
              </div>
              <div class="flex justify-between pt-4">
                <Button
                  :label="$t('medical_examination_form.buttons.back')"
                  @click="activateCallback('5')"
                  severity="secondary"
                />
                <Button
                  :label="$t('medical_examination_form.buttons.next')"
                  @click="activateCallback('7')"
                />
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
                  <Textarea
                    fluid
                    id="preliminary_diagnosis"
                    rows="2"
                    autoResize
                    v-model="examination.preliminary_diagnosis"
                  />
                  <label for="preliminary_diagnosis">
                    {{ $t("medical_examination_form.fields.preliminary_diagnosis") }}
                  </label>
                </FloatLabel>
              </div>
              <div class="field mt-3 w-2/3">
                <FloatLabel>
                  <Textarea
                    fluid
                    id="recommendations"
                    rows="2"
                    autoResize
                    v-model="examination.recommendations"
                  />
                  <label for="recommendations">
                    {{ $t("medical_examination_form.fields.recommendations") }}
                  </label>
                </FloatLabel>
              </div>
              <div class="field mt-3 w-2/3">
                <FloatLabel>
                  <Textarea
                    fluid
                    id="notes"
                    rows="2"
                    autoResize
                    v-model="examination.notes"
                  />
                  <label for="notes">
                    {{ $t("medical_examination_form.fields.notes") }}
                  </label>
                </FloatLabel>
              </div>
            </div>
            <div class="flex justify-between pt-4">
              <Button
                :label="$t('medical_examination_form.buttons.back')"
                @click="activateCallback('6')"
                severity="secondary"
              />
              <!-- <Button
                :label="$t('medical_examination_form.buttons.submit')"
                type="submit"
                @click="submitForm"
              /> -->
              <Button
                type="submit"
                :disabled="isSubmitting ? true : false"
                @click="submitForm"
              >
                <i class="fa-solid fa-spinner fa-spin" v-if="isSubmitting"></i>
                <span v-else>{{ $t("pet_form.buttons.submit") }}</span>
              </Button>
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
import ToggleSwitch from "primevue/toggleswitch";

import { useI18n } from "vue-i18n";
const { t } = useI18n();
const props = defineProps({
  medical_record_id: {
    type: Number,
    required: true,
  },
});
const emit = defineEmits(["submitted"]); // Define the event to be emitted

const examination = ref(
  {
    medical_record_id: props.medical_record_id,
    examination_date: new Date(),
    animal_weight: 0,
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
    abnormal_breathing_pattern: "",
    abnormal_breathing_type: "",
    abnormal_breathing_severity: "",
    abnormal_breathing_location: "",
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
  }
  /*{
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
  }*/
);
const activeStep = ref("1");
const isSubmitting = ref(false);
const yesno = ref([
  { label: t("medical_examination_form.options.yes"), value: "yes" },
  { label: t("medical_examination_form.options.no"), value: "no" },
]);
const breathingTypes = ref([
  {
    label: t("medical_examination_form.options.wheezing"),
    en_label: "Wheezing/أزيز",
    value: "wheezing",
  },
  {
    label: t("medical_examination_form.options.stridor"),
    en_label: "Stridor/صرير",
    value: "stridor",
  },
  {
    label: t("medical_examination_form.options.crackles"),
    en_label: "Crackles (Rales)/خراخر / طقطقة",
    value: "crackles",
  },
  {
    label: t("medical_examination_form.options.rhonchi"),
    en_label: "Rhonchi/خرخرة",
    value: "rhonchi",
  },
  {
    label: t("medical_examination_form.options.pleural_rub"),
    en_label: "Pleural rub/احتكاك غشاء الجنب",
    value: "pleural_rub",
  },
  {
    label: t("medical_examination_form.options.bronchial_sounds"),
    en_label: "Bronchial sounds/أصوات قصبية",
    value: "bronchial_sounds",
  },
  {
    label: t("medical_examination_form.options.diminished_lung_sounds"),
    en_label: "Diminished Lung Sounds/انخفاض أصوات الرئة",
    value: "diminished_lung_sounds",
  },
  {
    label: t("medical_examination_form.options.intestinal_sounds"),
    en_label: "Intestinal Sounds in Chest/أصوات أمعاء داخل الصدر",
    value: "intestinal_sounds",
  },
]);

const breathingSeverities = ref([
  {
    label: t("medical_examination_form.options.low"),
    value: "low",
    en_label: "Low",
  },

  {
    label: t("medical_examination_form.options.medium"),
    en_label: "Medium",
    value: "medium",
  },
  {
    label: t("medical_examination_form.options.high"),
    en_label: "High",
    value: "high",
  },
]);

const breathingLocations = ref([
  {
    label: t("medical_examination_form.options.front_left"),
    en_label: "Front Left/الجهة الأمامية اليسرى",
    value: "front_left",
  },
  {
    label: t("medical_examination_form.options.front_right"),
    en_label: "Front Right/الجهة الأمامية اليمنى",
    value: "front_right",
  },
  {
    label: t("medical_examination_form.options.back_left"),
    en_label: "Back Left/الجهة الخلفية اليسرى",
    value: "back_left",
  },
  {
    label: t("medical_examination_form.options.back_right"),
    en_label: "Back Right/الجهة الخلفية اليمنى",
    value: "back_right",
  },
  {
    label: t("medical_examination_form.options.whole_lungs"),
    en_label: "Whole Lungs/كامل الرئتين",
    value: "whole_lungs",
  },
]);
const breathingPatterns = ref([
  {
    label: t("medical_examination_form.options.thoracic"),
    en_label: "Thoracic",
    value: "thoracic",
  },
  {
    label: t("medical_examination_form.options.abdominal"),
    en_label: "Abdominal",
    value: "abdominal",
  },
  {
    label: t("medical_examination_form.options.mixed"),
    en_label: "Mixed",
    value: "mixed",
  },
  {
    label: t("medical_examination_form.options.paradoxical"),
    en_label: "Paradoxical",
    value: "paradoxical",
  },
]);

// Form submission
const submitForm = async () => {
  //const { t } = useI18n();
  if (isSubmitting.value) return;
  const submissionData = {
    ...examination.value,
    medical_record_id: props.medical_record_id,
    eye_sunkenness: examination.value.eye_sunkenness,
    respiratory_rate:
      examination.value.respiratory_rate + " " + examination.value.respiratory_rate,
  };

  try {
    isSubmitting.value = true;
    const response = await axiosInstance.post("/medical-examinations", submissionData);

    emit("PhysicalExaminationAdded", response.data);

    eventBus.emit("show-toast", {
      severity: "success",
      summary: t("medical_examination_form.messages.success_title"),
      detail: t("medical_examination_form.messages.success"),
      life: 5000,
    });
    isSubmitting.value = false;
  } catch (error) {
    eventBus.emit("show-toast", {
      severity: "error",
      summary: t("medical_examination_form.messages.error_title"),
      detail:
        error.response?.data?.message || t("medical_examination_form.messages.error"),
      life: 5000,
    });
    console.error("Error submitting form:", error);
    isSubmitting.value = false;
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
