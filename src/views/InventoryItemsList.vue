<template>
  <div class="w-full">
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
      @rowSelect="onSelectionChange"
      :exportFunction="beforeExportFunction"
      responsiveLayout="scroll"
      class="rounded-xl 2xl:overflow-y-scroll drop-shadow-md mt-4 h-[95vh]"
      size="small"
    >
      <template #header>
        <div class="flex justify-between">
          <div class="flex">
            <Button
              size="small"
              type="button"
              icon="pi pi-refresh !text-xs"
              label=""
              v-tooltip.bottom="`Refresh Data`"
              class="!text-xs ml-2"
              @click="refreshData"
            />
            <Button
              size="small"
              icon="pi pi-plus"
              @click="showModal"
              v-tooltip.bottom="`Add New Item`"
              class="p-button p-component p-button-icon-only !text-xs ml-2"
            />
            <Button
              size="small"
              icon="pi pi-download !text-xs"
              class="!text-xs ml-2"
              v-tooltip.bottom="`Export`"
              @click="exportCSV($event)"
            />
          </div>
          <h2 class="text-md !mb-0 pb-0 flex items-center">
            <i class="fa-solid fa-store mx-2"></i> Inventory
          </h2>
          <span class="p-input-icon-left text-xs">
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
                ref="inputRef"
                @focus="inputFocused = true"
                @blur="inputFocused = false"
                autofocus="true"
                type="text"
                class="!text-xs !text-gray-800 focus:!ring-0 focus:!ring-offset-0 focus:!border-gray-400 border-transparent"
                placeholder="Search All Columns"
              />
              <Button size="small" icon="pi pi-times" @click="clearFilters" />
            </InputGroup>
          </span>
        </div>
      </template>

      <!-- Barcode Column -->
      <Column class="text-xs" field="barcode" header="Barcode" sortable>
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="80%" height="1rem" />
          </template>
          <template v-else>
            <Chip
              class="shadow-sm !text-xs font-thin border dark:border-transparent h-7"
              :label="slotProps.data.barcode"
              icon="pi pi-barcode"
            />
          </template>
        </template>
      </Column>
      <!-- Brand Column -->
      <Column class="text-xs" field="brand" header="Brand" sortable>
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="40%" height="1rem" />
          </template>
          <template v-else>{{ slotProps.data.brand }}</template>
        </template>
      </Column>

      <!-- Name Column -->
      <Column class="text-xs" field="name" header="Name" sortable>
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="60%" height="1rem" />
          </template>
          <template v-else>{{ slotProps.data.name }}</template>
        </template>
      </Column>

      <!-- Category Column -->
      <Column class="text-xs" field="category" header="Category" sortable>
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="40%" height="1rem" />
          </template>
          <template v-else>
            <Chip
              class="shadow-sm !text-xs font-thin border dark:border-transparent h-7"
              :label="slotProps.data.category"
            />
          </template>
        </template>
        <template #filter>
          <Dropdown
            v-model="filters.category.value"
            :options="categories"
            optionLabel="label"
            optionValue="value"
            placeholder="Select Category"
            class="p-column-filter"
            @change="onCategoryFilterChange"
          />
        </template>
      </Column>

      <!-- Type Column -->
      <Column class="text-xs" field="type" header="Type" sortable>
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="40%" height="1rem" />
          </template>
          <template v-else>{{ slotProps.data.type }}</template>
        </template>
      </Column>

      <!-- Quantity Column -->
      <Column class="text-xs" field="quantity" header="Qty" sortable>
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
              class="shadow-sm !text-xs font-thin border dark:border-transparent h-7"
              :label="slotProps.data.quantity"
            />
          </template>
        </template>
      </Column>

      <!-- Cost Price Column -->
      <Column class="text-xs" field="cost_price" header="Cost" sortable>
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
      <Column class="text-xs" field="selling_price" header="Price" sortable>
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
      <Column class="text-xs" field="expiry_date" header="Expiry" sortable>
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
              class="shadow-sm !text-xs font-thin border dark:border-transparent h-7"
              :label="formatDate(slotProps.data.expiry_date)"
              icon="pi pi-calendar"
            />
            <span v-else>N/A</span>
          </template>
        </template>
      </Column>

      <!-- Actions Column -->
      <Column header="Actions" :exportable="false">
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
              v-tooltip.bottom="`Edit Item`"
            />
            <Button
              size="small"
              icon="pi pi-trash"
              class="p-button-rounded p-button-text p-button-sm p-button-danger"
              @click="confirmDelete(slotProps.data)"
              v-tooltip.bottom="`Delete Item`"
            />
          </template>
        </template>
      </Column>

      <template #footer>
        <Paginator
          :rows="itemsPerPage"
          :first="1"
          :totalRecords="totalRecords"
          :currentPage="currentPage"
          :rowsPerPageOptions="[25, 50, 100]"
          @page="onPageChange"
          class="!rounded-b-xl text-xs"
        ></Paginator>
      </template>
    </DataTable>
  </div>

  <!-- Add/Edit Item Dialog -->
  <Dialog
    :header="editMode ? 'Edit Inventory Item' : 'Add New Inventory Item'"
    v-model:visible="isModalVisible"
    @hide="resetForm"
    modal
    :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)]"
  >
    <InventoryItemForm
      :item="selectedItem"
      :editMode="editMode"
      @submitted="handleSubmit"
    />
  </Dialog>

  <!-- Delete Confirmation Dialog -->
  <Dialog
    v-model:visible="deleteDialogVisible"
    :style="{ width: '450px' }"
    header="Confirm"
    :modal="true"
  >
    <div class="confirmation-content">
      <i class="pi pi-exclamation-triangle mr-3" style="font-size: 2rem" />
      <span v-if="selectedItem"
        >Are you sure you want to delete <b>{{ selectedItem.name }}</b
        >?</span
      >
    </div>
    <template #footer>
      <Button
        size="small"
        label="No"
        icon="pi pi-times"
        class="p-button-text"
        @click="deleteDialogVisible = false"
      />
      <Button
        size="small"
        label="Yes"
        icon="pi pi-check"
        class="p-button-text p-button-danger"
        @click="deleteItem"
      />
    </template>
  </Dialog>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, watchEffect } from "vue";
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
import { useRoute } from "vue-router";
const route = useRoute();
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
const editMode = ref(false);
const selectedItem = ref(null);
const categoryFilter = ref("");
const categories = ref([
  { label: "Food", value: "food" },
  { label: "Medicine", value: "medicine" },
  { label: "Accessories", value: "accessories" },
  { label: "Miscellaneous", value: "miscellaneous" },
]);

const filters = ref({
  category: { value: null, matchMode: "equals" },
});

const clearFilters = () => {
  currentPage.value = 1;
  searchQuery.value = "";
  filters.value.category.value = null;
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

const editItem = (item) => {
  editMode.value = true;
  selectedItem.value = { ...item };
  console.log(selectedItem.value);
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
  console.log(data.data);
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
    console.log(url);
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

const refreshData = () => {
  loading.value = true;
  fetchInventoryItems(currentPage.value);
};

const skeletonRows = Array.from({ length: 10 }).map(() => ({
  id: "",
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
});

onBeforeUnmount(() => {
  window.removeEventListener("keydown", handleKeydown);
});
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
