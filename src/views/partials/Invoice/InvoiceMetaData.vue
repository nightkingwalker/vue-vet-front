<template>
  <div class="flex flex-col md:flex-row md:justify-between md:items-center gap-2">
    <div>
      <span class="font-medium">{{ $t("invoice.metadata.date") }}</span>
      {{ formatDate(date) }}
    </div>
    <div>
      <span class="font-medium">{{ $t("invoice.metadata.due_date") }}</span>
      {{ formatDate(dueDate) }}
    </div>
    <div v-if="paymentTerms">
      <span class="font-medium">{{ $t("invoice.metadata.payment_terms") }}</span>
      {{ $t(`invoice.metadata.terms.${paymentTerms}`) }}
    </div>
  </div>
</template>

<script setup>
import { useI18n } from "vue-i18n";

const { t } = useI18n();
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
</script>
