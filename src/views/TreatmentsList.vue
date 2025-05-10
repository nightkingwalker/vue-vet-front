<template>
  <DataTable
    :value="loading ? skeletonRows : medicalRecords"
    class="mx-4 rounded-lg overflow-hidden text-xs mb-4"
    stripedRows
    scrollable
    showGridlines
    scrollHeight="400px"
  >
    <template #empty> {{ $t("treatments.no_treatments") }} </template>
    <template #header>
      <div class="flex justify-between items-center !m-b-1">
        <div class="flex">
          <Button
            type="button"
            icon="pi pi-refresh !text-xs"
            label=""
            v-tooltip.bottom="$t('treatments.refresh')"
            class="!text-xs ml-2 !w-8 !h-8"
            @click="refreshData"
          />
          <Button
            icon="pi pi-plus"
            @click="showAddTreatmentModal"
            v-tooltip.bottom="$t('treatments.add')"
            class="p-button p-component p-button-icon-only !text-xs !w-8 !h-8 ml-2"
          />
        </div>
        <h2 class="text-sm !mb-0 pb-0 flex">
          <i class="fa-solid fa-paw ltr:mr-2 rtl:ml-2"></i>
          {{ $t("treatments.title") }}
        </h2>
      </div>
    </template>

    <Column field="treatment_date" :header="$t('treatments.headers.date')" class="w-1/5">
      <template v-if="loading" #body>
        <Skeleton width="100%" height="1rem" />
      </template>
      <template v-else #body="slotProps">
        {{ slotProps.data.treatment_date }}
      </template>
    </Column>
    <Column field="name" :header="$t('treatments.headers.treatment')" class="w-1/5">
      <template v-if="loading" #body>
        <Skeleton width="100%" height="1rem" />
      </template>
      <template v-else #body="slotProps"> {{ slotProps.data.name }}</template>
    </Column>
    <Column field="dosage" :header="$t('treatments.headers.dosage')" class="w-1/5">
      <template v-if="loading" #body>
        <Skeleton width="100%" height="1rem" />
      </template>
      <template v-else #body="slotProps"> {{ slotProps.data.dosage }}</template>
    </Column>
    <Column
      field="administration"
      :header="$t('treatments.headers.delivery')"
      class="w-1/5"
    >
      <template v-if="loading" #body>
        <Skeleton width="100%" height="1rem" />
      </template>
      <template v-else #body="slotProps">
        {{
          $t(
            "add_treatment.administration_methods." +
              slotProps.data.administration.toLowerCase()
          )
        }}</template
      >
    </Column>
    <Column
      field="description"
      :header="$t('treatments.headers.description')"
      class="font-normal"
    >
      <template v-if="loading" #body>
        <Skeleton width="100%" height="1rem" />
      </template>
      <template v-else #body="slotProps">
        {{ slotProps.data.description }}
      </template>
    </Column>
    <Column header="Data" class="whitespace-nowrap">
      <template #body="slotProps">
        <Button
          type="button"
          icon="fa-solid fa-pencil !text-primary"
          v-tooltip.top="{
            value: $t('treatments.actions.edit'),
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
          @click="showEditTreatmentModal(slotProps.data.id)"
        />
        <Button
          icon="fa-solid fa-times !text-primary"
          v-tooltip.top="{
            value: $t('treatments.actions.delete'),
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
import { ref, onMounted, onUnmounted } from "vue";
import { useI18n } from "vue-i18n";
import DataTable from "primevue/datatable";
import Column from "primevue/column";
import Button from "primevue/button";
import Skeleton from "primevue/skeleton";
import eventBus from "@/eventBus";
import axiosInstance from "@/axios";
import { useConfirm } from "primevue/useconfirm";

const { t } = useI18n();
const confirm = useConfirm();
const medicalRecords = ref();
const loading = ref(false);
const props = defineProps({
  medical_record_id: {
    type: Number,
    required: true,
  },
});

const skeletonRows = Array.from({ length: 4 }).map(() => ({
  treatment_date: "",
  name: "",
  dosage: "",
  description: "",
}));

const fetchTreatments = async () => {
  loading.value = true;
  try {
    const response = await axiosInstance.get(
      `/treatments/bymrid/${props.medical_record_id}`
    );
    medicalRecords.value = response.data.data;
    loading.value = false;
  } catch (error) {
    // Error handling
  } finally {
    loading.value = false;
  }
};

const emit = defineEmits();

const showAddTreatmentModal = () => {
  emit("showAddTreatmentModal");
};

const showEditTreatmentModal = (treatmentId) => {
  emit("showEditTreatmentModal", treatmentId);
};

const refreshData = () => {
  loading.value = true;
  fetchTreatments();
};

const confirmDelete = (treatmentId) => {
  confirm.require({
    message: t("treatments.delete_confirm.message"),
    header: t("treatments.delete_confirm.header"),
    icon: "pi pi-exclamation-triangle",
    acceptClass: "p-button-danger",
    accept: () => {
      deleteTreatment(treatmentId);
    },
    reject: () => {
      // console.log("Deletion cancelled");
    },
  });
};

const deleteTreatment = async (treatmentId) => {
  try {
    const response = await axiosInstance.delete(`/treatments/${treatmentId}`);
    fetchTreatments();
    eventBus.emit("TreatmentDeletedSuccessfully");
  } catch (error) {
    console.error("Failed to delete treatment:", error);
  }
};

onMounted(() => {
  fetchTreatments();

  eventBus.on("newTreatmentAdded", () => {
    fetchTreatments();
  });

  eventBus.on("TreatmentUpdatedSuccessfully", () => {
    fetchTreatments();
  });
});

onUnmounted(() => {
  eventBus.off("newTreatmentAdded");
  eventBus.off("TreatmentUpdatedSuccessfully");
});
</script>
