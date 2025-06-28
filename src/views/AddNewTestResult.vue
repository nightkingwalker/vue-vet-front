<template>
  <div class="w-full">
    <form @submit.prevent="submitForm" class="mt-2 md:mx-auto md:w-3/4 sm:mx-8 sm:w-full">
      <fieldset
        class="p-fieldset p-component w-full flex flex-col items-center border rounded-lg p-2 justify-start gap-x-2"
      >
        <legend>{{ $t("add_test_result.title") }}</legend>

        <div class="field mt-4 w-full">
          <FloatLabel class="w-full md:w-56">
            <InputText id="test_type" v-model="test.test_type" />
            <label for="test_type">{{ $t("add_test_result.fields.test_type") }}</label>
          </FloatLabel>
        </div>

        <div class="flex flex-wrap gap-1 test-results-container w-full">
          <div
            v-for="(result, index) in test.results"
            :key="index"
            class="field lg:w-[48%] flex !gap-1 items-start mt-6 justify-between !text-xs"
          >
            <div class="flex flex-col md:w-[80%] sm:w-full">
              <FloatLabel class="max-w-[100%]">
                <InputText
                  :id="'label-' + index"
                  v-model="test.results[index].label"
                  class="md:w-[100%]"
                />
                <label :for="'label-' + index">
                  {{ $t("add_test_result.fields.test_name", { index: index + 1 }) }}
                </label>
              </FloatLabel>
              <FloatLabel class="max-w-[100%] mt-6">
                <InputText
                  :id="'value-' + index"
                  v-model="test.results[index].value"
                  class="md:w-[100%]"
                />
                <label :for="'value-' + index">
                  {{ $t("add_test_result.fields.test_value", { index: index + 1 }) }}
                </label>
              </FloatLabel>
            </div>
            <Button
              icon="pi pi-times"
              class="p-button-danger !text-[10px] m-0 w-6 h-8 p-2"
              @click="removeResult(index)"
            />
          </div>
        </div>

        <div class="flex items-center mt-4">
          <Button :label="$t('add_test_result.buttons.add_result')" @click="addResult" />
        </div>
      </fieldset>
      <div class="flex justify-end">
        <Button type="submit" :disabled="isSubmitting ? true : false">
          <i class="fa-solid fa-spinner fa-spin" v-if="isSubmitting"></i>
          <span v-else>{{ $t("add_test_result.buttons.submit") }}</span>
        </Button>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref } from "vue";
import { useI18n } from "vue-i18n";
import InputText from "primevue/inputtext";
import FloatLabel from "primevue/floatlabel";
import Button from "primevue/button";
import axiosInstance from "@/axios";
import eventBus from "@/eventBus";
import { useRoute } from "vue-router";

const { t } = useI18n();
const emit = defineEmits();
const route = useRoute();

const props = defineProps({
  medical_record_id: {
    type: Number,
    required: true,
  },
});
const isSubmitting = ref(false);
const test = ref({
  medical_record_id: props.medical_record_id,
  test_type: "",
  results: [{ label: "", value: "" }],
});

const addResult = () => {
  test.value.results.push({ label: "", value: "" });
};

const removeResult = (index) => {
  test.value.results.splice(index, 1);
};

const submitForm = async () => {
  if (isSubmitting.value) return;
  const formattedResults = test.value.results
    .filter((result) => result.label && result.value)
    .map((result) => `"${result.label}: ${result.value}"`)
    .join(", ");
  const resultString = `[${formattedResults}]`;
  const submissionData = {
    medical_record_id: test.value.medical_record_id,
    test_type: test.value.test_type,
    result: resultString,
  };

  try {
    isSubmitting.value = true;
    const response = await axiosInstance.post("/test-results", submissionData);
    eventBus.emit("show-toast", {
      severity: "success",
      summary: t("add_test_result.title"),
      detail: t("add_test_result.toast.success"),
      life: 5000,
    });
    isSubmitting.value = false;
    emit("TestResultAdded", response.data);
  } catch (error) {
    eventBus.emit("show-toast", {
      severity: "warn",
      summary: t("add_test_result.title"),
      detail: t("add_test_result.toast.error"),
      life: 5000,
    });
    isSubmitting.value = false;
  }
};
</script>

<style scoped>
.form-container {
  margin: auto;
}
.field {
  margin-bottom: 16px;
}
.p-fieldset-content {
  display: flex;
}
</style>
