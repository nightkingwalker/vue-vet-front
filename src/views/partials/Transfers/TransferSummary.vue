<template>
    <div class="mt-4">
        <h3 class="!text-sm font-semibold mb-3 border-b pb-2">
            {{ $t("transfer.summary_section.title") }}
        </h3>

        <div class="space-y-2 xl:!text-[12px]">
            <div class="flex justify-between">
                <span>{{ $t("transfer.summary_section.total_items") }}</span>
                <span class="font-medium">{{ totalItems }}</span>
            </div>
            <div class="flex justify-between">
                <span>{{ $t("transfer.summary_section.total_quantities") }}</span>
                <span class="font-medium">{{ totalQuantities }}</span>
            </div>
            <div class="flex justify-between">
                <span>{{ $t("transfer.summary_section.total_cost") }}</span>
                <span class="font-medium">${{ totalCost.toFixed(2) }}</span>
            </div>
        </div>
    </div>
</template>

<script setup>
import { computed } from "vue";

const props = defineProps({
    items: {
        type: Array,
        default: () => []   // ✅ ensures we always have an array
    },
});

// Safely calculate totals
const totalItems = computed(() => (props.items || []).length);

const totalQuantities = computed(() =>
    (props.items || []).reduce((sum, item) => sum + (item.quantity || 0), 0)
);

const totalCost = computed(() =>
    (props.items || []).reduce(
        (sum, item) =>
            sum + (item.quantity || 0) * (parseFloat(item.cost_price) || 0),
        0
    )
);
</script>
