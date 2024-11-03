<template>
  <Paginator
    :rows="itemsPerPage"
    :first="1"
    :totalRecords="totalRecords"
    :currentPage="currentPage"
    :rowsPerPageOptions="[8, 10, 25, 50, 100]"
    @page="onPageChange"
    class="!rounded-b-xl text-xs"
  ></Paginator>
</template>

<script setup>
import Paginator from "primevue/paginator";
import { ref } from "vue";
import eventBus from "@/eventBus";
const itemsPerPage = ref(8);
const currentPage = ref(1);
const totalRecords = ref(0);

const onPageChange = (event) => {
  itemsPerPage.value = event.rows;
  currentPage.value = event.page + 1;
  eventBus.emit("fetchData", { event });
};
</script>
