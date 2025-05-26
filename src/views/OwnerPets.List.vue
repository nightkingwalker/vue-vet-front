<template>
  <DataView :value="pets" :layout="layout" class="!rounded-lg h-[calc(100vh-70px)]">
    <template #header>
      <div
        class="flex flex-col md:flex-row justify-between items-start md:items-center p-4 bg-surface-300 rounded-t-lg border-b border-surface-500 gap-2"
      >
        <!-- <h2 class="text-lg md:text-xl font-semibold text-surface-0">
          {{ ownerName }} {{ $t("owner_pet_list.title") }}
        </h2> -->
        <Breadcrumb :model="items">
          <template #item="{ item, props }">
            <router-link
              v-if="item.route"
              v-slot="{ href, navigate }"
              :to="item.route"
              custom
            >
              <a :href="href" v-bind="props.action" @click="navigate">
                <span :class="[item.icon, 'text-color']" />
                <span class="text-primary font-semibold">{{ item.label }}</span>
              </a>
            </router-link>
            <a v-else :href="item.url" :target="item.target" v-bind="props.action">
              <span class="text-surface-700 dark:text-surface-0">{{ item.label }}</span>
            </a>
          </template>
        </Breadcrumb>
        <div
          class="flex flex-col sm:flex-row gap-2 sm:gap-3 items-stretch w-full md:w-auto"
        >
          <InputGroup class="w-full sm:w-48 md:w-56 lg:w-64">
            <InputGroupAddon class="bg-surface-400 border-surface-500">
              <i class="pi pi-search text-surface-300 text-sm md:text-base" />
            </InputGroupAddon>
            <InputText
              v-model="searchQuery"
              @input="onSearchChange"
              @focus="inputFocused = true"
              @blur="inputFocused = false"
              type="text"
              class="bg-surface-400 border-surface-500 text-surface-100 placeholder-surface-500 text-sm md:text-base"
              :placeholder="$t('owner_pet_list.search_placeholder')"
            />
            <Button
              v-if="searchQuery"
              icon="pi pi-times"
              @click="clearFilters"
              class="p-button-text text-surface-400 hover:text-surface-200 text-sm md:text-base"
            />
          </InputGroup>

          <div class="flex gap-2 justify-end sm:justify-start">
            <Button
              icon="pi pi-refresh"
              @click="refreshData"
              class="p-button-text !text-emerald-400 hover:text-emerald-300 text-sm md:text-base"
              v-tooltip.top="$t('owner_pet_list.tooltips.refresh')"
            />
            <Button
              icon="pi pi-plus"
              @click="showNewPatientModal"
              class="p-button-primary bg-emerald-600 hover:bg-emerald-500 border-emerald-600 text-sm md:text-base"
              v-tooltip.top="$t('owner_pet_list.buttons.new_patient')"
            />
          </div>
        </div>
      </div>
    </template>

    <!-- Grid View -->
    <template #grid v-if="loading">
      <div class="grid grid-cols-12 gap-2 py-4">
        <div
          v-for="i in 4"
          :key="i"
          class="col-span-12 sm:col-span-6 md:col-span-4 xl:col-span-3 p-2"
        >
          <div
            class="p-6 border border-surface-500 bg-surface-300 rounded-lg flex flex-col"
          >
            <div class="text-lg font-medium border-b border-surface-500 pb-2">
              <Skeleton width="6rem" height="1.5rem" />
            </div>
            <div class="mt-4 text-sm">
              <div class="text-sm mt-2">
                <Skeleton width="12rem" height="1.5rem" />
              </div>
              <div class="text-sm mt-2">
                <Skeleton width="12rem" height="1.5rem" />
              </div>
              <div class="text-sm mt-2">
                <Skeleton width="12rem" height="1.5rem" />
              </div>
            </div>
            <div class="flex flex-col gap-6 mt-6">
              <div class="flex gap-2">
                <Skeleton class="w-full" height="1.5rem" />
              </div>
            </div>
          </div>
        </div>
      </div>
    </template>

    <template #grid="slotProps" v-else>
      <ScrollPanel style="height: calc(70vh)" class="!overflow-y-auto">
        <div
          class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-3 p-3"
        >
          <div
            v-for="(pet, index) in slotProps.items"
            :key="index"
            class="p-3 border border-surface-500 bg-surface-300 rounded-lg hover:bg-surface-400 transition-all"
          >
            <!-- Pet Header -->
            <div
              class="flex items-center gap-3 text-base md:text-lg font-medium text-surface-100 border-b border-emerald-500 w-fit mb-1 md:mb-2"
            >
              <div
                class="w-10 h-10 rounded-lg flex items-center justify-center text-white"
              >
                <i
                  :class="
                    getIconClass(pet.species) +
                    ' text-lg ' +
                    (pet.gender === 'Male' ? 'text-blue-500' : 'text-pink-500')
                  "
                ></i>
              </div>
              <h3 class="font-medium text-surface-100 truncate">
                {{ pet.name }}
              </h3>
            </div>

            <!-- Pet Details -->
            <div class="mt-3 space-y-2 flex-grow">
              <div class="flex items-start">
                <span class="text-xs text-surface-400 flex-shrink-0">
                  {{ $t("owner_pet_list.fields.species") }}
                </span>
                <span class="text-sm text-surface-200">
                  {{ getSpeciesValue(pet.species) }}
                </span>
              </div>
              <div class="flex items-start">
                <span class="text-xs text-surface-400 flex-shrink-0">
                  {{ $t("owner_pet_list.fields.breed") }}
                </span>
                <span class="text-sm text-surface-200">
                  {{ pet.breed || "-" }}
                </span>
              </div>
              <div class="flex items-start">
                <span class="text-xs text-surface-400 flex-shrink-0">
                  {{ $t("owner_pet_list.fields.gender") }}
                </span>
                <span class="text-sm text-surface-200">
                  {{ $t(`pets.status.${pet.gender.toLowerCase()}`) }}
                </span>
              </div>
            </div>

            <!-- Action Button -->
            <div class="mt-4 pt-3 border-t border-surface-500">
              <RouterLink
                class="w-full p-button !bg-emerald-600 hover:!bg-emerald-500 !text-surface-100 p-component p-button-sm !text-xs !justify-center"
                :to="{
                  name: 'PetDetails',
                  params: { petmicrochip: pet.microchip_num },
                }"
                v-tooltip.top="$t('owner_pet_list.tooltips.view_details')"
              >
                <i class="fas fa-paw mr-2"></i>
                <span>{{ $t("owner_pet_list.buttons.details") }}</span>
              </RouterLink>
            </div>
          </div>
        </div>
      </ScrollPanel>
    </template>

    <template #footer>
      <div class="p-2 md:p-4 bg-surface-300 border-t border-surface-500 rounded-b-lg">
        <Paginator
          :rows="itemsPerPage"
          :totalRecords="totalRecords"
          :rowsPerPageOptions="[25, 50, 100]"
          @page="onPageChange"
          class="border-0 bg-surface-300 [&>button]:text-surface-100 [&>button:hover]:bg-surface-400 text-xs md:text-sm"
        ></Paginator>
      </div>
    </template>
  </DataView>

  <Dialog
    v-model:visible="isModalVisible"
    :header="$t('owner_pet_list.modal.header')"
    :style="{ width: 'min(95vw, 600px)' }"
    class="bg-surface-300 text-surface-100"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <Avatar icon="fas fa-users" shape="circle" />
        <span class="font-bold whitespace-nowrap">
          {{ $t("owner_pet_list.modal.header") }}
        </span>
      </div>
    </template>
    <NewPatient
      @submitted="handleSubmit"
      @submittedOffline="handleSubmitOffline"
      :ownername="ownerName"
      v-focustrap="{
        disabled: false,
        autoFocus: true,
      }"
    />
  </Dialog>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from "vue";
import DataView from "primevue/dataview";
import Paginator from "primevue/paginator";
import InputGroupAddon from "primevue/inputgroupaddon";
import InputGroup from "primevue/inputgroup";
import InputText from "primevue/inputtext";
import SelectButton from "primevue/selectbutton";
import Button from "primevue/button";
import { RouterLink } from "vue-router";
import axiosInstance from "@/axios"; // Assuming axiosInstance is set up correctly
import Skeleton from "primevue/skeleton";
import router from "@/router";
import { useRoute } from "vue-router";
import Breadcrumb from "primevue/breadcrumb";
import Dialog from "primevue/dialog";
import Avatar from "primevue/avatar";
import NewPatient from "@/views/AddOwnerPetsView.vue";
import eventBus from "@/eventBus";
import { useI18n } from "vue-i18n";
const { t, locale } = useI18n();
const route = useRoute();
const home = ref({
  icon: "pi pi-home",
  label: "Home",
  route: "/",
});
const props = defineProps({
  ownerid: {
    type: [String, Number],
    required: true,
  },
});
const pets = ref([]);
const isModalVisible = ref(false);
const currentPage = ref(1); // Track the current page
const totalRecords = ref(0); // Total number of records
const itemsPerPage = ref(25); // Number of items per page (matching your API response)const layout = ref("grid");
const layout = ref("grid");
const loading = ref(true);
const owner = ref([]); // Initialize owner as an empty string
const options = ref(["list", "grid"]);
const ownerName = ref("");
// const ownerid = ref(route.params.ownerid);
const searchQuery = ref(""); // Reactive search query
const items = ref([
  { label: t("app.menu.owners"), route: "/owners" },
  {
    label: ownerName.value + " Patients",
    route: "/" + route.params.ownerid + "/pets",
  },
]);
const onPageChange = (event) => {
  itemsPerPage.value = event.rows;
  currentPage.value = event.page + 1; // PrimeVue Paginator uses zero-based index
  fetchPets(currentPage.value); // Fetch pets for the new page
  // console.log(event);
};
const onSearchChange = () => {
  if (searchQuery.value.length < 3) {
    return; // Do not proceed with search
  }
  if (searchQuery.value.length === 0) {
    clearFilters();
    return; // Do not proceed with search
  }
  currentPage.value = 1; // Reset to first page on search
  fetchPets(currentPage.value); // Fetch pets with the updated search query
};
// Function to fetch pets data from the API

const fetchPets = async (page = 1) => {
  loading.value = true;
  try {
    const response = await axiosInstance.get(
      `/owners/${route.params.ownerid}/pets?page=${page}&per_page=${itemsPerPage.value}&search=${searchQuery.value}`
    );

    // Pets data with pagination
    pets.value = response.data.pets.data;
    totalRecords.value = response.data.pets.total;
    currentPage.value = response.data.pets.current_page;

    // Owner data available even if no pets
    ownerName.value = response.data.owner.name;
    items.value = [
      { label: t("app.menu.owners"), route: "/owners" },
      {
        label: `${ownerName.value} Patients`,
        route: "/" + route.params.ownerid + "/pets",
      },
    ];

    loading.value = false;
  } catch (error) {
    console.error("Error fetching pets:", error);
    loading.value = false;
  }
};
const inputFocused = ref(false);
const clearFilters = () => {
  // console.log("clearing filters");
  loading.value = true; // Set loading state to true to show skeletons
  currentPage.value = 1;
  searchQuery.value = "";
  fetchPets(currentPage.value);
};
const refreshData = () => {
  loading.value = true; // Set loading state to true to show skeletons
  fetchPets(); // Fetch the pets data again
};
const showNewPatientModal = async () => {
  // await router.push("/add-owner");
  isModalVisible.value = true;
};
const handleSubmit = () => {
  isModalVisible.value = false;
  currentPage.value = 1;
  fetchPets(currentPage.value);
};
const handleSubmitOffline = () => {
  isModalVisible.value = false;
};
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
function getIconClass(speciesLabel) {
  const found = species.value.find((spec) => spec.label === speciesLabel);
  return found ? found.icon : "fa-solid fa-paw";
}
const getSpeciesValue = (label) => {
  const found = species.value.find((species) => species.en_label === label);
  return found ? found.label : null;
};
let typingTimer = null;
const typingDelay = 500; // Adjust based on the speed of your scanner
const handleKeydown = (event) => {
  // if (!inputFocused.value) {
  if (!inputFocused.value && isModalVisible.value === false && !event.ctrlKey) {
    // Check if the input is NOT focused
    if (event.key.length === 1) {
      // Capture only printable characters
      clearTimeout(typingTimer); // Clear the previous timer
      typingTimer = setTimeout(() => {
        // Only trigger search if buffer length is greater than 3
        if (searchQuery.value.length > 3) {
          onSearchChange(); // Call search when user stops typing
        }
      }, typingDelay);

      // Append to searchQuery immediately
      searchQuery.value += event.key; // Update the search query immediately
    }
  } else {
    // If focused, allow normal input behavior
    // No need for additional logic here; on input, v-model will update searchQuery
  }
};

onMounted(() => {
  fetchPets(1);
  eventBus.on("AddPet", () => {
    // console.log("OPEN ADD OWNER");
    isModalVisible.value = true;
  });
  window.addEventListener("keydown", handleKeydown);
});
onBeforeUnmount(() => {
  window.removeEventListener("keydown", handleKeydown);
});
</script>

<style scoped>
.form-container {
  max-width: 800px;
  margin: auto;
}
/* Improved responsive styles */
.button-transition {
  transition: all 0.2s ease;
}

.button-transition:hover {
  transform: translateY(-1px);
}

/* Better scrollbar styling */
:deep(.p-scrollpanel) {
  border-radius: 0.5rem;
}

:deep(.p-scrollpanel-bar) {
  background-color: var(--surface-400) !important;
  opacity: 1;
  transition: background-color 0.2s;
  width: 8px;
}

:deep(.p-scrollpanel-bar:hover) {
  background-color: var(--emerald-400) !important;
}

/* Responsive text truncation */
.truncate {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 100%;
}

/* Better mobile spacing */
@media (max-width: 640px) {
  .p-3 {
    padding: 0.75rem;
  }
  .gap-2 {
    gap: 0.5rem;
  }
}
</style>
