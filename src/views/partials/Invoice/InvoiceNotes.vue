<template>
  <div :class="{ 'text-right': $i18n.locale === 'ar' }">
    <h3 class="font-bold text-sm mb-2">{{ $t("invoice.notes.title") }}</h3>
    <div
      class="bg-gray-50 p-4 rounded-lg whitespace-pre-line"
      :dir="$i18n.locale === 'ar' ? 'rtl' : 'ltr'"
    >
      {{ notes }}
    </div>
  </div>
</template>

<script setup>
import { useI18n } from "vue-i18n";

const { t } = useI18n();
defineProps({
  notes: {
    type: String,
    required: true,
  },
});
</script>

<style scoped>
/* Additional RTL styling if needed */
[dir="rtl"] .notes-content {
  text-align: right;
}
</style>
