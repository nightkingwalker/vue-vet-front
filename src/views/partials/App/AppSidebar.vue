<template>
  <!-- Sidebar Menu -->
  <Menu
    :model="menuItems"
    @mouseenter="isHovered = true"
    @mouseleave="isHovered = false"
    :class="sidebarClasses"
    class="sidebar-container !py-8 px-4 2xl:px-1 lg:px-1 scrollbar-hide scroll-smooth sm:text-sm 2xl:text-xs lg:text-sm !rounded-none h-[100vh] top-0 left-0 overflow-y-scroll"
  >
    <template #start>
      <!-- Logo Slot -->
      <div class="flex justify-center w-full">
        <Image
          :src="Logo"
          alt="Application Logo"
          class="flex justify-center rounded-[4rem] w-[5rem] p-1"
        />
      </div>

      <!-- User Profile -->
      <router-link
        to="/profile"
        v-ripple
        class="p-menu-item-link relative overflow-hidden w-full border-0 bg-transparent flex items-center hover:bg-surface-100 dark:hover:bg-surface-800 rounded-none cursor-pointer transition-colors duration-200 h-[40px] min-w-[40px]"
      >
        <Avatar
          icon="pi pi-user"
          class="w-[40px]"
          :class="{ 'ltr:mr-2 rtl:ml-2': !isMobile && isHovered }"
          shape="circle"
        />
        <span
          v-if="(!isMobile && isHovered) || isMobile"
          class="inline-flex flex-col items-start"
        >
          <span class="font-bold">{{ userName }}</span>
        </span>
      </router-link>
    </template>

    <!-- Menu Item Templates -->
    <template #submenulabel="{ item }">
      <div class="font-bold flex items-center p-menu-item-content gap-2 dark:tex-white">
        <span class="dark:text-surface-100" :class="item.icon"></span>
        <span class="menu-item-label dark:text-surface-100">{{ item.label }}</span>
        <span v-if="item.items" class="fa-solid fa-angle-down"></span>
      </div>
    </template>

    <template #item="{ item, props }">
      <RouterLink
        v-ripple
        class="flex items-center"
        v-bind="props.action"
        :to="item.route || ''"
        @click="handleMenuItemClick"
      >
        <span class="dark:text-surface-100" :class="item.icon"></span>
        <span class="menu-item-label dark:text-surface-100">{{ item.label }}</span>
        <Badge v-if="item.badge" class="ml-auto p-badge" :value="item.badge" />
        <span
          v-if="item.shortcut"
          class="shortcut ltr:ml-auto rtl:mr-auto p-1 text-[10px] text-gray-600 dark:text-surface-400 justify-self-end"
        >
          {{ item.shortcut }}
        </span>
      </RouterLink>
    </template>
  </Menu>

  <!-- Scroll Indicator -->
  <span
    v-if="!isMobile && isHovered"
    class="animate-bounce h-6 w-6 text-xs bg-[var(--p-surface-800)] dark:bg-[var(--p-surface-100)] text-white dark:text-[var(--p-surface-800)] rounded-full inline-flex items-center justify-center z-20 right-[calc(100vw/12)] bottom-1 absolute"
  >
    <i class="pi pi-arrow-down text-xs" />
  </span>
</template>

<script setup lang="ts">
import { computed, ref } from "vue";
import { useI18n } from "vue-i18n";
import { useAuthStore } from "@/stores/authStore";
import { useRoute } from "vue-router";
import Cookies from "js-cookie";
import Menu from "primevue/menu";
import Avatar from "primevue/avatar";
import Image from "primevue/image";
import Badge from "primevue/badge";
import Logo from "@/assets/logo.png";
interface MenuItem {
  label: string;
  icon: string;
  route?: string;
  items?: MenuItem[];
  separator?: boolean;
  badge?: string | number;
  shortcut?: string;
  class?: string;
  command?: () => void;
}

const props = defineProps({
  isMobile: {
    type: Boolean,
    default: false,
  },
  mobileMenuVisible: {
    type: Boolean,
    default: false,
  },
  logo: {
    type: String,
    default: "/assets/logo-DOqaXMyT.png",
  },
});
const emit = defineEmits(["item-click"]);

const { t } = useI18n();
const route = useRoute();
const authStore = useAuthStore();
const isHovered = ref(false);

// Get user name from either store or cookies
const userName = computed(() => {
  return Cookies.get("name") || "Guest";
});

const sidebarClasses = computed(() => ({
  "fixed ltr:inset-y-0 ltr:left-0 rtl:inset-y-0 rtl:right-0 z-20 w-[100vw] mobile-menu":
    props.isMobile,
  "fixed ltr:left-0 rtl:right-0 hover:md:w-60 hover:lg:w-1/5 hover:2xl:w-1/6  z-20 drop-shadow-[0_5px_5px_rgba(0,0,0,0.3)]": !props.isMobile,
  hidden: props.isMobile && !props.mobileMenuVisible,
  "collapsed-menu": !props.isMobile && !isHovered.value,
  "expanded-menu": !props.isMobile && isHovered.value,
}));

const submenuItemClass = computed(
  () => `submenue_item ${!props.isMobile && !isHovered.value ? "" : ""}`
  //   () => `submenue_item ${!props.isMobile && !isHovered.value ? "ltr:pl-6 rtl:pr-6" : ""}`
);

const menuItems = computed(() => {
  const items: MenuItem[] = [
    {
      label: t("app.menu.calendar"),
      icon: "pi pi-calendar !text-md",
      route: "/",
      shortcut: "CTRL+ALT+Home",
    },

    {
      label: t("app.menu.patients"),
      icon: "fa-solid fa-paw !text-md !text-center",
      items: [
        { separator: true, label: null, icon: null },
        {
          label: t("app.menu.owners"),
          route: "/owners",
          icon: "fa-solid fa-users !text-md !text-center",
          shortcut: "CTRL+O",
          class: submenuItemClass.value,
        },
        {
          label: t("app.menu.pets"),
          route: "/pets",
          icon: "fa-solid fa-paw !text-md !text-center",
          shortcut: "CTRL+P",
          class: submenuItemClass.value,
        },
      ],
    },
    {
      label: t("app.menu.inventories"),
      icon: "fas fa-store !text-md",
      items: [
        { separator: true, label: null, icon: null },
        {
          label: t("app.menu.pet_food"),
          route: "/add-inventory-food",
          icon: "fa-solid fa-bone !text-md !text-center",
          class: submenuItemClass.value,
        },
        {
          label: t("app.menu.toys_tools"),
          route: "/add-inventory-toys",
          icon: "fa-solid fa-volleyball !text-md !text-center",
          class: submenuItemClass.value,
        },
        {
          label: t("app.menu.pharmaceutical"),
          route: "/add-inventory-pharmaceutical",
          icon: "fa-solid fa-pills !text-md !text-center",
          class: submenuItemClass.value,
        },
        {
          label: t("app.menu.grooming"),
          route: "/add-inventory-grooming",
          icon: "fa-solid fa-shower !text-md !text-center",
          class: submenuItemClass.value,
        },
        {
          label: t("app.menu.treatment"),
          route: "/add-inventory-treatment",
          icon: "fa-solid fa-stethoscope !text-md !text-center",
          class: submenuItemClass.value,
        },
      ],
    },
    {
      separator: true,
      label: null,
      icon: null,
    },
    {
      label: t("app.menu.invoices"),
      icon: "fa-solid fa-file-invoice-dollar !text-md",
      shortcut: "CTRL+I",
      route: "/invoices",
    },
    {
      label: t("app.menu.reports.reports"),
      icon: "fa-solid fa-arrow-trend-up !text-md",
      route: "/reports/stock-movement",
    },
    {
      label: t("app.menu.clinics"),
      icon: "fas fa-stethoscope !text-md",
      route: "/clinics",
    },
    // {
    //   label: t("app.menu.settings"),
    //   icon: "pi pi-cog !text-md",
    //   route: "/settings",
    // },
    // {
    //   label: t("app.menu.shortcuts"),
    //   icon: "fa-solid fa-keyboard !text-md",
    //   route: "/shortcuts",
    // },
    {
      label: t("app.menu.logout"),
      icon: "pi pi-sign-out !text-md",
      route: "/logout",
      command: () => {
        // authStore.logOut();
        if (props.isMobile) {
          emit("item-click");
        }
      },
    },
  ];
  return items;
});

const handleMenuItemClick = () => {
  if (props.isMobile) {
    emit("item-click");
  }
};
</script>

<style>
/* Menu item styling */
:deep(.p-megamenu-item:last-child .p-megamenu-item-content):hover {
  background: none !important;
}

:deep(.p-menuitem) {
  height: 40px !important;
  min-height: 40px !important;
}

.p-menu {
  transition: width 0.3s ease, transform 0.3s ease;
  will-change: width;
}

/* Container responsive sizing */
@media (min-width: 1536px) {
  .container {
    max-width: 90%;
  }
}

/* Active route styling */
.router-link-active {
  background: var(--p-surface-600);
  color: var(--p-primary-contrast-color) !important;
  border-radius: 0.5rem !important;
}

.dark .router-link-active {
  background: var(--p-surface-300);
  color: var(--p-primary-color) !important;
}
.router-link-active .shortcut {
  color: var(--p-surface-300);
}
.dark .router-link-active .shortcut {
  color: var(--p-primary-contrast-color);
}

/* Base menu styles */
.mobile-menu {
  top: 0;

  box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
}

.mobile-menu-visible {
  transform: translateX(0);
}

.p-menu-separator {
  width: 80%;
  /* border-bottom: 1px solid; */
}

/**MENU UPDATES */
/* Collapsed Menu Styles */
.collapsed-menu {
  overflow: hidden;
  width: 60px !important;
  min-width: 60px !important;
}

.collapsed-menu .menu-item-label,
.collapsed-menu .shortcut,
.collapsed-menu .p-badge,
.collapsed-menu .fa-angle-down {
  opacity: 0;
  width: 0;
  display: none;
  transition: opacity 0.3s ease, width 0.3s ease;
}

.collapsed-menu .p-menu-separator {
  width: 50%;

  /* margin: 0.5rem auto; */
}

.collapsed-menu .router-link-active {
  justify-content: center;
}

/* Center the logo in collapsed state */
.collapsed-menu .flex.justify-center {
  padding: 0;
}

.collapsed-menu .p-image,
.collapsed-menu .p-image img,
.expanded-menu .p-image,
.expanded-menu .p-image img {
  width: 30px !important;
  max-width: 30px !important;
}

/* } */

/* Profile link adjustments */
.collapsed-menu .router-link {
  justify-content: center;
  padding-left: 0 !important;
  padding-right: 0 !important;
}

.collapsed-menu .p-avatar {
  margin-right: 0 !important;
  margin-left: 0 !important;
}

.collapsed-menu span.inline-flex {
  display: none;
}

.collapsed-menu .p-avatar {
  margin-left: 0 !important;
  margin-right: 0 !important;
}

/* } */
/* } */

/* Expanded Menu Styles */
.expanded-menu .menu-item-label,
.expanded-menu .shortcut,
.expanded-menu .p-badge,
.expanded-menu .fa-angle-down {
  opacity: 1;
  width: auto;
}

.expanded-menu .p-menu-separator {
  width: 80%;
}

/* Smooth transitions */
.expanded-menu .menu-item-label {
  transition: all 0.4s ease-out allow-discrete;
}

/* Submenu adjustments */
:deep(.p-submenu-list) {
  padding-left: 0.5rem !important;
}

/* Keep active state visible in collapsed mode */
.collapsed-menu .router-link-active {
  position: relative;
}

.collapsed-menu .router-link-active::after {
  content: "";
  position: absolute;
  right: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 3px;
  height: 60%;
  background: var(--primary-color);
  border-radius: 3px;
}

.p-menu-list li:not(.p-menu-separator) {
  height: 40px;
}

.collapsed-menu a {
  height: 40px;
  min-width: 40px;
}

/* Ensure consistent vertical alignment */
.p-menu-item {
  padding-top: 0 !important;
  padding-bottom: 0 !important;
  margin: 0 !important;
  height: 40px !important;
  align-items: center !important;
}

/* Fix the avatar container */
.collapsed-menu .p-avatar,
.expanded-menu .p-avatar {
  margin: 0 !important;
  flex-shrink: 0;
}

/* User name container */
.inline-flex {
  white-space: nowrap;
  overflow: hidden;
  transition: all 0.3s ease;
}

/* Menu container stabilization */
.p-menu {
  top: 0 !important;
  margin-top: 0 !important;
  padding-top: 0 !important;
}

/* Logo container stabilization */
.flex.justify-center {
  padding: 0.5rem 0 !important;
  margin: 0 !important;
  height: auto !important;
}

.p-avatar {
  margin-left: 0 !important;
  margin-right: 0.5rem !important;
  /* Consistent spacing */
}

.collapsed-menu .p-menu-start .p-menu-item-link {
  justify-content: center;
}
</style>
