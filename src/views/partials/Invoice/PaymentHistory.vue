<template>
  <div>
    <h3 class="font-bold text-sm mb-3">{{ $t("invoice.payment_history.title") }}</h3>
    <DataTable
      :value="payments"
      :scrollable="true"
      scrollHeight="flex"
      class="p-datatable-sm"
      :dir="$i18n.locale === 'ar' ? 'rtl' : 'ltr'"
    >
      <Column
        field="payment_date"
        :header="$t('invoice.payment_history.headers.date')"
        style="width: 120px"
      >
        <template #body="{ data }">
          {{ formatDate(data.payment_date) }}
        </template>
      </Column>
      <Column
        field="method"
        :header="$t('invoice.payment_history.headers.method')"
        style="width: 150px"
      >
        <template #body="{ data }">
          {{ getPaymentMethodName(data.payment_method_id) }}
        </template>
      </Column>
      <Column
        field="amount"
        :header="$t('invoice.payment_history.headers.amount')"
        style="width: 120px"
      >
        <template #body="{ data }"> ${{ parseFloat(data.amount).toFixed(2) }} </template>
      </Column>
      <Column
        field="notes"
        :header="$t('invoice.payment_history.headers.note')"
        style="width: 120px"
      >
        <template #body="{ data }">
          {{ data.notes }}
        </template>
      </Column>
      <Column
        field="status"
        :header="$t('invoice.payment_history.headers.status')"
        style="width: 120px"
      >
        <template #body="{ data }">
          <Tag
            :value="
              data.is_verified
                ? $t('invoice.payment_history.status.verified')
                : $t('invoice.payment_history.status.pending')
            "
            :severity="data.is_verified ? 'success' : 'warning'"
          />
        </template>
      </Column>
    </DataTable>
  </div>
</template>

<script setup>
import { useI18n } from "vue-i18n";
import DataTable from "primevue/datatable";
import Column from "primevue/column";
import Tag from "primevue/tag";
import { ref } from "vue";

const { t } = useI18n();
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
  { id: 1, name: t("invoice.payment_history.methods.cash") },
  { id: 2, name: t("invoice.payment_history.methods.credit_card") },
  { id: 3, name: t("invoice.payment_history.methods.bank_transfer") },
]);

const formatDate = (dateString) => {
  if (!dateString) return "";
  const options = { year: "numeric", month: "short", day: "numeric" };
  return new Date(dateString).toLocaleDateString(undefined, options);
};

const getPaymentMethodName = (methodId) => {
  const method = paymentMethods.value.find((m) => m.id === methodId);
  return method ? method.name : t("invoice.payment_history.methods.unknown");
};
</script>

<style scoped>
/* RTL text alignment for Arabic */
[dir="rtl"] .p-datatable .p-datatable-thead > tr > th,
[dir="rtl"] .p-datatable .p-datatable-tbody > tr > td {
  text-align: right;
}
</style>
