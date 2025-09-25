<template>
    <div class="w-full mt-2 xl:!text-[12px]">
        <div
            class="grid grid-cols-1 lg:grid-cols-4 gap-6 bg-[var(--p-surface-200)] dark:bg-[var(--p-surface-600)] rounded-lg p-2">
            <!-- Left Column - Branch Info -->
            <div class="bg-white dark:bg-[var(--p-surface-800)] p-4 rounded-lg shadow">
                <h2 class="!text-sm font-semibold mb-4 border-b pb-2">
                    {{ $t("transfer.branch_section.title") }}
                </h2>
                <BranchInfo v-model:sourceBranch="sourceBranch" v-model:destinationBranch="destinationBranch"
                    :branches="branches" />
            </div>

            <!-- Middle Column - Item Search & List -->
            <div class="bg-white dark:bg-[var(--p-surface-800)] p-4 rounded-lg shadow col-span-2">
                <h2 class="!text-sm font-semibold mb-4 border-b pb-2">
                    {{ $t("transfer.items_section.title") }}
                </h2>
                <TransferItemsTable v-model:items="transferItems" :sourceBranch="sourceBranch" />
            </div>

            <!-- Right Column - Transfer Metadata & Summary -->
            <div class="bg-white dark:bg-[var(--p-surface-800)] p-4 rounded-lg shadow">
                <h2 class="!text-sm font-semibold mb-4 border-b pb-2">
                    {{ $t("transfer.summary_section.title") }}
                </h2>

                <TransferMetaData v-model:transferNumber="transferNumber" v-model:transferDate="transferDate"
                    v-model:status="status" />

                <TransferSummary :items="transferItems" />

                <TransferNotes v-model="notes" />

                <TransferActions :loading="loading" @saveDraft="saveDraft" @createTransfer="createTransfer" />
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import axiosInstance from "@/axios";

// Partials (to be created under src/views/partials/Transfers/)
import BranchInfo from "@/views/partials/Transfers/BranchInfo.vue";
import TransferItemsTable from "@/views/partials/Transfers/TransferItemsTable.vue";
import TransferMetaData from "@/views/partials/Transfers/TransferMetaData.vue";
import TransferSummary from "@/views/partials/Transfers/TransferSummary.vue";
import TransferNotes from "@/views/partials/Transfers/TransferNotes.vue";
import TransferActions from "@/views/partials/Transfers/TransferActions.vue";

const sourceBranch = ref(null);
const destinationBranch = ref(null);
const branches = ref([]);

const transferItems = ref([]);
const transferNumber = ref("");
const transferDate = ref(new Date());
const status = ref("draft");
const notes = ref("");
const loading = ref(false);

// Load branches from API
onMounted(async () => {
    try {
        const response = await axiosInstance.get("/branches");

        branches.value = response.data;
        // console.log("Branches loaded:", branches.value);
    } catch (err) {
        console.error("Error loading branches:", err);
    }

    generateTransferNumber();
});

// Generate transfer number
const generateTransferNumber = () => {
    const date = new Date();
    const prefix = "TRF";
    const year = date.getFullYear().toString().slice(-2);
    const month = (date.getMonth() + 1).toString().padStart(2, "0");
    const random = Math.floor(1000 + Math.random() * 9000);
    transferNumber.value = `${prefix}-${year}${month}-${random}`;
};

// Save as draft
const saveDraft = async () => {
    status.value = "draft";
    await createTransfer();
};

// Submit transfer
const createTransfer = async () => {
    if (!sourceBranch.value || !destinationBranch.value || transferItems.value.length === 0) {
        console.warn("Missing fields");
        return;
    }

    // ✅ Always fallback to empty array if branches not loaded
    const branchList = branches.value || [];

    const sourceName =
        branchList.find((b) => b.id === sourceBranch.value)?.name ||
        `Branch ${sourceBranch.value}`;

    const destinationName =
        branchList.find((b) => b.id === destinationBranch.value)?.name ||
        `Branch ${destinationBranch.value}`;

    loading.value = true;

    try {
        for (const item of transferItems.value) {
            const payload = {
                source_branch_id: sourceBranch.value,
                destination_branch_id: destinationBranch.value,
                inventory_item_id: item.id,
                quantity: item.quantity,
                // ✅ Add branch names to notes
                notes: `${notes.value || ""} | Transfer from ${sourceName} to ${destinationName}`,
            };

            await axiosInstance.post("/stock-movements/transfer", payload);
        }

        // console.log("Transfer order completed successfully");
    } catch (err) {
        console.error("Error creating transfer:", err);
    } finally {
        loading.value = false;
    }
};

</script>
