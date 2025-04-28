<template>
    <div class="w-full">
        <DataTable :value="loading ? skeletonRows : stockMovements" class="mx-4 rounded-lg overflow-hidden text-xs"
            stripedRows showGridlines scrollable scrollHeight="400px" :paginator="true" :rows="10"
            :rowsPerPageOptions="[10, 25, 50]" v-model:first="first"
            paginatorTemplate="FirstPageLink PrevPageLink PageLinks NextPageLink LastPageLink CurrentPageReport RowsPerPageDropdown"
            currentPageReportTemplate="Showing {first} to {last} of {totalRecords} entries">
            <template #empty> {{ $t("stock_movements.no_movements") }} </template>
            <template #loading> {{ $t("stock_movements.loading") }} </template>
            <template #header>
                <div class="flex justify-between items-center !m-b-1">
                    <div class="flex">
                        <Button type="button" icon="pi pi-refresh !text-xs" label=""
                            v-tooltip.bottom="$t('stock_movements.refresh')" class="!text-xs ml-2 !w-8 !h-8"
                            @click="refreshData" />
                        <div class="flex items-center ml-4">
                            <Calendar v-model="dateRange" selectionMode="range" :manualInput="false"
                                dateFormat="yy-mm-dd" placeholder="Select Date Range" class="!text-xs !h-8" />
                            <Button icon="pi pi-filter" @click="applyFilters" :label="$t('stock_movements.filter')"
                                class="!text-xs !h-8 ml-2" />
                            <Button icon="pi pi-times" @click="clearFilters" :label="$t('stock_movements.clear')"
                                class="!text-xs !h-8 ml-2 p-button-outlined" />
                        </div>
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
                    {{ slotProps.data.inventory_item.category }}
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
                        @click="viewInvoice(slotProps.data.reference_id)"
                        v-tooltip.top="$t('stock_movements.view_invoice')" class="!text-xs !text-primary" text />
                </template>
            </Column>
        </DataTable>
    </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useI18n } from "vue-i18n";
import DataTable from "primevue/datatable";
import Column from "primevue/column";
import Skeleton from "primevue/skeleton";
import Button from "primevue/button";
import Tag from "primevue/tag";
import Calendar from "primevue/calendar";
import axiosInstance from "@/axios";
import eventBus from "@/eventBus";

const { t } = useI18n();

const stockMovements = ref([]);
const loading = ref(false);
const first = ref(0);
const dateRange = ref(null);
const filters = ref({
    start_date: null,
    end_date: null,
    movement_type: null,
    category: null
});

const skeletonRows = Array.from({ length: 5 }).map(() => ({
    created_at: "",
    inventory_item: { name: "", category: "" },
    movement_type: "",
    effective_quantity: "",
    notes: "",
    creator: { name: "" }
}));

const fetchStockMovements = async () => {
    loading.value = true;
    try {
        let params = {};
        if (filters.value.start_date && filters.value.end_date) {
            params.start_date = filters.value.start_date;
            params.end_date = filters.value.end_date;
        }

        const response = await axiosInstance.get("/stock-movements", { params });
        stockMovements.value = response.data.data;
        console.log(response.data.data);
        rrturn
        loading.value = false;
    } catch (error) {
        console.error("Error fetching stock movements:", error);
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

const viewInvoice = (invoiceId) => {
    // Implement invoice viewing logic
    console.log("View invoice:", invoiceId);
};

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