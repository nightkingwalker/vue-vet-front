<template>
  <div v-if="!invoice">
    No invoice has been issues for this service.
    <Button
      size="medium"
      label="Create Invoice"
      icon="fa-solid fa-hand-holding-dollar"
      class="p-button-sm !text-[var(--p-primary-contrast-color)] dark:!text-[var(--p-primary-900)]"
      @click="openAddPaymentDialog"
      v-tooltip="'Create Invoice'"
    />
  </div>
  <div v-else class="invoice-details-container">
    <Card>
      <template #title>
        <div class="flex justify-between items-center">
          <span>Invoice #{{ invoice.invoice_number }}</span>
          <InvoiceStatusTag :status="invoice.status" />
        </div>
      </template>
      <template #subtitle>
        <InvoiceMetaData
          :date="invoice.date"
          :due-date="invoice.due_date"
          :payment-terms="invoice.payment_terms"
        />
      </template>

      <template #content>
        <!-- Header Section -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          <BranchInfo
            class="bg-zinc-200 text-zinc-800 dark:bg-gray-600 dark:text-white no-print"
            :branch="invoice.branch"
          />
          <ClientInfo
            class="bg-zinc-200 text-zinc-800 dark:bg-gray-600 dark:text-white"
            v-if="invoice.client_id"
            :client="invoice.owner"
          />
          <InvoiceSummary
            class="bg-zinc-200 text-zinc-800 dark:bg-gray-600 dark:text-white"
            :invoice="invoice"
          />
        </div>

        <!-- Items Table -->
        <InvoiceItemsTable :items="invoice.items" class="mb-8" />

        <!-- Payment History -->
        <PaymentHistory
          v-if="invoice.payment_status !== 'pending'"
          :payments="invoice.payments"
          :payment-methods="paymentMethods"
          class="mb-8"
        />

        <!-- Notes -->
        <InvoiceNotes v-if="invoice.notes" :notes="invoice.notes" class="mb-4" />

        <!-- Footer Actions -->
        <InvoiceActions
          @print="printInvoice"
          @download="downloadPDF"
          :invoice="invoice"
        />
      </template>
    </Card>
  </div>
</template>

<script setup>
import { ref } from "vue";
import { useToast } from "primevue/usetoast";
import Card from "primevue/card";
import InvoiceStatusTag from "./partials/Invoice/InvoiceStatusTag.vue";
import InvoiceMetaData from "./partials/Invoice/InvoiceMetaData.vue";
import BranchInfo from "./partials/Invoice/BranchInfo.vue";
import ClientInfo from "./partials/Invoice/ClientInfo.vue";
import InvoiceSummary from "./partials/Invoice/InvoiceSummary.vue";
import InvoiceItemsTable from "./partials/Invoice/InvoiceItemsTable.vue";
import PaymentHistory from "./partials/Invoice/PaymentHistory.vue";
import InvoiceNotes from "./partials/Invoice/InvoiceNotes.vue";
import InvoiceActions from "./partials/Invoice/InvoiceActions.vue";
import Button from "primevue/button";

const props = defineProps({
  invoice: {
    type: Object,
    required: true,
  },
  paymentMethods: {
    type: Array,
    default: () => [],
  },
});
const emit = defineEmits([]); // Define the event to be emitted

const openAddPaymentDialog = () => {
  emit("addInvoice");
};
// console.log(props.invoice);
const toast = useToast();

const printInvoice = () => {
  toast.add({
    severity: "info",
    summary: "Print",
    detail: "Preparing invoice for printing...",
    life: 3000,
  });

  // Get the invoice container
  const invoiceContainer = document.querySelector(".invoice-details-container");
  if (!invoiceContainer) {
    toast.add({
      severity: "error",
      summary: "Error",
      detail: "Could not find invoice content to print",
      life: 3000,
    });
    return;
  }

  // const openAddPaymentDialog = () => {
  //   emit("addInvoice");
  // };

  // Create a new window
  const printWindow = window.open("", "_blank");
  if (!printWindow) {
    toast.add({
      severity: "error",
      summary: "Error",
      detail: "Popup was blocked. Please allow popups for this site.",
      life: 5000,
    });
    return;
  }

  // Clone the content (deep clone to keep all child elements)
  const contentClone = invoiceContainer.cloneNode(true);

  // Remove any elements that shouldn't be printed
  const noPrintElements = contentClone.querySelectorAll(".no-print, button");
  noPrintElements.forEach((el) => el.remove());

  // Create the print document
  printWindow.document.write(`
    <!DOCTYPE html>
    <html>
    <head>
      <title>Invoice #${props.invoice.invoice_number}</title>
      <style>
        ${printStyles}
        @media print {
          body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
          }
          .invoice-print {
            width: 100%;
            padding: 20px;
          }
          .p-card {
            box-shadow: none;
            border: none;
          }
          .p-datatable {
            font-size: 12px;
          }
          .no-print {
            display: none !important;
          }
        }
      </style>
    </head>
    <body>
      <div class="invoice-print">
  `);

  // Add the cloned content
  printWindow.document.body.appendChild(contentClone);
  printWindow.document.write("</div></body></html>");
  printWindow.document.close();

  // Wait for content to load
  printWindow.onload = function () {
    setTimeout(() => {
      printWindow.focus();
      printWindow.print();
      // Optional: Close the window after printing
      printWindow.close();
    }, 500);
  };
};
const downloadPDF = () => {
  toast.add({
    severity: "info",
    summary: "Download",
    detail: "Generating PDF...",
    life: 3000,
  });
  // PDF generation logic would go here
};

const printStyles = `
  body { 
    font-family: Arial, sans-serif; 
    margin: 0; 
    padding: 20px; 
    color: #333; 
  }
  .invoice-print { 
    max-width: 1000px; 
    margin: 0 auto; 
  }
  .no-print { 
    display: none !important; 
  }
  table { 
    width: 100%; 
    border-collapse: collapse; 
    margin: 10px 0; 
  }
  th, td { 
    padding: 8px; 
    text-align: left; 
    border-bottom: 1px solid #ddd; 
  }
  .text-right { 
    text-align: right; 
  }
  .font-bold { 
    font-weight: bold; 
  }
  .border-t { 
    border-top: 1px solid #ddd; 
  }
  .mt-4 { 
    margin-top: 16px; 
  }
  .mb-4 { 
    margin-bottom: 16px; 
  }
  .p-4 { 
    padding: 16px; 
  }
  .bg-gray-50 { 
    background-color: #f9fafb; 
  }
  .rounded-lg { 
    border-radius: 8px; 
  }
  .grid { 
    display: grid; 
  }
  .grid-cols-3 { 
    grid-template-columns: repeat(3, 1fr); 
  }
  .gap-6 { 
    gap: 24px; 
  }
  .space-y-2 > * + * { 
    margin-top: 8px; 
  }
  .text-sm { 
    font-size: 0.875rem; 
  }
  .text-red-500 { 
    color: #ef4444; 
  }
  .wx-1 {
    width: 50%;
  }
  @media print {
    body * {
      visibility: hidden;
    }
    .invoice-details-container,
    .invoice-details-container * {
      visibility: visible;
    }
    .invoice-details-container {
      position: absolute;
      left: 0;
      top: 0;
      width: 100%;
      padding: 0;
      margin: 0;
    }
  }
`;
</script>

<style scoped>
.invoice-details-container {
  max-width: 1200px;
  margin: 0 auto;
}

.print-only {
  display: none;
}
@media print {
  .print-only {
    display: block;
  }
  .no-print {
    display: none !important;
  }
  .invoice-details-container {
    width: 100%;
    padding: 0;
    margin: 0;
  }
  .p-datatable-thead th:last-child,
  .p-datatable-tbody td:last-child {
    display: none;
  }
}
</style>
