<template>
  <div>
    <h3 class="font-bold text-sm mb-3">Payment History</h3>
    <DataTable
      :value="payments"
      :scrollable="true"
      scrollHeight="flex"
      class="p-datatable-sm"
    >
      <Column field="payment_date" header="Date" style="width: 120px">
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
        <template #body="{ data }"> ${{ parseFloat(data.amount).toFixed(2) }} </template>
      </Column>
      <Column field="notes" header="Note" style="width: 120px">
        <template #body="{ data }">
          {{ data.notes }}
          <!-- <Tag
            :value="data.notes"
            :severity="data.type === 'deposit' ? 'info' : 'success'"
          /> -->
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
</template>

<script setup>
import DataTable from "primevue/datatable";
import Column from "primevue/column";
import Tag from "primevue/tag";
import { ref } from "vue";

const props = defineProps({
  payments: {
    type: Array,
    required: true,
  },
  paymentMethods: {
    type: Array,
    required: false,
  },
});
const paymentMethods = ref([
  { id: 1, name: "Cash" },
  { id: 2, name: "Credit Card" },
  { id: 3, name: "Bank Transfer" },
]);
// console.log("paymentMethods", props.paymentMethods);
const formatDate = (dateString) => {
  if (!dateString) return "";
  const options = { year: "numeric", month: "short", day: "numeric" };
  return new Date(dateString).toLocaleDateString(undefined, options);
};

const getPaymentMethodName = (methodId) => {
  const method = paymentMethods.value.find((m) => m.id === methodId);
  return method ? method.name : "Unknown";
};
</script>
