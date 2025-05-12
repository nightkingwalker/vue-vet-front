<template>
  <div class="w-full lg:!text-[14px]">
    <DataTable id="petlist" ref="dt" :value="loading ? skeletonRows : pets" :row-hover="true" :loading="loading"
      :metaKeySelection="metaKey" sortMode="multiple" :exportFilename="$t('pets.title') + '_Details'" removableSort
      stripedRows v-model:selection="selectedPets" showGridlines scrollable scrollHeight="80vh" highlightOnSelect
      dataKey="id" @rowSelect="onSelectionChange" :exportFunction="beforeExportFunction" responsiveLayout="scroll"
      class="rounded-xl drop-shadow-md mt-4 h-[95vh]" :size="`small`">
      <template #header>
        <div class="flex justify-between items-center ">
          <div class="flex" v-if="!isMobile">
            <Button type="button" icon="pi pi-refresh !text-sm lg:!text-[14px]" label=""
              v-tooltip.bottom="$t('pets.header.refresh')" class="!text-sm lg:!text-[14px] ml-2" @click="refreshData" />
            <Button type="button"
              :icon="showDeceased ? `pi pi-eye-slash !text-sm lg:!text-[14px]` : `pi pi-eye !text-sm lg:!text-[14px]`"
              label="" v-tooltip.bottom="showDeceased
                ? $t('pets.header.hide_deceased')
                : $t('pets.header.show_deceased')
                " class="!text-sm lg:!text-[14px] ml-2" @click="toggleDeceasedVisibility" />
            <Button icon="pi pi-plus" @click="showModal" v-tooltip.bottom="$t('pets.header.add_new')"
              class="p-button p-component p-button-icon-only !text-sm lg:!text-[14px] ml-2" />
            <Button icon="pi pi-download !text-sm lg:!text-[14px]" class="!text-sm lg:!text-[14px] ml-2"
              v-tooltip.bottom="$t('pets.header.export')" @click="exportCSV($event)" />
          </div>
          <h2 class="text-lg !mb-0 pb-0 flex items-center">
            <i class="fa-solid fa-paw ltr:mr-2 rtl:ml-2"></i> {{ $t("pets.title") }}
          </h2>
          <span class="p-input-icon-left lg:!text-[14px] text-sm ">
            <InputGroup class="!text-gray-800 flex rounded-md overflow-hidden border !border-gray-400">
              <InputGroupAddon class="!text-gray-800 px-4 flex flex-col item-center justify-center">
                <i class="pi pi-search"></i>
              </InputGroupAddon>
              <InputText size="small" v-model="searchQuery" @input="onSearchChange" @keyup.enter="handleBarcodeEnter"
                @keydown.enter.prevent="handleBarcodeEnter" ref="inputRef" @focus="inputFocused = true"
                @blur="inputFocused = false" autofocus="true" type="text"
                class="!text-sm lg:!text-[14px] !text-gray-800 focus:!ring-0 focus:!ring-offset-0 focus:!border-gray-400 border-transparent"
                :placeholder="$t('pets.header.search_placeholder')" />
              <Button icon="pi pi-times" @click="clearFilters" />
            </InputGroup>
          </span>
        </div>
      </template>

      <Column class="text-md !font-thin" field="owner" :header="$t('pets.columns.owner')">
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="40%" height="1rem" />
          </template>
          <template v-else>
            <router-link :to="slotProps.data.owner.id + `/pets`" v-tooltip.top="{
              value: $t('pets.columns.view_details'),
              pt: {
                arrow: {
                  style: {
                    borderTopColor: 'var(--p-primary-color)',
                  },
                },
                text:
                  '!bg-[var(--p-primary-color)] !text-primary-contrast !font-thin !text-xs',
              },
            }">
              {{ slotProps.data.owner.name }}
              <i class="pi pi-external-link !text-[0.6rem] text-gray-500"></i>
            </router-link>
          </template>
        </template>
      </Column>
      <Column class="text-md" field="name" :header="$t('pets.columns.name')" sortable="">
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="40%" height="1rem" />
          </template>
          <template v-else>{{ slotProps.data.name }}</template>
        </template>
      </Column>

      <Column class="text-md" field="species" :header="$t('pets.columns.species')" sortable>
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="20%" height="1rem" />
          </template>
          <template v-else>
            <Chip class="shadow-sm !text-sm lg:!text-[14px] font-thin border dark:border-transparent h-7"
              :label="getSpeciesValue(slotProps.data.species)" :icon="getIconClass(slotProps.data.species)" />
          </template>
        </template>
      </Column>

      <Column v-if="!isMobile" class="text-md" field="breed" :header="$t('pets.columns.breed')">
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="40%" height="1rem" />
          </template>
          <template v-else>
            <Chip :label="slotProps.data.breed"
              class="shadow-sm !text-sm lg:!text-[14px] font-thin border dark:border-transparent h-7" />
          </template>
        </template>
      </Column>

      <Column v-if="!isMobile" class="text-md" field="gender">
        <template #header>
          <i class="fa-solid fa-venus-mars" v-tooltip.top="$t('pets.columns.gender')"></i>
        </template>
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="20%" height="1rem" />
          </template>
          <template v-else>
            <Chip :label="$t(`pets.status.${slotProps.data.gender.toLowerCase()}`)"
              :class="slotProps.data.gender === 'Male' ? `!bg-blue-400` : `!bg-pink-400`"
              class="shadow-sm !text-sm lg:!text-[14px] font-thin border dark:border-transparent h-7 !text-white" />
          </template>
        </template>
      </Column>

      <Column v-if="!isMobile" class="text-md" field="neutered">
        <template #header>
          <i class="fa-solid fa-neuter" v-tooltip.top="$t('pets.columns.neutered')"></i>
        </template>
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="20%" height="1rem" />
          </template>
          <template v-else>
            <Chip v-if="slotProps.data.neutered === 'Y'" :label="slotProps.data.gender === 'Male'
              ? $t('pets.status.neutered')
              : $t('pets.status.spayed')
              " class="shadow-sm !text-sm lg:!text-[14px] font-thin border dark:border-transparent h-7" />
          </template>
        </template>
      </Column>

      <Column v-if="!isMobile" class="text-md" field="deceased">
        <template #header> {{ $t("pets.columns.active") }} </template>
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="20%" height="1rem" />
          </template>
          <template v-else>
            <Chip :label="slotProps.data.deceased === 'Y'
              ? $t('pets.status.deceased')
              : $t('pets.status.alive')
              " class="shadow-sm !text-sm lg:!text-[14px] font-thin border dark:border-transparent h-7" />
          </template>
        </template>
      </Column>

      <Column class="text-md !font-thin" field="date_of_birth" :header="$t('pets.columns.age')">
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="60%" height="1rem" />
          </template>
          <template v-else>
            {{ computeAge(slotProps.data.date_of_birth) }}
          </template>
        </template>
      </Column>

      <Column class="text-md !font-thin" field="date_of_birth" :header="$t('pets.columns.actions')">
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="60%" height="1rem" />
          </template>
          <template v-else>
            <router-link class="!text-sm lg:!text-[14px] ml-2 p-button button-transition"
              v-tooltip.bottom="$t('pets.columns.view_details')" :to="`/pets/` + slotProps.data.microchip_num">
              <i class="fa-solid fa-paw"></i>
            </router-link>
          </template>
        </template>
      </Column>
      <template #footer>
        <Paginator :rows="itemsPerPage" :first="1" :totalRecords="totalRecords" :currentPage="currentPage"
          :rowsPerPageOptions="[25, 50, 100]" @page="onPageChange" class="!rounded-b-xl text-xs"></Paginator>
      </template>
    </DataTable>
  </div>
  <Dialog :header="$t('pets.modals.add_patient.title')" v-model:visible="isModalVisible" @hide="isModalVisible = false"
    :modal="true" :closable="true" class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)]">
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <Avatar icon="fas fa-users" shape="circle" />
        <span class="font-bold whitespace-nowrap">{{
          $t("pets.modals.add_patient.new_patient")
        }}</span>
      </div>
    </template>

    <NewPatient @submitted="handleSubmit" @showOwnerModal="showOwnerModal" v-focustrap="{
      disabled: false,
      autoFocus: true,
    }" />

    <template #footer> </template>
  </Dialog>
  <Dialog :header="$t('pets.modals.add_owner.title')" :visible="isModalOwnerVisible" @hide="isModalOwnerVisible = false"
    modal :closable="true" class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)]">
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <Avatar icon="fas fa-users" shape="circle" />
        <span class="font-bold whitespace-nowrap">{{
          $t("pets.modals.add_owner.new_client")
        }}</span>
      </div>
    </template>
    <NewClientForm @ownerAdded="handleOwnerSubmit" v-focustrap="{
      disabled: false,
      autoFocus: true,
    }" />
    <template #footer> </template>
  </Dialog>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from "vue";
import DataTable from "primevue/datatable";
import Column from "primevue/column";
import Skeleton from "primevue/skeleton";
import InputText from "primevue/inputtext";
import InputGroupAddon from "primevue/inputgroupaddon";
import InputGroup from "primevue/inputgroup";
import Button from "primevue/button";
import axiosInstance from "@/axios";
import Chip from "primevue/chip";
import Paginator from "primevue/paginator";
import Dialog from "primevue/dialog";
import NewPatient from "@/views/AddNewPet.vue";
import Avatar from "primevue/avatar";
import NewClientForm from "@/views/AddNewOwner.vue";
import { useI18n } from "vue-i18n";
import eventBus from "@/eventBus";
import { useDevice } from "@/composables/useDevice";

const { isMobile, mobileMenuVisible } = useDevice();
const { t } = useI18n();
// BARCODE READER WORK
const inputFocused = ref(false);
const inputRef = ref(null); // Reference to the input element
let typingTimer = null;
const typingDelay = 500; // Adjust based on the speed of your scanner
const isModalVisible = ref(false);
const isModalOwnerVisible = ref(false);
const showOwnerModal = () => {
  // console.log("SHOWING NEW OWNER MODAL");
  isModalOwnerVisible.value = true; // Ensure this route is defined in your router configurations
};
const showModal = () => {
  isModalVisible.value = true;
};
const handleKeydown = (event) => {
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
const handleBarcodeEnter = async () => {
  /*   if (!itemSearch.value) return;
  
    if (/^\d{6,}$/.test(itemSearch.value)) {
      try {
        const response = await axiosInstance.get("/inventory-items/by-barcode", {
          params: { barcode: itemSearch.value },
        });

        if (response.data.data) {
          selectItem({ value: response.data.data });
        }
      } catch (error) {
        console.error("Error searching by barcode:", error);
      }
    } */
  return
};
const handleSubmit = () => {
  isModalVisible.value = false;
  currentPage.value = 1; // Reset to the first page when searching
  fetchPets(currentPage.value); // Fetch pets with the updated search query
};
const handleOwnerSubmit = () => {
  isModalOwnerVisible.value = false;
};
// END BARCODE
const pets = ref([]);
const loading = ref(true);
const genders = ref(["Male", "Female"]);
const status = ref([
  { label: "Deceased", value: "Y" },
  { label: "Alive", value: "N" },
]);
const showDeceased = ref(true);
const selectedPets = ref();
const metaKey = ref(true);
const currentPage = ref(1); // Track the current page
const totalRecords = ref(0); // Total number of records
const itemsPerPage = ref(25); // Number of items per page (matching your API response)const layout = ref("grid");
const dt = ref();
const searchQuery = ref(""); // New reactive search query

const clearFilters = () => {
  currentPage.value = 1;
  searchQuery.value = "";
  fetchPets(currentPage.value);
};

const onSearchChange = () => {
  if (searchQuery.value.length < 3) {
    return; // Prevent search for less than 3 characters
  }
  currentPage.value = 1; // Reset to the first page when searching
  fetchPets(currentPage.value); // Fetch pets with the updated search query
};
const filters = ref({
  global: { value: null, matchMode: "contains" },
  name: { value: null, matchMode: "startsWith" },
  species: { value: null, matchMode: "startsWith" },
  breed: { value: null, matchMode: "startsWith" },
  gender: { value: null, matchMode: "equals" },
  owner: { value: null, matchMode: "contains" },
  deceased: { value: null, matchMode: "equals" },
});
const onPageChange = (event) => {
  itemsPerPage.value = event.rows;
  currentPage.value = event.page + 1; // PrimeVue Paginator uses zero-based index
  fetchPets(currentPage.value); // Fetch pets for the new page
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
  const found = species.value.find((spec) => spec.en_label === speciesLabel);
  return found ? found.icon : "fa-solid fa-paw";
}
const getSpeciesValue = (label) => {
  // console.log(label);
  const found = species.value.find((species) => species.en_label === label);
  return found ? found.label : null;
};
// Function to compute the age of the pet in years and months
const computeAge = (dateOfBirth) => {
  const birthDate = new Date(dateOfBirth);
  const currentDate = new Date();
  const currentYear = currentDate.getFullYear();
  const currentMonth = currentDate.getMonth();
  const birthYear = birthDate.getFullYear();
  const birthMonth = birthDate.getMonth();
  let ageInYears = currentYear - birthYear;
  let ageInMonths = currentMonth - birthMonth;
  if (ageInMonths < 0) {
    ageInYears--;
    ageInMonths += 12; // Adding 12 because it's a full year back
  }
  const yearsText = ageInYears > 0 ? `${ageInYears} ${ageInYears > 1 ? "Y" : "Y"}` : "";
  const monthsText =
    ageInMonths > 0 ? `${ageInMonths} ${ageInMonths > 1 ? "M" : "M"}` : "";
  return `${yearsText}${yearsText && monthsText ? " & " : ""}${monthsText}`;
};

const beforeExportFunction = (data, field) => {
  if (data.field === "owner") {
    return data.data.name;
  } else {
    return data.data;
  }
};
const exportCSV = (event) => {
  dt.value.exportCSV({
    selectionOnly: false,
  });
};
// Function to fetch pets data from the API
const fetchPets = async (page = 1, hideDeceased = false) => {
  try {
    loading.value = true;
    let url = `/pets?page=${page}&per_page=${itemsPerPage.value}&search=${searchQuery.value}`;
    if (hideDeceased) {
      url += `&hideDeceased=true`;
    }
    // console.log(url)
    const response = await axiosInstance.get(
      url
    );
    pets.value = response.data.data;
    // console.log(pets.value);
    totalRecords.value = response.data.total;
    currentPage.value = response.data.current_page;
    loading.value = false;
  } catch (error) {
    // showSuccess("warn", "Warning", "Couldent Fetch Data");
  } finally {
  }
};
const toggleDeceasedVisibility = () => {
  // console.log(showDeceased.value);
  showDeceased.value = !showDeceased.value;
  // console.log(showDeceased.value);
  if (showDeceased.value) {
    // filters.value.deceased.value = "Y";
    // console.log("showing deseaced");
    currentPage.value = 1;
    fetchPets(currentPage.value, true);
  } else {
    // console.log("OH OH")
    filters.value.deceased.value = "N"; // Hide deceased
    fetchPets(currentPage.value, false);
  }
};
onMounted(() => {
  fetchPets();
  window.addEventListener("keydown", handleKeydown);
  eventBus.on("AddPet", () => {
    // console.log("OPEN ADD OWNER");
    isModalVisible.value = true;
  });
});
onBeforeUnmount(() => {
  window.removeEventListener("keydown", handleKeydown);
});
const ownerSortFunction = (event) => {
  const { data, order } = event;
  data.sort((a, b) => {
    const ownerA = a.owner?.name.toLowerCase() || "";
    const ownerB = b.owner?.name.toLowerCase() || "";
    return order * ownerA.localeCompare(ownerB);
  });
};

const skeletonRows = Array.from({ length: 10 }).map((_, index) => ({
  owner: "",
  id: `skeleton-${index}`,
  name: "",
  species: "",
  breed: "",
  gender: "",
  date_of_birth: "",
}));
const generateSkeletonItems = (count, fields) => {
  const randomValues = {
    name: () => `Pet ${Math.ceil(Math.random() * 100)}`,
    species: () => ["Dog", "Cat", "Bird", "Rabbit"][Math.floor(Math.random() * 4)],
    status: () => ["Active", "Inactive", "Pending"][Math.floor(Math.random() * 3)],
    // Add more field generators as needed
  };

  return Array.from({ length: count }).map((_, index) => {
    const item = {
      id: `skeleton-${index}-${Date.now()}`,
      __isSkeleton: true,
    };

    fields.forEach((field) => {
      item[field] = randomValues[field] ? randomValues[field]() : "";
    });

    return item;
  });
};
// const skeletonRows = generateSkeletonItems(10, [
//   "name",
//   "species",
//   "breed",
//   "age",
//   "owner_name",
//   "status",
//   "last_visit",
// ]);

const refreshData = () => {
  loading.value = true; // Set loading state to true to show skeletons
  fetchPets(); // Fetch the pets data again
};
function onSelectionChange(event) {
  // console.log("Selected Products:", JSON.stringify(selectedPets.value));
}
</script>

<style>
h2 {
  margin-bottom: 1rem;
}
.dark\::-webkit-scrollbar {
  width: 10px;
}
.dark\::-webkit-scrollbar-track {
  --tw-bg-opacity: 1;
  background-color: rgb(55 65 81 / var(--tw-bg-opacity));
}
</style>
