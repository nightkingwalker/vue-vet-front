<template>
  <div class="w-full">
    <h4 class="mt-2 mb-4 mx-auto flex items-center justify-center">
      <i class="pi pi-calendar"></i> {{ $t("reports.menu.patients_reports") }}
    </h4>
    <DataTable
      :value="loading ? skeletonRows : appointments"
      class="rounded-lg overflow-hidden text-xs"
      stripedRows
      showGridlines
      scrollable
      scrollHeight="95vh"
      :paginator="true"
      :rows="10"
      :rowsPerPageOptions="[10, 25, 50]"
      v-model:first="first"
      paginatorTemplate="FirstPageLink PrevPageLink PageLinks NextPageLink LastPageLink CurrentPageReport RowsPerPageDropdown"
      currentPageReportTemplate="Showing {first} to {last} of {totalRecords} entries"
      :sortField="sortField"
      :sortOrder="sortOrder"
      @sort="onSort"
    >
      <template #empty> {{ $t("appointments.no_appointments") }} </template>
      <template #loading> {{ $t("appointments.loading") }} </template>
      <template #header>
        <div class="flex justify-between items-center !m-b-1">
          <div class="flex items-center gap-2">
            <InputGroup
              class="!text-gray-800 flex !w-1/3 !h-10 rounded-md overflow-hidden border !border-gray-400"
            >
              <InputGroupAddon
                class="!text-gray-800 px-4 flex flex-col item-center justify-center"
              >
                <i class="pi pi-search"></i>
              </InputGroupAddon>
              <InputText
                size="small"
                v-model="searchQuery"
                fluid
                @keyup.enter="applyFilters"
                ref="inputRef"
                @focus="inputFocused = true"
                @blur="inputFocused = false"
                autofocus="true"
                type="text"
                class="!text-sm lg:!text-[14px] !text-gray-800 focus:!ring-0 focus:!ring-offset-0 border-transparent"
                :placeholder="$t('appointments.header.search_placeholder')"
              />
              <Button icon="pi pi-times" @click="clearFilters" />
            </InputGroup>

            <Select
              v-model="selectedStatus"
              :options="statusOptions"
              optionLabel="label"
              :placeholder="$t('appointments.filter.status')"
              class="!text-xs !h-10 w-40"
            />

            <Select
              v-model="selectedType"
              :options="typeOptions"
              optionLabel="label"
              :placeholder="$t('appointments.filter.type')"
              class="!text-xs !h-10 w-40"
            />

            <DatePicker
              v-model="dateRange"
              selectionMode="range"
              :manualInput="false"
              dateFormat="yy-mm-d"
              size="small"
              :placeholder="$t('appointments.filter.date_range')"
              class="!text-xs !h-10 w-60"
            />

            <Button
              icon="pi pi-filter"
              @click="applyFilters"
              :label="$t('appointments.filter.apply')"
              class="!text-xs lg:!text-[14px] ml-2"
            />

            <Button
              icon="pi pi-times"
              @click="clearFilters"
              :label="$t('appointments.filter.clear')"
              class="!text-xs lg:!text-[14px] w-fit whitespace-nowrap ml-2 p-button-outlined"
            />
            <Button
              type="button"
              icon="pi pi-refresh !text-xs"
              label=""
              v-tooltip.bottom="$t('appointments.refresh')"
              class="!text-xs !w-8 !h-8"
              @click="fetchAppointments(currentPage)"
            />
          </div>

          <h2 class="text-sm !mb-0 pb-0 flex">
            <i class="fa-solid fa-calendar-days ltr:mr-2 rtl:ml-2"></i>
            {{ $t("appointments.title") }}
          </h2>
        </div>
      </template>

      <Column
        field="start"
        :header="$t('appointments.headers.date')"
        class="w-1/10"
        sortable
      >
        <template v-if="loading" #body>
          <Skeleton width="100%" height="1rem" />
        </template>
        <template v-else #body="slotProps">
          {{ formatDateTime(slotProps.data.start) }}
        </template>
      </Column>

      <Column
        field="pet.name"
        :header="$t('appointments.headers.pet')"
        class="w-1/10"
        sortable
      >
        <template v-if="loading" #body>
          <Skeleton width="100%" height="1rem" />
        </template>
        <template v-else #body="slotProps">
          {{ slotProps.data.pet.name }}
          <Tag :value="slotProps.data.pet.species" severity="info" class="ml-2" />
        </template>
      </Column>

      <Column
        field="owner.name"
        :header="$t('appointments.headers.owner')"
        class="w-1/10"
        sortable
      >
        <template v-if="loading" #body>
          <Skeleton width="100%" height="1rem" />
        </template>
        <template v-else #body="slotProps">
          <div class="flex flex-col">
            <span>{{ slotProps.data.owner.name }}</span>
          </div>
        </template>
      </Column>

      <Column
        field="title"
        :header="$t('appointments.headers.title')"
        class="w-1/5"
        sortable
      >
        <template v-if="loading" #body>
          <Skeleton width="100%" height="1rem" />
        </template>
        <template v-else #body="slotProps">
          {{ slotProps.data.title }}
        </template>
      </Column>

      <Column
        field="type"
        :header="$t('appointments.headers.type')"
        class="w-1/10"
        sortable
      >
        <!-- <template v-if="loading" #body>
          <Skeleton width="100%" height="1rem" />
        </template>
        <template v-else #body="slotProps">
          <Tag
            :value="slotProps.data.type"
            :severity="getAppointmentTypeSeverity(slotProps.data.type)"
          />
        </template> -->
        <template v-if="loading" #body>
          <Skeleton width="100%" height="1rem" />
        </template>
        <template v-else #body="slotProps">
          <Tag
            class="shadow-md border-gray-500 rtl:border-r-2 rtl:border-r-[var(--border-color)] border-l-2 border-l-[var(--border-color)]"
            :style="{
              '--border-color': getEventTheme(slotProps.data.type).lightColors.main,
              '--background-color': getEventTheme(slotProps.data.type).lightColors
                .container,
              '--text-color': getEventTheme(slotProps.data.type).lightColors.onContainer,
              background: `var(--background-color)`,
              color: `var(--text-color)`,
            }"
          >
            <div class="gap-2 px-1">
              <span class="lg:!text-[14px] text-xs whitespace-nowrap font-normal">{{
                $t(`calendar.appointment.${slotProps.data.type.toLowerCase()}`)
              }}</span>
            </div>
          </Tag>
        </template>
      </Column>

      <Column
        field="status"
        :header="$t('appointments.headers.status')"
        class="w-1/10"
        sortable
      >
        <template v-if="loading" #body>
          <Skeleton width="100%" height="1rem" />
        </template>
        <template v-else #body="slotProps">
          <Tag
            :value="
              appointmentScheduleTypes[slotProps.data.status] || slotProps.data.status
            "
            :severity="getAppointmentStatusSeverity(slotProps.data.status)"
          />
        </template>
      </Column>

      <Column
        field="description"
        :header="$t('appointments.headers.description')"
        class="w-1/5"
      >
        <template v-if="loading" #body>
          <Skeleton width="100%" height="1rem" />
        </template>
        <template v-else #body="slotProps">
          {{ slotProps.data.description }}
        </template>
      </Column>

      <Column :header="$t('appointments.headers.actions')" class="w-1/10">
        <template v-if="loading" #body>
          <Skeleton width="100%" height="1rem" />
        </template>
        <template v-else #body="slotProps">
          <!-- <Button
            v-if="slotProps.data.medicalrecord"
            icon="pi pi-file-medical"
            @click="viewMedicalRecord(slotProps.data.id)"
            v-tooltip.top="$t('appointments.view_record')"
            class="!text-xs !text-primary"
            text
          /> -->
          <router-link
            :to="`/pets/` + slotProps.data.pet.microchip_num"
            v-tooltip.top="{
              value: $t('pets.columns.view_details'),
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
            ><i class="fas fa-paw"></i>
          </router-link>
        </template>
      </Column>
    </DataTable>

    <Dialog
      :header="$t('medical_records.dialog.view_title')"
      v-model:visible="medicalRecordDialogVisible"
      modal
      :closable="true"
      class="w-11/12 md:w-8/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)]"
    >
      <PetDetails v-if="selectedMedicalRecord" :microchip_num="microchip_num" />
    </Dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useI18n } from "vue-i18n";
import DataTable from "primevue/datatable";
import Column from "primevue/column";
import Select from "primevue/select";
import Skeleton from "primevue/skeleton";
import Button from "primevue/button";
import Tag from "primevue/tag";
import DatePicker from "primevue/datepicker";
import InputText from "primevue/inputtext";
import InputGroupAddon from "primevue/inputgroupaddon";
import InputGroup from "primevue/inputgroup";
import Dialog from "primevue/dialog";
import PetDetails from "@/views/PetDetails.vue";
import axiosInstance from "@/axios";
import eventBus from "@/eventBus";

const { t } = useI18n();
const appointments = ref([]);
const loading = ref(false);
const first = ref(0);
const itemsPerPage = ref(10);
const totalRecords = ref(0);
const currentPage = ref(1);
const dateRange = ref(null);
const searchQuery = ref("");
const sortField = ref("start");
const sortOrder = ref(-1);

const skeletonRows = Array.from({ length: 10 }).map(() => ({
  id: "",
  title: "",
  start: "",
  end: "",
  status: "",
  type: "FollowUp",
  description: "",
  pet: { name: "", species: "" },
  owner: { name: "", phone: "" },
  medicalrecord: null,
}));

// Status filter options
const statusOptions = ref([
  { label: t("appointments.statuses.all"), value: null },
  { label: t("appointments.statuses.scheduled"), value: "Scheduled" },
  { label: t("appointments.statuses.walkin"), value: "Walkin" },
  { label: t("appointments.statuses.completed"), value: "Completed" },
  { label: t("appointments.statuses.cancelled"), value: "Cancelled" },
]);

// Type filter options
const typeOptions = ref([
  { label: t("appointments.types.all"), value: null },
  { label: t("appointments.types.regular"), value: "Regular" },
  { label: t("appointments.types.emergency"), value: "Emergency" },
  { label: t("appointments.types.followup"), value: "FollowUp" },
  { label: t("appointments.types.grooming"), value: "Grooming" },
  { label: t("appointments.types.non_emergency"), value: "Non-Emergency" },
]);

const selectedStatus = ref(statusOptions.value[0]);
const selectedType = ref(typeOptions.value[0]);

const medicalRecordDialogVisible = ref(false);
const selectedMedicalRecord = ref(null);

const fetchAppointments = async (page = 1) => {
  try {
    loading.value = true;
    let url = `/appointments/reports?page=${page}&per_page=${itemsPerPage.value}`;

    // Add search query if exists
    if (searchQuery.value) {
      url += `&search=${searchQuery.value}`;
    }

    // Add status filter if selected
    if (selectedStatus.value.value) {
      url += `&status=${selectedStatus.value.value}`;
    }

    // Add type filter if selected
    if (selectedType.value.value) {
      url += `&type=${selectedType.value.value}`;
    }

    // Add date range filter if selected
    if (dateRange.value && dateRange.value.length === 2) {
      url += `&start_date=${formatDateForAPI(dateRange.value[0])}`;
      url += `&end_date=${formatDateForAPI(dateRange.value[1])}`;
    }

    // Add sorting parameters
    if (sortField.value) {
      url += `&sort_field=${sortField.value}`;
      url += `&sort_order=${sortOrder.value === 1 ? "asc" : "desc"}`;
    }
    console.log(url);
    const response = await axiosInstance.get(url);
    appointments.value = response.data.data;
    totalRecords.value = response.data.totalRecords;
    currentPage.value = page;
  } catch (error) {
    console.error("Error fetching appointments:", error);
  } finally {
    loading.value = false;
  }
};

const applyFilters = () => {
  fetchAppointments(1); // Reset to first page when applying new filters
};

const clearFilters = () => {
  dateRange.value = null;
  searchQuery.value = "";
  selectedStatus.value = statusOptions.value[0];
  selectedType.value = typeOptions.value[0];
  fetchAppointments(1);
};

const onSort = (event) => {
  sortField.value = event.sortField;
  sortOrder.value = event.sortOrder;
  fetchAppointments(currentPage.value);
};

const formatDateTime = (dateTimeString) => {
  const date = new Date(dateTimeString);
  return (
    date.toLocaleDateString() +
    " " +
    date.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" })
  );
};

const formatDateForAPI = (date) => {
  return date.toISOString().split("T")[0];
};

// const getAppointmentTypeSeverity = (type) => {
//   switch (type) {
//     case "Emergency":
//       return "danger";
//     case "FollowUp":
//       return "info";
//     case "Grooming":
//       return "warning";
//     case "Regular":
//       return "success";
//     case "Non-Emergency":
//       return "help";
//     default:
//       return null;
//   }
// };
const appointmentScheduleTypes = ref({
  Scheduled: t("appointments.statuses.scheduled"),
  Walkin: t("appointments.statuses.walkin"),
});

const eventTheme = {
  Regular: {
    colorName: "Regular",
    lightColors: {
      main: "#f9d71c",
      container: "#fff5aa",
      onContainer: "#594800",
    },
    darkColors: {
      main: "#fff5c0",
      onContainer: "#fff5de",
      container: "#a29742",
    },
  },
  Emergency: {
    colorName: "Emergency",
    lightColors: {
      main: "#f91c45",
      container: "#ffd2dc",
      onContainer: "#59000d",
    },
    darkColors: {
      main: "#ffc0cc",
      onContainer: "#ffdee6",
      container: "#a24258",
    },
  },
  "Non-Emergency": {
    colorName: "Non-Emergency",
    lightColors: {
      main: "#1db954", // Vibrant green (similar to Spotify's green)
      container: "#86e8b6", // Very light mint green
      onContainer: "#064e3b", // Dark green (for text on container)
    },
    darkColors: {
      main: "#a7f3d0", // Soft mint green
      onContainer: "#86e8b6", // Very light mint green
      container: "#065f46", // Deep emerald green
    },
  },

  FollowUp: {
    colorName: "FollowUp",
    lightColors: {
      main: "#1cf9b0",
      container: "#dafff0",
      onContainer: "#004d3d",
    },
    darkColors: {
      main: "#c0fff5",
      onContainer: "#e6fff5",
      container: "#42a297",
    },
  },
  Surgery: {
    colorName: "Surgery",
    lightColors: {
      main: "#1c7df9",
      container: "#d2e7ff",
      onContainer: "#002859",
    },
    darkColors: {
      main: "#c0dfff",
      onContainer: "#dee6ff",
      container: "#426aa2",
    },
  },
  Grooming: {
    colorName: "Grooming",
    lightColors: {
      main: "#8A2BE2",
      container: "#E6D6FF",
      onContainer: "#3E0071",
    },
    darkColors: {
      main: "#c0dfff",
      onContainer: "#dee6ff",
      container: "#426aa2",
    },
  },
  Default: {
    colorName: "Default",
    lightColors: {
      main: "#6b7280",
      container: "#e5e7eb",
      onContainer: "#111827",
    },
    darkColors: {
      main: "#9ca3af",
      onContainer: "#f3f4f6",
      container: "#4b5563",
    },
  },
};

function getEventTheme(themeName) {
  // console.log(themeName);
  return eventTheme[themeName] || eventTheme.Default; // Return the corresponding theme or null if not found
}

const getAppointmentStatusSeverity = (status) => {
  switch (status) {
    case "Scheduled":
      return "info";
    case "Walkin":
      return "warning";
    case "Completed":
      return "success";
    case "Cancelled":
      return "danger";
    default:
      return null;
  }
};

const viewMedicalRecord = async (appointmentId) => {
  // try {
  //   const response = await axiosInstance.get(`/medical-records/${appointmentId}`);
  //   selectedMedicalRecord.value = response.data.data;
  //   medicalRecordDialogVisible.value = true;
  // } catch (error) {
  //   console.error("Error fetching medical record:", error);
  // }
};

onMounted(() => {
  fetchAppointments();
  eventBus.on("appointmentAdded", () => {
    fetchAppointments();
  });
});
</script>

<style scoped>
/* Custom styles if needed */
</style>
