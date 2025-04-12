<template>
  <div
    class="bg-gray-50 p-4 rounded-lg wx-1"
    :class="{ 'text-right': $i18n.locale === 'ar' }"
  >
    <h3 class="font-bold text-sm mb-2 border-b pb-1">
      {{ $t("invoice.summary.title") }}
    </h3>
    <div class="space-y-2">
      <div class="flex justify-between">
        <span>{{ $t("invoice.summary.subtotal") }}</span>
        <span>${{ parseFloat(invoice.subtotal).toFixed(2) }}</span>
      </div>
      <div class="flex justify-between">
        <span>{{ $t("invoice.summary.discount") }}</span>
        <span class="text-red-500">
          -${{ parseFloat(invoice.discount_amount).toFixed(2) }}
        </span>
      </div>
      <div class="flex justify-between">
        <span>{{ $t("invoice.summary.tax") }}</span>
        <span>${{ parseFloat(invoice.tax_amount).toFixed(2) }}</span>
      </div>
      <div class="flex justify-between font-bold border-t pt-2 mt-2">
        <span>{{ $t("invoice.summary.total") }}</span>
        <span>${{ parseFloat(invoice.total_amount).toFixed(2) }}</span>
      </div>
      <div v-if="invoice.deposit_required > 0" class="flex justify-between">
        <span>{{ $t("invoice.summary.first_deposit") }}</span>
        <span>${{ parseFloat(invoice.deposit_paid).toFixed(2) }}</span>
      </div>
      <div class="flex justify-between">
        <span>{{ $t("invoice.summary.amount_paid") }}</span>
        <span>${{ parseFloat(invoice.amount_paid).toFixed(2) }}</span>
      </div>
      <div
        v-if="invoice.balance_due > 0"
        class="flex justify-between font-bold text-red-500"
      >
        <span>{{ $t("invoice.summary.balance_due") }}</span>
        <span>
          ${{
            (parseFloat(invoice.total_amount) - parseFloat(invoice.amount_paid)).toFixed(
              2
            )
          }}
        </span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useI18n } from "vue-i18n";

const { t } = useI18n();
defineProps({
  invoice: {
    type: Object,
    required: true,
  },
});
</script>
