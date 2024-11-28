<template>
  <!-- <div class="rounded-xl overflow-scroll drop-shadow-md mt-4 is-light-mode"> -->
  <!-- <Qalendar :events="events" :config="config" class="!py-4" /> -->
  <div class="flex gap-2">
    <div class="w-4/5">
      <ScheduleXCalendar
        :calendar-app="calendarApp"
        class="!h-[calc(100vh-100px)] !w-full mt-6 mx-auto"
        :headerContentRightPrepend="``"
      >
        <template #headerContentRightPrepend>
          <div class="sx__calendar-header-content">
            <Button
              type=""
              icon="pi pi-refresh !text-sm"
              label=""
              v-tooltip.bottom="`Refresh Data`"
              class="!text-xs !text-[var(--p-primary-color)] hover:!text-[var(--p-primary-contrast-color)] sx__today-button sx__ripple"
              @click="refreshData"
              style="
                padding: var(--sx-spacing-padding3) var(--sx-spacing-padding4);
                border-radius: var(--sx-rounding-extra-small);
                font-size: var(--sx-calendar-header-input-font-size);
                color: var(--sx-internal-color-text);
              "
            />
            <Button
              type=""
              icon="pi pi-plus !text-sm"
              label=""
              v-tooltip.bottom="`Add Appointment`"
              class="!text-xs !text-[var(--p-primary-color)] hover:!text-[var(--p-primary-contrast-color)] sx__today-button sx__ripple"
              style="
                padding: var(--sx-spacing-padding3) var(--sx-spacing-padding4);
                border-radius: var(--sx-rounding-extra-small);
                font-size: var(--sx-calendar-header-input-font-size);
                color: var(--sx-internal-color-text);
              "
            />
          </div>
        </template>
      </ScheduleXCalendar>
      <ContextMenu ref="menu" :model="menuItems" class="!text-xs"
        >.
        <template #item="{ item, props }">
          <h5 class="!text-xs" v-bind="props.action">
            <i :class="item.icon"></i> {{ item.label }}
          </h5>
        </template>
      </ContextMenu>
    </div>
    <div
      class="w-1/5 !h-[calc(100vh-100px)] mt-6 !bg-gray-200 dark:!bg-zinc-600 border rounded-lg p-4 flex flex-col justify-between"
    >
      <div
        class="flex flex-col items-center gap-4 mb-4 bg-gray-100 dark:bg-zinc-500 shadow-md rounded-lg p-4 !text-sm"
        :style="{
          '--border-color': currentPet.theme.lightColors.main,
          '--background-color': currentPet.theme.lightColors.container,
          '--text-color': currentPet.theme.lightColors.onContainer,
          'border-left': `4px solid var(--border-color)`,
          background: `var(--background-color)`,
          color: `var(--text-color)`,
        }"
      >
        <h4 class="w-full">
          <i
            :class="
              getIconClass(currentPet.pet.species) +
              ` text-sm text-center ` +
              (currentPet.pet.gender === `Male` ? `text-blue-600` : 'text-pink-600') +
              ` mx-auto w-fit dark:bg-surface-500  mr-2`
            "
          ></i>
          {{ currentPet.pet.name }}
        </h4>
        <h4 class="w-full">
          <i class="fas fa-paw mr-2"></i>{{ getSpeciesValue(currentPet.pet.species) }}
        </h4>

        <h4 class="w-full">
          <i class="fa-solid fa-users"></i> {{ currentPet.people[0] }}
        </h4>
        <h4 class="w-full">
          <i class="fa-solid fa-location-dot mr-2" aria-hidden="true"></i>
          {{ currentPet.location }}
        </h4>
        <h4 class="w-full text-xs">Details: {{ currentPet.description }}</h4>
        <RouterLink
          class="p-button p-component !text-xs !text-[var(--p-primary-contrast-color)] !border-none shadow-sm"
          icon="fas fa-paw"
          label="Details"
          v-tooltip.top="{
            value: 'View Details',
            pt: {
              arrow: {
                style: {
                  borderTopColor: 'var(--p-primary-color)',
                },
              },
              text:
                '!bg-[var(--p-primary-color)] !text-primary-contrast !font-thin !text-xs',
            },
          }"
          :to="{
            name: 'PetDetails',
            params: { petmicrochip: currentPet.pet.microchip_num },
          }"
        >
          <i class="fas fa-paw"></i><span>Details</span>
        </RouterLink>
      </div>

      <div class="flex flex-col">
        <h4>Legend</h4>
        <div class="flex flex-wrap gap-2">
          <div v-for="(theme, name) in eventTheme" :key="name" class="theme-box">
            <Tag
              class="shadow-md border-gray-500"
              :style="{
                '--border-color': theme.lightColors.main,
                '--background-color': theme.lightColors.container,
                '--text-color': theme.lightColors.onContainer,
                'border-left': `4px solid var(--border-color)`,
                background: `var(--background-color)`,
                color: `var(--text-color)`,
              }"
            >
              <div class="gap-2 px-1">
                <span class="!text-xs font-normal">{{ theme.colorName }}</span>
              </div>
            </Tag>
          </div>
        </div>
      </div>
    </div>
  </div>
  <Dialog
    header="New Appointment"
    v-model:visible="isNewApointmentVisible"
    @hide="isNewApointmentVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">New Test Result</span>
      </div>
    </template>
    <addNewAppointment :activeDate="activeDate" @submitted="handleSubmit" />
    <template #footer> </template>
  </Dialog>
</template>

<script setup>
import { ref, onMounted, nextTick } from "vue";
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
import { createEventModalPlugin } from "@schedule-x/event-modal";
import { createDragAndDropPlugin } from "@schedule-x/drag-and-drop";
import { createScrollControllerPlugin } from "@schedule-x/scroll-controller";
import eventBus from "@/eventBus";
import "@schedule-x/theme-default/dist/calendar.css";
import Tag from "primevue/tag";
import ContextMenu from "primevue/contextmenu";
import Dialog from "primevue/dialog";
import addNewAppointment from "@/views/addNewAppointment.vue"; // Adjust the path as needed
import Button from "primevue/button";
import { RouterLink } from "vue-router";
// import RouterLink from "primevue/routerlink";
import axiosInstance from "@/axios"; // Ensure this is correctly set up with baseURL
const eventsServicePlugin = createEventsServicePlugin();
const eventModal = createEventModalPlugin();
const calendarControls = createCalendarControlsPlugin();
const events = ref("");
const searchQuery = ref("");
const itemsPerPage = ref(100);
const loading = ref(false);
const visible = ref(false);
const activeDate = ref("");
const isNewApointmentVisible = ref(false);
const scrollController = createScrollControllerPlugin({
  initialScroll: "12:00",
});
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
const species = ref([
  { label: "Avian", value: "Birds", icon: "fa-solid fa-dove" },
  { label: "Bovine", value: "Cows", icon: "fa-solid fa-cow" },
  { label: "Camelid", value: "Camels", icon: "fa-solid fa-paw" }, // Default icon
  { label: "Canine", value: "Dogs", icon: "fa-solid fa-dog" },
  { label: "Caprine", value: "Goats", icon: "fa-solid fa-paw" }, // Default icon
  { label: "Cavies", value: "Guinea Pigs", icon: "fa-solid fa-paw" }, // Default icon
  { label: "Cervidae", value: "Deers", icon: "fa-solid fa-paw" },
  { label: "Equine", value: "Horses", icon: "fa-duotone fa-horse " },
  { label: "Feline", value: "Cats", icon: "fa-solid fa-cat" },
  { label: "Lapine", value: "Rabbits", icon: "fa-solid fad fa-rabbit" },
  { label: "Murine", value: "Mice", icon: "fa-solid fa-paw" },
  { label: "Ovine", value: "Sheeps", icon: "fa-solid fa-sheep" },
]);
function getIconClass(speciesLabel) {
  const found = species.value.find((spec) => spec.label === speciesLabel);
  return found ? found.icon : "fa-solid fa-paw";
}
const getSpeciesValue = (label) => {
  const found = species.value.find((species) => species.label === label);
  return found ? found.value : null;
};
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
  console.log(data);
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
        monthGrid: "<h1>" + appointment.pet.name + "</h1>",
        dateGrid: "<h1>" + appointment.pet.name + "</h1>",
        timeGrid: "<h1>" + appointment.pet.name + "</h1>",
      },
    }));
    currentPet.value = events.value[0];
    // console.log(events.value);
    visible.value = true;
    calendarApp.eventsService.set(events.value);
  } catch (error) {
    console.error("Could not fetch appointments", error);
  } finally {
    loading.value = false;
  }
};
const eventTheme = {
  Emergency: {
    colorName: "Emergency",
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
  Regular: {
    colorName: "Regular",
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
};
function getEventTheme(themeName) {
  return eventTheme[themeName] || null; // Return the corresponding theme or null if not found
}
// console.log(getEventTheme("Emergency"));
const calendarApp = createCalendar({
  selectedDate: formatDateTime(new Date()),
  calendars: {
    Emergency: {
      colorName: "Emergency",
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
    Regular: {
      colorName: "Regular",
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
  views: [viewMonthGrid, viewWeek, viewDay],
  defaultView: viewMonthGrid.name,
  callbacks: {
    /**
     * Is called when:
     * 1. Selecting a date in the date picker
     * 2. Selecting a new view
     * */
    onRangeUpdate(range) {
      console.log("new calendar range start date", range.start);
      console.log("new calendar range end date", range.end);
    },

    /**
     * Is called when an event is updated through drag and drop
     * */
    onEventUpdate(updatedEvent) {
      // console.log("onEventUpdate", updatedEvent);
      onEventUpdate(updatedEvent);
    },

    /**
     * Is called when an event is clicked
     * */
    onEventClick(calendarEvent) {
      console.log("onEventClick", currentPet.value);
      visible.value = true;
      currentPet.value = calendarEvent;
      console.log("onEventClick", currentPet.value.description);
    },

    /**
     * Is called when clicking a date in the month grid
     * */
    onClickDate(date, event) {
      // console.log(date);
      // console.log(event);
      activeDate.value = date;
      console.log("Active Date: " + activeDate.value);
      onRightClick();
    },

    /**
     * Is called when clicking somewhere in the time grid of a week or day view
     * */
    onClickDateTime(dateTime) {
      console.log("onClickDateTime", dateTime); // e.g. 2024-01-01 12:37
      changeView(dateTime);
    },

    /**
     * Is called when selecting a day in the month agenda
     * */
    onClickAgendaDate(date) {
      console.log("onClickAgendaDate", date); // e.g. 2024-01-01
    },

    /**
     * Is called when double clicking a date in the month grid
     * */
    onDoubleClickDate(date) {
      console.log("onClickDate", date); // e.g. 2024-01-01
    },

    /**
     * Is called when double clicking somewhere in the time grid of a week or day view
     * */
    onDoubleClickDateTime(dateTime) {
      console.log("onDoubleClickDateTime", dateTime); // e.g. 2024-01-01 12:37
    },

    /**
     * Is called when clicking the "+ N events" button of a month grid-day
     * */
    onClickPlusEvents(date) {
      console.log("onClickPlusEvents", date); // e.g. 2024-01-01
    },

    /**
     * Is called when the selected date is updated
     * */
    onSelectedDateUpdate(date) {
      console.log("onSelectedDateUpdate", date);
    },

    /**
     * Runs on resizing the calendar, to decide if the calendar should be small or not.
     * This in turn affects what views are rendered.
     * */
    isCalendarSmall($app) {
      // return $app.elements.calendarWrapper?.clientWidth! < 500
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
    onRender($app) {
      console.log("onRender", $app);
    },
  },

  plugins: [
    eventsServicePlugin,
    createDragAndDropPlugin(),
    calendarControls,
    scrollController,
  ],
});
const menuItems = ref([
  {
    label: "Go To Day Calendar",
    icon: "pi pi-calendar",
    command: () => {
      // Implement navigation to day view
      changeView(activeDate.value);
    },
  },
  {
    label: "Add New Appointment",
    icon: "pi pi-calendar-plus",
    command: () => {
      addAppointment();
      // Implement functionality to add a new appointment
    },
  },
]);
const onEventUpdate = async (updatedEvent) => {
  // console.log("onEventUpdate", updatedEvent);
  const data = JSON.stringify({
    start: updatedEvent.start + `:00`, // Ensure this matches the model's field name
    end: updatedEvent.end + `:00`, // Ensure this matches the model's field name
    title: updatedEvent.title,
    description: updatedEvent.description,
    type: updatedEvent.calendarId,
    status: updatedEvent.status,
  });
  // console.log("onEventUpdate", data);
  try {
    const response = await axiosInstance.put(`/appointments/${updatedEvent.id}`, data, {
      headers: {
        "Content-Type": "application/json",
      },
    });
    // console.log("Appointment updated successfully:", response.data);
    eventBus.emit("show-toast", {
      severity: "success",
      summary: "Appointment Updated",
      detail: "The appointment has been updated successfully.",
      life: 5000,
    });
  } catch (error) {
    console.error("Error updating appointment:", error);
    eventBus.emit("show-toast", {
      severity: "error",
      summary: "Error",
      detail: "Failed to update the appointment.",
      life: 5000,
    });
  }
};
const addAppointment = () => {
  isNewApointmentVisible.value = true;
};
eventModal.close(); // close the modal
const changeView = (date) => {
  // console.log(date);
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
onMounted(() => {
  eventBus.on("themeChange", setCalendarTheme);
  initializeCalendarTheme();
  fetchAppointments();
});
</script>
<style>
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
  color: var(--p-primary-contrast-color);
  background: var(--border-color);
  border: 1px solid var(--p-primary-color);
  padding: 0.5rem 0.7rem;
  font-size: 1rem;
  font-family: inherit;
  font-feature-settings: inherit;
  transition: background 0.5, color var(--p-transition-duration),
    border-color var(--p-transition-duration), outline-color var(--p-transition-duration),
    box-shadow var(--p-transition-duration);
  border-radius: var(--p-border-radius-md);
  outline-color: transparent;
  gap: 0.5rem;
}
/* .sx__week-grid {
  max-height: 800px;
} */
</style>
