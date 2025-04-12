<template>
  <div class="bg-gray-50 p-4 rounded-lg" :class="{ 'text-right': $i18n.locale === 'ar' }">
    <h3 class="font-bold text-sm mb-2 border-b pb-1">
      {{ $t("invoice.client_info.bill_to") }}
    </h3>
    <div class="space-y-1">
      <div class="text-sm font-medium">{{ client.name }}</div>
      <div>{{ client.address }}</div>
      <div>
        {{ $t("invoice.client_info.phone") }} {{ $t("invoice.client_info.phone_masked") }}
      </div>
      <!-- Uncomment if you want to show actual phone number -->
      <!-- <div>{{ $t('invoice.client_info.phone') }} {{ client.phone }}</div> -->
      <div>{{ $t("invoice.client_info.email") }} {{ client.email }}</div>
    </div>
  </div>
</template>

<script setup>
import { useI18n } from "vue-i18n";

const { t } = useI18n();
defineProps({
  client: {
    type: Object,
    required: true,
  },
});
</script>
