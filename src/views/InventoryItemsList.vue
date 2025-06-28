<template>
  <div class="w-full lg:!text-[14px]">
    <DataTable
      id="inventoryList"
      ref="dt"
      :value="loading ? skeletonRows : inventoryItems"
      :row-hover="true"
      :loading="loading"
      :metaKeySelection="metaKey"
      sortMode="multiple"
      exportFilename="Inventory_Items"
      removableSort
      showGridlines
      stripedRows
      v-model:selection="selectedItems"
      highlightOnSelect
      dataKey="id"
      :exportFunction="beforeExportFunction"
      responsiveLayout="scroll"
      scrollable
      scrollHeight="75vh"
      class="rounded-xl 2xl:overflow-y-auto drop-shadow-md h-[95vh]"
      size="small"
    >
      <template #header>
        <div class="flex justify-between">
          <div class="flex">
            <Button
              size="small"
              type="button"
              icon="pi pi-refresh !text-sm lg:!text-[14px]"
              label=""
              v-tooltip.bottom="$t('inventory.actions.refresh')"
              class="!text-sm lg:!text-[14px] ml-2"
              @click="refreshData"
            />
            <Button
              size="small"
              icon="pi pi-plus"
              @click="showModal"
              v-tooltip.bottom="$t('inventory.actions.add')"
              class="p-button p-component p-button-icon-only !text-sm lg:!text-[14px] ml-2"
            />
            <Button
              size="small"
              icon="pi pi-cloud-upload"
              @click="showImportModal"
              v-tooltip.bottom="$t('inventory.actions.import')"
              class="p-button p-component p-button-icon-only !text-sm lg:!text-[14px] ml-2"
            />
            <Button
              size="small"
              icon="pi pi-download !text-sm lg:!text-[14px]"
              class="!text-sm lg:!text-[14px] ml-2"
              v-tooltip.bottom="$t('inventory.actions.export')"
              @click="exportCSV($event)"
            />
          </div>
          <h2 class="text-md !mb-0 pb-0 flex items-center">
            <i class="fa-solid fa-store mx-2"></i> {{ $t("inventory.title") }}
          </h2>
          <span class="p-input-icon-left !text-sm lg:!text-[14px]">
            <InputGroup
              class="!text-gray-800 flex rounded-md overflow-hidden border !border-gray-400"
            >
              <InputGroupAddon
                class="!text-gray-800 px-4 flex flex-col item-center justify-center"
              >
                <i class="pi pi-search"></i>
              </InputGroupAddon>
              <InputText
                size="small"
                v-model="searchQuery"
                @input="onSearchChange"
                @keyup.enter="handleBarcodeEnter"
                @keydown.enter.prevent="handleBarcodeEnter"
                ref="inputRef"
                @focus="inputFocused = true"
                @blur="inputFocused = false"
                autofocus="true"
                type="text"
                class="!text-sm lg:!text-[14px] !text-gray-800 focus:!ring-0 focus:!ring-offset-0 focus:!border-gray-400 border-transparent"
                :placeholder="$t('inventory.search.placeholder')"
              />
              <Button size="small" icon="pi pi-times" @click="clearFilters" />
            </InputGroup>
          </span>
        </div>
      </template>

      <!-- Barcode Column -->
      <Column
        class="!text-sm lg:!text-[14px]"
        field="barcode"
        :header="$t('inventory.columns.barcode')"
        sortable
      >
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="80%" height="1rem" />
          </template>
          <template v-else>
            <Chip
              class="shadow-sm !text-sm lg:!text-[14px] font-thin border dark:border-transparent h-7"
              :label="slotProps.data.barcode"
              icon="pi pi-barcode"
            />
          </template>
        </template>
      </Column>
      <!-- Brand Column -->
      <Column
        class="!text-sm lg:!text-[14px]"
        field="brand"
        :header="$t('inventory.columns.brand')"
        sortable
      >
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="40%" height="1rem" />
          </template>
          <template v-else>{{ slotProps.data.brand }}</template>
        </template>
      </Column>

      <!-- Name Column -->
      <Column
        class="!text-sm lg:!text-[14px]"
        field="name"
        :header="$t('inventory.columns.name')"
        sortable
      >
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="60%" height="1rem" />
          </template>
          <template v-else>{{ slotProps.data.name }}</template>
        </template>
      </Column>

      <!-- Category Column -->
      <Column
        class="!text-sm lg:!text-[14px]"
        field="category"
        :header="$t('inventory.columns.category')"
        sortable
      >
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="40%" height="1rem" />
          </template>
          <template v-else>
            <Chip
              class="shadow-sm !text-sm lg:!text-[14px] font-thin border dark:border-transparent h-7"
              :label="slotProps.data.category"
            />
          </template>
        </template>
        <!-- <template #filter>
          <Dropdown
            v-model="filters.category.value"
            :options="categories"
            optionLabel="label"
            optionValue="value"
            :placeholder="$t('inventory.columns.category')"
            class="p-column-filter"
            @change="onCategoryFilterChange"
          />
        </template> -->
      </Column>

      <!-- Type Column -->
      <Column
        class="!text-sm lg:!text-[14px]"
        field="type"
        :header="$t('inventory.columns.type')"
        sortable
      >
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="40%" height="1rem" />
          </template>
          <template v-else>{{ slotProps.data.type }}</template>
        </template>
      </Column>

      <!-- Quantity Column -->
      <Column
        class="!text-sm lg:!text-[14px]"
        field="quantity"
        :header="$t('inventory.columns.quantity')"
        sortable
      >
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="30%" height="1rem" />
          </template>
          <template v-else>
            <Chip
              :class="{
                '!bg-red-100 !text-red-800':
                  slotProps.data.quantity <= slotProps.data.minimum_stock_level,
                '!bg-green-100 !text-green-800':
                  slotProps.data.quantity > slotProps.data.minimum_stock_level,
              }"
              class="shadow-sm !text-sm lg:!text-[14px] font-thin border dark:border-transparent h-7"
              :label="slotProps.data.quantity.toString()"
            />
          </template>
        </template>
      </Column>

      <!-- Cost Price Column -->
      <Column
        class="!text-sm lg:!text-[14px]"
        field="cost_price"
        :header="$t('inventory.columns.cost_price')"
        sortable
      >
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="40%" height="1rem" />
          </template>
          <template v-else>
            {{ formatCurrency(slotProps.data.cost_price) }}
          </template>
        </template>
      </Column>

      <!-- Selling Price Column -->
      <Column
        class="!text-sm lg:!text-[14px]"
        field="selling_price"
        :header="$t('inventory.columns.selling_price')"
        sortable
      >
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="40%" height="1rem" />
          </template>
          <template v-else>
            {{ formatCurrency(slotProps.data.selling_price) }}
          </template>
        </template>
      </Column>

      <!-- Expiry Date Column -->
      <Column
        class="!text-sm lg:!text-[14px]"
        field="expiry_date"
        :header="$t('inventory.columns.expiry_date')"
        sortable
      >
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="60%" height="1rem" />
          </template>
          <template v-else>
            <Chip
              v-if="slotProps.data.expiry_date"
              :class="{
                '!bg-red-100 !text-red-800': isExpired(slotProps.data.expiry_date),
                '!bg-yellow-100 !text-yellow-800': isExpiringSoon(
                  slotProps.data.expiry_date
                ),
              }"
              class="shadow-sm !text-sm lg:!text-[14px] font-thin border dark:border-transparent h-7"
              :label="formatDate(slotProps.data.expiry_date)"
              icon="pi pi-calendar"
            />
            <span v-else>N/A</span>
          </template>
        </template>
      </Column>

      <!-- Actions Column -->
      <Column :header="$t('inventory.columns.actions')" :exportable="false">
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="60%" height="1rem" />
          </template>
          <template v-else>
            <Button
              size="small"
              icon="pi pi-pencil"
              class="p-button-rounded p-button-text p-button-sm"
              @click="editItem(slotProps.data)"
              v-tooltip.bottom="$t('inventory.actions.edit')"
            />
            <Button
              size="small"
              icon="pi pi-trash"
              class="p-button-rounded p-button-text p-button-sm p-button-danger"
              @click="confirmDelete(slotProps.data)"
              v-tooltip.bottom="$t('inventory.actions.delete')"
            />
          </template>
        </template>
      </Column>

      <template #footer>
        <Paginator
          :rows="itemsPerPage"
          :first="0"
          :totalRecords="totalRecords"
          :currentPage="currentPage"
          :rowsPerPageOptions="[25, 50, 100]"
          @page="onPageChange"
          class="!rounded-b-xl !text-sm lg:!text-[14px]"
        >
        </Paginator>
      </template>
    </DataTable>
  </div>

  <!-- Add/Edit Item Dialog -->
  <Dialog
    :header="
      editMode ? $t('inventory.dialog.edit_title') : $t('inventory.dialog.add_title')
    "
    v-model:visible="isModalVisible"
    @hide="resetForm"
    modal
    :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)]"
  >
    <InventoryItemForm
      v-focustrap="{
        disabled: false,
        autoFocus: true,
      }"
      :item="selectedItem"
      :editMode="editMode"
      @submitted="handleSubmit"
    />
  </Dialog>
  <!-- Add/Edit Item Dialog -->
  <Dialog
    :header="
      editMode ? $t('inventory.dialog.edit_title') : $t('inventory.dialog.import_title')
    "
    v-model:visible="isImportModalVisible"
    @hide="resetForm"
    modal
    :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)]"
  >
    <InventoryItemImport
      v-focustrap="{
        disabled: false,
        autoFocus: true,
      }"
      :item="selectedItem"
      :editMode="editMode"
      @submitted="handleImportSubmit"
    />
  </Dialog>

  <!-- Delete Confirmation Dialog -->
  <Dialog
    v-model:visible="deleteDialogVisible"
    :style="{ width: '450px' }"
    :header="$t('inventory.dialog.delete_title')"
    :modal="true"
  >
    <div
      class="confirmation-content"
      v-focustrap="{
        disabled: false,
        autoFocus: true,
      }"
    >
      <i class="pi pi-exclamation-triangle ltr:mr-3 rtl:ml-3" style="font-size: 2rem" />
      <span
        v-if="selectedItem"
        v-html="$t('inventory.dialog.delete_message', { item: selectedItem.name })"
      ></span>
    </div>
    <template #footer>
      <Button
        size="small"
        :label="$t('inventory.actions.no')"
        icon="pi pi-times"
        class="p-button-text"
        @click="deleteDialogVisible = false"
      />
      <Button
        size="small"
        :label="$t('inventory.actions.yes')"
        icon="pi pi-check"
        class="p-button-text p-button-danger"
        @click="deleteItem"
      />
    </template>
  </Dialog>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, watchEffect, watch } from "vue";
import DataTable from "primevue/datatable";
import Column from "primevue/column";
import Skeleton from "primevue/skeleton";
import InputText from "primevue/inputtext";
import InputGroupAddon from "primevue/inputgroupaddon";
import InputGroup from "primevue/inputgroup";
import Button from "primevue/button";
import axiosInstance from "@/axios";
import Chip from "primevue/chip";
import Paginator from "primevue/paginator";
import Dialog from "primevue/dialog";
import Dropdown from "primevue/dropdown";
import InventoryItemForm from "@/views/addInventoryItem.vue";
import InventoryItemImport from "@/views/importInventoryItems.vue";
import { useRoute } from "vue-router";
import { useI18n } from "vue-i18n";
import eventBus from "@/eventBus";
const route = useRoute();
const { t } = useI18n();

// BARCODE READER WORK
const inputFocused = ref(false);
const inputRef = ref(null);
let typingTimer = null;
const typingDelay = 500;

const handleKeydown = (event) => {
  if (!inputFocused.value && isModalVisible.value === false && !event.ctrlKey) {
    if (event.key.length === 1) {
      clearTimeout(typingTimer);
      typingTimer = setTimeout(() => {
        if (searchQuery.value.length > 3) {
          onSearchChange();
        }
      }, typingDelay);
      searchQuery.value += event.key;
    }
  }
};
// END BARCODE

const inventoryItems = ref([]);
const loading = ref(true);
const selectedItems = ref();
const metaKey = ref(true);
const currentPage = ref(1);
const totalRecords = ref(0);
const itemsPerPage = ref(25);
const dt = ref();
const searchQuery = ref("");
const deleteDialogVisible = ref(false);
const isModalVisible = ref(false);
const isImportModalVisible = ref(false);
const editMode = ref(false);
const selectedItem = ref(null);
const categoryFilter = ref("");
const categories = ref([
  { label: t("inventory.categories.food"), value: "food" },
  { label: t("inventory.categories.pharmaceutical"), value: "pharmaceutical" },
  // { label: t("inventory.categories.accessories"), value: "accessories" },
  { label: t("inventory.categories.miscellaneous"), value: "miscellaneous" },
  // { label: t("inventory.categories.treatment"), value: "treatment" },
]);
const filters = ref({
  category: { value: null, matchMode: "equals" },
});

const clearFilters = () => {
  currentPage.value = 1;
  searchQuery.value = "";
  // filters.value.category.value = null;
  fetchInventoryItems(currentPage.value);
};
watchEffect(() => {
  if (route.path === "/add-inventory-pharmaceutical") {
    filters.value.category.value = "pharmaceutical"; // or whatever default you want
    // isPredefined.value = true;
  } else if (route.path === "/add-inventory-food") {
    filters.value.category.value = "food";
    // isPredefined.value = true;
  } else if (route.path === "/add-inventory-toys") {
    filters.value.category.value = "miscellaneous";
    // isPredefined.value = true;
  } else if (route.path === "/add-inventory-grooming") {
    filters.value.category.value = "grooming";
    // isPredefined.value = true;
  } else if (route.path === "/add-inventory-treatment") {
    filters.value.category.value = "treatment";
    // isPredefined.value = true;
  }
  // Add more route cases as needed
});
const onSearchChange = () => {
  if (searchQuery.value.length < 3 && searchQuery.value.length > 0) {
    return;
  }
  currentPage.value = 1;
  fetchInventoryItems(currentPage.value);
};

const onCategoryFilterChange = () => {
  currentPage.value = 1;
  fetchInventoryItems(currentPage.value);
};

const onPageChange = (event) => {
  itemsPerPage.value = event.rows;
  currentPage.value = event.page + 1;
  fetchInventoryItems(currentPage.value);
};

const formatCurrency = (value) => {
  return new Intl.NumberFormat("en-US", {
    style: "currency",
    currency: "USD",
  }).format(value);
};

const formatDate = (dateString) => {
  if (!dateString) return "N/A";
  const options = { year: "long", month: "short", day: "numeric" };
  return new Date(dateString).toLocaleDateString("en-GB");
};

const isExpired = (expiryDate) => {
  if (!expiryDate) return false;
  return new Date(expiryDate) < new Date();
};

const isExpiringSoon = (expiryDate) => {
  if (!expiryDate) return false;
  const today = new Date();
  const expiry = new Date(expiryDate);
  const diffTime = expiry - today;
  const diffDays = diffTime / (1000 * 60 * 60 * 24);
  return diffDays > 0 && diffDays <= 30; // Expiring in next 30 days
};

const showModal = () => {
  editMode.value = false;
  selectedItem.value = null;
  isModalVisible.value = true;
};
const showImportModal = () => {
  // editMode.value = false;
  // selectedItem.value = null;
  isImportModalVisible.value = true;
};

const editItem = (item) => {
  editMode.value = true;
  selectedItem.value = { ...item };
  
  isModalVisible.value = true;
};

const confirmDelete = (item) => {
  selectedItem.value = item;
  deleteDialogVisible.value = true;
};

const deleteItem = async () => {
  try {
    await axiosInstance.delete(`/inventory-items/${selectedItem.value.id}`);
    deleteDialogVisible.value = false;
    fetchInventoryItems(currentPage.value);
  } catch (error) {
    console.error("Error deleting item:", error);
  }
};

const handleSubmit = () => {
  isModalVisible.value = false;
  currentPage.value = 1;
  fetchInventoryItems(currentPage.value);
};
const handleImportSubmit = () => {
  isImportModalVisible.value = false;
  currentPage.value = 1;
  fetchInventoryItems(currentPage.value);
};

const resetForm = () => {
  selectedItem.value = null;
  editMode.value = false;
};

// const beforeExportFunction = (data) => {
//   if (data.field === "expiry_date") {
//     return data.data.expiry_date ? formatDate(data.data.expiry_date) : "N/A";
//   }
//   if (["cost_price", "selling_price"].includes(data.field)) {
//     return formatCurrency(data.data[data.field]);
//   }
//   return data.data[data.field];
// };
const beforeExportFunction = (data, field) => {
  
  if (data.field === "expiry_date") {
    return formatDate(data.data);
  } else {
    return data.data;
  }
};
// const formatDate = (dateString) => {
//   return new Date(dateString).toLocaleDateString();
// };
const exportCSV = (event) => {
  dt.value.exportCSV({
    selectionOnly: false,
  });
};

const fetchInventoryItems = async (page = 1) => {
  try {
    loading.value = true;
    let url = `/inventory-items?branch_id=1&page=${page}&per_page=${itemsPerPage.value}`;

    if (searchQuery.value) {
      url += `&search=${searchQuery.value}`;
    }

    if (filters.value.category.value) {
      url += `&category=${filters.value.category.value}`;
    }
    
    const response = await axiosInstance.get(url);
    inventoryItems.value = response.data.data.data;
    totalRecords.value = response.data.data.total;
    currentPage.value = response.data.data.current_page;
  } catch (error) {
    console.error("Error fetching inventory items:", error);
  } finally {
    loading.value = false;
  }
};
const handleBarcodeEnter = async () => {
  /*   if (!itemSearch.value) return;
  
    if (/^\d{6,}$/.test(itemSearch.value)) {
      try {
        const response = await axiosInstance.get("/inventory-items/by-barcode", {
          params: { barcode: itemSearch.value },
        });
  
        if (response.data.data) {
          selectItem({ value: response.data.data });
        }
      } catch (error) {
        console.error("Error searching by barcode:", error);
      }
    } */
  return;
};
const refreshData = () => {
  loading.value = true;
  fetchInventoryItems(currentPage.value);
};

const skeletonRows = Array.from({ length: 10 }).map((_, index) => ({
  id: `skeleton-${index}`, // Unique ID for each item
  name: "",
  category: "",
  type: "",
  brand: "",
  quantity: "",
  cost_price: "",
  selling_price: "",
  expiry_date: "",
}));

onMounted(() => {
  fetchInventoryItems();
  window.addEventListener("keydown", handleKeydown);
  eventBus.on("AddInventoryItem", () => {
    
    isModalVisible.value = true;
  });
});

onBeforeUnmount(() => {
  window.removeEventListener("keydown", handleKeydown);
});
watch(
  () => route.path,
  () => {
    fetchInventoryItems();
  }
);
</script>

<style>
h2 {
  margin-bottom: 1rem;
}
.dark\::-webkit-scrollbar {
  width: 10px;
}
.dark\::-webkit-scrollbar-track {
  --tw-bg-opacity: 1;
  background-color: rgb(55 65 81 / var(--tw-bg-opacity));
}
</style>
