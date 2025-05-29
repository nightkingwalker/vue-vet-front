<template>
  <div class="w-full px-4 lg:!text-[14px]">
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
      :exportFunction="beforeExportFunction"
      responsiveLayout="scroll"
      class="rounded-xl 2xl:overflow-y-auto drop-shadow-md h-[95vh]"
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
              v-tooltip.bottom="$t('invoices.actions.refresh')"
              class="!text-xs ml-2"
              @click="refreshData"
            />
            <Button
              size="small"
              icon="pi pi-plus"
              @click="showModal"
              v-tooltip.bottom="$t('invoices.actions.create')"
              class="p-button p-component p-button-icon-only !text-xs ml-2"
            />
            <Button
              size="small"
              icon="pi pi-download !text-xs"
              class="!text-xs ml-2"
              v-tooltip.bottom="$t('invoices.actions.export')"
              @click="exportCSV($event)"
            />
          </div>
          <h2 class="text-md !mb-0 pb-0 flex items-center">
            <i class="fa-solid fa-file-invoice mx-2"></i> {{ $t("invoices.title") }}
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
                :placeholder="$t('invoices.search.placeholder')"
              />
              <Button size="small" icon="pi pi-times" @click="clearFilters" />
            </InputGroup>
          </span>
        </div>
      </template>

      <!-- Invoice Number Column -->
      <Column
        class="text-xs"
        field="invoice_number"
        :header="$t('invoices.columns.invoice_number')"
        sortable
      >
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
      <Column
        class="text-xs"
        field="client.name"
        :header="$t('invoices.columns.client')"
        sortable
      >
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="60%" height="1rem" />
          </template>
          <template v-else>{{ slotProps.data.owner?.name || "N/A" }}</template>
        </template>
      </Column>

      <!-- Pet Column -->
      <Column
        class="text-xs"
        field="pet.name"
        :header="$t('invoices.columns.pet')"
        sortable
      >
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="60%" height="1rem" />
          </template>
          <template v-else>{{ slotProps.data.pet?.name || "N/A" }}</template>
        </template>
      </Column>

      <!-- Date Column -->
      <Column class="text-xs" field="date" :header="$t('invoices.columns.date')" sortable>
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
      <Column
        class="text-xs"
        field="due_date"
        :header="$t('invoices.columns.due_date')"
        sortable
      >
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
      <Column
        class="text-xs"
        field="status"
        :header="$t('invoices.columns.status')"
        sortable
      >
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
              :label="$t('invoices.status.' + slotProps.data.status)"
            />
          </template>
        </template>
        <template #filter>
          <Dropdown
            v-model="filters.status.value"
            :options="statusOptions"
            optionLabel="label"
            optionValue="value"
            :placeholder="$t('invoices.columns.status')"
            class="p-column-filter"
            @change="onStatusFilterChange"
          />
        </template>
      </Column>

      <!-- Total Amount Column -->
      <Column
        class="text-xs"
        field="total_amount"
        :header="$t('invoices.columns.total_amount')"
        sortable
      >
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
      <Column
        class="text-xs"
        field="amount_paid"
        :header="$t('invoices.columns.amount_paid')"
        sortable
      >
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
      <Column
        class="text-xs"
        field="balance_due"
        :header="$t('invoices.columns.balance_due')"
        sortable
      >
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
      <Column
        class="text-xs"
        field="payment_status"
        :header="$t('invoices.columns.payment_status')"
        sortable
      >
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
              :label="$t('invoices.status.' + slotProps.data.payment_status)"
            />
          </template>
        </template>
      </Column>

      <!-- Actions Column -->
      <Column :header="$t('invoices.columns.actions')" :exportable="false">
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
              v-tooltip.bottom="$t('invoices.actions.view')"
            />
            <Button
              size="small"
              icon="pi pi-pencil"
              class="p-button-rounded p-button-text p-button-sm"
              :disabled="
                slotProps.data.payment_status === 'paid' ||
                slotProps.data.payment_status === 'cancelled'
              "
              @click="editInvoice(slotProps.data)"
              v-tooltip="
                slotProps.data.payment_status === 'paid'
                  ? $t('invoices.dialog.paid_message')
                  : slotProps.data.payment_status === 'cancelled'
                  ? $t('invoices.dialog.cancelled_message')
                  : $t('invoices.actions.edit')
              "
            />
            <Button
              size="small"
              icon="pi pi-trash"
              class="p-button-rounded p-button-text p-button-sm p-button-danger"
              @click="confirmDelete(slotProps.data)"
              v-tooltip.bottom="$t('invoices.actions.delete')"
            />
            <Button
              size="small"
              icon="fa-solid fa-hand-holding-dollar"
              class="p-button-rounded p-button-text p-button-sm"
              @click="openPaymentDialog(slotProps.data)"
              :disabled="
                slotProps.data.payment_status === 'paid' ||
                slotProps.data.payment_status === 'cancelled'
              "
              v-tooltip="
                slotProps.data.payment_status === 'paid'
                  ? $t('invoices.dialog.paid_message')
                  : slotProps.data.payment_status === 'cancelled'
                  ? $t('invoices.dialog.cancelled_message')
                  : $t('invoices.actions.add_payment')
              "
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
    :header="$t('invoices.dialog.view_title')"
    v-model:visible="viewDialogVisible"
    modal
    :closable="true"
    class="w-11/12 md:w-8/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)]"
  >
    <InvoiceView
      v-focustrap="{
        disabled: false,
        autoFocus: true,
      }"
      v-if="selectedInvoice"
      :invoice="selectedInvoice"
      :paymentMethods="paymentMethods"
      @showPayment="openPaymentDialog(selectedInvoice)"
    />
  </Dialog>

  <!-- Add/Edit Invoice Dialog -->
  <Dialog
    :header="
      editMode ? $t('invoices.dialog.edit_title') : $t('invoices.dialog.create_title')
    "
    v-model:visible="isEditModalVisible"
    @hide="resetForm"
    modal
    :closable="true"
    class="w-11/12 md:w-11/12 h-screen bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)]"
  >
    <InvoiceEdit
      v-focustrap="{
        disabled: false,
        autoFocus: true,
      }"
      :invoiceData="selectedInvoice"
      @updated="handleInvoiceUpdated"
      @close="isEditModalVisible = false"
    />
  </Dialog>
  <Dialog
    :header="$t('invoices.dialog.create_title')"
    v-model:visible="isModalVisible"
    @hide="resetForm"
    modal
    :closable="true"
    class="w-11/12 md:w-11/12 h-screen bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)]"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2 h-4">
        <span class="font-bold whitespace-nowrap">{{
          $t("invoices.dialog.create_title")
        }}</span>
      </div>
    </template>
    <InvoiceAdd
      v-focustrap="{
        disabled: false,
        autoFocus: true,
      }"
      :invoice="selectedInvoice"
      :editMode="editMode"
      @InvoiceCreated="handleInvoiceCreated"
    />
  </Dialog>

  <!-- Payment Dialog -->
  <Dialog
    :header="$t('invoices.dialog.payment_title')"
    v-model:visible="paymentDialogVisible"
    @hide="
      resetForm;
      isEditModalVisible = false;
    "
    modal
    :closable="true"
    class="w-[11/12] md:w-[500px] h-fit bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)]"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2 h-4">
        <span class="font-bold whitespace-nowrap">{{
          $t("invoices.dialog.payment_title")
        }}</span>
      </div>
    </template>
    <AddPayment
      v-focustrap="{
        disabled: false,
        autoFocus: true,
      }"
      v-if="selectedInvoice"
      :invoice="selectedInvoice"
      :paymentMethods="paymentMethods"
      @submit="handlePaymentSubmit"
      @cancel="paymentDialogVisible = false"
    />
  </Dialog>

  <!-- Delete Confirmation Dialog -->
  <Dialog
    v-model:visible="deleteDialogVisible"
    :style="{ width: '450px' }"
    :header="$t('invoices.dialog.delete_title')"
    :modal="true"
  >
    <div
      class="confirmation-content"
      v-focustrap="{
        disabled: false,
        autoFocus: false,
      }"
    >
      <i class="pi pi-exclamation-triangle ltr:mr-3 rtl:ml-3" style="font-size: 2rem" />
      <span
        v-if="selectedInvoice"
        v-html="
          $t('invoices.dialog.delete_message', {
            invoice: selectedInvoice.invoice_number,
          })
        "
      ></span>
    </div>
    <template #footer>
      <Button
        size="small"
        :label="$t('invoices.actions.no')"
        icon="pi pi-times"
        class="p-button-text"
        @click="deleteDialogVisible = false"
      />
      <Button
        size="small"
        :label="$t('invoices.actions.yes')"
        icon="pi pi-check"
        class="p-button-text p-button-danger"
        @click="deleteInvoice"
      />
    </template>
  </Dialog>
</template>

<script setup>
// import { ref, onMounted, onBeforeUnmount } from "vue";
import DataTable from "primevue/datatable";
import Column from "primevue/column";
import Skeleton from "primevue/skeleton";
import InputText from "primevue/inputtext";
import InputGroupAddon from "primevue/inputgroupaddon";
import InputGroup from "primevue/inputgroup";
import Button from "primevue/button";
// import axiosInstance from "@/axios";
import Chip from "primevue/chip";
import Paginator from "primevue/paginator";
import Dialog from "primevue/dialog";
import Dropdown from "primevue/dropdown";
// import InvoiceAdd from "@/views/AddInvoice.vue";
// import InvoiceEdit from "@/views/EditInvoice.vue";
// import InvoiceView from "@/views/InvoiceView.vue";
// import AddPayment from "@/views/AddInvoicePayment.vue";
// import eventBus from "@/eventBus";
import { useToast } from "primevue/usetoast";

import { ref, onMounted, onBeforeUnmount, defineAsyncComponent } from "vue";

// Lazy-loaded PrimeVue components with chunk names
// const DataTable = defineAsyncComponent(() =>
//   import(/* webpackChunkName: "prime-datatable" */ "primevue/datatable")
// );
// const Column = defineAsyncComponent(() =>
//   import(/* webpackChunkName: "prime-column" */ "primevue/column")
// );
// const Skeleton = defineAsyncComponent(() =>
//   import(/* webpackChunkName: "prime-skeleton" */ "primevue/skeleton")
// );
// const InputText = defineAsyncComponent(() =>
//   import(/* webpackChunkName: "prime-inputtext" */ "primevue/inputtext")
// );
// const InputGroupAddon = defineAsyncComponent(() =>
//   import(/* webpackChunkName: "prime-inputgroup" */ "primevue/inputgroupaddon")
// );
// const InputGroup = defineAsyncComponent(() =>
//   import(/* webpackChunkName: "prime-inputgroup" */ "primevue/inputgroup")
// );
// const Button = defineAsyncComponent(() =>
//   import(/* webpackChunkName: "prime-button" */ "primevue/button")
// );
// const Chip = defineAsyncComponent(() =>
//   import(/* webpackChunkName: "prime-chip" */ "primevue/chip")
// );
// // const Paginator = defineAsyncComponent(() =>
// //   import(/* webpackChunkName: "prime-paginator" */ "primevue/paginator")
// // );
// const Dialog = defineAsyncComponent(() =>
//   import(/* webpackChunkName: "prime-dialog" */ "primevue/dialog")
// );
// const Dropdown = defineAsyncComponent(() =>
//   import(/* webpackChunkName: "prime-dropdown" */ "primevue/dropdown")
// );

// Lazy-loaded view components with loading states
const InvoiceAdd = defineAsyncComponent({
  loader: () => import(/* webpackChunkName: "views-invoice" */ "@/views/AddInvoice.vue"),
  loadingComponent: {
    template: '<div class="p-4 text-center">Loading invoice form...</div>',
  },
});

const InvoiceEdit = defineAsyncComponent({
  loader: () => import(/* webpackChunkName: "views-invoice" */ "@/views/EditInvoice.vue"),
  loadingComponent: {
    template: '<div class="p-4 text-center">Loading editor...</div>',
  },
});

const InvoiceView = defineAsyncComponent({
  loader: () => import(/* webpackChunkName: "views-invoice" */ "@/views/InvoiceView.vue"),
  loadingComponent: {
    template: '<div class="p-4 text-center">Loading invoice details...</div>',
  },
});

const AddPayment = defineAsyncComponent({
  loader: () =>
    import(/* webpackChunkName: "views-payment" */ "@/views/AddInvoicePayment.vue"),
  loadingComponent: {
    template: '<div class="p-4 text-center">Loading payment form...</div>',
  },
});

// Static imports for critical dependencies
import axiosInstance from "@/axios";
import eventBus from "@/eventBus";

// Lazy-loaded utilities
// let toast;
// const getToast = async () => {
//   if (!toast) {
//     ({ useToast: toast } = await import("primevue/usetoast"));
//   }
//   return toast();
// };
const toast = useToast();

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
const paymentDialogVisible = ref(false);
const paymentLoading = ref(false);
// BARCODE READER WORK
const inputFocused = ref(false);
const inputRef = ref(null);
let typingTimer = null;
const typingDelay = 500;

const handleKeydown = (event) => {
  if (
    !inputFocused.value &&
    isModalVisible.value === false &&
    deleteDialogVisible.value === false &&
    paymentDialogVisible.value === false &&
    viewDialogVisible.value === false &&
    isEditModalVisible.value === false &&
    !event.ctrlKey
  ) {
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
  // console.log(invoice);
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
const handleInvoiceCreated = () => {
  isModalVisible.value = false;
  currentPage.value = 1;
  fetchInvoices(currentPage.value);
};
const handleInvoiceUpdated = () => {
  isEditModalVisible.value = false;
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
const openPaymentDialog = (invoice) => {
  selectedInvoice.value = invoice;
  paymentDialogVisible.value = true;
};

const handlePaymentSubmit = async (paymentData) => {
  paymentLoading.value = true;
  try {
    // await axiosInstance.post(
    //   `/invoices/${selectedInvoice.value.id}/payments`,
    //   paymentData
    // );
    toast.add({
      severity: "success",
      summary: "Success",
      detail: "Payment added successfully",
      life: 3000,
    });
    paymentDialogVisible.value = false;
    refreshData();
  } catch (error) {
    console.error("Error adding payment:", error);
    toast.add({
      severity: "error",
      summary: "Error",
      detail: error.response?.data?.message || "Failed to add payment",
      life: 5000,
    });
  } finally {
    paymentLoading.value = false;
  }
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
    // console.log(response.data.data.data);
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

// const skeletonRows = Array.from({ length: 10 }).map(() => ({
//   id: "",
//   invoice_number: "",
//   client: "",
//   date: "",
//   due_date: "",
//   status: "",
//   total_amount: "",
//   amount_paid: "",
//   balance_due: "",
//   payment_status: "",
// }));
const generateSkeletonRows = (count = 10) => {
  const statusOptions = ["draft", "pending", "paid", "cancelled"];
  const paymentStatusOptions = ["unpaid", "partial", "paid"];

  return Array.from({ length: count }).map((_, index) => {
    const randomAmount = (Math.random() * 1000).toFixed(2);
    const randomDateOffset = Math.floor(Math.random() * 30);
    const date = new Date();
    date.setDate(date.getDate() - randomDateOffset);

    return {
      id: `skeleton-${index}`, // Unique ID for each row
      invoice_number: `INV-${Math.floor(1000 + Math.random() * 9000)}`,
      client: {
        name: `Client ${String.fromCharCode(65 + (index % 26))}`,
      },
      date: date.toISOString().split("T")[0],
      due_date: new Date(date.setDate(date.getDate() + 7)).toISOString().split("T")[0],
      status: statusOptions[index % statusOptions.length],
      total_amount: randomAmount,
      amount_paid: (randomAmount * 0.7).toFixed(2),
      balance_due: (randomAmount * 0.3).toFixed(2),
      payment_status: paymentStatusOptions[index % paymentStatusOptions.length],
      __skeleton: true, // Optional flag to identify skeleton rows
    };
  });
};

const skeletonRows = generateSkeletonRows(10);
onMounted(() => {
  fetchInvoices();
  window.addEventListener("keydown", handleKeydown);
  eventBus.on("AddInvoice", () => {
    // console.log("OPEN ADD OWNER");
    showModal();
  });
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
