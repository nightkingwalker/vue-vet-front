<template>
    <div class="w-full">
        <DataTable :value="loading ? skeletonRows : stockMovements" class="mx-4 rounded-lg overflow-hidden text-xs"
            stripedRows showGridlines scrollable scrollHeight="95vh" :paginator="true" :rows="10"
            :rowsPerPageOptions="[10, 25, 50]" v-model:first="first"
            paginatorTemplate="FirstPageLink PrevPageLink PageLinks NextPageLink LastPageLink CurrentPageReport RowsPerPageDropdown"
            currentPageReportTemplate="Showing {first} to {last} of {totalRecords} entries">
            <template #empty> {{ $t("stock_movements.no_movements") }} </template>
            <template #loading> {{ $t("stock_movements.loading") }} </template>
            <template #header>
                <div class="flex justify-between items-center !m-b-1">
                    <div class="flex items-center gap-2">

                        <!-- <span class="p-input-icon-left">
                            <i class="pi pi-search" />
                            <InputText v-model="searchQuery" :placeholder="$t('stock_movements.search')"
                                class="!text-xs !h-8" @keyup.enter="applyFilters" />
                        </span> -->
                        <InputGroup
                            class="!text-gray-800 flex !w-1/3 !h-10 rounded-md overflow-hidden border !border-gray-400">
                            <InputGroupAddon class="!text-gray-800 px-4 flex flex-col item-center justify-center">
                                <i class="pi pi-search"></i>
                            </InputGroupAddon>
                            <InputText size="small" v-model="searchQuery" fluid @keyup.enter="applyFilters"
                                ref="inputRef" @focus="inputFocused = true" @blur="inputFocused = false"
                                autofocus="true" type="text"
                                class="!text-sm lg:!text-[14px] !text-gray-800 focus:!ring-0 focus:!ring-offset-0  border-transparent "
                                :placeholder="$t('pets.header.search_placeholder')" />
                            <Button icon="pi pi-times" @click="clearFilters" />
                        </InputGroup>
                        <Select v-model="selectedMovementType" :options="movementTypes" optionLabel="label"
                            :placeholder="$t('stock_movements.filter_type')" class="!text-xs !h-10 w-40" />

                        <DatePicker v-model="dateRange" selectionMode="range" :manualInput="false" dateFormat="yy-mm-d"
                            size="small" :placeholder="$t('stock_movements.date_range')" class="!text-xs !h-10 w-60" />

                        <Button icon="pi pi-filter" @click="applyFilters" :label="$t('stock_movements.filter')"
                            class="!text-xs lg:!text-[14px] ml-2" />

                        <Button icon="pi pi-times" @click="clearFilters" :label="$t('stock_movements.clear')"
                            class="!text-xs lg:!text-[14px] w-fit whitespace-nowrap ml-2 p-button-outlined" />
                        <Button type="button" icon="pi pi-refresh !text-xs" label=""
                            v-tooltip.bottom="$t('stock_movements.refresh')" class="!text-xs !w-8 !h-8"
                            @click="fetchStockMovements(currentPage)" />

                    </div>

                    <h2 class="text-sm !mb-0 pb-0 flex">
                        <i class="fa-solid fa-boxes-stacked ltr:mr-2 rtl:ml-2"></i>
                        {{ $t("stock_movements.title") }}
                    </h2>
                </div>
            </template>

            <Column field="created_at" :header="$t('stock_movements.headers.date')" class="w-1/10" sortable>
                <template v-if="loading" #body>
                    <Skeleton width="100%" height="1rem" />
                </template>
                <template v-else #body="slotProps">
                    {{ formatDate(slotProps.data.created_at) }}
                </template>
            </Column>

            <Column field="inventory_item.name" :header="$t('stock_movements.headers.item')" class="w-1/10" sortable>
                <template v-if="loading" #body>
                    <Skeleton width="100%" height="1rem" />
                </template>
                <template v-else #body="slotProps">
                    {{ slotProps.data.inventory_item.name }}
                </template>
            </Column>

            <Column field="inventory_item.category" :header="$t('stock_movements.headers.category')" class="w-1/10"
                sortable>
                <template v-if="loading" #body>
                    <Skeleton width="100%" height="1rem" />
                </template>
                <template v-else #body="slotProps">
                    {{ t(`inventory.categories.${slotProps.data.inventory_item.category}`) }}
                </template>
            </Column>

            <Column field="movement_type" :header="$t('stock_movements.headers.type')" class="w-1/10" sortable>
                <template v-if="loading" #body>
                    <Skeleton width="100%" height="1rem" />
                </template>
                <template v-else #body="slotProps">
                    <Tag :value="slotProps.data.movement_type"
                        :severity="getMovementTypeSeverity(slotProps.data.movement_type)" />
                </template>
            </Column>

            <Column field="effective_quantity" :header="$t('stock_movements.headers.quantity')" class="w-1/10" sortable>
                <template v-if="loading" #body>
                    <Skeleton width="100%" height="1rem" />
                </template>
                <template v-else #body="slotProps">
                    <span :class="{
                        'text-green-500': slotProps.data.effective_quantity > 0,
                        'text-red-500': slotProps.data.effective_quantity < 0
                    }">
                        {{ formatQuantity(slotProps.data.effective_quantity) }}
                    </span>
                </template>
            </Column>

            <Column field="notes" :header="$t('stock_movements.headers.notes')" class="w-2/5">
                <template v-if="loading" #body>
                    <Skeleton width="100%" height="1rem" />
                </template>
                <template v-else #body="slotProps">
                    {{ slotProps.data.notes }}
                </template>
            </Column>

            <Column field="creator.name" :header="$t('stock_movements.headers.user')" class="w-1/10" sortable>
                <template v-if="loading" #body>
                    <Skeleton width="100%" height="1rem" />
                </template>
                <template v-else #body="slotProps">
                    {{ slotProps.data.creator.name }}
                </template>
            </Column>

            <Column :header="$t('stock_movements.headers.reference')" class="w-1/10">
                <template v-if="loading" #body>
                    <Skeleton width="100%" height="1rem" />
                </template>
                <template v-else #body="slotProps">
                    <Button v-if="slotProps.data.reference_type === 'invoice'" icon="pi pi-file"
                        @click="viewInvoice(slotProps.data.reference_type, slotProps.data.reference_id)"
                        v-tooltip.top="$t('stock_movements.view_invoice')" class="!text-xs !text-primary" text />
                </template>
            </Column>
        </DataTable>
        <Dialog :header="$t('invoices.dialog.view_title')" v-model:visible="viewDialogVisible" modal :closable="true"
            class="w-11/12 md:w-8/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)]">
            <InvoiceView v-if="selectedInvoice" :invoice="selectedInvoice" :paymentMethods="paymentMethods"
                @showPayment="openPaymentDialog(selectedInvoice)" />
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
import axiosInstance from "@/axios";
import eventBus from "@/eventBus";
import Dialog from "primevue/dialog";
import InvoiceView from "@/views/InvoiceView.vue"; // Make sure this path is correct

const { t } = useI18n();
const stockMovements = ref([]);
const loading = ref(false);
const first = ref(0);
const itemsPerPage = ref(10);
const totalRecords = ref(0);
const currentPage = ref(1);
const dateRange = ref(null);
const searchQuery = ref('');
const filters = ref({
    start_date: null,
    end_date: null,
    movement_type: null,
    category: null
});

const skeletonRows = Array.from({ length: 10 }).map(() => ({
    created_at: "",
    inventory_item: { name: "", category: "" },
    movement_type: "",
    effective_quantity: "",
    notes: "",
    creator: { name: "" },
    reference_id: "",
    reference_type: ""
}));
const movementTypes = ref([
    { label: t('stock_movements.types.all'), value: null },
    { label: t('stock_movements.types.purchase'), value: 'purchase' },
    { label: t('stock_movements.types.sale'), value: 'sale' },
    { label: t('stock_movements.types.transfer'), value: 'transfer' },
    { label: t('stock_movements.types.adjustment'), value: 'adjustment' },
    { label: t('stock_movements.types.expired'), value: 'expired' }
]);

const selectedMovementType = ref(movementTypes.value[0]);
const fetchStockMovements = async (page = 1) => {
    try {
        loading.value = true;
        let url = `/stock-movements?branch_id=1&page=${page}&per_page=${itemsPerPage.value}`;

        if (searchQuery.value) {
            url += `&search=${searchQuery.value}`;
        }

        if (selectedMovementType.value.value) {
            url += `&movement_type=${selectedMovementType.value.value}`;
        }

        if (dateRange.value && dateRange.value.length === 2) {
            url += `&start_date=${formatDateForAPI(dateRange.value[0])}`;
            url += `&end_date=${formatDateForAPI(dateRange.value[1])}`;
        }

        const response = await axiosInstance.get(url);
        stockMovements.value = response.data.data.data;
        totalRecords.value = response.data.data.total;
        currentPage.value = response.data.data.current_page;
    } catch (error) {
        console.error("Error fetching stock movements:", error);
    } finally {
        loading.value = false;
    }
};
const applyFilters = () => {
    if (dateRange.value && dateRange.value.length === 2) {
        filters.value.start_date = formatDateForAPI(dateRange.value[0]);
        filters.value.end_date = formatDateForAPI(dateRange.value[1]);
    }
    fetchStockMovements();
};

const clearFilters = () => {
    dateRange.value = null;
    filters.value = {
        start_date: null,
        end_date: null,
        movement_type: null,
        category: null
    };
    fetchStockMovements();
};

const refreshData = () => {
    loading.value = true;
    fetchStockMovements();
};

const formatDate = (dateString) => {
    return new Date(dateString).toLocaleDateString();
};

const formatDateForAPI = (date) => {
    return date.toISOString().split('T')[0];
};

const formatQuantity = (quantity) => {
    return quantity > 0 ? `+${quantity}` : quantity;
};

const getMovementTypeSeverity = (type) => {
    switch (type) {
        case 'purchase': return 'success';
        case 'sale': return 'danger';
        case 'transfer': return 'info';
        case 'adjustment': return 'warning';
        case 'expired': return 'danger';
        default: return null;
    }
};

const viewDialogVisible = ref(false);
const selectedInvoice = ref(null);
const paymentMethods = ref([
    { id: 1, name: "Cash" },
    { id: 2, name: "Credit Card" },
    { id: 3, name: "Bank Transfer" },
]);

// Add this method to view invoice details
const viewInvoiceDetails = async (invoiceId) => {
    try {
        const response = await axiosInstance.get(`/invoices/${invoiceId}`);
        selectedInvoice.value = response.data.data;
        viewDialogVisible.value = true;
    } catch (error) {
        console.error("Error fetching invoice details:", error);
        // You might want to show a toast notification here
    }
};
const viewInvoice = (referenceType, referenceId) => {
    console.log(referenceType)
    if (referenceType === 'invoice') {
        console.log("CLICKED2")
        viewInvoiceDetails(referenceId);
    }
};
/* const viewInvoice = (invoiceId) => {
    // Implement invoice viewing logic
    console.log("View invoice:", invoiceId);
};
 */
onMounted(() => {
    fetchStockMovements();
    eventBus.on("stockMovementAdded", () => {
        fetchStockMovements();
    });
});
</script>

<style scoped>
/* Custom styles if needed */
</style>