<template>
    <Tag :value="statusLabel" :severity="statusSeverity" class="px-3 py-1 rounded-full text-xs font-medium" />
</template>

<script setup>
import { computed } from "vue";
import Tag from "primevue/tag";
import { useI18n } from "vue-i18n";

const { t } = useI18n();

const props = defineProps({
    status: {
        type: String,
        default: "draft", // possible: draft, pending, completed, cancelled
    },
});

const statusLabel = computed(() => {
    return t(`transfer.status.${props.status}`);
});

const statusSeverity = computed(() => {
    switch (props.status) {
        case "draft":
            return "secondary";
        case "pending":
            return "info";
        case "completed":
            return "success";
        case "cancelled":
            return "danger";
        default:
            return "secondary";
    }
});
</script>
