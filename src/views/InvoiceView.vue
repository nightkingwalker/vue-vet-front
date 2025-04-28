<template>
  <div v-if="!invoice">
    {{ $t('invoice.no_invoice') }}
    <Button size="medium" :label="$t('invoice.create_invoice')" icon="fa-solid fa-hand-holding-dollar"
      class="p-button-sm !text-[var(--p-primary-contrast-color)] dark:!text-[var(--p-primary-900)]"
      @click="openAddPaymentDialog" v-tooltip="$t('invoice.create_invoice')" />
  </div>
  <div v-else class="invoice-details-container  lg:!text-[14px]">
    <Card>
      <template #title>
        <div class="flex justify-between items-center">
          <span>{{ $t('invoice.invoice_number', { number: invoice.invoice_number }) }}</span>
          <InvoiceStatusTag :status="invoice.status" />
        </div>
      </template>
      <template #subtitle>
        <InvoiceMetaData :date="invoice.date" :due-date="invoice.due_date" :payment-terms="invoice.payment_terms" />
      </template>

      <template #content>
        <!-- Header Section -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          <BranchInfo class="bg-zinc-200 text-zinc-800 dark:bg-gray-600 dark:text-white no-print"
            :branch="invoice.branch" />
          <ClientInfo class="bg-zinc-200 text-zinc-800 dark:bg-gray-600 dark:text-white" v-if="invoice.client_id"
            :client="invoice.owner" />
          <InvoiceSummary class="bg-zinc-200 text-zinc-800 dark:bg-gray-600 dark:text-white" :invoice="invoice" />
        </div>

        <!-- Items Table -->
        <InvoiceItemsTable :items="invoice.items" class="mb-8" />

        <!-- Payment History -->
        <PaymentHistory v-if="invoice.payment_status !== 'pending'" :payments="invoice.payments"
          :payment-methods="paymentMethods" class="mb-8" />

        <!-- Notes -->
        <InvoiceNotes v-if="invoice.notes" :notes="invoice.notes" class="mb-4" />

        <!-- Footer Actions -->
        <InvoiceActions @print="printPOS" @download="downloadPDF" :invoice="invoice"
          :onAddPayment="openPaymentDialog" />
      </template>
    </Card>

    <!-- Hidden POS Template -->
    <div class="pos-template hidden">
      <div class="pos-header">
        <div class="pos-business-name">{{ invoice.branch.name }}</div>
        <div class="pos-address">{{ invoice.branch.address }}</div>
        <div class="pos-contact">Tel: {{ invoice.branch.phone }}</div>
      </div>

      <div class="pos-divider">--------------------------------</div>

      <div class="pos-invoice-info">
        <div>{{ $t('invoice.invoice_number', { number: invoice.invoice_number }) }}</div>
        <div>DATE: {{ formatPOSDate(invoice.date) }}</div>
        <div v-if="invoice.owner">CUSTOMER: {{ invoice.owner.name }}</div>
      </div>

      <div class="pos-divider">--------------------------------</div>

      <div class="pos-items">
        <div class="pos-item-header">
          <span class="pos-item-desc">{{ $t('invoice.items.item') }}</span>
          <span class="pos-item-qty">{{ $t('invoice.items.qty') }}</span>
          <span class="pos-item-price">{{ $t('invoice.items.price') }}</span>
          <span class="pos-item-total">{{ $t('invoice.items.total') }}</span>
        </div>

        <div v-for="(item, index) in invoice.items" :key="index" class="pos-item">
          <span class="pos-item-desc">{{ item.inventory_item.name }}</span>
          <span class="pos-item-qty">{{ item.quantity }}</span>
          <span class="pos-item-price">{{ formatPOSCurrency(item.unit_price) }}</span>
          <span class="pos-item-total">{{ formatPOSCurrency(item.total_price) }}</span>
        </div>
      </div>

      <div class="pos-divider">--------------------------------</div>

      <div class="pos-totals">
        <div class="pos-subtotal">
          <span>{{ $t('invoice.totals.subtotal') }}</span>
          <span>{{ formatPOSCurrency(invoice.subtotal) }}</span>
        </div>
        <div v-if="parseFloat(invoice.tax_amount) > 0" class="pos-tax">
          <span>{{ $t('invoice.totals.tax', { rate: invoice.tax_rate }) }}</span>
          <span>{{ formatPOSCurrency(invoice.tax_amount) }}</span>
        </div>
        <div v-if="parseFloat(invoice.discount_amount) > 0" class="pos-discount">
          <span>{{ $t('invoice.totals.discount') }}</span>
          <span>-{{ formatPOSCurrency(invoice.discount_amount) }}</span>
        </div>
        <div class="pos-total">
          <span>{{ $t('invoice.totals.total') }}</span>
          <span>{{ formatPOSCurrency(invoice.total_amount) }}</span>
        </div>
      </div>

      <div class="pos-divider">--------------------------------</div>

      <div class="pos-payments">
        <div v-for="(payment, index) in invoice.payments" :key="index" class="pos-payment">
          <div>{{ $t('invoice.payments.payment', { number: index + 1 }) }}: {{ formatPOSDate(payment.payment_date) }}
          </div>
          <div>{{ $t('invoice.payments.method') }}: {{ getPaymentMethod(payment.payment_method_id) }}</div>
          <div>{{ $t('invoice.payments.amount') }}: {{ formatPOSCurrency(payment.amount) }}</div>
        </div>
        <div v-if="invoice.balance_due === 0" class="pos-paid">
          <span>{{ $t('invoice.totals.paid_full') }}</span>
        </div>
        <div v-else class="pos-balance">
          <span>{{ $t('invoice.totals.balance_due') }}:</span>
          <span>{{ formatPOSCurrency(invoice.balance_due) }}</span>
        </div>
      </div>

      <div class="pos-divider">--------------------------------</div>

      <div class="pos-footer">
        <div>{{ $t('invoice.footer.thank_you') }}</div>
        <div>{{ $t('invoice.footer.visit_again') }}</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";
import { useToast } from "primevue/usetoast";
import { useI18n } from 'vue-i18n';
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
import { onMounted, onBeforeUnmount } from "vue";
import eventBus from "@/eventBus";

const { t } = useI18n();
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
const emit = defineEmits([]);

const openAddPaymentDialog = () => {
  emit("addInvoice");
};

// const categories = ref([
//   { label: t("inventory.categories.food"), value: "food" },
//   { label: t("inventory.categories.medicine"), value: "medicine" },
//   { label: t("inventory.categories.accessories"), value: "accessories" },
//   { label: t("inventory.categories.miscellaneous"), value: "miscellaneous" },
//   { label: t("inventory.categories.treatment"), value: "treatment" },
// ]);
const toast = useToast();

const printInvoice = () => {
  toast.add({
    severity: "info",
    summary: "Print",
    detail: t('invoice.print_preparing'),
    life: 3000,
  });

  const invoiceContainer = document.querySelector(".invoice-details-container");
  if (!invoiceContainer) {
    toast.add({
      severity: "error",
      summary: "Error",
      detail: t('invoice.print_error_content'),
      life: 3000,
    });
    return;
  }

  const printWindow = window.open("", "_blank");
  if (!printWindow) {
    toast.add({
      severity: "error",
      summary: "Error",
      detail: t('invoice.print_error_popup'),
      life: 5000,
    });
    return;
  }

  const contentClone = invoiceContainer.cloneNode(true);
  const noPrintElements = contentClone.querySelectorAll(".no-print, button");
  noPrintElements.forEach((el) => el.remove());

  printWindow.document.write(`
    <!DOCTYPE html>
    <html>
    <head>
      <title>${t('invoice.invoice_number', { number: props.invoice.invoice_number })}</title>
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

  printWindow.document.body.appendChild(contentClone);
  printWindow.document.write("</div></body></html>");
  printWindow.document.close();

  printWindow.onload = function () {
    setTimeout(() => {
      printWindow.focus();
      printWindow.print();
      printWindow.close();
    }, 500);
  };
};

const showPaymentDialog = () => {
  // Logic to show payment dialog if needed
  // Or you can directly emit an event to parent if the dialog is managed there
  emit('showPayment');
};
const downloadPDF = () => {
  toast.add({
    severity: "info",
    summary: "Download",
    detail: t('invoice.download_preparing'),
    life: 3000,
  });
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

const getPaymentMethod = (id) => {
  const method = props.paymentMethods.find((m) => m.id === id);
  return method ? method.name : "Unknown";
};

const formatPOSDate = (dateString) => {
  const date = new Date(dateString);
  return date
    .toLocaleDateString("en-US", {
      month: "short",
      day: "numeric",
      year: "numeric",
      hour: "2-digit",
      minute: "2-digit",
    })
    .replace(",", "");
};

const formatPOSCurrency = (amount) => {
  return parseFloat(amount).toFixed(2);
};

const printPOS = () => {
  toast.add({
    severity: "info",
    summary: "Print",
    detail: t('invoice.pos_preparing'),
    life: 3000,
  });

  const posTemplate = document.querySelector(".pos-template");
  if (!posTemplate) {
    toast.add({
      severity: "error",
      summary: "Error",
      detail: t('invoice.pos_error_template'),
      life: 3000,
    });
    return;
  }

  const printWindow = window.open("", "_blank");
  if (!printWindow) {
    toast.add({
      severity: "error",
      summary: "Error",
      detail: t('invoice.print_error_popup'),
      life: 5000,
    });
    return;
  }

  const contentClone = posTemplate.cloneNode(true);
  contentClone.classList.remove("hidden");

  printWindow.document.write(`
    <!DOCTYPE html>
    <html>
    <head>
      <title>${t('invoice.invoice_number', { number: props.invoice.invoice_number })}</title>
      <style>
        ${posPrintStyles}
      </style>
    </head>
    <body>
  `);

  printWindow.document.body.appendChild(contentClone);
  printWindow.document.write("</body></html>");
  printWindow.document.close();

  printWindow.onload = function () {
    setTimeout(() => {
      printWindow.focus();
      printWindow.print();
    }, 500);
  };
};

const posPrintStyles = `
  @media print {
    body {
      margin: 0;
      padding: 5px;
      font-family: 'Courier New', monospace;
      font-size: 12px;
      width: 80mm;
      max-width: 80mm;
    }
    
    .hidden {
      display: none !important;
    }
    
    .pos-header {
      text-align: center;
      margin-bottom: 5px;
      line-height: 1.2;
    }
    
    .pos-business-name {
      font-weight: bold;
      font-size: 14px;
      text-transform: uppercase;
    }
    
    .pos-address, .pos-contact {
      font-size: 10px;
    }
    
    .pos-divider {
      text-align: center;
      margin: 3px 0;
      font-size: 10px;
    }
    
    .pos-invoice-info {
      margin-bottom: 5px;
      line-height: 1.3;
      font-size: 11px;
    }
    
    .pos-items {
      margin-bottom: 5px;
    }
    
    .pos-item-header, .pos-item {
      display: flex;
      justify-content: space-between;
      margin-bottom: 2px;
      font-size: 11px;
    }
    
    .pos-item-header {
      font-weight: bold;
      border-bottom: 1px dashed #000;
      padding-bottom: 2px;
    }
    
    .pos-item-desc {
      flex: 3;
      word-break: break-word;
    }
    
    .pos-item-qty {
      flex: 1;
      text-align: right;
      padding-right: 5px;
    }
    
    .pos-item-price {
      flex: 2;
      text-align: right;
      padding-right: 5px;
    }
    
    .pos-item-total {
      flex: 2;
      text-align: right;
    }
    
    .pos-totals, .pos-payments {
      margin: 5px 0;
      font-size: 11px;
    }
    
    .pos-subtotal, .pos-tax, .pos-discount, .pos-total, 
    .pos-payment, .pos-balance, .pos-paid {
      display: flex;
      justify-content: space-between;
      margin-bottom: 2px;
    }
    
    .pos-total, .pos-paid {
      font-weight: bold;
      margin-top: 3px;
    }
    
    .pos-footer {
      text-align: center;
      font-size: 10px;
      margin-top: 5px;
    }
    
    @page {
      size: 80mm auto;
      margin: 0;
    }
  }
`;
onMounted(() => {
  eventBus.on("showPaymentView", showPaymentDialog);
});

onBeforeUnmount(() => {
  eventBus.off("showPaymentView", showPaymentDialog);
});
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
.hidden {
  display: none !important;
}
</style>