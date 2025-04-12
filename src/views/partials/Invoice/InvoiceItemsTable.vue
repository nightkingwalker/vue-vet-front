<template>
  <div>
    <h3 class="font-bold text-sm mb-3">{{ $t("invoice.items_table.title") }}</h3>
    <DataTable
      :value="items"
      :scrollable="true"
      scrollHeight="flex"
      class="p-datatable-sm"
      :dir="$i18n.locale === 'ar' ? 'rtl' : 'ltr'"
    >
      <Column field="name" :header="$t('invoice.items_table.headers.item')">
        <template #body="{ data }">
          <div :class="{ 'text-right': $i18n.locale === 'ar' }">
            <div class="font-medium">{{ data.inventory_item.name }}</div>
            <div class="text-sm text-gray-500">{{ data.inventory_item.brand }}</div>
          </div>
        </template>
      </Column>
      <Column
        field="quantity"
        :header="$t('invoice.items_table.headers.qty')"
        style="width: 80px"
      />
      <Column
        field="unit_price"
        :header="$t('invoice.items_table.headers.price')"
        style="width: 100px"
      >
        <template #body="{ data }">
          ${{ parseFloat(data.unit_price).toFixed(2) }}
        </template>
      </Column>
      <Column
        :header="$t('invoice.items_table.headers.discount')"
        style="width: 100px"
        class="no-print"
      >
        <template #body="{ data }">
          <span class="text-red-500">
            -${{ parseFloat(data.discount_amount).toFixed(2) }}
          </span>
        </template>
      </Column>
      <Column
        :header="$t('invoice.items_table.headers.tax')"
        style="width: 80px"
        class="no-print"
      >
        <template #body="{ data }"> {{ data.tax_rate }}% </template>
      </Column>
      <Column :header="$t('invoice.items_table.headers.total')" style="width: 120px">
        <template #body="{ data }">
          ${{ parseFloat(data.total_price).toFixed(2) }}
        </template>
      </Column>
    </DataTable>
  </div>
</template>

<script setup>
import { useI18n } from "vue-i18n";
import DataTable from "primevue/datatable";
import Column from "primevue/column";

const { t } = useI18n();
defineProps({
  items: {
    type: Array,
    required: true,
  },
});
</script>

<style scoped>
/* RTL text alignment for Arabic */
[dir="rtl"] .p-datatable .p-datatable-thead > tr > th,
[dir="rtl"] .p-datatable .p-datatable-tbody > tr > td {
  text-align: right;
}
</style>
