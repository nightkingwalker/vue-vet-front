<template>
  <Tag
    :value="formatStatus(status)"
    :severity="getStatusSeverity(status)"
    class="!text-sm"
  />
</template>

<script setup>
import Tag from "primevue/tag";
const props = defineProps({
  status: {
    type: String,
    required: true,
  },
});

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
