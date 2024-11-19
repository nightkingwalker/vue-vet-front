<template>
  <div class="w-full">
    <DataTable
      id="petlist"
      ref="dt"
      :value="loading ? skeletonRows : pets"
      :row-hover="true"
      :loading="loading"
      :metaKeySelection="metaKey"
      sortMode="multiple"
      exportFilename="Patients_Details"
      removableSort
      stripedRows
      v-model:selection="selectedPets"
      highlightOnSelect
      dataKey="id"
      @rowSelect="onSelectionChange"
      :exportFunction="beforeExportFunction"
      responsiveLayout="scroll"
      class="rounded-xl 2xl:overflow-y-scroll drop-shadow-md mt-4 h-[95vh]"
      :size="small"
    >
      <TableHeader
        :show-deceased="showDeceased"
        :search-query="searchQuery"
        @refresh="refreshData"
        @toggle-deceased="toggleDeceasedVisibility"
        @show-modal="showModal"
        @export-csv="exportCSV"
        @search-change="onSearchChange"
        @clear-filters="clearFilters"
      />

      <template #default>
        <PatientColumns
          :loading="loading"
          :species-options="species"
          :compute-age="computeAge"
        />
      </template>

      <template #footer>
        <TablePaginator
          :items-per-page="itemsPerPage"
          :total-records="totalRecords"
          :current-page="currentPage"
          @page-change="onPageChange"
        />
      </template>
    </DataTable>

    <PatientModal
      v-model:visible="isModalVisible"
      @submitted="handleSubmit"
      @show-owner-modal="showOwnerModal"
    />

    <OwnerModal v-model:visible="isModalOwnerVisible" @owner-added="handleOwnerSubmit" />
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from "vue";
import { usePatients } from "@/composables/usePatients";
import { useBarcodeScanner } from "@/composables/useBarcodeScanner";
import TableHeader from "./TableHeader.vue";
import PatientColumns from "./PatientColumns.vue";
import TablePaginator from "./TablePaginator.vue";
import PatientModal from "./PatientModal.vue";
import OwnerModal from "./OwnerModal.vue";

// Composables
const {
  pets,
  loading,
  totalRecords,
  currentPage,
  itemsPerPage,
  fetchPets,
  refreshData,
  showDeceased,
  toggleDeceasedVisibility,
} = usePatients();

const { searchQuery, inputFocused, inputRef, handleKeydown } = useBarcodeScanner({
  onSearch: () => {
    currentPage.value = 1;
    fetchPets(currentPage.value);
  },
});

// Modal state
const isModalVisible = ref(false);
const isModalOwnerVisible = ref(false);

// Table state
const selectedPets = ref();
const metaKey = ref(true);
const dt = ref();

const showModal = () => (isModalVisible.value = true);
const showOwnerModal = () => (isModalOwnerVisible.value = true);

const handleSubmit = () => {
  isModalVisible.value = false;
  currentPage.value = 1;
  fetchPets(currentPage.value);
};

const handleOwnerSubmit = () => {
  isModalOwnerVisible.value = false;
};

const clearFilters = () => {
  currentPage.value = 1;
  searchQuery.value = "";
  fetchPets(currentPage.value);
};

const onPageChange = (event) => {
  itemsPerPage.value = event.rows;
  currentPage.value = event.page + 1;
  fetchPets(currentPage.value);
};

const beforeExportFunction = (data) => {
  return data.field === "owner" ? data.data.name : data.data;
};

const exportCSV = () => {
  dt.value.exportCSV({ selectionOnly: false });
};

onMounted(() => {
  fetchPets();
  window.addEventListener("keydown", handleKeydown);
});

onBeforeUnmount(() => {
  window.removeEventListener("keydown", handleKeydown);
});
</script>
