<template>
  <Tag
    :value="$t(`invoice.status.${status}`)"
    :severity="getStatusSeverity(status)"
    class="!text-sm"
  />
</template>

<script setup>
import { useI18n } from "vue-i18n";
import Tag from "primevue/tag";

const { t } = useI18n();
const props = defineProps({
  status: {
    type: String,
    required: true,
  },
});

const getStatusSeverity = (status) => {
  const severityMap = {
    draft: "info",
    pending: "warning",
    partially_paid: "warning",
    paid: "success",
    cancelled: "danger",
    refunded: "info",
  };
  return severityMap[status] || "info";
};
</script>
