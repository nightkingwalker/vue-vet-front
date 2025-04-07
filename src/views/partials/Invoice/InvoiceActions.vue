<template>
  <div class="border-t pt-4 mt-6 no-print">
    <div class="flex flex-col md:flex-row justify-between items-center gap-4">
      <div class="text-sm text-gray-500"></div>
      <div class="flex gap-2">
        <Button
          label="Print Invoice"
          icon="pi pi-print"
          @click="$emit('print')"
          class="p-button-sm no-print"
        />
        <!-- <Button
          label="Download PDF"
          icon="pi pi-download"
          class="p-button-sm p-button-outlined no-print"
          @click="$emit('download')"
        /> -->
        <Button
          size="small"
          icon="fa-solid fa-hand-holding-dollar"
          class="p-button-sm !text-[var(--p-primary-contrast-color)] dark:!text-[var(--p-primary-900)]"
          @click="openPaymentDialog(invoice)"
          label="Add payment"
          v-if="payment_status !== 'paid' && payment_status !== 'cancelled'"
          v-tooltip="
            payment_status === 'paid'
              ? 'Invoice is already paid'
              : payment_status === 'cancelled'
              ? 'Cannot pay cancelled invoice'
              : 'Add payment to invoice'
          "
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";

import Button from "primevue/button";
import eventBus from "@/eventBus";
const emit = defineEmits(["submit", "cancel"]);
const payment_status = ref(null);
const props = defineProps({
  invoice: {
    type: Object,
    required: true,
  },
});
if (props.invoice) {
  payment_status.value = props.invoice;
}
const openPaymentDialog = () => {
  eventBus.emit("showPaymentView");
};
// console.log("INVOICE", payment_status.value);
</script>
