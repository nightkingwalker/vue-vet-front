<template>
    <div class="w-full lg:!text-[14px]">
        <form @submit.prevent="handleSubmit" class="mx-auto w-full">
            <fieldset
                class="p-fieldset p-component w-9/10 flex flex-wrap justify-between mx-auto items-top border rounded-lg p-4">
                <legend>{{ $t("inventory.transfer.title") }}</legend>

                <!-- Source Branch -->
                <div class="field w-1/2 mt-4">
                    <FloatLabel class="w-[95%] !text-xs">
                        <Select v-model="form.sourceBranchId" :options="branches" optionLabel="name" optionValue="id"
                            :invalid="invalid.sourceBranchId" class="w-full" />
                        <label>{{ $t("inventory.transfer.source_branch") }}</label>
                    </FloatLabel>
                </div>

                <!-- Destination Branch -->
                <div class="field w-1/2 mt-4">
                    <FloatLabel class="w-[95%] !text-xs">
                        <Select v-model="form.destinationBranchId" :options="filteredDestBranches" optionLabel="name"
                            optionValue="id" :invalid="invalid.destinationBranchId" class="w-full" />
                        <label>{{ $t("inventory.transfer.destination_branch") }}</label>
                    </FloatLabel>
                </div>
                <!-- Item Search -->
                <div class="field w-full mt-6">
                    <FloatLabel class="w-[95%] !text-xs">
                        <AutoComplete v-model="searchInput" :suggestions="filteredSuggestions" @complete="searchItems"
                            optionLabel="displayText" dropdown forceSelection @item-select="handleItemSelect" fluid
                            @keydown.enter.prevent="handleBarcodeScan">
                            <template #item="slotProps">
                                <div class="flex flex-col p-2">
                                    <div class="flex justify-between">
                                        <span class="font-medium">{{ slotProps.item.name }}</span>
                                        <span class="text-sm text-gray-500 ml-2">
                                            {{ slotProps.item.brand }}
                                        </span>
                                    </div>
                                    <div class="mt-1">
                                        <Tag v-if="slotProps.item.barcode" :value="slotProps.item.barcode"
                                            severity="info" class="text-xs" />
                                    </div>
                                </div>
                            </template>
                        </AutoComplete>
                        <label>{{ $t("inventory.transfer.item") }}</label>
                    </FloatLabel>
                </div>

                <!-- Quantity -->
                <div class="field mt-6 w-1/2">
                    <FloatLabel class="w-[95%] !text-xs">
                        <InputNumber id="quantity" class="!text-xs" fluid v-model="form.quantity"
                            :invalid="invalid.quantity" mode="decimal" :min="1" :max="5000000" :step="1" />
                        <label for="quantity">{{ $t("inventory.transfer.quantity") }}</label>
                    </FloatLabel>
                </div>

                <!-- Notes -->
                <div class="field mt-6 w-full">
                    <FloatLabel class="w-full !text-xs">
                        <Textarea id="notes" class="!text-xs" fluid v-model="form.notes" rows="2" />
                        <label for="notes">{{ $t("inventory.transfer.notes") }}</label>
                    </FloatLabel>
                </div>

                <!-- Buttons -->
                <div class="field mt-6 w-full flex justify-end gap-3">
                    <Button type="button" :label="$t('common.cancel')" icon="pi pi-times" severity="secondary"
                        @click="$emit('cancelled')" />
                    <Button type="submit" :label="$t('inventory.transfer.submit')" icon="pi pi-save" :loading="loading"
                        class="!text-xs" />
                </div>
            </fieldset>
        </form>
    </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import { useToast } from "primevue/usetoast";
import Cookies from "js-cookie";
import axiosInstance from "@/axios";

// PrimeVue
import InputText from "primevue/inputtext";
import FloatLabel from "primevue/floatlabel";
import Button from "primevue/button";
import Select from "primevue/select";
import InputNumber from "primevue/inputnumber";
import Textarea from "primevue/textarea";
import AutoComplete from "primevue/autocomplete";
import Tag from "primevue/tag";

const emit = defineEmits(["submitted", "cancelled"]);
const toast = useToast();

// FORM
const form = ref({
    sourceBranchId: Cookies.get("M3K8g2387BahBaqyjDe6"),
    sourceBranchName: Cookies.get("branch_name") || "Current Branch",
    destinationBranchId: null,
    itemId: null,
    quantity: 1,
    notes: "",
});

const invalid = ref({
    sourceBranchId: false,
    destinationBranchId: false,
    quantity: false,
});

const filteredDestBranches = computed(() => {
    return branches.value.filter(b => b.id !== form.value.sourceBranchId);
});

// In handleSubmit validation
invalid.value.sourceBranchId = !form.value.sourceBranchId;
invalid.value.destinationBranchId = !form.value.destinationBranchId;
invalid.value.quantity = !form.value.quantity || form.value.quantity <= 0;

const branches = ref([]);

// Autocomplete search
const searchInput = ref("");
const searchResults = ref([]);
const filteredSuggestions = computed(() => {
    return searchResults.value.filter(
        (item) => item.name && typeof item.name === "string"
    );
});

const searchItems = async (event) => {
    if (event.query.trim().length < 2) {
        searchResults.value = [];
        return;
    }
    try {
        const { data } = await axiosInstance.get(`/inventory-items/search`, {
            params: {
                branch_id: form.value.sourceBranchId,
                query: event.query,
            },
        });
        searchResults.value = data.data.map((item) => ({
            ...item,
            displayText: `${item.name} (${item.brand})`,
        }));
    } catch (error) {
        console.error("Search error:", error);
        searchResults.value = [];
    }
};

const handleItemSelect = (event) => {
    if (!event.value) return;
    form.value.itemId = event.value.id;
    searchInput.value = event.value.displayText;
};

const handleBarcodeScan = () => {
    // optional barcode scan handler
    return;
};

// Submit
const loading = ref(false);
const handleSubmit = async () => {
    invalid.value.destinationBranchId = !form.value.destinationBranchId;
    invalid.value.quantity = !form.value.quantity || form.value.quantity <= 0;

    if (invalid.value.destinationBranchId || invalid.value.quantity) {
        toast.add({
            severity: "error",
            summary: "Error",
            detail: "Please fill required fields",
            life: 4000,
        });
        return;
    }

    loading.value = true;
    try {
        const payload = {
            source_branch_id: form.value.sourceBranchId,
            destination_branch_id: form.value.destinationBranchId,
            inventory_item_id: form.value.itemId,
            quantity: form.value.quantity,
            notes: form.value.notes,
        };

        await axiosInstance.post("/stock-movements/transfer", payload);

        toast.add({
            severity: "success",
            summary: "Success",
            detail: "Stock transferred successfully",
            life: 4000,
        });

        emit("submitted", payload);
    } catch (error) {
        console.error("Transfer error:", error);
        toast.add({
            severity: "error",
            summary: "Error",
            detail: error.response?.data?.message || "Transfer failed",
            life: 5000,
        });
    } finally {
        loading.value = false;
    }
};

onMounted(async () => {
    try {
        const { data } = await axiosInstance.get("/branches");
        branches.value = data;
        console.log("Fetched branches:", data);
    } catch (err) {
        console.error("Error fetching branches:", err);
    }
});
</script>
