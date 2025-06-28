<template>
  <div id="printable" class="px-4 lg:!text-[14px]">
    <div
      class="no-print sticky top-0 bg-white dark:bg-[var(--p-surface-800)] shadow-md z-10 mb-4 p-2 flex flex-wrap gap-2"
    >
      <a
        v-for="section in sections"
        :key="section.id"
        :href="`#${section.id}`"
        :class="{
          'px-3 py-1 rounded-full lg:!text-[14px] text-sm text-grey-700  bg-gray-100 dark:bg-gray-700 hover:bg-primary-100 dark:hover:bg-primary-700 transition-colors': true,
          'bg-gray-700 text-white dark:bg-[var(--p-primary-contrast-color)] is-active':
            activeSection === section.id,
        }"
      >
        {{ $t(section.label) }}
      </a>
    </div>
    <Card>
      <template #title>
        <div class="flex justify-between items-center">
          <span>{{ $t("medical_examination.title") }}</span>
          <Button
            icon="pi pi-print"
            @click="printComponent"
            class="p-button p-button-icon-only p-button-rounded"
            v-tooltip="$t('pet_details.print')"
          />
        </div>
      </template>
      <template #content>
        <!-- General Information -->
        <div class="flex justify-between" id="general-info">
          <Panel class="w-[30%] border rounded-lg shadow p-4">
            <p>
              <strong>{{ $t("medical_examination.general_info.pet_id") }}:</strong>
              {{ medicalRecord.pet_id }}
            </p>
            <p>
              <strong>{{ $t("medical_examination.general_info.pet_name") }}:</strong>
              {{ props.pet_name }}
            </p>
            <p>
              <strong>{{ $t("medical_examination.general_info.branch_id") }}:</strong>
              {{ medicalRecord.branch_id }}
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

        <!-- Current Symptoms -->
        <Divider :align="!isRtl ? `left` : `right`" type="solid" id="symptoms">
          <span class="lg:!text-[14px] text-xl font-bold">{{
            $t("case_history.steps.current_symptoms")
          }}</span>
        </Divider>
        <Panel
          :header="$t('case_history.steps.current_symptoms')"
          toggleable
          v-for="(symptom, index) in medicalRecord.current_symptom"
          :key="index"
          class="border rounded-lg shadow p-4"
        >
          <p>
            <strong>{{ $t("case_history.fields.symptom_description") }}:</strong>
            {{ symptom.symptom_description }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.start_date") }}:</strong>
            {{ formatDate(symptom.start_date) }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.symptom_progression") }}:</strong>
            {{ symptom.symptom_progression }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.medication_given") }}:</strong>
            {{
              symptom.medication_given
                ? $t("medical_examination_form.options.yes")
                : $t("medical_examination_form.options.no")
            }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.medication_name") }}:</strong>
            {{ symptom.medication_name }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.medication_dosage") }}:</strong>
            {{ symptom.medication_dosage }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.prescribed_by") }}:</strong>
            {{ symptom.prescribed_by }}
          </p>
        </Panel>

        <!-- General Health -->
        <Divider :align="!isRtl ? `left` : `right`" type="solid" id="health">
          <span class="lg:!text-[14px] text-xl font-bold">{{
            $t("case_history.steps.general_health")
          }}</span>
        </Divider>
        <Panel
          :header="$t('case_history.steps.general_health')"
          toggleable
          v-for="(health, index) in medicalRecord.general_health"
          :key="index"
          class="border rounded-lg shadow p-4"
        >
          <p>
            <strong>{{ $t("case_history.fields.activity_level") }}:</strong>
            {{
              $t(
                `case_history.options.activity_level.${health.activity_level.toLowerCase()}`
              )
            }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.vaccination_status") }}:</strong>
            {{
              $t(
                `case_history.options.vaccination_status.${health.vaccination_status.toLowerCase()}`
              )
            }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.care_location") }}:</strong>
            {{
              $t(
                `case_history.options.care_location.${health.care_location.toLowerCase()}`
              )
            }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.other_animals_in_household") }}:</strong>
            {{
              health.other_animals_in_household
                ? $t("medical_examination_form.options.yes")
                : $t("medical_examination_form.options.no")
            }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.number_of_other_animals") }}:</strong>
            {{ health.number_of_other_animals }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.types_of_other_animals") }}:</strong>
            {{ health.types_of_other_animals }}
          </p>
          <p>
            <strong
              >{{ $t("case_history.fields.previous_diseases_in_other_animals") }}:</strong
            >
            {{ health.previous_diseases_in_other_animals }}
          </p>
        </Panel>

        <!-- Reproductive History -->
        <Divider :align="!isRtl ? `left` : `right`" type="solid" id="reproductive">
          <span class="lg:!text-[14px] text-xl font-bold">
            <i class="fa-solid fa-mars-and-venus"></i>
            {{ $t("case_history.steps.reproductive_history") }}
          </span>
        </Divider>
        <Panel
          :header="$t('case_history.steps.reproductive_history')"
          toggleable
          v-for="(history, index) in medicalRecord.reproductive_history"
          :key="index"
          class="border rounded-lg shadow p-4"
        >
          <p>
            <strong>{{ $t("case_history.fields.last_reproductive_cycle_date") }}:</strong>
            {{ formatDate(history.last_reproductive_cycle_date) }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.cycle_length") }}:</strong>
            {{ history.cycle_length }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.notable_signs") }}:</strong>
            {{ history.notable_signs }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.other_discharges") }}:</strong>
            {{ history.other_discharges }}
          </p>
        </Panel>

        <!-- Itching and Skin Condition -->
        <Divider :align="!isRtl ? `left` : `right`" type="solid" id="itching">
          <span class="lg:!text-[14px] text-xl font-bold">{{
            $t("case_history.steps.itching_skin")
          }}</span>
        </Divider>
        <Panel
          :header="$t('case_history.steps.itching_skin')"
          toggleable
          v-for="(itching, index) in medicalRecord.itching_skin_condition"
          :key="index"
          class="border rounded-lg shadow p-4"
        >
          <p>
            <strong>{{ $t("case_history.fields.itching_present") }}:</strong>
            {{
              itching.itching_present
                ? $t("medical_examination_form.options.yes")
                : $t("medical_examination_form.options.no")
            }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.itching_location") }}:</strong>
            {{ itching.itching_location }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.itching_description") }}:</strong>
            {{ itching.itching_description }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.skin_condition_description") }}:</strong>
            {{ itching.skin_condition_description }}
          </p>
        </Panel>

        <!-- Diet and Water Intake -->
        <Divider :align="!isRtl ? `left` : `right`" type="solid" id="diet">
          <span class="lg:!text-[14px] text-xl font-bold">
            <i class="fa-solid fa-bone"></i> {{ $t("case_history.steps.diet_water") }}
          </span>
        </Divider>
        <Panel
          :header="$t('case_history.steps.diet_water')"
          toggleable
          v-for="(diet, index) in medicalRecord.diet_water_intake"
          :key="index"
          class="border rounded-lg shadow p-4"
        >
          <p>
            <strong>{{ $t("case_history.fields.diet_type") }}:</strong>
            {{ $t(`case_history.options.diet_type.${diet.diet_type.toLowerCase()}`) }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.diet_details") }}:</strong>
            {{ diet.diet_details }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.number_of_meals") }}:</strong>
            {{ diet.number_of_meals }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.meal_quantity") }}:</strong>
            {{ diet.meal_quantity }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.appetite") }}:</strong>
            {{ $t(`case_history.options.appetite.${diet.appetite.toLowerCase()}`) }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.recent_diet_change") }}:</strong>
            {{
              diet.recent_diet_change
                ? $t("medical_examination_form.options.yes")
                : $t("medical_examination_form.options.no")
            }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.diet_change_type") }}:</strong>
            {{
              $t(
                `case_history.options.diet_change_type.${diet.diet_change_type.toLowerCase()}`
              )
            }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.water_intake") }}:</strong>
            {{ diet.water_intake }}
          </p>
        </Panel>

        <!-- Gastrointestinal Symptoms -->
        <Divider :align="!isRtl ? `left` : `right`" type="solid" id="XYZ">
          <span class="lg:!text-[14px] text-xl font-bold flex gap-2">
            <svg
              class="w-[24px] !text-[var(--p-dialog-color)] dark:!text-[var(--p-primary-contrast-color)]"
              fill="currentColor"
              version="1.1"
              id="Capa_1"
              xmlns="http://www.w3.org/2000/svg"
              xmlns:xlink="http://www.w3.org/1999/xlink"
              viewBox="0 0 59.003 59.003"
              xml:space="preserve"
            >
              <path
                d="M51.525,11.833c-3.952-3.789-7.918-5.71-11.788-5.71c-6.145,0-10.1,4.772-11.321,6.485
	c-4.974-1.173-5.981-5.414-6.022-5.597l-0.248-1.154l-9.027,3.569l0.147,0.807c0.072,0.395,1.87,9.518,14.317,12.158
	c0.207,1.366,0.927,4.123,3.417,5.667v4.256c-1.222,0.577-3.794,2.05-4.658,4.537c-0.52-0.094-1.199-0.178-1.969-0.178
	c-1.744,0-4.167,0.435-6.179,2.405c-1.346-0.627-4.44-1.877-7.724-1.877C5.694,37.202,0,39.795,0,52.146v1h7v-1
	c0-3.442,1.207-5.244,2.399-5.244c0.349,0,0.687,0.153,0.978,0.444c1.382,1.382,2.753,2.253,4.093,2.604
	C14.194,49.771,14,49.476,14,49.123c0-0.552,0.448-1,1-1s1,0.448,1,1c0,0.487-0.355,0.873-0.815,0.963
	c0.209,0.026,0.417,0.041,0.624,0.041c1.388,0,2.404-0.589,3.007-1.077c8.35,4.744,15.496,4.112,16.399,4.007
	c0.206,0.005,0.411,0.008,0.614,0.008c9.329,0,17.725-5.893,21.391-15.014C60.935,28.809,58.753,18.763,51.525,11.833z M15,44.123
	c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S15.552,44.123,15,44.123z M18,41.123c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1
	S18.552,41.123,18,41.123z M21,44.123c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S21.552,44.123,21,44.123z M24,47.123
	c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S24.552,47.123,24,47.123z M24,41.123c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1
	S24.552,41.123,24,41.123z M27,50.123c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S27.552,50.123,27,50.123z M27,44.123
	c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S27.552,44.123,27,44.123z M30,47.123c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1
	S30.552,47.123,30,47.123z M30,41.123c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S30.552,41.123,30,41.123z M33,50.123
	c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S33.552,50.123,33,50.123z M33,44.123c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1
	S33.552,44.123,33,44.123z M36,47.123c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S36.552,47.123,36,47.123z M36,41.123
	c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S36.552,41.123,36,41.123z M39,50.123c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1
	S39.552,50.123,39,50.123z M39,44.123c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S39.552,44.123,39,44.123z M42,47.123
	c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S42.552,47.123,42,47.123z M42,41.123c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1
	S42.552,41.123,42,41.123z M45,50.123c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S45.552,50.123,45,50.123z M45,44.123
	c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S45.552,44.123,45,44.123z M45,38.123c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1
	S45.552,38.123,45,38.123z M48,47.123c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S48.552,47.123,48,47.123z M48,41.123
	c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S48.552,41.123,48,41.123z M51,44.123c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1
	S51.552,44.123,51,44.123z M51,38.123c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S51.552,38.123,51,38.123z M54,41.123
	c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1S54.552,41.123,54,41.123z M54,35.123c-0.552,0-1-0.448-1-1s0.448-1,1-1s1,0.448,1,1
	S54.552,35.123,54,35.123z"
              />
            </svg>

            {{ $t("case_history.steps.gastrointestinal") }}
          </span>
        </Divider>
        <Panel
          :header="$t('case_history.steps.gastrointestinal')"
          toggleable
          v-for="(symptom, index) in medicalRecord.gastrointestinal_symptom"
          :key="index"
          class="border rounded-lg shadow p-4"
        >
          <p>
            <strong>{{ $t("case_history.fields.vomiting") }}:</strong>
            {{
              symptom.vomiting
                ? $t("medical_examination_form.options.yes")
                : $t("medical_examination_form.options.no")
            }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.vomit_color") }}:</strong>
            {{ symptom.vomit_color }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.vomit_contents") }}:</strong>
            {{ symptom.vomit_contents }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.vomit_smell") }}:</strong>
            {{ symptom.vomit_smell }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.vomiting_frequency") }}:</strong>
            {{ symptom.vomiting_frequency }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.vomiting_related_to_food") }}:</strong>
            {{
              symptom.vomiting_related_to_food
                ? $t("medical_examination_form.options.yes")
                : $t("medical_examination_form.options.no")
            }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.vomiting_related_to_diarrhea") }}:</strong>
            {{
              symptom.vomiting_related_to_diarrhea
                ? $t("medical_examination_form.options.yes")
                : $t("medical_examination_form.options.no")
            }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.diarrhea_started_first") }}:</strong>
            {{
              symptom.diarrhea_started_first
                ? $t("medical_examination_form.options.yes")
                : $t("medical_examination_form.options.no")
            }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.stool_consistency") }}:</strong>
            {{
              symptom.stool_consistency
                ? $t(
                    `case_history.options.stool_consistency.${symptom.stool_consistency.toLowerCase()}`
                  )
                : $t("common.not_available")
            }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.stool_color") }}:</strong>
            {{ symptom.stool_color }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.stool_frequency") }}:</strong>
            {{ symptom.stool_frequency }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.abnormal_stool_contents") }}:</strong>
            {{ symptom.abnormal_stool_contents }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.excessive_licking_of_anus") }}:</strong>
            {{
              symptom.excessive_licking_of_anus
                ? $t("medical_examination_form.options.yes")
                : $t("medical_examination_form.options.no")
            }}
          </p>
        </Panel>

        <!-- Neurological Symptoms -->
        <Divider :align="!isRtl ? `left` : `right`" type="solid" id="neurological">
          <span class="lg:!text-[14px] text-xl font-bold">
            <i class="fa-solid fa-brain"></i> {{ $t("case_history.steps.neurological") }}
          </span>
        </Divider>
        <Panel
          :header="$t('case_history.steps.neurological')"
          toggleable
          v-for="(symptom, index) in medicalRecord.neurological_symptom"
          :key="index"
          class="border rounded-lg shadow p-4"
        >
          <p>
            <strong>{{ $t("case_history.fields.neurological_signs") }}:</strong>
            {{ symptom.neurological_signs }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.neurological_signs_frequency") }}:</strong>
            {{ symptom.neurological_signs_frequency }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.associated_symptoms") }}:</strong>
            {{ symptom.associated_symptoms }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.sudden_onset") }}:</strong>
            {{
              symptom.sudden_onset
                ? $t("medical_examination_form.options.yes")
                : $t("medical_examination_form.options.no")
            }}
          </p>
          <p>
            <strong
              >{{ $t("case_history.fields.related_to_eating_or_activity") }}:</strong
            >
            {{ symptom.related_to_eating_or_activity }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.additional_details") }}:</strong>
            {{ symptom.additional_details }}
          </p>
        </Panel>

        <!-- Respiratory Symptoms -->
        <Divider :align="!isRtl ? `left` : `right`" type="solid" id="respiratory">
          <span class="lg:!text-[14px] text-xl font-bold flex gap-2">
            <svg
              class="w-[24px] !text-[var(--p-dialog-color)] dark:!text-[var(--p-primary-contrast-color)]"
              fill="currentColor"
              version="1.1"
              xmlns="http://www.w3.org/2000/svg"
              xmlns:xlink="http://www.w3.org/1999/xlink"
              x="0px"
              y="0px"
              viewBox="0 0 256 256"
              enable-background="new 0 0 256 256"
              xml:space="preserve"
            >
              <g>
                <g>
                  <g>
                    <path
                      fill="#000000"
                      d="M121,12.7l-1.5,1.3l-0.3,26.6c-0.3,28.9-0.3,28.9-3.2,37.9c-0.8,2.4-2.2,5.8-3.1,7.6l-1.6,3.2l0.2-2.8c1.5-20.4,1.3-30.9-0.6-37.3c-1.2-3.8-2.5-5.8-5-7.6c-1.8-1.2-2.5-1.4-6.1-1.5c-15.9-0.6-39.3,15.7-58,40.8c-7.6,10.1-14.8,22.8-19.1,33.9C9.3,148.9,5.9,202.4,15.3,231c2.9,8.8,6.3,13.2,10.7,13.6c3.7,0.4,5.7-0.5,11.8-5c10.5-7.9,16.5-11,33.7-18c5.2-2.1,11.4-4.7,13.7-5.8c8.7-4.1,14.5-9,17.1-14.4c1.7-3.4,1.9-8.1,1.1-17.3c-0.3-3.7-0.6-9.6-0.6-13.2c0-5.7,0.2-7.5,1.9-15.4c4.9-22.7,5.5-26.3,5.8-32.6l0.3-6.3l4.3-4.4c4.6-4.6,8.8-9.8,11.2-13.4c0.8-1.2,1.5-2.2,1.6-2.2c0.1,0,1.3,1.7,2.6,3.6c2.6,4,10.8,13.3,13,14.9l1.4,1l0.3,6.3c0.3,6.5,1,10.5,5.8,33c2.2,10.5,2.5,15.9,1.4,28.5c-1.2,13.4-0.4,17.2,4.7,22.8c4.5,4.9,10.8,8.4,27.2,15c17.1,6.9,23.2,10.1,33.7,18c6.1,4.5,8.1,5.4,11.8,5c4.3-0.4,7.7-4.8,10.7-13.6c9.4-28.5,6-82.1-7.2-116c-12.9-33.1-41.8-64.7-66.8-73.3c-4.4-1.5-11.5-2.1-14.3-1.2c-8.4,2.8-10.5,14.5-7.9,45.8l0.3,3l-1.3-2.3c-1.8-3.3-3.8-9-5.2-14.6c-1.2-4.9-1.2-4.9-1.4-31.3c-0.2-20-0.4-26.6-0.9-27.4c-1.2-2.1-2.3-2.5-8.1-2.5C122.5,11.3,122.4,11.3,121,12.7z M131.8,40.4c0.2,22.2,0.3,24.9,1.2,29.6c2.5,13.5,8.1,25,17.3,36.1c4.2,5,7.5,8.1,8.6,8.1c2.1,0,4.7-4.8,4.7-8.9c0-3.3-0.6-4.6-3.8-9.4c-3.1-4.5-3.9-7.1-4.4-13.4c-0.5-5.7-1.2-7.1-4.8-9.5c-1.4-1-2.6-1.9-2.6-2.1c0-0.2,1.1-0.2,2.4-0.1l2.4,0.1l-0.3-2.7c-0.3-2.5-0.3-2.7,0.4-1.8c0.4,0.5,1.5,2.6,2.5,4.6l1.8,3.7l0.8-3.1c1.9-6.9,2-2.2,0.5,11.5l-0.3,2.3l0.9-1.9c0.5-1,1.3-2.3,1.7-2.8c0.7-0.9,0.7-0.9,0.7,0.1c0,0.6-0.6,2.4-1.3,4.1c-1.3,3-1.3,3.1-0.4,4.6c0.9,1.8,6.2,7.1,6.5,6.7c0.1-0.1,0.6-1.8,1-3.7c0.9-4.2,0.6-14.1-0.5-19.4c-1-4.5-3.4-11.8-5.5-16.6c-0.9-2.1-1.6-3.8-1.5-3.8c0.4,0,4.4,6,4.9,7.4c0.3,0.8,0.6,1.4,0.8,1.4c0.2,0,1-1.4,1.8-3.1l1.5-3.1v1.9c0,1-0.4,3.1-1,4.7l-1,2.8l1.5,4.3c1.7,4.7,1.8,4.7,3.2,0.1c1.3-3.9,1.7-1.7,0.6,3.4c-1,4.9-1.4,13.4-0.8,15.1c0.4,1,0.8,0.5,4.3-5l3.9-6.1l-1-5c-0.5-2.7-1-6.1-1-7.5l0-2.5l1.3,3.9c0.7,2.2,1.6,4.5,2,5.3l0.7,1.4l3.1-3.1c1.7-1.7,3.1-2.9,3.1-2.6c0,2.1-6.7,15-14,27l-3.7,6l-1.1,10.8l-1.1,10.9l2,2c1.1,1.1,2.1,1.9,2.3,1.9c0.2-0.1,1.9-1.6,3.8-3.4l3.4-3.2l2.2-7.7l2.2-7.7l-1.5-3.8c-1.1-2.8-1.6-4.8-1.7-7.3c-0.1-2.9,0-3.3,0.4-2.3c2,4.4,3.8,7.8,4.8,9l1.2,1.4l1.2-1.4c1-1.2,1.1-1.8,1.2-6.1c0-2.7,0.2-5.3,0.6-6c0.6-1.2,0.6-0.7,0.8,4l0.2,5.3l1.9-2.3c1.5-1.9,2-2.8,2.5-5.5c1-5.9,3.9-13.2,4.9-12.2c0.1,0.1-0.1,1.8-0.6,3.7c-1.1,4.4-2.5,12.5-2.2,12.8c0.5,0.5,5.4-2.9,7.8-5.3c1.3-1.3,2.5-2.5,2.8-2.5c0.6,0,0.3,2.1-0.6,3.6c-0.9,1.5-6.1,5.7-7.1,5.7c-0.4,0-0.4,0.1,0,0.5c0.3,0.3,2.4,0.6,4.7,0.6c2.5,0,4.2,0.2,4.1,0.5c-0.3,0.8-2.3,1.1-7.6,1.1c-5.9,0-7.4,0.5-9.7,3c-2.5,2.6-4.5,7.7-5.4,13.5l-0.2,1.8l5.2-0.1c5-0.2,5.3-0.3,7.6-1.7c2.4-1.5,9.5-8.6,11-10.9c0.4-0.7,1-1.2,1.2-1.2c1,0,0.3,2-1.7,4.9c-1.2,1.7-2.1,3.1-2.1,3.2c0,0.4,2.6-0.9,4.9-2.4c1.4-0.9,2.6-1.6,2.8-1.4c0.6,0.6-1.4,3-3.8,4.8c-1.4,1-4.1,2.7-6.1,3.8l-3.5,1.9l2.1,0.3c1.2,0.2,3.3,0.2,4.7,0.1c1.4,0,2.6,0,2.6,0.2c0,0.8-8.2,2.2-13.9,2.2l-2.5,0l2.1,1.9c1.2,1,3,2.4,4.1,3.1c1.1,0.6,1.9,1.2,1.9,1.3c0,0.4-3.3-0.4-5-1.1c-0.8-0.4-2.9-1.6-4.6-2.7c-3.5-2.4-5.5-2.6-8.5-1.1c-1.9,1-9.2,8.1-9.2,9c0,1.3,4.8,6.3,7.5,7.8c5.7,3.1,15.8,5.2,20.2,4c4.6-1.2,9.1-8.3,15.2-23.6c1.6-3.9,3-7.3,3.1-7.4c0.8-0.8-1.6,10.1-3.3,14.6c-0.3,0.8-0.2,0.8,0.6-0.1c1-1.2,3.8-3.4,4.4-3.4c0.2,0-0.9,1.5-2.4,3.4c-3,3.6-8.4,11.5-8.1,11.9c0.1,0.1,1.5-0.9,3.2-2.2c3.3-2.6,4-2.9,3-1.3c-0.4,0.6-1.2,1.9-1.7,2.8l-1.1,1.8l1.6-0.6c1.9-0.8,6.3-3.6,8.8-5.5c1.6-1.3,1.7-1.3,1.7-0.4c0,2.5-5.2,6.2-13,9.1l-3.9,1.5l2.2,1c5.7,2.5,14.7,3.7,19,2.4c0.9-0.3,1.7-0.3,1.7-0.1c0,0.7-2.4,2.3-4.2,2.9c-1,0.3-1.8,0.7-1.8,0.9c0,0.4,4.7,2.2,5.7,2.3c0.3,0,0.1,0.2-0.5,0.4c-1.5,0.6-4.3,0-13.1-3c-8.1-2.7-10.2-3.1-23-4c-3.9-0.3-8.6-0.9-10.4-1.3c-1.9-0.5-3.4-0.8-3.5-0.8c0,0,0.1,0.9,0.4,1.8c0.6,1.8,5.2,6.2,11.7,11.1c7.4,5.6,10,6.2,18.8,4.4c3.2-0.6,7-1.2,8.6-1.2h2.8l-3.1,0.9c-4.5,1.3-10.6,3.7-10.4,4.1c0.1,0.2,1.4,1.4,3.1,2.8c5.1,4.3,9.1,10.5,9.7,15.5c0.2,1.8,0.1,1.7-1.6-1.6c-1.9-3.8-5.6-8.8-7.2-10c-1-0.7-1-0.6-1.3,1c-0.2,1-0.3,3-0.3,4.5c0,4-0.8,2.7-2-3.3l-1-5.1l-7.4-3.5c-4.1-1.9-7.5-3.5-7.6-3.3c-0.4,0.4,9,22.1,10.8,25.1c2.6,4.1,9.1,10.5,13.3,13.2l3.2,2.1l-2.5,0.1c-2.6,0.1-2.6,0.1-1.6,3.2c0.3,0.9-0.4,0.2-5.7-5.6l-2.9-3.2l1.7,4.6c0.9,2.5,2.3,7.1,3,10.1c1.3,5.2,2.5,13.1,2.2,13.4c-0.1,0.1-1.3-3-2.7-6.9l-2.5-7l-0.8,4.1c-0.5,2.3-0.9,4.2-1,4.3c-0.1,0.1-0.3-2.2-0.5-5c-0.4-6.4-1.4-12.8-3-17.7c-1.2-3.8-3.5-8.8-4.3-9.2c-0.6-0.4-1.2,17.1-0.9,27c0.2,6.8,0.1,7.9-0.3,6.7c-0.8-2-1.6-8.9-1.6-14.4v-4.6l-1.9,3.8c-1.1,2.1-2.5,4.4-3.3,5.1l-1.4,1.3l1.1-2.5c3.2-7,5-15.6,5-23.2v-4.9l-1.3,2.8c-1.3,2.7-4.1,6.5-4.5,6c-0.1-0.1,0.3-1.3,1-2.5c3.7-7.3,3.3-15.8-1-23.1l-1.3-2.2l-2,6.3c-1.3,4.2-2.2,8.1-2.7,11.8c-1.5,11.7-2.7,13.7-2.3,3.8c0.2-3.7,0.2-6.8,0.1-6.8c-0.1,0-1.3,2.3-2.5,5.1c-1.3,2.8-2.3,5-2.4,4.9c-0.1-0.1,0.6-2.6,1.4-5.7c0.9-3,1.6-5.6,1.5-5.6c-0.1-0.1-0.6,0.1-1.2,0.4c-1.7,0.9-1.5,0.2,0.7-3c3.6-5.1,6.2-10,6.2-11.6c0-1-0.6-2.4-2.2-4.4l-2.2-3l-0.3,1.4c-1.6,6.9-2.1,8.8-3.6,12.2c-0.9,2.1-3.1,6.3-4.9,9.2c-3.2,5.3-3.2,5.4-3,8c0.2,2.7,2.9,8.9,6.3,14.7c0.8,1.3,1.3,2.4,1,2.4c-0.6,0-5.4-4.7-8.3-8.1c-1.1-1.3-1.9-1.9-1.7-1.4c1.2,3.4,2.5,10,2.5,11.5l-0.1,1.8l-1.9-3c-1-1.6-2.3-3.3-2.8-3.8c-0.9-0.9-1-0.8-1.4,0.9c-0.3,1-0.5,2.4-0.6,3.1l0,1.4l-0.7-1.6c-0.6-1.3-0.6-2.8-0.4-7.6c0.1-3.3,0.4-7.1,0.6-8.3l0.2-2.3l-1.4,1.6c-0.8,0.9-1.9,2.5-2.5,3.6c-1.1,2.1-1.8,2.5-1.8,1.2c0-1.7,1.9-4.7,6.1-10c7.8-9.7,9.7-14,9.7-21.7c0-5.2-1.1-9.9-3.6-14.8c-2-4-2.5-4.4-2.5-1.7c0,2.7-1.1,6.1-2.8,8.8c-0.9,1.4-1.7,3.5-2.1,5.8c-0.4,1.9-0.9,3.7-1.1,3.9c-0.2,0.2-0.6-0.7-0.7-2.2c-0.1-1.4-0.5-2.8-0.7-3.1c-0.3-0.3-1.3,1.7-2.6,5c-1.2,3-2.3,5.6-2.4,5.7c-0.1,0.1-0.1-1,0-2.5c0.2-2.9,1.6-7.5,3.2-10.6l0.9-1.9l-1.3-1.1c-0.7-0.6-2.4-1.7-3.7-2.5c-2-1.2-2.2-1.4-1.1-1.4c0.7,0,2.1,0.3,3.2,0.7c3.1,1.1,3.2,0.9,0.5-1.9l-2.5-2.6l1.6,0.3c1,0.2,2.4,1,3.6,2.2l1.9,1.9l0.6-1.3c1.3-3.2-0.7-13.2-3.8-19.2c-0.5-1-3.9-4.5-7.7-8c-12.8-11.6-19.6-19.8-23.5-28c-0.7-1.6-1.5-2.9-1.7-2.9c-0.2,0-0.8,1.1-1.4,2.4c-1.5,3.2-5.5,9.6-7.9,12.6c-1.1,1.3-6.4,6.9-11.9,12.3c-10.7,10.7-12.6,13.2-14.4,19c-1.2,3.7-1.7,9.9-0.9,11.8l0.6,1.3l1.9-1.9c1.2-1.2,2.6-2,3.6-2.2l1.6-0.3l-2.5,2.6c-2.7,2.8-2.6,3,0.5,1.9c1.1-0.4,2.5-0.7,3.2-0.7c1.1,0,0.9,0.2-1.1,1.4c-1.3,0.7-2.9,1.9-3.6,2.4l-1.3,1.1l1.1,2.5c1.7,3.8,3.1,8.7,3.1,10.6c0,2.3-0.5,1.6-2.8-4.2c-1.2-3.1-2.1-4.9-2.4-4.6c-0.2,0.2-0.6,1.6-0.7,3.1c-0.1,1.4-0.5,2.5-0.6,2.3c-0.2-0.2-0.7-2-1.2-4c-0.5-2.2-1.3-4.5-2.1-5.8c-1.7-2.6-2.7-6-2.7-8.7c0-2.6-0.6-2.3-2.5,1.7c-2.5,4.9-3.6,9.6-3.6,14.8c0,7.7,1.9,12,9.7,21.7c4.3,5.3,6.1,8.3,6.1,10c0,1.4-0.6,0.9-1.8-1.2c-0.6-1.1-1.7-2.7-2.5-3.6l-1.4-1.6l0.2,2.3c0.1,1.3,0.4,5,0.6,8.3c0.2,4.9,0.2,6.3-0.4,7.6l-0.7,1.6l0-1.4c0-0.8-0.3-2.2-0.6-3.1c-0.5-1.8-0.5-1.8-1.4-0.9c-0.5,0.5-1.8,2.1-2.8,3.8l-1.9,3l-0.1-1.7c-0.1-1.4,1.6-9.6,2.6-12.2c0.1-0.4-1,0.9-2.6,2.8c-2.8,3.5-6.8,7.3-7.5,7.3c-0.2,0,0.3-1.1,1.1-2.5c3.4-5.8,6.1-11.9,6.3-14.6c0.2-2.7,0.2-2.8-2.5-7.3c-5-8.1-6.4-11.7-8.8-22.1l-0.3-1.4l-1.5,2.5c-2.3,4.1-2.4,5.5-0.2,10c1.1,2.1,2.7,5.2,3.8,6.7c2,3,2.1,3.7,0.5,2.8c-0.6-0.3-1.1-0.5-1.2-0.4c-0.1,0.1,0.6,2.6,1.4,5.7c0.9,3,1.5,5.6,1.5,5.6c-0.1,0-1.2-2.2-2.4-5c-1.2-2.8-2.3-5.1-2.5-5.1c-0.1,0-0.1,3.1,0.1,6.8c0.4,10-0.8,8-2.3-3.8c-0.5-3.7-1.3-7.6-2.7-11.8l-2-6.3l-1.3,2.2c-4.3,7.3-4.7,15.7-1,23.1c0.7,1.3,1.1,2.5,1,2.5c-0.4,0.4-3.3-3.3-4.6-6l-1.4-2.8l0.2,6.7c0.3,7.5,1.3,12.7,4.2,19.8c0.9,2.2,1.6,4.1,1.5,4.2c-0.3,0.3-3.1-3.8-4.6-6.8l-1.8-3.5v4.3c0,5.5-0.8,12.8-1.6,14.6c-0.5,1.3-0.6,0.6-0.4-5.3c0.3-8.5-0.3-28.8-0.8-28.4c-0.8,0.5-3.1,5.5-4.3,9.2c-1.5,4.9-2.6,11.3-3,17.7c-0.1,2.9-0.4,5.1-0.5,5c0-0.1-0.5-2-1-4.3l-0.8-4.1l-2.6,7.2c-2.5,6.8-2.6,7-2.4,4.4c0.5-5,2.1-12.4,4.2-18.7c1.1-3.4,2-6.3,2-6.4c0-0.1-1.2,1.1-2.7,2.7c-5.1,5.6-5.7,6.2-5.5,5.4c1-3.1,1-3.1-1.6-3.2l-2.5-0.1l3.2-2.1c4.3-2.7,10.7-9.1,13.3-13.2c1.9-2.9,11.3-24.7,10.8-25.1c-0.1-0.1-3.5,1.4-7.5,3.3l-7.4,3.6l-1,5.1c-0.6,2.9-1.2,5.4-1.4,5.6s-0.5-1.5-0.6-3.9c-0.1-2.3-0.4-4.4-0.5-4.5c-0.7-0.7-5.7,5.5-8.3,10.5l-1.9,3.5l0.3-2.2c0.6-4.8,4.9-11.4,10-15.5c1.4-1.2,2.6-2.2,2.7-2.5c0.2-0.4-6-2.8-10.4-4.1l-3.2-0.9h2.8c1.5,0,5.4,0.5,8.6,1.2c8.6,1.8,11.4,1.2,18.3-4.1c6.9-5.1,11.6-9.5,12.1-11.3c0.3-0.9,0.5-1.8,0.4-1.8s-1.6,0.3-3.5,0.8c-1.9,0.5-6.5,1.1-10.4,1.3c-12.8,0.9-14.9,1.2-23,4c-8.7,3-11.6,3.6-13.1,3c-0.6-0.2-0.8-0.4-0.5-0.4c1-0.1,5.7-1.9,5.7-2.3c0-0.2-0.8-0.6-1.8-0.9c-1.9-0.6-4.2-2.2-4.2-2.9c0-0.2,0.6-0.2,1.3,0c3.5,1.4,13.8,0.1,19.5-2.4l2.2-1l-3.9-1.5c-7.8-3-13-6.6-13-9.1c0-0.9,0.1-0.9,1.8,0.4c2.5,1.9,6.9,4.7,8.8,5.5l1.6,0.6l-1.1-1.8c-0.6-1-1.3-2.2-1.7-2.8c-1-1.6-0.3-1.3,3,1.3c1.6,1.3,3.1,2.3,3.1,2.2c0.3-0.3-5.1-8.2-8.2-11.9c-1.5-1.9-2.6-3.4-2.4-3.4c0.6,0,3.2,2,4.2,3.2c0.8,1,0.7,0.4-0.6-4.2c-1.3-4.8-2.5-10.7-1.9-10.2c0.1,0.1,1.5,3.4,3.1,7.4c6.7,16.8,11,23.1,16.4,23.9c4.7,0.7,14.3-1.4,19.5-4.4c2.4-1.4,7.1-6.5,7.1-7.6c0-0.9-7.2-8-9.2-9c-3.1-1.6-4.8-1.3-8.9,1.3c-3.2,2-8.5,4.2-9.1,3.6c-0.1-0.1,0.5-0.6,1.3-1.1c0.8-0.5,2.7-1.9,4.1-3l2.5-2l-6.6-0.5c-6.2-0.5-9.9-1.3-9.9-1.9c0-0.2,1.2-0.2,2.6-0.2c1.4,0.1,3.5,0,4.7-0.1l2.1-0.3l-3.5-1.9c-1.9-1.1-4.7-2.8-6.1-3.8c-2.4-1.8-4.4-4.2-3.8-4.8c0.1-0.1,1.4,0.5,2.8,1.4c2.3,1.5,4.9,2.8,4.9,2.4c0-0.1-0.9-1.6-2.1-3.2c-1.9-2.9-2.6-4.9-1.7-4.9c0.2,0,1.2,1,2.1,2.3c2.5,3.3,9.1,9.4,11.2,10.5c1.5,0.7,2.8,0.9,6.7,0.9h4.9l-0.1-1.6c-0.6-7.1-4.6-14.2-8.8-15.8c-0.6-0.2-3.5-0.4-6.3-0.5c-5.3,0-7.3-0.3-7.6-1.1c-0.1-0.3,1.6-0.5,4.1-0.5c2.4,0,4.4-0.3,4.7-0.6c0.4-0.4,0.4-0.5,0-0.5c-1,0-6.2-4.2-7.1-5.7c-0.9-1.5-1.3-3.6-0.6-3.6c0.2,0,1.3,1,2.4,2.2c2,2,7.1,5.7,8,5.7c0.2,0,0.3-1,0.1-2.2c-0.3-2.3-2.3-11.6-2.8-13.4c-0.6-1.9,0.6-1.1,1.9,1.3c1.2,2.2,3.5,10.2,3.5,12.2c0,0.5,0.9,2,2.1,3.3l2,2.3l0-5.3c0-4.2,0.1-5.2,0.6-4.7c0.4,0.4,0.6,2.5,0.7,6c0.1,4.6,0.3,5.6,1.2,6.7c0.5,0.7,1.1,1.3,1.3,1.3c0.6,0,4-5.5,4.9-7.7c1.3-3.6,1.7-3.5,1.4,0.1c-0.1,2.1-0.7,4.6-1.7,7.1l-1.5,3.8l2.2,7.7l2.2,7.7l3.4,3.2c1.9,1.8,3.6,3.3,3.8,3.4c0.1,0,1.2-0.8,2.3-1.9l2-2l-1.1-10.9L86,99.1l-3.7-6c-7.6-12.4-14-24.8-14-27.1c0-0.3,0.7,0.3,1.5,1.3c0.8,1,2.2,2.4,3.1,3.1l1.6,1.3l0.7-1.3c0.4-0.7,1.3-3.1,1.9-5.2l1.3-3.9l0,2.3c0,1.3-0.4,4.7-1,7.5l-1,5.2l3.8,6.1l3.8,6.1l0.4-1.6c0.6-2.2,0.1-9.5-0.8-14.6c-0.5-2.5-0.7-4.6-0.5-5.1c0.4-0.8,0.4-0.8,0.6,0c0.1,0.5,0.6,2,1.1,3.4l1,2.5l1.6-4.3l1.6-4.3l-1-2.8c-0.6-1.6-1-3.6-1-4.4c0-1.6,0.1-1.6,1.5,1.3c0.8,1.6,1.6,2.9,1.8,2.9s0.6-0.6,0.8-1.4c0.6-1.5,4-6.7,4.7-7.2c0.3-0.2,0.2,0.5-0.3,1.5c-5.5,12.6-7.6,21.2-7.6,30.4c0,4.2,0.9,10.7,1.6,11.3c0.4,0.4,5.6-4.9,6.5-6.7c0.8-1.5,0.8-1.6-0.4-4.6c-1.3-3-1.7-5.5-0.8-4.6c0.2,0.3,1,1.5,1.6,2.7c0.6,1.3,1.2,2.2,1.2,2.1c0-0.1-0.3-3.1-0.7-6.7c-1.1-10.5-0.9-12.1,0.9-6.6l1,2.8l1.8-4c2.4-5.3,3.2-6,2.8-2.4l-0.3,2.6l2.4-0.1c1.3-0.1,2.4,0,2.4,0.1c0,0.2-1.2,1.1-2.6,2.1c-3.6,2.4-4.3,3.8-4.8,9.5c-0.5,6.3-1.5,9.1-4.5,13.6c-3.2,4.8-3.8,6.1-3.8,9.4c0,3,1.4,6.7,3.1,8.2c1.3,1.2,3,0.5,6-2.6c8.8-9.2,15.1-19.1,18.7-30c3.5-10.5,3.8-12.8,4-40.4l0.2-24.4h3.6h3.6L131.8,40.4z"
                    />
                  </g>
                </g>
              </g>
            </svg>
            {{ $t("case_history.steps.respiratory") }}
          </span>
        </Divider>
        <Panel
          :header="$t('case_history.steps.respiratory')"
          toggleable
          v-for="(symptom, index) in medicalRecord.respiratory_symptom"
          :key="index"
          class="border rounded-lg shadow p-4"
        >
          <p>
            <strong>{{ $t("case_history.fields.cough") }}:</strong>
            {{
              symptom.cough
                ? $t("medical_examination_form.options.yes")
                : $t("medical_examination_form.options.no")
            }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.cough_start_date") }}:</strong>
            {{
              symptom.cough_start_date
                ? formatDate(symptom.cough_start_date)
                : $t("common.not_available")
            }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.cough_frequency") }}:</strong>
            {{ symptom.cough_frequency }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.cough_type") }}:</strong>
            <!-- {{
            $t(`case_history.options.cough_type.${symptom.cough_type.toLowerCase()}`)
            }} -->
            {{
              symptom.cough_type
                ? $t(
                    `case_history.options.stool_consistency.${symptom.cough_type.toLowerCase()}`
                  )
                : $t("common.not_available")
            }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.breathing_difficulty") }}:</strong>
            {{
              symptom.breathing_difficulty
                ? $t("medical_examination_form.options.yes")
                : $t("medical_examination_form.options.no")
            }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.sneezing") }}:</strong>
            {{
              symptom.sneezing
                ? $t("medical_examination_form.options.yes")
                : $t("medical_examination_form.options.no")
            }}
          </p>
        </Panel>
        <!-- Urinary Symptoms -->
        <!-- Urinary Symptoms -->
        <Divider :align="!isRtl ? `left` : `right`" type="solid" id="urinary">
          <span class="lg:!text-[14px] text-xl font-bold flex gap-2">
            <svg
              class="w-[24px] !text-[var(--p-dialog-color)] dark:!text-[var(--p-primary-contrast-color)]"
              fill="currentColor"
              version="1.1"
              id="Capa_1"
              xmlns="http://www.w3.org/2000/svg"
              xmlns:xlink="http://www.w3.org/1999/xlink"
              viewBox="0 0 56 56"
              xml:space="preserve"
            >
              <path
                d="M42.75,1.822c-4.514,0-9.524,3.714-9.749,9.713c-0.07,1.865,0.766,3.792,1.65,5.832c0.197,0.454,0.394,0.912,0.584,1.373
	c0.938-4.246,4.629-7.622,8.764-7.622c0.553,0,1,0.447,1,1s-0.447,1-1,1c-3.663,0-7,3.672-7,7.704c0,0.448-0.303,0.805-0.709,0.931
	C33.571,20.46,31,16.299,31,11.178c0-0.553-0.447-1-1-1s-1,0.447-1,1c0,4.996,2.194,9.536,5.214,11.686
	c-2.759,1.016-4.998,3.102-6.214,5.759c-1.215-2.657-3.455-4.742-6.214-5.759C24.806,20.714,27,16.174,27,11.178
	c0-0.553-0.447-1-1-1s-1,0.447-1,1c0,5.121-2.571,9.283-5.291,10.575C19.303,21.627,19,21.27,19,20.822c0-4.032-3.337-7.704-7-7.704
	c-0.553,0-1-0.447-1-1s0.447-1,1-1c4.135,0,7.827,3.376,8.764,7.622c0.19-0.461,0.387-0.919,0.584-1.373
	c0.885-2.04,1.721-3.967,1.65-5.832c-0.225-5.999-5.235-9.713-9.749-9.713c-7.306,0-13.25,9.869-13.25,22s5.944,22,13.25,22
	c2.692,0,7.704,0,9.693-5.669c0.787-2.243-0.213-4.899-1.371-7.975c-0.567-1.506-1.173-3.129-1.583-4.787
	c-1.13,3.634-4.057,6.727-7.989,6.727c-0.553,0-1-0.447-1-1s0.447-1,1-1c3.862,0,6.462-4.075,6.502-7.915
	C23.231,24.466,27,28.384,27,33.178v20c0,0.553,0.447,1,1,1s1-0.447,1-1v-20c0-4.793,3.769-8.712,8.498-8.975
	c0.04,3.84,2.64,7.915,6.502,7.915c0.553,0,1,0.447,1,1s-0.447,1-1,1c-3.932,0-6.859-3.092-7.989-6.727
	c-0.411,1.658-1.016,3.282-1.583,4.787c-1.158,3.075-2.158,5.731-1.371,7.975c1.989,5.669,7.001,5.669,9.693,5.669
	c7.306,0,13.25-9.869,13.25-22S50.056,1.822,42.75,1.822z M12,24.178c-0.553,0-1-0.447-1-1s0.447-1,1-1h6c-0.553,0-1,0.447-1,1
	s0.447,1,1,1H12z M44,24.178h-6c0.553,0,1-0.447,1-1s-0.447-1-1-1h6c0.553,0,1,0.447,1,1S44.553,24.178,44,24.178z"
              />
            </svg>
            {{ $t("case_history.steps.urinary") }}
          </span>
        </Divider>
        <Panel
          :header="$t('case_history.steps.urinary')"
          toggleable
          v-for="(symptom, index) in medicalRecord.urinary_symptom"
          :key="index"
          class="border rounded-lg shadow p-4"
        >
          <p>
            <strong>{{ $t("case_history.fields.urination_frequency") }}:</strong>
            {{ symptom.urination_frequency }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.stool_frequency") }}:</strong>
            {{
              symptom.stool_frequency
                ? $t("medical_examination_form.options.yes")
                : $t("medical_examination_form.options.no")
            }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.urine_volume") }}:</strong>
            {{ symptom.urine_volume }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.urine_color") }}:</strong>
            {{ symptom.urine_color }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.urination_type") }}:</strong>
            <!-- {{
            $t(
            `case_history.options.urination_type.${symptom.urination_type.toLowerCase()}`
            )
            }} -->
            {{
              symptom.urination_type
                ? $t(
                    `case_history.options.stool_consistency.${symptom.urination_type.toLowerCase()}`
                  )
                : $t("common.not_available")
            }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.blood_in_urine") }}:</strong>
            {{
              symptom.blood_in_urine
                ? $t("medical_examination_form.options.yes")
                : $t("medical_examination_form.options.no")
            }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.blood_location") }}:</strong>
            <!-- {{
            $t(
            `case_history.options.blood_location.${symptom.blood_location.toLowerCase()}`
            )
            }} -->
            {{
              symptom.blood_location
                ? $t(
                    `case_history.options.stool_consistency.${symptom.blood_location.toLowerCase()}`
                  )
                : $t("common.not_available")
            }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.abnormal_urinary_discharge") }}:</strong>
            {{ symptom.abnormal_urinary_discharge }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.genital_discharge") }}:</strong>
            {{ symptom.genital_discharge }}
          </p>
          <p>
            <strong
              >{{ $t("case_history.fields.excessive_licking_of_genital_area") }}:</strong
            >
            {{
              symptom.excessive_licking_of_genital_area
                ? $t("medical_examination_form.options.yes")
                : $t("medical_examination_form.options.no")
            }}
          </p>
        </Panel>

        <!-- Vaccination History -->
        <Divider :align="!isRtl ? `left` : `right`" type="solid" id="vaccines">
          <span class="lg:!text-[14px] text-xl font-bold flex gap-2">
            <svg
              version="1.1"
              id="Layer_1"
              xmlns="http://www.w3.org/2000/svg"
              xmlns:xlink="http://www.w3.org/1999/xlink"
              x="0px"
              y="0px"
              viewBox="0 0 122.88 117.56"
              class="w-[24px] !text-[var(--p-dialog-color)] dark:!text-[var(--p-primary-contrast-color)]"
              fill="currentColor"
              xml:space="preserve"
            >
              <g>
                <path
                  class="st0"
                  d="M69.65,100.54h46.84c0,1.27,0.05,0.9,0.02,2.17c-0.05,2.18-0.54,3.9-1.62,4.99c-1.25,1.01-2.9,1.53-4.91,1.6 l-34.19-0.12c-2.06-0.01-3.52-0.57-4.46-1.49c-0.84-0.81-1.34-1.99-1.55-3.48C69.52,102.5,69.66,102.27,69.65,100.54L69.65,100.54 L69.65,100.54z M40.75,48.94h-14.8c-1.23,0-2.23,1.01-2.23,2.23c0,1.23,1,2.23,2.23,2.23h14.8v6.1h-14.8c-1.23,0-2.23,1-2.23,2.23 s1,2.23,2.23,2.23l14.79,0v6.1h-14.8c-1.23,0-2.23,1.01-2.23,2.23c0,1.23,1.01,2.23,2.23,2.23h14.8v6.1h-14.8 c-1.23,0-2.23,1.01-2.23,2.23c0,1.23,1.01,2.23,2.23,2.23h14.8v1.04l0,0c0,2.78-1.14,5.3-2.97,7.14c-1.83,1.83-4.36,2.98-7.14,2.97 c-3.56,0-7.12,0-10.68,0c-2.35,0-4.57-0.94-6.23-2.6c-1.6-1.6-2.59-3.81-2.6-6.23l0,0V40.25h29.59L40.75,48.94L40.75,48.94 L40.75,48.94z M39.66,35.69V18.72c2.32-0.16,4.41-1.17,5.96-2.73c1.7-1.7,2.75-4.04,2.75-6.62l0,0l0,0c0-2.58-1.06-4.93-2.75-6.63 C43.92,1.05,41.58,0,39,0H13.11C10.54,0,8.2,1.06,6.5,2.76L6.49,2.75C4.8,4.45,3.75,6.8,3.75,9.38l0,0c0,2.58,1.05,4.92,2.75,6.62 c1.46,1.46,3.38,2.43,5.53,2.69l-0.01,17c-3.27,0-6.5,0.11-9.79,0.11C1,35.79,0,36.8,0,38.03c0,1.23,1,2.23,2.23,2.23h5v47.17l0,0 c0,3.51,1.43,6.69,3.74,9c2.31,2.31,5.49,3.74,9,3.74H23l0.01,15.16c0,1.23,1.45,2.23,2.68,2.23s2.68-1,2.68-2.23v-15.17h2.27 c3.85,0,7.36-1.57,9.9-4.12s4.12-6.05,4.12-9.9l0,0V40.27h4.49c1.23,0,2.23-1.01,2.23-2.23c0-1.23-1-2.23-2.23-2.23 C45.96,35.8,42.84,35.69,39.66,35.69L39.66,35.69z M13.11,5.03H39c1.19,0,2.28,0.49,3.07,1.28c0.79,0.79,1.28,1.87,1.28,3.07l0,0 l0,0c0,1.2-0.49,2.28-1.28,3.07c-0.79,0.79-1.87,1.28-3.07,1.28v0H13.11c-1.2,0-2.28-0.49-3.07-1.28 c-0.79-0.79-1.28-1.87-1.28-3.07l0,0c0-1.19,0.49-2.28,1.28-3.07L10.04,6.3C10.83,5.51,11.92,5.03,13.11,5.03L13.11,5.03 L13.11,5.03z M17.05,18.92h17.58v16.12H17.05V18.92L17.05,18.92L17.05,18.92z M90.81,61.48h5.36c1,0,1.82,0.82,1.82,1.82v7.99h7.99 c1,0,1.82,0.82,1.82,1.82v5.36c0,1-0.82,1.82-1.82,1.82H98v7.99c0,1-0.82,1.82-1.82,1.82h-5.36c-1,0-1.82-0.82-1.82-1.82v-7.99H81 c-1,0-1.82-0.82-1.82-1.82v-5.37c0-1,0.82-1.82,1.82-1.82h7.99V63.3C88.99,62.3,89.81,61.48,90.81,61.48L90.81,61.48L90.81,61.48z M116.93,51.06H70.1c0-2.59-0.17-6.33,0.11-8.75c0.88-7.6,4.95-13.06,9.57-19.27c1.01-1.35,2.05-2.76,3.13-4.27h21.11 c0.95,1.32,1.98,2.68,2.99,4.04c4.6,6.12,8.98,11.96,9.79,19.57C116.88,43.13,116.93,51.06,116.93,51.06L116.93,51.06z M73.1,0.75 h41.48c1.73,0,3.29,0.71,4.44,1.85c1.14,1.14,1.85,2.71,1.85,4.44v5.24c0,1.73-0.71,3.29-1.85,4.44c-1.14,1.14-2.71,1.85-4.44,1.85 h-4.05c0.58,0.8,1.17,1.57,1.74,2.34c5.49,7.31,10.71,14.26,10.58,24.41c0,19.42,0.01,38.83,0.01,58.25h0 c0.18,3.67-0.56,6.65-2.52,8.66c-1.97,2-5.04,2.91-9.51,2.44H74.39v-0.01c-3.4,0.1-5.87-0.74-7.56-2.39 c-1.68-1.63-2.51-3.96-2.64-6.86c-0.01-0.07-0.01-0.13-0.01-0.2V47.44c-0.7-11.16,3.98-17.83,10.31-26.33 c0.63-0.84,1.27-1.7,1.9-2.56H73.1c-1.73,0-3.29-0.71-4.44-1.85c-1.14-1.14-1.85-2.71-1.85-4.44V7.03c0-1.73,0.71-3.29,1.85-4.44 C69.8,1.45,71.37,0.75,73.1,0.75L73.1,0.75L73.1,0.75z"
                />
              </g>
            </svg>
            {{ $t("case_history.additional.vaccination_history") }}
          </span>
        </Divider>
        <Panel
          :header="$t('case_history.additional.vaccination_history')"
          toggleable
          v-for="(vaccine, index) in medicalRecord.vaccination_history"
          :key="index"
          class="border rounded-lg shadow p-4"
        >
          <p>
            <strong>{{ $t("case_history.fields.vaccine_name") }}:</strong>
            {{ vaccine.vaccine_name }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.vaccine_date") }}:</strong>
            {{ formatDate(vaccine.vaccine_date) }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.next_due_date") }}:</strong>
            {{ formatDate(vaccine.next_due_date) }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.administered_by") }}:</strong>
            {{ vaccine.administered_by }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.additional_notes") }}:</strong>
            {{ vaccine.notes }}
          </p>
        </Panel>

        <!-- Medication History -->
        <Divider :align="!isRtl ? `left` : `right`" type="solid" id="medications">
          <span class="lg:!text-[14px] text-xl font-bold">
            <i class="fa-solid fa-capsules"></i>
            {{ $t("case_history.additional.medication_history") }}
          </span>
        </Divider>
        <Panel
          :header="$t('case_history.additional.medication_history')"
          toggleable
          v-for="(medication, index) in medicalRecord.medication_history"
          :key="index"
          class="border rounded-lg shadow p-4"
        >
          <p>
            <strong>{{ $t("case_history.fields.medication_name") }}:</strong>
            {{ medication.medication_name }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.medication_type") }}:</strong>
            {{
              $t(
                `case_history.options.medication_type.${medication.medication_type.toLowerCase()}`
              )
            }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.dosage") }}:</strong>
            {{ medication.dosage }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.frequency") }}:</strong>
            {{ medication.frequency }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.medication_start_date") }}:</strong>
            {{ formatDate(medication.start_date) }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.medication_end_date") }}:</strong>
            {{ formatDate(medication.end_date) }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.prescribed_by") }}:</strong>
            {{ medication.prescribed_by }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.additional_notes") }}:</strong>
            {{ medication.notes }}
          </p>
        </Panel>

        <!-- Antiparasitic Treatment -->
        <Divider :align="!isRtl ? `left` : `right`" type="solid" id="antiparasitic">
          <span class="lg:!text-[14px] text-xl font-bold flex gap-2">
            <svg
              class="w-[24px] !text-[var(--p-dialog-color)] dark:!text-[var(--p-primary-contrast-color)]"
              xmlns="http://www.w3.org/2000/svg"
              fill="currentColor"
              viewBox="0 0 576 512"
            >
              <path
                d="M164.5 107.4l33.4-73.5c5.5-12.1 .1-26.3-11.9-31.8s-26.3-.1-31.8 11.9L128 71.7 101.9 14.1C96.4 2 82.1-3.3 70.1 2.1S52.7 21.9 58.1 33.9l33.4 73.5c-10.2 7.1-18.2 17-22.9 28.6l-17 0-4.1-20.7c-2.6-13-15.2-21.4-28.2-18.8S-2.1 111.7 .5 124.7l8 40C10.7 175.9 20.6 184 32 184l32 0 0 23.3-37.8 9.5c-9.5 2.4-16.6 10.2-17.9 19.9l-8 56c-1.9 13.1 7.2 25.3 20.4 27.2s25.3-7.2 27.2-20.4l5.7-40 18.4-4.6C82.7 274.6 103.8 288 128 288s45.3-13.4 56.1-33.2l18.4 4.6 5.7 40c1.9 13.1 14 22.2 27.2 20.4s22.2-14 20.4-27.2l-8-56c-1.4-9.7-8.5-17.5-17.9-19.9L192 207.3l0-23.3 32 0c11.4 0 21.3-8.1 23.5-19.3l8-40c2.6-13-5.8-25.6-18.8-28.2s-25.6 5.8-28.2 18.8L204.3 136l-17 0c-4.7-11.6-12.7-21.5-22.9-28.6zM496 286.5l65.6-47c10.8-7.7 13.3-22.7 5.6-33.5s-22.7-13.3-33.5-5.6l-51.4 36.8 6.1-62.9c1.3-13.2-8.4-24.9-21.6-26.2s-24.9 8.4-26.2 21.6L432.8 250c-12.3 1-24.2 5.6-34.1 13.3L384 254.8l6.8-20c4.2-12.6-2.5-26.2-15-30.4s-26.2 2.5-30.4 15l-13.1 38.6c-3.7 10.8 .8 22.8 10.7 28.5l27.7 16L359 322.7 321.5 312c-9.4-2.7-19.5 .6-25.5 8.3l-34.9 44.5c-8.2 10.4-6.4 25.5 4.1 33.7s25.5 6.4 33.7-4.1l25-31.8 18.2 5.2c-.5 22.6 11 44.7 32 56.8s45.9 11 65.2-.7l13.6 13.2-15.1 37.5c-4.9 12.3 1 26.3 13.3 31.2s26.3-1 31.2-13.3L503.5 440c3.6-9.1 1.4-19.4-5.6-26.2l-28-27.1 11.6-20.1 27.7 16c9.9 5.7 22.5 3.7 30-4.9L566.2 347c8.7-10 7.8-25.1-2.2-33.9s-25.1-7.8-33.9 2.2l-13.9 15.9-14.7-8.5c1.7-12.4-.2-25-5.5-36.2z"
              />
            </svg>
            {{ $t("case_history.additional.antiparasitic_treatment") }}
          </span>
        </Divider>
        <Panel
          :header="$t('case_history.additional.antiparasitic_treatment')"
          toggleable
          v-for="(treatment, index) in medicalRecord.antiparasitic_treatment"
          :key="index"
          class="border rounded-lg shadow p-4"
        >
          <p>
            <strong>{{ $t("case_history.fields.treatment_name") }}:</strong>
            {{ treatment.treatment_name }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.treatment_type") }}:</strong>
            {{
              $t(
                `case_history.options.treatment_type.${treatment.treatment_type.toLowerCase()}`
              )
            }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.dosage") }}:</strong>
            {{ treatment.dosage }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.administration_date") }}:</strong>
            {{ formatDate(treatment.administration_date) }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.next_due_date") }}:</strong>
            {{ formatDate(treatment.next_due_date) }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.administered_by") }}:</strong>
            {{ treatment.administered_by }}
          </p>
          <p>
            <strong>{{ $t("case_history.fields.additional_notes") }}:</strong>
            {{ treatment.notes }}
          </p>
        </Panel>
        <!-- Additional Notes -->
        <Divider :align="!isRtl ? `left` : `right`" type="solid" id="XYZ">
          <span class="lg:!text-[14px] text-xl font-bold"
            ><i class="fa-solid fa-note-sticky"></i>
            {{ $t("medical_examination.sections.notes") }}</span
          >
        </Divider>
        <Panel
          :header="$t('medical_examination.sections.notes')"
          toggleable
          v-for="(note, index) in medicalRecord.additional_note"
          :key="index"
          class="border rounded-lg shadow p-4"
        >
          <p>
            <strong>{{ $t("case_history.fields.additional_notes") }}:</strong>
            {{ note.notes }}
          </p>
        </Panel>

        <!-- Test Results -->
        <Divider :align="!isRtl ? `left` : `right`" type="solid" id="tests">
          <span class="lg:!text-[14px] text-xl font-bold"
            ><i class="fa-solid fa-vials"></i> {{ $t("pet_details.test_results") }}</span
          >
        </Divider>
        <Panel
          :header="$t('pet_details.test_results')"
          toggleable
          v-for="(test, index) in medicalRecord.test_results"
          :key="index"
          class="border rounded-lg shadow p-4"
        >
          <div class="flex flex-wrap w-full">
            <p class="w-[30%]">
              <strong>{{ $t("add_test_result.fields.test_type") }}:</strong>
              {{ test.test_type }}
            </p>
            <div class="w-2/3">
              <strong>{{ $t("add_test_result.fields.test_name") }}:</strong>
              <div
                v-for="(entry, index) in parseResults(test.result)"
                :key="index"
                class="flex gap-2"
              >
                <p class="lg:!text-[14px] !text-sm m-1">
                  <strong>{{ entry.key }}:</strong> {{ entry.value }}
                </p>
              </div>
            </div>
          </div>
        </Panel>

        <!-- Medical Images -->
        <Divider :align="!isRtl ? `left` : `right`" type="solid" id="images">
          <span class="lg:!text-[14px] text-xl font-bold"
            ><i class="fa-solid fa-x-ray text-2xl"></i>
            {{ $t("pet_details.xray_ultrasound") }}
          </span>
        </Divider>
        <div class="flex flex-wrap w-full gap-4">
          <Panel
            :header="$t('pet_details.xray_ultrasound')"
            toggleable
            v-for="(image, index) in medicalRecord.medical_images"
            :key="index"
            class="border rounded-lg shadow p-4 w-[48%]"
          >
            <p>
              <strong>{{ $t("medical_images.headers.type") }}:</strong>
              {{ image.type }}
            </p>
            <p>
              <strong>{{ $t("medical_images.headers.organ") }}:</strong>
              {{ image.organ }}
            </p>
            <p>
              <strong>{{ $t("medical_images.headers.measurements") }}:</strong>
              {{ image.measurements }}
            </p>
            <p>
              <strong>{{ $t("medical_images.headers.description") }}:</strong>
              {{ image.description }}
            </p>
            <p>
              <strong>{{ $t("medical_images.headers.ref_number") }}:</strong>
              {{ image.ref_number }}
            </p>
          </Panel>
        </div>

        <!-- Physical Examination -->
        <Divider :align="!isRtl ? `left` : `right`" type="solid" id="examination">
          <span class="lg:!text-[14px] text-xl font-bold"
            ><i class="fa-solid fa-stethoscope"></i>
            {{ $t("medical_examination.title") }}</span
          >
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
              toggleable
              class="w-[30%] border rounded-lg shadow p-4"
            >
              <template #header>
                <div class="flex items-center gap-2">
                  <i class="fa-solid fa-heart-pulse text-2xl"></i>
                  <span class="font-bold">{{
                    $t("medical_examination.sections.vital_signs")
                  }}</span>
                </div>
              </template>
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
        <!-- Treatments -->
        <Divider :align="!isRtl ? `left` : `right`" type="solid" id="treatments">
          <span class="lg:!text-[14px] text-xl font-bold"
            ><i class="fa-solid fa-syringe"></i> {{ $t("treatments.title") }}</span
          >
        </Divider>
        <div class="flex flex-wrap w-full gap-4">
          <Panel
            :header="$t('treatments.title')"
            toggleable
            v-for="(treatment, index) in medicalRecord.treatments"
            :key="index"
            class="border rounded-lg shadow p-4 w-[48%]"
          >
            <p>
              <strong>{{ $t("case_history.fields.medication_name") }}:</strong>
              {{ treatment.name }}
            </p>
            <p>
              <strong>{{ $t("case_history.fields.dosage") }}:</strong>
              {{ treatment.dosage }}
            </p>
            <p>
              <strong>{{ $t("treatments.headers.delivery") }}:</strong>
              {{ treatment.administration }}
            </p>
            <p>
              <strong>{{ $t("treatments.headers.description") }}:</strong>
              {{ treatment.description }}
            </p>
            <p>
              <strong>{{ $t("case_history.fields.administration_date") }}:</strong>
              {{ formatDate(treatment.treatment_date) }}
            </p>
          </Panel>
        </div>
      </template>
    </Card>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, nextTick, computed } from "vue";
import Card from "primevue/card";
import Divider from "primevue/divider";
import Panel from "primevue/panel";
import Button from "primevue/button";
import axiosInstance from "@/axios";
import { useI18n } from "vue-i18n";
const { t, locale } = useI18n();

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
const isRtl = computed(() => ["ar", "he", "fa"].includes(locale.value));

const sections = [
  { id: "general-info", label: "medical_examination_form.section_titles.general_info" },
  { id: "symptoms", label: "case_history.steps.current_symptoms" },
  { id: "health", label: "case_history.steps.general_health" },
  { id: "reproductive", label: "case_history.steps.reproductive_history" },
  { id: "itching", label: "case_history.steps.itching_skin" },
  { id: "diet", label: "case_history.steps.diet_water" },
];
const medicalRecord = ref({
  medical_examinations: [],
  current_symptom: [],
  general_health: [],
  reproductive_history: [],
  itching_skin_condition: [],
  diet_water_intake: [],
  gastrointestinal_symptom: [],
  neurological_symptom: [],
  respiratory_symptom: [],
  urinary_symptom: [],
  vaccination_history: [],
  medication_history: [],
  antiparasitic_treatment: [],
  additional_note: [],
  test_results: [],
  medical_images: [],
  treatments: [],
});
const parseResults = (resultsString) => {
  if (!resultsString) return [];
  try {
    // Directly parse the JSON array
    const results = JSON.parse(resultsString);
    return results.map((result) => {
      const parts = result.split(":");

      return { key: parts[0].trim(), value: parts[1].trim() };
    });
  } catch (error) {
    console.error("Error parsing results:", error);
    return [];
  }
};

const fetchMedicalRecord = async () => {
  try {
    const response = await axiosInstance.get(
      // `/medical-records/31/full`
      `/medical-records/${props.medical_record_id}/full`
    );
    medicalRecord.value = response.data;
  } catch (error) {
    console.error("Error fetching medical record:", error);
  }
};

// Helper function to format dates
const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString();
};
const activeSection = ref("general-info"); // Default to first section

const observer = ref(null);

const setupScrollTracking = () => {
  const container = document.querySelector(".p-dialog-content");
  if (!container) return;

  const onScroll = () => {
    const sectionElements = sections
      .map((s) => ({
        id: s.id,
        el: document.getElementById(s.id),
      }))
      .filter((s) => s.el);

    const containerRect = container.getBoundingClientRect();

    const visibleSections = sectionElements
      .map(({ id, el }) => {
        const rect = el.getBoundingClientRect();
        const offset = Math.abs(rect.top - containerRect.top);
        return { id, offset, top: rect.top, height: rect.height };
      })
      .filter(({ top, height }) => {
        // Only consider sections that are at least partially visible
        return top < containerRect.bottom && top + height > containerRect.top;
      })
      .sort((a, b) => a.offset - b.offset); // closest to top of container

    if (visibleSections.length > 0) {
      activeSection.value = visibleSections[0].id;
    }
  };

  container.addEventListener("scroll", onScroll);
  // Trigger once on load
  requestAnimationFrame(onScroll);

  // Clean up
  onUnmounted(() => {
    container.removeEventListener("scroll", onScroll);
  });
};
function printComponent() {
  // Get the printable content
  const printContent = document.getElementById("printable");

  if (!printContent) {
    console.error("Printable element not found");
    return;
  }

  // Create a new window for printing
  // const printWindow = window.open('', '_blank');
  const printWindow = window.open(
    URL,
    t("medical_examination.title") + " - " + props.pet_name,
    "width=500,height=600,left=100,top=100"
  );

  // Write the HTML content to the new window
  printWindow.document.write(`
    <!DOCTYPE html>
    <html>
      <head>
        <title>Print Report</title>
            <script src="https://cdn.tailwindcss.com"><\/script>

        <style>
          body { font-family: Arial, sans-serif; margin: 0; padding: 20px; }
          h1, h2, h3, h4 { color: #333; }
          .section { margin-bottom: 30px; }
          .panel { border: 1px solid #ddd; border-radius: 5px; padding: 15px; margin-bottom: 15px; }
          .flex-row { display: flex; flex-wrap: wrap; gap: 15px; }
          .w-30 { width: 30%; }
          .w-48 { width: 48%; }
          .w-full { width: 100%; }
          .border { border: 1px solid #eee; }
          .shadow { box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
          .p-4 { padding: 1rem; }
          .rounded-lg { border-radius: 0.5rem; }
          .font-bold { font-weight: bold; }
          .text-sm { font-size: 0.875rem; }
          .text-xl { font-size: 1.25rem; }
          .gap-4 { gap: 1rem; }
          .flex-wrap { flex-wrap: wrap; }
          @media print {
            body { padding: 0; }
            .no-print { display: none !important; }
            .page-break { page-break-after: always; }
          }
        </style>
      </head>
      <body dir="${!isRtl ? `ltr` : `rtl`}" >
        ${printContent.innerHTML}
        <script>
          // Close the window after printing
          window.onload = function() {
                      setTimeout(function() {
                        window.print();
                        setTimeout(function() {
                          window.close();
                        }, 500);
                      }, 500);
                    };
        <\/script>
      </body>
    </html>
  `);

  printWindow.document.close();
}

onMounted(async () => {
  await fetchMedicalRecord();
  nextTick(() => {
    setupScrollTracking();
  });
});
onUnmounted(() => {
  if (observer.value) {
    observer.value.disconnect();
  }
});
</script>

<style scoped>
/* Add custom styles if needed */
@media print {
  body * {
    visibility: hidden;
  }

  #printable,
  #printable * {
    visibility: visible;
  }
}
</style>
