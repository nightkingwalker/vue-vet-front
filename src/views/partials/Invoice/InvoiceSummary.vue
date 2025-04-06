<template>
  <div class="bg-gray-50 p-4 rounded-lg wx-1">
    <h3 class="font-bold text-sm mb-2 border-b pb-1">Invoice Summary</h3>
    <div class="space-y-2">
      <div class="flex justify-between">
        <span>Subtotal:</span>
        <span>${{ parseFloat(invoice.subtotal).toFixed(2) }}</span>
      </div>
      <div class="flex justify-between">
        <span>Discount:</span>
        <span class="text-red-500">
          -${{ parseFloat(invoice.discount_amount).toFixed(2) }}
        </span>
      </div>
      <div class="flex justify-between">
        <span>Tax:</span>
        <span>${{ parseFloat(invoice.tax_amount).toFixed(2) }}</span>
      </div>
      <div class="flex justify-between font-bold border-t pt-2 mt-2">
        <span>Total:</span>
        <span>${{ parseFloat(invoice.total_amount).toFixed(2) }}</span>
      </div>
      <div v-if="invoice.deposit_required > 0" class="flex justify-between">
        <span>First Deposit:</span>
        <span>${{ parseFloat(invoice.deposit_paid).toFixed(2) }}</span>
      </div>
      <div class="flex justify-between">
        <span>Total Amount Paid:</span>
        <span>${{ parseFloat(invoice.amount_paid).toFixed(2) }}</span>
      </div>
      <div
        v-if="invoice.balance_due > 0"
        class="flex justify-between font-bold text-red-500"
      >
        <span>Balance Due:</span>
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
defineProps({
  invoice: {
    type: Object,
    required: true,
  },
});
</script>
