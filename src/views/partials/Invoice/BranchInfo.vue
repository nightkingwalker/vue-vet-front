<template>
  <div class="bg-gray-50 p-4 rounded-lg">
    <h3 class="font-bold text-sm mb-2 border-b pb-1">
      {{ $t("invoice.branch_info.from") }}
    </h3>
    <div class="space-y-1">
      <div class="text-md font-semibold">{{ branch.name }}</div>
      <div>{{ branch.address }}</div>
      <div>{{ $t("invoice.branch_info.phone") }} {{ branch.phone }}</div>
    </div>
  </div>
</template>

<script setup>
import { useI18n } from "vue-i18n";

const { t } = useI18n();
defineProps({
  branch: {
    type: Object,
    required: true,
  },
});
</script>
