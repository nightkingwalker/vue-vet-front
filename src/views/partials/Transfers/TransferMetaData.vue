<template>
    <div class="bg-white dark:bg-[var(--p-surface-800)] p-4 rounded-lg shadow">
        <h2 class="!text-sm font-semibold mb-4 border-b pb-2">
            {{ $t("transfer.meta_section.title") }}
        </h2>

        <!-- Transfer Number -->
        <div class="mb-4">
            <FloatLabel variant="on" class="lg:!text-xs w-full">
                <InputText v-model="localTransferNumber" disabled fluid />
                <label>{{ $t("transfer.meta_section.transfer_number") }}</label>
            </FloatLabel>
        </div>

        <!-- Transfer Date -->
        <div class="mb-4">
            <FloatLabel variant="on" class="lg:!text-xs w-full">
                <DatePicker v-model="localTransferDate" dateFormat="yy-mm-dd" showIcon fluid />
                <label>{{ $t("transfer.meta_section.transfer_date") }}</label>
            </FloatLabel>
        </div>

        <!-- Status -->
        <div class="mb-4">
            <FloatLabel variant="on" class="lg:!text-xs w-full">
                <Select v-model="localStatus" :options="statusOptions" optionLabel="label" optionValue="value" fluid />
                <label>{{ $t("transfer.meta_section.status") }}</label>
            </FloatLabel>
        </div>
    </div>
</template>

<script setup>
import { ref, watch } from "vue";
import InputText from "primevue/inputtext";
import DatePicker from "primevue/datepicker";
import Select from "primevue/select";
import FloatLabel from "primevue/floatlabel";

const props = defineProps({
    transferNumber: String,
    transferDate: [String, Date],
    status: String,
});

const emit = defineEmits([
    "update:transferNumber",
    "update:transferDate",
    "update:status",
]);

// local copies
const localTransferNumber = ref(props.transferNumber);
const localTransferDate = ref(props.transferDate);
const localStatus = ref(props.status);

const statusOptions = [
    { label: "Draft", value: "draft" },
    { label: "Pending", value: "pending" },
    { label: "Completed", value: "completed" },
];
// sync props -> local
watch(() => props.transferNumber, (val) => (localTransferNumber.value = val));
watch(() => props.transferDate, (val) => (localTransferDate.value = val));
watch(() => props.status, (val) => (localStatus.value = val));

// sync local -> parent
watch(localTransferNumber, (val) => emit("update:transferNumber", val));
watch(localTransferDate, (val) => emit("update:transferDate", val));
watch(localStatus, (val) => emit("update:status", val));
</script>