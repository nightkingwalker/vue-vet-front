<template>
  <DataTable
    :value="loading ? skeletonRows : medicalRecords"
    class="mx-4 rounded-lg overflow-hidden text-xs"
    stripedRows
    showGridlines
    scrollable
    scrollHeight="400px"
  >
    <template #empty> {{ $t("test_results.no_results") }} </template>

    <template #header>
      <div class="flex justify-between items-center !m-b-1">
        <div class="flex">
          <Button
            type="button"
            icon="pi pi-refresh !text-xs"
            label=""
            v-tooltip.bottom="$t('test_results.refresh')"
            class="!text-xs ml-2 !w-8 !h-8"
            @click="refreshData"
          />
          <Button
            icon="pi pi-plus"
            @click="showAddTestResultModal"
            v-tooltip.bottom="$t('test_results.add')"
            class="p-button p-component p-button-icon-only !text-xs !w-8 !h-8 ml-2"
          />
        </div>
        <h2 class="text-sm !mb-0 pb-0 flex">
          <i class="fa-solid fa-paw ltr:mr-2 rtl:ml-2"></i>
          {{ $t("test_results.title") }}
        </h2>
      </div>
    </template>

    <Column field="test_type" :header="$t('test_results.headers.test')" class="w-1/5">
      <template v-if="loading" #body>
        <Skeleton width="100%" height="1rem" />
      </template>
      <template v-else #body="slotProps">
        {{ slotProps.data.test_type }}
      </template>
    </Column>
    <Column field="result" :header="$t('test_results.headers.result')" class="w-1/5">
      <template v-if="loading" #body>
        <Skeleton width="100%" height="1rem" />
      </template>
      <template v-else #body="slotProps">
        <div
          v-for="(entry, index) in parseResults(slotProps.data.result)"
          :key="index"
          class="flex gap-2"
        >
          <p class="!text-sm m-1">
            <strong>{{ entry.key }}:</strong> {{ entry.value }}
          </p>
        </div>
      </template>
    </Column>
    <Column header="Data" class="whitespace-nowrap w-[10%]">
      <template #body="slotProps">
        <Button
          type="button"
          icon="fa-solid fa-pencil !text-primary"
          v-tooltip.top="{
            value: $t('test_results.actions.edit'),
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
          variant="text"
          size="small"
          class="!text-xs !text-primary"
          @click="showEditTestResultModal(slotProps.data.id)"
        />
        <Button
          icon="fa-solid fa-times !text-primary"
          v-tooltip.top="{
            value: $t('test_results.actions.delete'),
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
          variant="text"
          size="small"
          class="!text-x !text-primary"
          @click.prevent="confirmDelete(slotProps.data.id)"
          v-if="slotProps.data.type !== `Grooming`"
        />
      </template>
    </Column>
  </DataTable>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useI18n } from "vue-i18n";
import DataTable from "primevue/datatable";
import Column from "primevue/column";
import Skeleton from "primevue/skeleton";
import Button from "primevue/button";
import eventBus from "@/eventBus";
import axiosInstance from "@/axios";
import { useConfirm } from "primevue/useconfirm";

const { t } = useI18n();
const confirm = useConfirm();
const medicalRecords = ref();
const loading = ref(false);
const emit = defineEmits();

const props = defineProps({
  medical_record_id: {
    type: Number,
    required: true,
  },
});

const skeletonRows = Array.from({ length: 4 }).map(() => ({
  test_type: "",
  result: "",
}));

const parseResults = (resultsString) => {
  if (!resultsString) return [];
  try {
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

const fetchTestResults = async () => {
  loading.value = true;
  try {
    const response = await axiosInstance.get(
      `/test-results/bymrid/${props.medical_record_id}`
    );
    medicalRecords.value = response.data.data;
    loading.value = false;
  } catch (error) {
    console.error("Error fetching test results:", error);
  } finally {
    loading.value = false;
  }
};

const showAddTestResultModal = () => {
  emit("showAddTestResultModal");
};

const showEditTestResultModal = (testResultId) => {
  emit("showEditTestResultModal", testResultId);
};

const refreshData = () => {
  loading.value = true;
  fetchTestResults();
};

const confirmDelete = (testResultId) => {
  confirm.require({
    message: t("test_results.delete_confirm.message"),
    header: t("test_results.delete_confirm.header"),
    icon: "pi pi-exclamation-triangle",
    acceptClass: "p-button-danger",
    accept: () => {
      deleteTestResult(testResultId);
    },
    reject: () => {
      
    },
  });
};

const deleteTestResult = async (testResultId) => {
  try {
    const response = await axiosInstance.delete(`/test-results/${testResultId}`);
    fetchTestResults();
    eventBus.emit("TestResultDeletedSuccessfully");
  } catch (error) {
    console.error("Failed to delete test result:", error);
  }
};

onMounted(() => {
  fetchTestResults();
  eventBus.on("newTestResultAdded", () => {
    fetchTestResults();
  });
  eventBus.on("handleTestResultUpdatedSuccessfully", () => {
    fetchTestResults();
  });
});
</script>
