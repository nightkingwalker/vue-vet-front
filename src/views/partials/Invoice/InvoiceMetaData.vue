<template>
  <div class="flex flex-col md:flex-row md:justify-between md:items-center gap-2">
    <div><span class="font-medium">Date:</span> {{ formatDate(date) }}</div>
    <div><span class="font-medium">Due Date:</span> {{ formatDate(dueDate) }}</div>
    <div v-if="paymentTerms">
      <span class="font-medium">Payment Terms:</span>
      {{ formatPaymentTerms(paymentTerms) }}
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  date: String,
  dueDate: String,
  paymentTerms: String,
});

const formatDate = (dateString) => {
  if (!dateString) return "";
  const options = { year: "numeric", month: "short", day: "numeric" };
  return new Date(dateString).toLocaleDateString(undefined, options);
};

const formatPaymentTerms = (terms) => {
  const termsMap = {
    due_on_receipt: "Due on Receipt",
    net_15: "Net 15 Days",
    net_30: "Net 30 Days",
    "50_upfront": "50% Upfront, 50% on Completion",
  };
  return termsMap[terms] || terms;
};
</script>
