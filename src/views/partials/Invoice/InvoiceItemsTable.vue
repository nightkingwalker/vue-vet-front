<template>
  <div>
    <h3 class="font-bold text-sm mb-3">Items</h3>
    <DataTable
      :value="items"
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
      <Column field="quantity" header="Qty" style="width: 80px" />
      <Column field="unit_price" header="Price" style="width: 100px">
        <template #body="{ data }">
          ${{ parseFloat(data.unit_price).toFixed(2) }}
        </template>
      </Column>
      <Column header="Discount" style="width: 100px" class="no-print">
        <template #body="{ data }">
          <span class="text-red-500">
            -${{ parseFloat(data.discount_amount).toFixed(2) }}
          </span>
        </template>
      </Column>
      <Column header="Tax" style="width: 80px" class="no-print">
        <template #body="{ data }"> {{ data.tax_rate }}% </template>
      </Column>
      <Column header="Total" style="width: 120px">
        <template #body="{ data }">
          ${{ parseFloat(data.total_price).toFixed(2) }}
        </template>
      </Column>
    </DataTable>
  </div>
</template>

<script setup>
import DataTable from "primevue/datatable";
import Column from "primevue/column";

defineProps({
  items: {
    type: Array,
    required: true,
  },
});
</script>
