<template>
  <div class="flex gap-2" :class="{ 'flex-wrap': isMobile }">
    <div :class="{ 'w-full': !isMobile, 'w-9/10 mx-auto': isMobile }" :dir="isRTL ? 'rtl' : 'ltr'">
      <ScheduleXCalendar :calendar-app="calendarApp" class="mx-auto" :class="{
        '!w-full !h-[calc(100vh-100px)]': !isMobile,
        '!w-full !h-[400px]': isMobile,
      }">
        <!-- :headerContentRightPrepend="``" -->
        <template #headerContentRightPrepend>
          <div :class="{ 'sx__calendar-header-content': !isMobile, hidden: isMobile }">
            <Button type="" icon="pi pi-refresh !text-sm" label="" v-tooltip.bottom="$t('calendar.refresh')"
              class="p-button-text !text-emerald-400 hover:!bg-emerald-600 hover:!text-white transition text-sm md:text-base"
              @click="refreshData" />
            <Button type="" icon="pi pi-plus !text-sm" v-tooltip.bottom="$t('calendar.add_appointment')"
              @click="addAppointment"
              class="p-button-text !text-emerald-400 hover:!bg-emerald-600 hover:!text-white transition text-sm md:text-base" />
            <Button type="" icon="pi pi-google" @click="handleGoogleSync" :class="[
              '!text-xs', '!p-button-text', 'hover:!bg-emerald-600',
              isGoogleSynced ? '!text-emerald-600' : '!text-[var(--p-primary-color)]',
              isGoogleSynced ? 'hover:!text-emerald-900' : '!text-[var(--p-primary-color)]',
              'hover:!text-[var(--p-primary-contrast-color)]',
            ]" class="sx__ripple" v-tooltip.bottom="googleSyncTooltip" />
          </div>
        </template>
      </ScheduleXCalendar>
      <ContextMenu ref="menu" :model="menuItems" class="!text-xs">
        <template #item="{ item, props }">
          <h5 class="!text-xs" v-bind="props.action">
            <i :class="item.icon"></i> {{ item.label }}
          </h5>
        </template>
      </ContextMenu>
    </div>
    <div id="pet-details" :class="[
      isMobile
        ? 'w-full h-fit mx-auto mb-4'
        : 'w-1/5 min-w-[280px] h-[calc(100vh-100px)]',
      'border-[1px] border-[#c4c7c5] dark:!border-[#444746] rounded-xl shadow-sm p-4 flex flex-col gap-4 hidden',
    ]">
      <!-- Pet Information Card -->
      <div class="flex flex-col gap-3 p-4 rounded-lg transition-all duration-300" :style="{
        borderLeft: `4px solid ${currentPet.theme.lightColors.main}`,
        backgroundColor: currentPet.theme.lightColors.container,
        color: currentPet.theme.lightColors.onContainer,
      }">
        <!-- Pet Name -->
        <div class="flex items-center gap-2">
          <i :class="[
            getIconClass(currentPet.pet.species),
            'text-lg',
            currentPet.pet.gender === 'Male' ? 'text-blue-500' : 'text-pink-500',
          ]"></i>
          <h3 class="font-medium">
            {{ currentPet.pet.name || $t("calendar.pet_details.select_appointment") }}
          </h3>
        </div>

        <!-- Details List -->
        <div class="space-y-2 text-sm">
          <div class="flex items-start gap-2">
            <i class="fas fa-paw mt-0.5 text-sm opacity-70"></i>
            <div>
              <span class="text-xs opacity-80">{{ $t("calendar.pet_details.species") }}:</span>
              <p>
                {{
                  currentPet.pet.species && getSpeciesValue(currentPet.pet.species)
                    ? $t(`pet_details.species.${getSpeciesValue(currentPet.pet.species)}`)
                    : "-"
                }}
              </p>
            </div>
          </div>

          <div class="flex items-start gap-2">
            <i class="fa-solid fa-user mt-0.5 text-sm opacity-70"></i>
            <div>
              <span class="text-xs opacity-80">{{ $t("calendar.pet_details.owner") }}:</span>
              <p>{{ currentPet.people[0] || "-" }}</p>
            </div>
          </div>

          <div class="flex items-start gap-2">
            <i class="fa-solid fa-location-dot mt-0.5 text-sm opacity-70"></i>
            <div>
              <span class="text-xs opacity-80">{{ $t("calendar.pet_details.location") }}:</span>
              <p>{{ currentPet.location || "-" }}</p>
            </div>
          </div>

          <div class="flex items-start gap-2" v-if="currentPet.description">
            <i class="fa-solid fa-circle-info mt-0.5 text-sm opacity-70"></i>
            <div>
              <span class="text-xs opacity-80">{{ $t("calendar.pet_details.details") }}:</span>
              <p class="text-xs">{{ currentPet.description }}</p>
            </div>
          </div>
        </div>

        <!-- View Details Button -->
        <Button :label="currentPet.pet.microchip_num === '123123'
          ? $t('calendar.pet_details.select_appointment')
          : $t('calendar.pet_details.view_details')
          " icon="fas fa-paw" class="mt-2 !text-xs w-full justify-center" :class="currentPet.pet.microchip_num === '123123'
            ? 'p-button-outlined'
            : 'p-button-primary'
            " :disabled="currentPet.pet.microchip_num === '123123'" @click="
              currentPet.pet.microchip_num !== '123123' &&
              $router.push({
                name: 'PetDetails',
                params: { petmicrochip: currentPet.pet.microchip_num },
              })
              " v-tooltip.top="currentPet.pet.microchip_num === '123123'
                ? $t('calendar.pet_details.select_appointment')
                : $t('calendar.pet_details.view_details')
                " />
      </div>

      <!-- Event Legend -->
      <div class="mt-auto">
        <h4 class="text-sm font-medium mb-2 text-gray-700 dark:text-gray-300">
          {{ $t("calendar.legend") }}
        </h4>
        <div class="grid grid-cols-2 gap-2">
          <div v-for="(theme, name) in eventTheme" :key="name" class="flex items-center gap-2">
            <div class="w-3 h-3 rounded-full" :style="{ backgroundColor: theme.lightColors.main }"></div>
            <span class="text-xs">
              {{ $t(`calendar.appointment.${name.toLowerCase()}`) }}
            </span>
          </div>
        </div>
      </div>
    </div>
  </div>
  <Dialog :header="$t('calendar.appointment.new')" v-model:visible="isNewApointmentVisible"
    @hide="isNewApointmentVisible = false" modal :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto">
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">{{
          $t("calendar.appointment.new")
        }}</span>
      </div>
    </template>
    <AddNewAppointment v-focustrap="{
      disabled: false,
      autoFocus: true,
    }" :activeDate="activeDate" @submitted="handleSubmit" />
    <template #footer> </template>
  </Dialog>
  <Dialog v-model:visible="petDetailsVisible" modal :style="{
    width: isMobile ? '90vw' : '400px',
    borderLeft: `4px solid ${currentPet.theme.lightColors.main}`,
    backgroundColor: currentPet.theme.lightColors.container,
    color: currentPet.theme.lightColors.onContainer,
  }" :breakpoints="{ '960px': '75vw', '641px': '90vw' }">
    <template #header>
      <div class="flex items-center gap-2">
        <i :class="[
          getIconClass(currentPet.pet.species),
          'text-lg',
          currentPet.pet.gender === 'Male' ? 'text-blue-500' : 'text-pink-500',
        ]"></i>
        <h3>
          {{ currentPet.pet.name || $t("calendar.pet_details.select_appointment") }}
        </h3>
      </div>
    </template>

    <div class="space-y-3">
      <div class="flex items-start gap-2">
        <i class="fas fa-paw mt-0.5 text-sm opacity-70"></i>
        <div>
          <span class="text-xs opacity-80">{{ $t("calendar.pet_details.species") }}:</span>
          <p>
            {{
              currentPet.pet.species && getSpeciesValue(currentPet.pet.species)
                ? getSpeciesValue(currentPet.pet.species)
                : "-"
            }}
          </p>
        </div>
      </div>

      <div class="flex items-start gap-2">
        <i class="fa-solid fa-user mt-0.5 text-sm opacity-70"></i>
        <div>
          <span class="text-xs opacity-80">{{ $t("calendar.pet_details.owner") }}:</span>
          <p>{{ currentPet.people[0] || "-" }}</p>
        </div>
      </div>

      <div class="flex items-start gap-2">
        <i class="fa-solid fa-location-dot mt-0.5 text-sm opacity-70"></i>
        <div>
          <span class="text-xs opacity-80">{{ $t("calendar.pet_details.location") }}:</span>
          <p>{{ currentPet.location || "-" }}</p>
        </div>
      </div>

      <div class="flex items-start gap-2" v-if="currentPet.description">
        <i class="fa-solid fa-circle-info mt-0.5 text-sm opacity-70"></i>
        <div>
          <span class="text-xs opacity-80">{{ $t("calendar.pet_details.details") }}:</span>
          <p class="text-xs">{{ currentPet.description }}</p>
        </div>
      </div>
    </div>

    <template #footer>
      <Button :label="currentPet.pet.microchip_num === '123123'
        ? $t('calendar.pet_details.select_appointment')
        : $t('calendar.pet_details.view_details')
        " icon="fas fa-paw" class="!text-xs w-full justify-center" :class="currentPet.pet.microchip_num === '123123'
          ? 'p-button-outlined'
          : 'p-button-primary'
          " :disabled="currentPet.pet.microchip_num === '123123'" @click="
            currentPet.pet.microchip_num !== '123123' &&
            $router.push({
              name: 'PetDetails',
              params: { petmicrochip: currentPet.pet.microchip_num },
            })
            " />
    </template>
  </Dialog>
</template>
<script setup>
import { ref, onMounted, nextTick, watchEffect, computed } from "vue";
// import { Qalendar } from "qalendar";
import { ScheduleXCalendar } from "@schedule-x/vue";
import {
  createCalendar,
  viewDay,
  viewMonthAgenda,
  viewMonthGrid,
  viewWeek,
} from "@schedule-x/calendar";

import { createCalendarControlsPlugin } from "@schedule-x/calendar-controls";
import { createEventsServicePlugin } from "@schedule-x/events-service";
import { createDragAndDropPlugin } from "@schedule-x/drag-and-drop";
import { createScrollControllerPlugin } from "@schedule-x/scroll-controller";
import eventBus from "@/eventBus";
import "@schedule-x/theme-default/dist/calendar.css";
import { translations, mergeLocales } from "@schedule-x/translations";
import Tag from "primevue/tag";
import ContextMenu from "primevue/contextmenu";
import Dialog from "primevue/dialog";
import AddNewAppointment from "@/views/addNewAppointment.vue";
import Button from "primevue/button";
import { useRoute } from "vue-router";
import { useI18n } from "vue-i18n";
import Cookies from "js-cookie";
import router from "@/router";
import axiosInstance from "@/axios"; // Ensure this is correctly set up with baseURL
import { useDevice } from "@/composables/useDevice";
import { useToast } from "primevue/usetoast";
const route = useRoute();

const { isMobile, mobileMenuVisible } = useDevice();
const eventsServicePlugin = createEventsServicePlugin();
const calendarControls = createCalendarControlsPlugin();
const events = ref("");
const searchQuery = ref("");
const itemsPerPage = ref(100);
const loading = ref(false);
const visible = ref(false);
const activeDate = ref("");
const isNewApointmentVisible = ref(false);
const isGoogleSynced = ref(false);
const isSyncing = ref(false);
const toast = useToast();
const petDetailsVisible = ref(false);

const scrollController = createScrollControllerPlugin({
  initialScroll: "12:00",
});
const { t } = useI18n();
const formatDateTime = (dateTimeStr) => {
  const date = new Date(dateTimeStr);
  const formattedDate =
    date.getFullYear() +
    "-" +
    ("0" + (date.getMonth() + 1)).slice(-2) +
    "-" +
    ("0" + date.getDate()).slice(-2);
  const formattedTime =
    ("0" + date.getHours()).slice(-2) + ":" + ("0" + date.getMinutes()).slice(-2);

  return formattedDate + " " + formattedTime;
};
// Computed properties for dynamic UI
const googleSyncIcon = computed(() =>
  isSyncing.value
    ? "pi pi-spin pi-spinner"
    : isGoogleSynced.value
      ? "pi pi-google"
      : "pi pi-google"
);

const googleSyncLabel = computed(() =>
  isMobile.value
    ? ""
    : isGoogleSynced.value
      ? t("calendar.google_synced")
      : t("calendar.google_sync")
);

const googleSyncTooltip = computed(() =>
  isGoogleSynced.value
    ? t("calendar.google_sync_connected")
    : t("calendar.google_sync_connect")
);
const handleGoogleSync = async () => {
  if (isSyncing.value) return;

  try {
    isSyncing.value = true;

    if (isGoogleSynced.value) {
      // Disconnect logic
      await axiosInstance.delete("/google/calendar/disconnect");
      isGoogleSynced.value = false;
      eventBus.emit("show-toast", {
        severity: "success",
        summary: t("calendar.google_disconnected"),
        life: 3000,
      });
      // showToast("success", t("calendar.google_disconnected"));
    } else {
      // Connect logic - get auth URL from backend first
      // const response = await axiosInstance.get("/google/connect");
      const { data } = await axiosInstance.get("/google/connect");

      // Store current route to return after OAuth flow
      localStorage.setItem("preAuthRoute", router.currentRoute.value.fullPath);

      // Redirect to Google's OAuth page
      window.location.href = data.auth_url;
    }
  } catch (error) {
    // console.log(error);
    eventBus.emit("show-toast", {
      severity: "error",
      summary: t("calendar.google_sync_error"),
      life: 3000,
    });
    // showToast("error", t("calendar.google_sync_error"), error);
  } finally {
    isSyncing.value = false;
  }
};

// const species = ref([
//   { label: "Avian", value: "Birds", icon: "fa-solid fa-dove" },
//   { label: "Bovine", value: "Cows", icon: "fa-solid fa-cow" },
//   { label: "Camelid", value: "Camels", icon: "fa-solid fa-paw" }, // Default icon
//   { label: "Canine", value: "Dogs", icon: "fa-solid fa-dog" },
//   { label: "Caprine", value: "Goats", icon: "fa-solid fa-paw" }, // Default icon
//   { label: "Cavies", value: "Guinea Pigs", icon: "fa-solid fa-paw" }, // Default icon
//   { label: "Cervidae", value: "Deers", icon: "fa-solid fa-paw" },
//   { label: "Equine", value: "Horses", icon: "fa-duotone fa-horse " },
//   { label: "Feline", value: "Cats", icon: "fa-solid fa-cat" },
//   { label: "Lapine", value: "Rabbits", icon: "fa-solid fad fa-rabbit" },
//   { label: "Murine", value: "Mice", icon: "fa-solid fa-paw" },
//   { label: "Ovine", value: "Sheeps", icon: "fa-solid fa-sheep" },
// ]);
const species = ref([
  {
    label: t("species.avian"),
    en_label: "Avian",
    value: "Birds",
    icon: "fa-solid fa-dove",
  },
  {
    label: t("species.bovine"),
    en_label: "Bovine",
    value: "Cows",
    icon: "fa-solid fa-cow",
  },
  {
    label: t("species.camelid"),
    en_label: "Camelid",
    value: "Camels",
    icon: "fa-solid fa-paw",
  },
  {
    label: t("species.canine"),
    en_label: "Canine",
    value: "Dogs",
    icon: "fa-solid fa-dog",
  },
  {
    label: t("species.caprine"),
    en_label: "Caprine",
    value: "Goats",
    icon: "fa-solid fa-paw",
  },
  {
    label: t("species.cavies"),
    en_label: "Cavies",
    value: "Guinea Pigs",
    icon: "fa-solid fa-paw",
  },
  {
    label: t("species.cervidae"),
    en_label: "Cervidae",
    value: "Deers",
    icon: "fa-solid fa-paw",
  },
  {
    label: t("species.equine"),
    en_label: "Equine",
    value: "Horses",
    icon: "fa-duotone fa-horse",
  },
  {
    label: t("species.feline"),
    en_label: "Feline",
    value: "Cats",
    icon: "fa-solid fa-cat",
  },
  {
    label: t("species.lapine"),
    en_label: "Lapine",
    value: "Rabbits",
    icon: "fa-solid fad fa-rabbit",
  },
  {
    label: t("species.murine"),
    en_label: "Murine",
    value: "Mice",
    icon: "fa-solid fa-paw",
  },
  {
    label: t("species.ovine"),
    en_label: "Ovine",
    value: "Sheeps",
    icon: "fa-solid fa-sheep",
  },
]);

const getSpeciesValue = (label) => {
  const found = species.value.find((species) => species.en_label === label);
  return found ? found.label : null;
};

function getIconClass(speciesLabel) {
  const found = species.value.find((spec) => spec.label === speciesLabel);
  return found ? found.icon : "fa-solid fa-paw";
}
// const getSpeciesValue = (label) => {
//   const found = species.value.find((species) => species.label === label);
//   return found ? found.value : null;
// };
const currentPet = ref({
  id: "",
  title: "",
  people: ["Unknown"], // Assuming owner has a name field
  start: "",
  end: "",
  isEditable: true,
  description: "",
  calendarId: "leisure",
  owner: "",
  pet: { microchip_num: "123123" },
  location: "",
  theme: {
    lightColors: {
      main: "#f91c45",
      container: "#ffd2dc",
      onContainer: "#59000d",
    },
    darkColors: {
      main: "#ffc0cc",
      onContainer: "#ffdee6",
      container: "#a24258",
    },
  },
});
const handleSubmit = (data) => {
  isNewApointmentVisible.value = false;
  // currentPage.value = 1; // Reset to the first page when searching

  fetchAppointments();
};
const refreshData = () => {
  fetchAppointments();
};
const fetchAppointments = async (page = 1) => {
  loading.value = true;
  try {
    const response = await axiosInstance.get(
      `/appointments?page=${page}&per_page=${itemsPerPage.value}&search=${searchQuery.value}`
    );

    events.value = response.data.data.map((appointment) => ({
      id: appointment.id.toString(),
      title: appointment.title,
      people: appointment.owner
        ? [`${appointment.owner.name}`, `${appointment.pet.name}`]
        : ["Unknown"], // Assuming owner has a name field
      start: formatDateTime(appointment.start),
      end: formatDateTime(appointment.end),
      isEditable: true,
      description: appointment.description,
      calendarId: appointment.type,
      owner: appointment.owner.id,
      pet: appointment.pet,
      location: appointment.branch.name,
      theme: getEventTheme(appointment.type),
      status: appointment.status,
      _customContent: {
        monthGrid:
          "<h1>" +
          appointment.pet.name +
          "/" +
          appointment.owner.name +
          "</h1><p>" +
          appointment.description +
          "</p>",
        dateGrid:
          "<h1>" +
          appointment.pet.name +
          "/" +
          appointment.owner.name +
          "</h1><span>" +
          appointment.title +
          "</span>",
        timeGrid:
          "<h1>" +
          appointment.pet.name +
          "/" +
          appointment.owner.name +
          "</h1><span>" +
          appointment.title +
          "</span>",
      },
    }));
    if (events.value.length > 0) {
      // currentPet.value = events.value[0];
    }
    visible.value = true;
    calendarApp.eventsService.set(events.value);
  } catch (error) {
    console.error("Could not fetch appointments", error);
  } finally {
    loading.value = false;
  }
};
const eventTheme = {
  Regular: {
    colorName: "Regular",
    lightColors: {
      main: "#f9d71c",
      container: "#fff5aa",
      onContainer: "#594800",
    },
    darkColors: {
      main: "#fff5c0",
      onContainer: "#fff5de",
      container: "#a29742",
    },
  },
  Emergency: {
    colorName: "Emergency",
    lightColors: {
      main: "#f91c45",
      container: "#ffd2dc",
      onContainer: "#59000d",
    },
    darkColors: {
      main: "#ffc0cc",
      onContainer: "#ffdee6",
      container: "#a24258",
    },
  },
  "Non-Emergency": {
    colorName: "Non-Emergency",
    lightColors: {
      main: "#1db954", // Vibrant green (similar to Spotify's green)
      container: "#86e8b6", // Very light mint green
      onContainer: "#064e3b", // Dark green (for text on container)
    },
    darkColors: {
      main: "#a7f3d0", // Soft mint green
      onContainer: "#86e8b6", // Very light mint green
      container: "#065f46", // Deep emerald green
    },
  },
  FollowUp: {
    colorName: "FollowUp",
    lightColors: {
      main: "#1cf9b0",
      container: "#dafff0",
      onContainer: "#004d3d",
    },
    darkColors: {
      main: "#c0fff5",
      onContainer: "#e6fff5",
      container: "#42a297",
    },
  },
  Surgery: {
    colorName: "Surgery",
    lightColors: {
      main: "#1c7df9",
      container: "#d2e7ff",
      onContainer: "#002859",
    },
    darkColors: {
      main: "#c0dfff",
      onContainer: "#dee6ff",
      container: "#426aa2",
    },
  },
  Grooming: {
    colorName: "Grooming",
    lightColors: {
      main: "#8A2BE2",
      container: "#E6D6FF",
      onContainer: "#3E0071",
    },
    darkColors: {
      main: "#c0dfff",
      onContainer: "#dee6ff",
      container: "#426aa2",
    },
  },
};
function getEventTheme(themeName) {
  return eventTheme[themeName] || null; // Return the corresponding theme or null if not found
}
console.log("Current locale:", Cookies.get("language"));
const calendarApp = createCalendar({
  selectedDate: formatDateTime(new Date()),
  calendars: {
    Regular: {
      colorName: "Regular",
      lightColors: {
        main: "#f9d71c",
        container: "#fff5aa",
        onContainer: "#594800",
      },
      darkColors: {
        main: "#fff5c0",
        onContainer: "#fff5de",
        container: "#a29742",
      },
    },
    "Non-Emergency": {
      colorName: "Non-Emergency",
      lightColors: {
        main: "#1db954", // Vibrant green (similar to Spotify's green)
        container: "#86e8b6", // Very light mint green
        onContainer: "#064e3b", // Dark green (for text on container)
      },
      darkColors: {
        main: "#a7f3d0", // Soft mint green
        onContainer: "#86e8b6", // Very light mint green
        container: "#065f46", // Deep emerald green
      },
    },
    Emergency: {
      colorName: "Emergency",
      lightColors: {
        main: "#f91c45",
        container: "#ffd2dc",
        onContainer: "#59000d",
      },
      darkColors: {
        main: "#ffc0cc",
        onContainer: "#ffdee6",
        container: "#a24258",
      },
    },
    FollowUp: {
      colorName: "FollowUp",
      lightColors: {
        main: "#1cf9b0",
        container: "#dafff0",
        onContainer: "#004d3d",
      },
      darkColors: {
        main: "#c0fff5",
        onContainer: "#e6fff5",
        container: "#42a297",
      },
    },
    Surgery: {
      colorName: "Surgery",
      lightColors: {
        main: "#1c7df9",
        container: "#d2e7ff",
        onContainer: "#002859",
      },
      darkColors: {
        main: "#c0dfff",
        onContainer: "#dee6ff",
        container: "#426aa2",
      },
    },
    Grooming: {
      colorName: "Grooming",
      lightColors: {
        main: "#8A2BE2",
        container: "#E6D6FF",
        onContainer: "#3E0071",
      },
      darkColors: {
        main: "#c0dfff",
        onContainer: "#dee6ff",
        container: "#426aa2",
      },
    },
  },
  views: [viewMonthGrid, viewWeek, viewDay, viewMonthAgenda],
  defaultView: viewMonthGrid.name,
  // locale: "en-US",
  locale: Cookies.get("language") === "ar"
    ? "ar-SY"
    : Cookies.get("language") === "de"
      ? "de-DE"
      : "en-US",
  isRTL: true,
  isDark: true,
  gridHeight: 500,
  isResponsive: true,
  skipValidation: true,
  monthGridOptions: {
    /**
     * Number of events to display in a day cell before the "+ N events" button is shown
     * */
    nEventsPerDay: 2,
  },
  /*   translations: mergeLocales(translations, {
      "arSY": {
        Today: "اليوم",
        Month: "شهر",
        Week: "أسبوع",
        Day: "يوم",
        "Select View": "اختر طريقة العرض",
        events: "مواعيد",
        event: "موعد",
        "No events": "لا مواعيد",
        "Next period": "الفترة التالية",
        "Previous period": "الفترة السابقة",
        to: "حتى",
        "Full day- and multiple day events": "موعد يستمر كامل اليوم - وعلى عدة أيام",
        "Link to {{n}} more events on {{date}}": "رابط لـ {{n}} مواعيد إضافية بتاريخ: {{date}}",
        "Link to 1 more event on {{date}}": "رابطة لموعد إضافي واحد بتاريخ: {{date}}",
      },
    }),
   */
  translations: mergeLocales(translations, {

    "arAR": {
      Today: "اليوم",
      Month: "شهر",
      Week: "أسبوع",
      Day: "يوم",
      "Select View": "اختر طريقة العرض",
      events: "مواعيد",
      event: "موعد",
      "No events": "لا مواعيد",
      "Next period": "الفترة التالية",
      "Previous period": "الفترة السابقة",
      to: "حتى",
      "Full day- and multiple day events": "موعد يستمر كامل اليوم - وعلى عدة أيام",
      "Link to {{n}} more events on {{date}}": "رابط لـ {{n}} مواعيد إضافية بتاريخ: {{date}}",
      "Link to 1 more event on {{date}}": "رابطة لموعد إضافي واحد بتاريخ: {{date}}"
    }

  }),
  callbacks: {
    /**
     * Is called when:
     * 1. Selecting a date in the date picker
     * 2. Selecting a new view
     * */
    onRangeUpdate(range) { },

    /**
     * Is called when an event is updated through drag and drop
     * */
    onEventUpdate(updatedEvent) {
      onEventUpdate(updatedEvent);
    },

    /**
     * Is called when an event is clicked
     * */
    onEventClick(calendarEvent) {
      // visible.value = true;
      // currentPet.value = calendarEvent;
      currentPet.value = calendarEvent;
      petDetailsVisible.value = true;
    },

    /**
     * Is called when clicking a date in the month grid
     * */
    onClickDate(date, event) {
      activeDate.value = date;

      onRightClick();
    },

    /**
     * Is called when clicking somewhere in the time grid of a week or day view
     * */
    onClickDateTime(dateTime) {
      // e.g. 2024-01-01 12:37
      changeView(dateTime);
    },

    /**
     * Is called when selecting a day in the month agenda
     * */
    onClickAgendaDate(date) {
      // e.g. 2024-01-01
    },

    /**
     * Is called when double clicking a date in the month grid
     * */
    onDoubleClickDate(date) {
      // e.g. 2024-01-01
    },

    /**
     * Is called when double clicking somewhere in the time grid of a week or day view
     * */
    onDoubleClickDateTime(dateTime) {
      // e.g. 2024-01-01 12:37
    },

    /**
     * Is called when clicking the "+ N events" button of a month grid-day
     * */
    onClickPlusEvents(date) {
      // e.g. 2024-01-01
    },

    /**
     * Is called when the selected date is updated
     * */
    onSelectedDateUpdate(date) { },

    /**
     * Runs on resizing the calendar, to decide if the calendar should be small or not.
     * This in turn affects what views are rendered.
     * */
    isCalendarSmall($app) {
      return $app.elements.calendarWrapper?.clientWidth < 500;
    },

    /**
     * Runs before the calendar is rendered
     * */
    beforeRender($app) {
      // const range = $app.calendarState.range.value;
      // fetchYourEventsFor(range.start, range.end);
    },

    /**
     * Runs after the calendar is rendered
     * */
    onRender($app) { },
  },

  plugins: [
    eventsServicePlugin,
    createDragAndDropPlugin(),
    calendarControls,
    scrollController,
    // createEventModalPlugin(),
  ],
});

const menuItems = ref([
  {
    label: t("calendar.context_menu.day_view"),
    icon: "pi pi-calendar",
    command: () => {
      // Implement navigation to day view
      changeView(activeDate.value);
    },
  },
  {
    label: t("calendar.context_menu.add_new"),
    icon: "pi pi-calendar-plus",
    command: () => {
      addAppointment();
      // Implement functionality to add a new appointment
    },
  },
]);
const onEventUpdate = async (updatedEvent) => {
  const data = JSON.stringify({
    start: updatedEvent.start + `:00`, // Ensure this matches the model's field name
    end: updatedEvent.end + `:00`, // Ensure this matches the model's field name
    title: updatedEvent.title,
    description: updatedEvent.description,
    type: updatedEvent.calendarId,
    status: updatedEvent.status,
  });

  try {
    const response = await axiosInstance.put(`/appointments/${updatedEvent.id}`, data, {
      headers: {
        "Content-Type": "application/json",
      },
    });

    eventBus.emit("show-toast", {
      severity: "success",
      summary: t("appointment_updated_summary"),
      detail: t("appointment_updated_detail"),
      life: 5000,
    });
  } catch (error) {
    console.error("Error updating appointment:", error);
    eventBus.emit("show-toast", {
      severity: "error",
      summary: t("common.error"),
      detail: "Failed to update the appointment.",
      life: 5000,
    });
  }
};
const addAppointment = () => {
  isNewApointmentVisible.value = true;
};
// eventModal.close(); // close the modal
const changeView = (date) => {
  calendarControls.setDate(date);
  calendarControls.setView("day");
};
const initializeCalendarTheme = () => {
  // Retrieve theme from localStorage, default to "light" if not set
  const savedTheme = localStorage.getItem("theme") || "light";

  // Set the calendar theme based on the saved theme
  calendarApp.setTheme(savedTheme);
};
const setCalendarTheme = (theme) => {
  calendarApp.setTheme(theme);
};
const contextMenu = ref(null);
const clickedDate = ref(null);
const lastClickPosition = ref({ x: 0, y: 0 });
const handleDateClick = async (event, date) => {
  clickedDate.value = date;

  // Capture the mouse click coordinates
  lastClickPosition.value = { x: event.clientX, y: event.clientY };

  await nextTick(); // Ensure the context menu is rendered and available

  if (contextMenu.value) {
    // Set position of the context menu manually
    const contextMenuElement = contextMenu.value.$el;
    contextMenuElement.style.left = `${lastClickPosition.value.x}px`;
    contextMenuElement.style.top = `${lastClickPosition.value.y}px`;
    contextMenuElement.style.position = "fixed";

    // Show the context menu at the specified position
    contextMenu.value.show(event);
  }
};
const menu = ref();
const onRightClick = () => {
  menu.value.show(event);
};
/*testing calendar multilanguage*/
const datePickerArAR = {
  Date: "Date",
  "MM/DD/YYYY": "MM/DD/YYYY",
  "Next month": "الشهر التالي",
  "Previous month": "الشهر السابق",
  "Choose Date": "اختر تاريخا",
};

const calendarArAR = {
  Today: "اليوم",
  Month: "شهر",
  Week: "أسبوع",
  Day: "يوم",
  "Select View": "اختر طريقة العرض",
  events: "مواعيد",
  event: "موعد",
  "No events": "لا مواعيد",
  "Next period": "الفترة التالية",
  "Previous period": "الفترة السابقة",
  to: "حتى", // as in 2/1/2020 to 2/2/2020
  "Full day- and multiple day events": "موعد يستمر كامل اليوم - وعلى عدة أيام",
  "Link to {{n}} more events on {{date}}": "رابط لـ {{n}} مواعيد إضافية بتاريخ: {{date}}",
  "Link to 1 more event on {{date}}": "رابطة لموعد إضافي واحد بتاريخ:  {{date}}",
};

const arAR = {
  ...datePickerArAR,
  ...calendarArAR,
};
watchEffect(() => {
  setCalendarTheme(Cookies.get("theme"));
});
watchEffect(
  () => route.query,
  (query) => {
    if (query.google_sync_success) {
      isGoogleSynced.value = true;
      eventBus.emit("show-toast", {
        severity: "success",
        summary: t("calendar.google_sync_connected"),
        life: 3000,
      });
    }
    if (query.google_sync_error) {
      eventBus.emit("show-toast", {
        severity: "error",
        summary: t("calendar.google_sync_error"),
        life: 5000,
      });
    }
  }
);

const checkSyncStatus = async () => {
  try {
    const { data } = await axiosInstance.get("/google/calendar/status");

    isGoogleSynced.value = data.connected;

    if (data.needs_reconnect) {
      eventBus.emit("show-toast", {
        severity: "warn",
        summary: t("calendar.google_reconnect_warning"),
        life: 5000,
      });
      // showToast("warn", t("calendar.google_reconnect_warning"));
    }
  } catch (error) {
    console.error("Sync status check failed", error);
  }
};

/*end testing calendar*/
onMounted(async () => {
  eventBus.on("themeChange", setCalendarTheme);
  // try {
  //   const response = await axiosInstance.get("/google/calendar/status");
  //
  //   isGoogleSynced.value = response.data.connected;
  // } catch (error) {
  //   console.error("Could not check Google Calendar status", error);
  // }
  checkSyncStatus();
  const interval = setInterval(checkSyncStatus, 300000);
  initializeCalendarTheme();
  fetchAppointments();
});
</script>
<style scooped>
.sx-vue-calendar-wrapper {
  width: 1200px;
  max-width: 100vw;
  height: 800px;
  max-height: 90vh;
}

.p-button {
  display: inline-flex;
  cursor: pointer;
  user-select: none;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  position: relative;
  /* color: var(--p-primary-contrast-color); */
  /* background: var(--border-color); */
  /* border: 1px solid var(--p-primary-color); */
  /* padding: 0.5rem 0.7rem; */
  font-size: 1rem;
  font-family: inherit;
  font-feature-settings: inherit;
  transition: background 0.5, color var(--p-transition-duration),
    border-color var(--p-transition-duration), outline-color var(--p-transition-duration),
    box-shadow var(--p-transition-duration);
  border-radius: var(--p-border-radius-md);
  outline-color: transparent;
  /* gap: 0.5rem; */
}

.sx__event.sx__month-grid-event.sx__month-grid-cell {
  height: 50px;
}

.sx__forward-backward-navigation {
  direction: ltr;
}

.google-sync-status {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.8rem;
  margin-left: 1rem;
}

.google-sync-status.connected {
  color: var(--green-500);
}

.google-sync-status.disconnected {
  color: var(--red-500);
}

[dir="rtl"] .sx__date-input-chevron-wrapper {
  right: 1rem;
  left: auto;
}
</style>
