<template>
  <Menubar :model="items" />
  <div id="content"></div>
</template>
<script setup>
import { computed, ref } from "vue";
import { useI18n } from "vue-i18n";
import { useAuthStore } from "@/stores/authStore";
import { useRoute } from "vue-router";
import Cookies from "js-cookie";
import Menubar from "primevue/menubar";
const { t } = useI18n();
const items = ref([
  {
    label: t("reports.menu.stockmovement"),
    icon: "pi pi-barcode",
  },
  {
    label: t("reports.menu.patients_reports"),
    icon: "fa-solid fa-paw",
  },
  {
    label: t("reports.menu.sales_reports"),
    icon: "fa-solid fa-file-invoice-dollar",
  },
]);
</script>
