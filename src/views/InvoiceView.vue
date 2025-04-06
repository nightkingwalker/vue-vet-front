<template>
  <div class="invoice-details-container">
    <Card>
      <template #title>
        <div class="flex justify-between items-center">
          <span>Invoice #{{ invoice.invoice_number }}</span>
          <Tag
            :value="formatStatus(invoice.status)"
            :severity="getStatusSeverity(invoice.status)"
            class="!text-sm"
          />
        </div>
      </template>
      <template #subtitle>
        <div class="flex flex-col md:flex-row md:justify-between md:items-center gap-2">
          <div><span class="font-medium">Date:</span> {{ formatDate(invoice.date) }}</div>
          <div>
            <span class="font-medium">Due Date:</span> {{ formatDate(invoice.due_date) }}
          </div>
          <div v-if="invoice.payment_terms">
            <span class="font-medium">Payment Terms:</span>
            {{ formatPaymentTerms(invoice.payment_terms) }}
          </div>
        </div>
      </template>

      <template #content>
        <!-- Header Section -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          <!-- Clinic Information -->
          <div class="bg-gray-50 p-4 rounded-lg no-print">
            <h3 class="font-bold text-sm mb-2 border-b pb-1">From</h3>
            <div class="space-y-1">
              <div class="text-md font-semibold">{{ invoice.branch.name }}</div>
              <div>{{ invoice.branch.address }}</div>
              <div>Phone: {{ invoice.branch.phone }}</div>
            </div>
          </div>

          <!-- Client Information -->
          <div class="bg-gray-50 p-4 rounded-lg" v-if="invoice.client_id">
            <h3 class="font-bold text-sm mb-2 border-b pb-1">Bill To</h3>
            <div class="space-y-1">
              <div class="text-sm font-medium">{{ invoice.owner.name }}</div>
              <div>{{ invoice.owner.address }}</div>
              <div>Phone: {{ invoice.owner.phone }}</div>
              <div>Email: {{ invoice.owner.email }}</div>
            </div>
          </div>

          <!-- Invoice Summary -->
          <div class="bg-gray-50 p-4 rounded-lg w-1">
            <h3 class="font-bold text-sm mb-2 border-b pb-1">Invoice Summary</h3>
            <div class="space-y-2">
              <div class="flex justify-between">
                <span>Subtotal:</span>
                <span>${{ parseFloat(invoice.subtotal).toFixed(2) }}</span>
              </div>
              <div class="flex justify-between">
                <span>Discount:</span>
                <span class="text-red-500"
                  >-${{ parseFloat(invoice.discount_amount).toFixed(2) }}</span
                >
              </div>
              <div class="flex justify-between">
                <span>Tax:</span>
                <span>${{ parseFloat(invoice.tax_amount).toFixed(2) }}</span>
              </div>
              <div class="flex justify-between font-bold border-t pt-2 mt-2">
                <span>Total:</span>
                <span>${{ parseFloat(invoice.total_amount).toFixed(2) }}</span>
              </div>
              <div class="flex justify-between" v-if="invoice.deposit_required > 0">
                <span>Deposit Paid:</span>
                <span>${{ parseFloat(invoice.deposit_paid).toFixed(2) }}</span>
              </div>
              <div
                class="flex justify-between font-bold"
                v-if="invoice.deposit_required > 0"
              >
                <span>Balance Due:</span>
                <span
                  >${{
                    (
                      parseFloat(invoice.total_amount) - parseFloat(invoice.deposit_paid)
                    ).toFixed(2)
                  }}</span
                >
              </div>
            </div>
          </div>
        </div>

        <!-- Items Table -->
        <div class="mb-8">
          <h3 class="font-bold text-sm mb-3">Items</h3>
          <DataTable
            :value="invoice.items"
            :scrollable="true"
            scrollHeight="flex"
            class="p-datatable-sm"
          >
            <Column field="name" header="Item">
              <template #body="{ data }">
                <div>
                  <div class="font-medium">{{ data.inventory_item.name }}</div>
                  <div class="text-sm text-gray-500">{{ data.inventory_item.brand }}</div>
                </div>
              </template>
            </Column>
            <Column field="quantity" header="Qty" style="width: 80px"></Column>
            <Column field="unit_price" header="Price" style="width: 100px">
              <template #body="{ data }">
                ${{ parseFloat(data.unit_price).toFixed(2) }}
              </template>
            </Column>
            <Column header="Discount" style="width: 100px">
              <template #body="{ data }">
                <span class="text-red-500"
                  >-${{ parseFloat(data.discount_amount).toFixed(2) }}</span
                >
              </template>
            </Column>
            <Column header="Tax" style="width: 80px">
              <template #body="{ data }"> {{ data.tax_rate }}% </template>
            </Column>
            <Column header="Total" style="width: 120px">
              <template #body="{ data }">
                ${{ parseFloat(data.total_price).toFixed(2) }}
              </template>
            </Column>
          </DataTable>
        </div>

        <!-- Payment History -->
        <div class="mb-8" v-if="invoice.payment_status !== 'pending'">
          <h3 class="font-bold text-sm mb-3">Payment History</h3>
          <DataTable
            :value="getPaymentHistory()"
            :scrollable="true"
            scrollHeight="flex"
            class="p-datatable-sm"
          >
            <Column field="date" header="Date" style="width: 120px">
              <template #body="{ data }">
                {{ formatDate(data.payment_date) }}
              </template>
            </Column>
            <Column field="method" header="Method" style="width: 150px">
              <template #body="{ data }">
                {{ getPaymentMethodName(data.payment_method_id) }}
              </template>
            </Column>
            <Column field="amount" header="Amount" style="width: 120px">
              <template #body="{ data }">
                ${{ parseFloat(data.amount).toFixed(2) }}
              </template>
            </Column>
            <Column field="type" header="Type" style="width: 120px">
              <template #body="{ data }">
                <Tag
                  :value="data.type"
                  :severity="data.type === 'deposit' ? 'info' : 'success'"
                />
              </template>
            </Column>
            <Column field="status" header="Status" style="width: 120px">
              <template #body="{ data }">
                <Tag
                  :value="data.is_verified ? 'Verified' : 'Pending'"
                  :severity="data.is_verified ? 'success' : 'warning'"
                />
              </template>
            </Column>
          </DataTable>
        </div>

        <!-- Notes -->
        <div class="mb-4" v-if="invoice.notes">
          <h3 class="font-bold text-sm mb-2">Notes</h3>
          <div class="bg-gray-50 p-4 rounded-lg whitespace-pre-line">
            {{ invoice.notes }}
          </div>
        </div>

        <!-- Footer -->
        <div class="border-t pt-4 mt-6 no-print">
          <div class="flex flex-col md:flex-row justify-between items-center gap-4">
            <div class="text-sm text-gray-500"></div>
            <div class="flex gap-2">
              <Button
                label="Print Invoice"
                icon="pi pi-print"
                @click="printInvoice"
                class="p-button-sm no-print"
              />
              <Button
                label="Download PDF"
                icon="pi pi-download"
                class="p-button-sm p-button-outlined no-print"
                @click="downloadPDF"
              />
            </div>
          </div>
        </div>
      </template>
    </Card>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useToast } from "primevue/usetoast";

// PrimeVue Components
import Card from "primevue/card";
import DataTable from "primevue/datatable";
import Column from "primevue/column";
import Tag from "primevue/tag";
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

const toast = useToast();

// Formatting functions
const formatDate = (dateString) => {
  if (!dateString) return "";
  const options = { year: "numeric", month: "short", day: "numeric" };
  return new Date(dateString).toLocaleDateString(undefined, options);
};

const formatDateTime = (dateString) => {
  if (!dateString) return "";
  const options = {
    year: "numeric",
    month: "short",
    day: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  };
  return new Date(dateString).toLocaleDateString(undefined, options);
};

const formatStatus = (status) => {
  const statusMap = {
    draft: "Draft",
    pending: "Pending",
    partially_paid: "Partially Paid",
    paid: "Paid",
    cancelled: "Cancelled",
    refunded: "Refunded",
  };
  return statusMap[status] || status;
};

const getStatusSeverity = (status) => {
  const severityMap = {
    draft: "info",
    pending: "warning",
    partially_paid: "warning",
    paid: "success",
    cancelled: "danger",
    refunded: "info",
  };
  return severityMap[status] || "info";
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

const getPaymentMethodName = (methodId) => {
  const method = props.paymentMethods.find((m) => m.id === methodId);
  return method ? method.name : "Unknown";
};

const getPaymentHistory = () => {
  // In a real app, this would come from the API
  // For now, we'll simulate based on the invoice status
  if (props.invoice.payment_status === "paid") {
    return [
      {
        payment_date: props.invoice.last_payment_date || props.invoice.date,
        payment_method_id: 1, // Assuming cash is ID 1
        amount: props.invoice.total_amount,
        type: "full",
        is_verified: true,
      },
    ];
  } else if (props.invoice.payment_status === "partially_paid") {
    return [
      {
        payment_date: props.invoice.last_payment_date || props.invoice.date,
        payment_method_id: 1, // Assuming cash is ID 1
        amount: props.invoice.deposit_paid,
        type: "deposit",
        is_verified: true,
      },
    ];
  }
  return [];
};

const printInvoice = () => {
  toast.add({
    severity: "info",
    summary: "Print",
    detail: "Preparing invoice for printing...",
    life: 3000,
  });

  // Get the card body content
  const cardBody = document.querySelector(".invoice-details-container .p-card-body");

  if (!cardBody) {
    toast.add({
      severity: "error",
      summary: "Error",
      detail: "Could not find invoice content to print",
      life: 3000,
    });
    return;
  }

  // Create a new window
  const printWindow = window.open("", "_blank");
  const printDocument = printWindow.document;

  // Add basic styles for printing
  printDocument.write(`
    <!DOCTYPE html>
    <html>
    <head>
      <title>Invoice #${props.invoice.invoice_number}</title>
      <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; color: #333; }
        .invoice-print { max-width: 1000px; margin: 0 auto; }
        .no-print { display: none !important; }
        table { width: 100%; border-collapse: collapse; margin: 10px 0; }
        th, td { padding: 8px; text-align: left; border-bottom: 1px solid #ddd; }
        .text-right { text-align: right; }
        .font-bold { font-weight: bold; }
        .border-t { border-top: 1px solid #ddd; }
        .mt-4 { margin-top: 16px; }
        .mb-4 { margin-bottom: 16px; }
        .p-4 { padding: 16px; }
        .bg-gray-50 { background-color: #f9fafb; }
        .rounded-lg { border-radius: 8px; }
        .grid { display: grid; }
        .grid-cols-3 { grid-template-columns: repeat(3, 1fr); }
        .gap-6 { gap: 24px; }
        .space-y-2 > * + * { margin-top: 8px; }
        .text-sm { font-size: 0.875rem; }
        .text-red-500 { color: #ef4444; }
        @media (min-width: 768px) {
        .md\:grid-cols-3 {
                grid-template-columns: repeat(3, minmax(0, 1fr));
            }
        }
        .gap-6 {
            gap: 1.5rem;
        }

        .grid-cols-1 {
            grid-template-columns: repeat(1, minmax(0, 1fr));
            display: flex
        ;
            justify-content: space-between;
        }
        }

        .mb-8 {
            margin-bottom: 2rem;
        }
            .rounded-lg {
    border-radius: 8px;
}
.bg-gray-50 {
    background-color: #f9fafb;
}
.p-4 {
    padding: 16px;
}
    .w-1{width:50%;}
      </style>
    </head>
    <body>
      <div class="invoice-print">
  `);

  // Clone the content (deep clone to keep all child elements)
  const contentClone = cardBody.cloneNode(true);

  // Remove any elements that shouldn't be printed (like buttons)
  const noPrintElements = contentClone.querySelectorAll(".no-print, button");
  noPrintElements.forEach((el) => el.remove());

  // Add the cloned content to the print document
  printDocument.body.appendChild(contentClone);
  printDocument.write("</div></body></html>");
  printDocument.close();

  // Wait for content to load then print
  printWindow.onload = function () {
    setTimeout(() => {
      printWindow.print();
      // printWindow.close();
    }, 200);
  };
};

const downloadPDF = () => {
  toast.add({
    severity: "info",
    summary: "Download",
    detail: "Generating PDF...",
    life: 3000,
  });
  // In a real app, you would generate or fetch a PDF
};

onMounted(() => {
  // You might want to fetch additional data here if needed
});
</script>

<style scoped>
.invoice-details-container {
  max-width: 1200px;
  margin: 0 auto;
}

@media print {
  .invoice-details-container {
    width: 100%;
    padding: 0;
    margin: 0;
  }

  /* Hide elements that shouldn't print */
  .p-datatable-thead th:last-child,
  .p-datatable-tbody td:last-child {
    display: none;
  }

  /* Add any other print-specific styles */
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
  .no-print {
    display: none !important;
  }
}
</style>
