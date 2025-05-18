<template>
  <Menubar :model="items" class="text-xs">
    <template #item="{ item, props }">
      <!-- Bind class based on the active property of the item -->
      <a
        v-bind="props.action"
        v-bind:class="item.active ? 'router-link-active router-link-exact-active' : ''"
        @click="item.command"
      >
        <span :class="item.icon" />
        <span>{{ item.label }}</span>
      </a>
    </template>
  </Menubar>
  <div id="content">
    <router-view></router-view>
    <!-- Nested view will render here -->
  </div>
</template>
<script setup>
import { computed, ref, watch } from "vue";
import { useI18n } from "vue-i18n";
import { useAuthStore } from "@/stores/authStore";
import { useRouter, useRoute } from "vue-router";
import Cookies from "js-cookie";
import Menubar from "primevue/menubar";
const { t } = useI18n();
const route = useRoute();
const router = useRouter();
// console.log(route.path);
const items = ref([
  {
    label: t("reports.menu.stockmovement"),
    icon: "pi pi-barcode",
    active: route.path === "/reports/stock-movement" ? true : false,
    command: () => router.push("/reports/stock-movement"),
  },
  {
    label: t("reports.menu.patients_reports"),
    icon: "fa-solid fa-paw",
    active: route.path === "/reports/patients" ? true : false,
    command: () => router.push("/reports/patients"),
  },
  //   {
  //     label: t("reports.menu.sales_reports"),
  //     icon: "fa-solid fa-file-invoice-dollar",
  //     command: () => router.push("/reports/sales"),
  //   },
]);

const updateActiveItems = () => {
  items.value.forEach((item) => {
    item.active = route.path.startsWith(
      item.command.toString().replace('() => router.push("', "").replace('")', "")
    );
  });
};

watch(
  () => route.path,
  () => {
    updateActiveItems();
  },
  { immediate: true }
);
</script>
