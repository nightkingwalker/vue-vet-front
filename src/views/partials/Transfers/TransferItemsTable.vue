<template>
    <div>
        <!-- Item Search -->
        <div class="mb-4">
            <FloatLabel class="lg:!text-xs w-full">
                <!-- <AutoComplete v-model="itemSearch" :suggestions="filteredItems" :forceSelection="false" dropdown fluid
                    optionLabel="displayText" @complete="searchItems" @item-select="selectItem"
                    :disabled="!props.sourceBranch" /> -->
                <AutoComplete v-model="itemSearch" :suggestions="filteredItems" @complete="searchItems"
                    optionLabel="displayText" size="small" fluid @item-select="selectItem"
                    @keyup.enter="handleBarcodeEnter" @keydown.enter.prevent="handleBarcodeEnter">
                    <template #item="slotProps">
                        <div class="flex items-center justify-between p-2">
                            <div>
                                <div class="font-medium">{{ slotProps.item.name }}</div>
                                <div class="lg:!text-xs text-gray-500">
                                    {{ slotProps.item.brand }}
                                </div>
                            </div>
                            <div class="flex items-center">
                                <span class="lg:!text-xs font-semibold ltr:mr-2 rtl:ml-2">${{
                                    slotProps.item.selling_price }}</span>
                                <Tag v-if="slotProps.item.quantity <= 0"
                                    :value="$t('add_invoice.items_section.out_of_stock')" severity="danger" />
                                <Tag v-else-if="
                                    slotProps.item.expiry_date &&
                                    new Date(slotProps.item.expiry_date) < new Date()
                                " :value="$t('add_invoice.items_section.expired')" severity="warning" />
                                <Tag v-else :value="$t('add_invoice.items_section.in_stock')" severity="success" />
                            </div>
                        </div>
                    </template>
                    <template #option="slotProps">
                        <div class="flex items-center">
                            <div>
                                <Chip :icon="slotProps.option.category === 'food'
                                    ? 'fa-solid fa-bone'
                                    : slotProps.option.category === 'miscellaneous'
                                        ? 'fa-solid fa-volleyball'
                                        : slotProps.option.category === 'pharmaceutical'
                                            ? 'fa-solid fa-pills'
                                            : slotProps.option.category === 'grooming'
                                                ? 'fa-solid fa-shower'
                                                : slotProps.option.category === 'treatment'
                                                    ? 'fa-solid fa-stethoscope'
                                                    : 'fa-solid fa-question'
                                    " />
                                {{ slotProps.option.brand }} {{ slotProps.option.name }} --
                                ${{ slotProps.option.cost_price }}
                                <Tag v-if="
                                    slotProps.option.quantity <= slotProps.option.minimum_stock_level
                                " :value="$t('add_invoice.items_section.almost_out_of_stock') +
                                    ` ` +
                                    slotProps.option.quantity
                                    " severity="warn" />
                                <Tag v-else :value="$t('add_invoice.items_section.in_stock') +
                                    ` ` +
                                    slotProps.option.quantity
                                    " severity="success" />
                            </div>
                        </div>
                    </template>
                </AutoComplete>
                <label>{{ $t("transfer.items_section.search_items") }}</label>
            </FloatLabel>
        </div>

        <!-- Selected Item Form -->
        <div v-if="selectedItem" class="mb-4 p-3 bg-gray-50 dark:bg-[var(--p-surface-700)] rounded">
            <div class="flex justify-between items-start mb-2">
                <div>
                    <div class="font-medium">{{ selectedItem.name }}</div>
                    <div class="lg:!text-xs text-gray-500">
                        {{ selectedItem.brand }}
                    </div>
                </div>
                <Button size="small" icon="pi pi-times" class="p-button-text p-button-xs lg:!text-xs"
                    @click="clearItem" />
            </div>

            <div class="grid grid-cols-2 gap-4 mt-3">
                <!-- Quantity -->
                <div>
                    <FloatLabel variant="on" class="lg:!text-xs">
                        <InputNumber v-model="itemQuantity" :min="1" :max="selectedItem ? selectedItem.quantity : null"
                            showButtons fluid size="small" />
                        <label>{{ $t("transfer.items_section.quantity") }}</label>
                    </FloatLabel>
                </div>

                <!-- Cost Price (readonly) -->
                <div>
                    <FloatLabel variant="on" class="lg:!text-xs">
                        <InputNumber v-model="selectedItem.cost_price" mode="currency" currency="USD" fluid size="small"
                            :disabled="true" />
                        <label>{{ $t("transfer.items_section.cost_price") }}</label>
                    </FloatLabel>
                </div>
            </div>

            <div class="mt-3 flex justify-end">
                <Button size="small" :label="$t('transfer.items_section.add_to_transfer')" icon="pi pi-plus"
                    class="lg:!text-xs" @click="addItemToTransfer" />
            </div>
        </div>

        <!-- Items Table -->
        <DataTable :value="items" class="p-datatable-sm" :scrollable="true" scrollHeight="300px" editMode="cell"
            @cell-edit-complete="onCellEditComplete">
            <template #empty> No customers found. </template>
            <template #loading> Loading customers data. Please wait. </template>
            <Column field="name" :header="$t('transfer.items_section.item')" class="lg:!text-xs" />
            <Column field="quantity" :header="$t('transfer.items_section.qty')" class="lg:!text-xs"
                style="width: 120px">
                <template #editor="slotProps">
                    <InputNumber v-model="slotProps.data.quantity" :min="1" showButtons size="small" fluid />
                </template>
            </Column>
            <Column :header="$t('transfer.items_section.cost_price')" class="lg:!text-xs" style="width: 100px">
                <template #body="slotProps">
                    ${{ Number(slotProps.data.cost_price).toFixed(2) }}
                </template>
            </Column>
            <Column :header="$t('transfer.items_section.actions')" style="width: 80px">
                <template #body="slotProps">
                    <Button size="small" icon="pi pi-trash" class="p-button-text p-button-danger"
                        @click="removeItem(slotProps.index)" />
                </template>
            </Column>
        </DataTable>
    </div>
</template>

<script setup>
import { ref } from "vue";
import { useToast } from "primevue/usetoast";
import axiosInstance from "@/axios";

// PrimeVue
import AutoComplete from "primevue/autocomplete";
import FloatLabel from "primevue/floatlabel";
import InputNumber from "primevue/inputnumber";
import Button from "primevue/button";
import DataTable from "primevue/datatable";
import Column from "primevue/column";
import Chip from "primevue/chip";
import Tag from "primevue/tag";

const props = defineProps({
    items: {
        type: Array,
        default: () => [],
    },
    sourceBranch: {
        type: [String, Number, null],
        default: null,
    },
});

const emit = defineEmits(["update:items"]);

const toast = useToast();

const itemSearch = ref("");
const filteredItems = ref([]);
const selectedItem = ref(null);
const itemQuantity = ref(1);

// Search items from source branch
const searchItems = async (event) => {
    if (event.query.trim().length < 2 || !props.sourceBranch) {
        filteredItems.value = [];
        return;
    }
    try {
        const response = await axiosInstance.get("/inventory-items/search/transfer", {
            params: {
                branch_id: props.sourceBranch,
                query: event.query,
            },
        });

        // console.log("Search response:", response);
        const items = response.data.data || response.data; // normalize
        filteredItems.value = items.map((item) => ({
            ...item,
            displayText: `${item.name} (${item.brand}) - $${item.cost_price}- ${item.quantity}`,
        }));
    } catch (err) {
        console.error("Search error:", err);
        filteredItems.value = [];
    }
};

// Select item
const selectItem = (event) => {
    selectedItem.value = event.value;
    itemQuantity.value = 1;
    itemSearch.value = event.value.displayText;
};

const clearItem = () => {
    selectedItem.value = null;
    itemSearch.value = "";
};

// Add item to transfer list
const addItemToTransfer = () => {
    if (!selectedItem.value || itemQuantity.value <= 0) return;

    // Prevent adding more than available stock
    if (itemQuantity.value > selectedItem.value.quantity) {
        toast.add({
            severity: "error",
            summary: "Error",
            detail: `Only ${selectedItem.value.quantity} available in stock`,
            life: 4000,
        });
        return;
    }

    const newItem = {
        id: selectedItem.value.id,
        name: selectedItem.value.name,
        brand: selectedItem.value.brand,
        quantity: itemQuantity.value,
        cost_price: parseFloat(selectedItem.value.cost_price) || 0,
    };

    emit("update:items", [...props.items, newItem]);

    clearItem();
    toast.add({
        severity: "success",
        summary: "Added",
        detail: "Item added to transfer",
        life: 3000,
    });
};

const handleBarcodeEnter = () => {
    // Optional: implement barcode scan support later
    return;
};

// Inline edit handler
const onCellEditComplete = (event) => {
    const { newValue, field, index } = event;
    const updated = [...props.items];
    updated[index][field] = newValue;
    emit("update:items", updated);
};

// Remove item
const removeItem = (index) => {
    const updated = [...props.items];
    updated.splice(index, 1);
    emit("update:items", updated);
};
</script>
