<template>
  <div class="w-full">
    <DataTable
      id="invoicesList"
      ref="dt"
      :value="loading ? skeletonRows : invoices"
      :row-hover="true"
      :loading="loading"
      :metaKeySelection="metaKey"
      sortMode="multiple"
      exportFilename="Invoices"
      removableSort
      showGridlines
      stripedRows
      v-model:selection="selectedInvoices"
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
              v-tooltip.bottom="`Create New Invoice`"
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
            <i class="fa-solid fa-file-invoice mx-2"></i> Invoices
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

      <!-- Invoice Number Column -->
      <Column class="text-xs" field="invoice_number" header="Invoice #" sortable>
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="80%" height="1rem" />
          </template>
          <template v-else>
            <Chip
              class="shadow-sm !text-xs font-thin border dark:border-transparent h-7"
              :label="slotProps.data.invoice_number"
              icon="pi pi-hashtag"
            />
          </template>
        </template>
      </Column>

      <!-- Client Column -->
      <Column class="text-xs" field="client.name" header="Client" sortable>
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="60%" height="1rem" />
          </template>
          <template v-else>{{ slotProps.data.owner?.name || "N/A" }}</template>
        </template>
      </Column>

      <!-- Date Column -->
      <Column class="text-xs" field="date" header="Date" sortable>
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="60%" height="1rem" />
          </template>
          <template v-else>
            {{ formatDate(slotProps.data.date) }}
          </template>
        </template>
      </Column>

      <!-- Due Date Column -->
      <Column class="text-xs" field="due_date" header="Due Date" sortable>
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="60%" height="1rem" />
          </template>
          <template v-else>
            <Chip
              :class="{
                '!bg-red-100 !text-red-800': slotProps.data.is_overdue,
                '!bg-yellow-100 !text-yellow-800': isDueSoon(slotProps.data.due_date),
              }"
              class="shadow-sm !text-xs font-thin border dark:border-transparent h-7"
              :label="formatDate(slotProps.data.due_date)"
              icon="pi pi-calendar"
            />
          </template>
        </template>
      </Column>

      <!-- Status Column -->
      <Column class="text-xs" field="status" header="Status" sortable>
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="40%" height="1rem" />
          </template>
          <template v-else>
            <Chip
              :class="{
                '!bg-gray-100 !text-gray-800': slotProps.data.status === 'draft',
                '!bg-blue-100 !text-blue-800': slotProps.data.status === 'pending',
                '!bg-yellow-100 !text-yellow-800':
                  slotProps.data.status === 'partially_paid',
                '!bg-green-100 !text-green-800': slotProps.data.status === 'paid',
                '!bg-red-100 !text-red-800':
                  slotProps.data.status === 'cancelled' ||
                  slotProps.data.status === 'refunded',
              }"
              class="shadow-sm !text-xs font-thin border dark:border-transparent h-7"
              :label="formatStatus(slotProps.data.status)"
            />
          </template>
        </template>
        <template #filter>
          <Dropdown
            v-model="filters.status.value"
            :options="statusOptions"
            optionLabel="label"
            optionValue="value"
            placeholder="Select Status"
            class="p-column-filter"
            @change="onStatusFilterChange"
          />
        </template>
      </Column>

      <!-- Total Amount Column -->
      <Column class="text-xs" field="total_amount" header="Total" sortable>
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="40%" height="1rem" />
          </template>
          <template v-else>
            {{ formatCurrency(slotProps.data.total_amount) }}
          </template>
        </template>
      </Column>

      <!-- Amount Paid Column -->
      <Column class="text-xs" field="amount_paid" header="Paid" sortable>
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="40%" height="1rem" />
          </template>
          <template v-else>
            {{ formatCurrency(slotProps.data.amount_paid) }}
          </template>
        </template>
      </Column>

      <!-- Balance Due Column -->
      <Column class="text-xs" field="balance_due" header="Balance" sortable>
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="40%" height="1rem" />
          </template>
          <template v-else>
            <Chip
              :class="{
                '!bg-red-100 !text-red-800': slotProps.data.balance_due > 0,
                '!bg-green-100 !text-green-800': slotProps.data.balance_due <= 0,
              }"
              class="shadow-sm !text-xs font-thin border dark:border-transparent h-7"
              :label="formatCurrency(slotProps.data.balance_due)"
            />
          </template>
        </template>
      </Column>

      <!-- Payment Status Column -->
      <Column class="text-xs" field="payment_status" header="Payment" sortable>
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="40%" height="1rem" />
          </template>
          <template v-else>
            <Chip
              :class="{
                '!bg-red-100 !text-red-800': slotProps.data.payment_status === 'unpaid',
                '!bg-yellow-100 !text-yellow-800':
                  slotProps.data.payment_status === 'partial',
                '!bg-green-100 !text-green-800': slotProps.data.payment_status === 'paid',
              }"
              class="shadow-sm !text-xs font-thin border dark:border-transparent h-7"
              :label="formatPaymentStatus(slotProps.data.payment_status)"
            />
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
              icon="pi pi-eye"
              class="p-button-rounded p-button-text p-button-sm"
              @click="viewInvoice(slotProps.data)"
              v-tooltip.bottom="`View Invoice`"
            />
            <Button
              size="small"
              icon="pi pi-pencil"
              class="p-button-rounded p-button-text p-button-sm"
              @click="editInvoice(slotProps.data)"
              v-tooltip.bottom="`Edit Invoice`"
            />
            <Button
              size="small"
              icon="pi pi-trash"
              class="p-button-rounded p-button-text p-button-sm p-button-danger"
              @click="confirmDelete(slotProps.data)"
              v-tooltip.bottom="`Delete Invoice`"
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

  <!-- View Invoice Dialog -->
  <Dialog
    header="Invoice Details"
    v-model:visible="viewDialogVisible"
    modal
    :closable="true"
    class="w-11/12 md:w-8/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)]"
  >
    <InvoiceView
      v-if="selectedInvoice"
      :invoice="selectedInvoice"
      :paymentMethods="paymentMethods"
    />
  </Dialog>

  <!-- Add/Edit Invoice Dialog -->
  <Dialog
    :header="editMode ? 'Edit Invoice' : 'Create New Invoice'"
    v-model:visible="isEditModalVisible"
    @hide="resetForm"
    modal
    :closable="true"
    class="w-11/12 md:w-11/12 h-screen bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)]"
  >
    <InvoiceEdit
      :invoiceData="selectedInvoice"
      @updated="handleInvoiceUpdated"
      @close="isEditModalVisible = false"
    />
  </Dialog>
  <Dialog
    :header="editMode ? 'Edit Invoice' : 'Create New Invoice'"
    v-model:visible="isModalVisible"
    @hide="resetForm"
    modal
    :closable="true"
    class="w-11/12 md:w-11/12 h-screen bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)]"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2 h-4">
        <span class="font-bold whitespace-nowrap">Create New Invoice</span>
      </div>
    </template>
    <InvoiceAdd
      :invoice="selectedInvoice"
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
      <span v-if="selectedInvoice"
        >Are you sure you want to delete invoice
        <b>{{ selectedInvoice.invoice_number }}</b
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
        @click="deleteInvoice"
      />
    </template>
  </Dialog>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from "vue";
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
import InvoiceAdd from "@/views/AddInvoice.vue";
import InvoiceEdit from "@/views/EditInvoice.vue";
import InvoiceView from "@/views/InvoiceView.vue";

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

const invoices = ref([]);
const loading = ref(true);
const selectedInvoices = ref();
const metaKey = ref(true);
const currentPage = ref(1);
const totalRecords = ref(0);
const itemsPerPage = ref(25);
const dt = ref();
const searchQuery = ref("");
const deleteDialogVisible = ref(false);
const isModalVisible = ref(false);
const isEditModalVisible = ref(false);
const viewDialogVisible = ref(false);
const editMode = ref(false);
const selectedInvoice = ref(null);

const statusOptions = ref([
  { label: "Draft", value: "draft" },
  { label: "Pending", value: "pending" },
  { label: "Partially Paid", value: "partially_paid" },
  { label: "Paid", value: "paid" },
  { label: "Cancelled", value: "cancelled" },
  { label: "Refunded", value: "refunded" },
]);
const paymentMethods = ref([
  { id: 1, name: "Cash" },
  { id: 2, name: "Credit Card" },
  { id: 3, name: "Bank Transfer" },
]);
const filters = ref({
  status: { value: null, matchMode: "equals" },
});

const clearFilters = () => {
  currentPage.value = 1;
  searchQuery.value = "";
  filters.value.status.value = null;
  fetchInvoices(currentPage.value);
};

const onSearchChange = () => {
  if (searchQuery.value.length < 3 && searchQuery.value.length > 0) {
    return;
  }
  currentPage.value = 1;
  fetchInvoices(currentPage.value);
};

const onStatusFilterChange = () => {
  currentPage.value = 1;
  fetchInvoices(currentPage.value);
};

const onPageChange = (event) => {
  itemsPerPage.value = event.rows;
  currentPage.value = event.page + 1;
  fetchInvoices(currentPage.value);
};

const formatCurrency = (value) => {
  return new Intl.NumberFormat("en-US", {
    style: "currency",
    currency: "USD",
  }).format(value);
};

const formatDate = (dateString) => {
  if (!dateString) return "N/A";
  const options = { year: "numeric", month: "short", day: "numeric" };
  return new Date(dateString).toLocaleDateString("en-US", options);
};

const isDueSoon = (dueDate) => {
  if (!dueDate) return false;
  const today = new Date();
  const due = new Date(dueDate);
  const diffTime = due - today;
  const diffDays = diffTime / (1000 * 60 * 60 * 24);
  return diffDays > 0 && diffDays <= 7; // Due in next 7 days
};

const formatStatus = (status) => {
  const statusMap = {
    draft: "Draft",
    pending: "Pending",
    partially_paid: "Partially Paid",
    paid: "Paid",
    cancelled: "Cancelled",
    refunded: "Refunded",
  };
  return statusMap[status] || status;
};

const formatPaymentStatus = (status) => {
  const statusMap = {
    unpaid: "Unpaid",
    partial: "Partial",
    paid: "Paid",
  };
  return statusMap[status] || status;
};

const showModal = () => {
  editMode.value = false;
  selectedInvoice.value = null;
  isModalVisible.value = true;
};

const viewInvoice = (invoice) => {
  selectedInvoice.value = invoice;
  viewDialogVisible.value = true;
};

const editInvoice = (invoice) => {
  editMode.value = true;
  selectedInvoice.value = { ...invoice };
  isEditModalVisible.value = true;
};

const confirmDelete = (invoice) => {
  selectedInvoice.value = invoice;
  deleteDialogVisible.value = true;
};

const deleteInvoice = async () => {
  try {
    await axiosInstance.delete(`/invoices/${selectedInvoice.value.id}`);
    deleteDialogVisible.value = false;
    fetchInvoices(currentPage.value);
  } catch (error) {
    console.error("Error deleting invoice:", error);
  }
};

const handleSubmit = () => {
  isModalVisible.value = false;
  currentPage.value = 1;
  fetchInvoices(currentPage.value);
};

const resetForm = () => {
  selectedInvoice.value = null;
  editMode.value = false;
};

const beforeExportFunction = (data, field) => {
  if (["date", "due_date"].includes(data.field)) {
    return formatDate(data.data);
  } else if (["total_amount", "amount_paid", "balance_due"].includes(data.field)) {
    return formatCurrency(data.data);
  } else if (data.field === "status") {
    return formatStatus(data.data);
  } else if (data.field === "payment_status") {
    return formatPaymentStatus(data.data);
  }
  return data.data;
};

const exportCSV = (event) => {
  dt.value.exportCSV({
    selectionOnly: false,
  });
};

const fetchInvoices = async (page = 1) => {
  try {
    loading.value = true;
    let url = `/invoices?page=${page}&per_page=${itemsPerPage.value}`;

    if (searchQuery.value) {
      url += `&search=${searchQuery.value}`;
    }

    if (filters.value.status.value) {
      url += `&status=${filters.value.status.value}`;
    }

    const response = await axiosInstance.get(url);

    invoices.value = response.data.data.data;
    totalRecords.value = response.data.data.total;
    console.log(response.data.data.data);
    currentPage.value = response.data.data.current_page;
  } catch (error) {
    console.error("Error fetching invoices:", error);
  } finally {
    loading.value = false;
  }
};

const refreshData = () => {
  loading.value = true;
  fetchInvoices(currentPage.value);
};

const skeletonRows = Array.from({ length: 10 }).map(() => ({
  id: "",
  invoice_number: "",
  client: "",
  date: "",
  due_date: "",
  status: "",
  total_amount: "",
  amount_paid: "",
  balance_due: "",
  payment_status: "",
}));

onMounted(() => {
  fetchInvoices();
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
.p-dialog-header {
  padding-bottom: 0;
  padding-top: 5px;
}
.dark\::-webkit-scrollbar {
  width: 10px;
}
.dark\::-webkit-scrollbar-track {
  --tw-bg-opacity: 1;
  background-color: rgb(55 65 81 / var(--tw-bg-opacity));
}
</style>
