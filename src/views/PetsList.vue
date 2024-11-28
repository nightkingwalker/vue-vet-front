<template>
  <div class="w-full">
    <DataTable
      id="petlist"
      ref="dt"
      :value="loading ? skeletonRows : pets"
      :row-hover="true"
      :loading="loading"
      :metaKeySelection="metaKey"
      sortMode="multiple"
      exportFilename="Patients_Details"
      removableSort
      stripedRows
      v-model:selection="selectedPets"
      highlightOnSelect
      dataKey="id"
      @rowSelect="onSelectionChange"
      :exportFunction="beforeExportFunction"
      responsiveLayout="scroll"
      class="rounded-xl 2xl:overflow-y-scroll drop-shadow-md mt-4 h-[95vh]"
      :size="`small`"
    >
      <template #header>
        <div class="flex justify-between">
          <div class="flex">
            <Button
              type="button"
              icon="pi pi-refresh !text-sm"
              label=""
              v-tooltip.bottom="`Refresh Data`"
              class="!text-sm ml-2"
              @click="refreshData"
            />
            <Button
              type="button"
              :icon="showDeceased ? `pi pi-eye-slash !text-sm` : `pi pi-eye !text-sm`"
              label=""
              v-tooltip.bottom="showDeceased ? `Hide Deceased` : `Show Deceased`"
              class="!text-sm ml-2"
              @click="toggleDeceasedVisibility"
            />
            <Button
              icon="pi pi-plus"
              @click="showModal"
              v-tooltip.bottom="`Add New Patient`"
              class="p-button p-component p-button-icon-only !text-sm ml-2"
            />
            <Button
              icon="pi pi-download !text-sm"
              class="!text-sm ml-2"
              v-tooltip.bottom="`Export`"
              @click="exportCSV($event)"
            />
          </div>
          <h2 class="text-2xl !mb-0 pb-0 flex">
            <i class="fa-solid fa-paw mr-2"></i> Patients
          </h2>
          <span class="p-input-icon-left text-sm">
            <InputGroup
              class="!text-gray-800 flex rounded-md overflow-hidden border !border-gray-400"
            >
              <InputGroupAddon
                class="!text-gray-800 px-4 flex flex-col item-center justify-center"
              >
                <i class="pi pi-search"></i
              ></InputGroupAddon>
              <InputText
                size="small"
                v-model="searchQuery"
                @input="onSearchChange"
                ref="inputRef"
                @focus="inputFocused = true"
                @blur="inputFocused = false"
                autofocus="true"
                type="text"
                class="!text-sm !text-gray-800 focus:!ring-0 focus:!ring-offset-0 focus:!border-gray-400 border-transparent"
                placeholder="Search All Columns"
              />
              <Button icon="pi pi-times" @click="clearFilters" />
            </InputGroup>
          </span>
        </div>
      </template>
      <!-- <Column
        selectionMode="multiple"
        class="p-datatable"
        headerStyle="width: 3rem"
      ></Column> -->
      <Column class="text-md !font-thin" field="owner" header="Owner">
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="40%" height="1rem" />
          </template>
          <template v-else>
            <router-link
              :to="slotProps.data.owner.id + `/pets`"
              v-tooltip.top="{
                value: 'View Patients',
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
            >
              {{ slotProps.data.owner.name }}
              <i class="pi pi-external-link !text-[0.6rem] text-gray-500"></i>
            </router-link>
          </template>
        </template>
      </Column>
      <Column class="text-md" field="name" header="Name" sortable="">
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="40%" height="1rem" />
          </template>
          <template v-else>{{ slotProps.data.name }}</template>
        </template>
      </Column>

      <!-- Species Column with filtering -->
      <Column class="text-md" field="species" header="Species" sortable>
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="20%" height="1rem" />
          </template>
          <template v-else>
            <Chip
              class="shadow-sm !text-sm font-thin border dark:border-transparent h-7"
              :label="getSpeciesValue(slotProps.data.species)"
              :icon="getIconClass(slotProps.data.species)"
            />
          </template>
        </template>
      </Column>

      <!-- Breed Column with filtering -->
      <Column class="text-md" field="breed" header="Breed">
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="40%" height="1rem" />
          </template>
          <template v-else
            ><Chip
              :label="slotProps.data.breed"
              class="shadow-sm !text-sm font-thin border dark:border-transparent h-7"
          /></template>
        </template>
      </Column>

      <!-- Gender Column -->
      <Column class="text-md" field="gender">
        <template #header>
          <i class="fa-solid fa-venus-mars" v-tooltip.top="`Gender`"></i>
        </template>
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="20%" height="1rem" />
          </template>
          <template v-else>
            <Chip
              :label="slotProps.data.gender"
              :class="slotProps.data.gender === 'Male' ? `!bg-blue-400` : `!bg-pink-400`"
              class="shadow-sm !text-sm font-thin border dark:border-transparent h-7 !text-white"
            />
          </template>
        </template>
      </Column>

      <!-- Neuterd Column -->
      <Column class="text-md" field="neutered">
        <template #header>
          <i class="fa-solid fa-neuter" v-tooltip.top="`Neutered/Spayed`"></i>
        </template>
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="20%" height="1rem" />
          </template>
          <template v-else>
            <Chip
              v-if="slotProps.data.neutered === 'Y'"
              :label="slotProps.data.gender === 'Male' ? `Neutered` : `Spayed`"
              class="shadow-sm !text-sm font-thin border dark:border-transparent h-7"
            />
          </template>
        </template>
      </Column>

      <!-- Deceased Column -->

      <Column class="text-md" field="deceased">
        <template #header> Active </template>
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="20%" height="1rem" />
          </template>
          <template v-else>
            <Chip
              :label="slotProps.data.deceased === 'Y' ? `Deceased` : `Alive`"
              class="shadow-sm !text-sm font-thin border dark:border-transparent h-7"
            />
          </template>
        </template>
      </Column>

      <!-- Age Column -->
      <Column class="text-md !font-thin" field="date_of_birth" header="Age">
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="60%" height="1rem" />
          </template>
          <template v-else>
            {{ computeAge(slotProps.data.date_of_birth) }}
          </template>
        </template>
      </Column>

      <!-- ِؤفهخىس Column -->
      <Column class="text-md !font-thin" field="date_of_birth" header="Age">
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="60%" height="1rem" />
          </template>
          <template v-else>
            <!-- <Button
              type="button"
              :icon="showDeceased ? `pi pi-eye-slash !text-sm` : `pi pi-eye !text-sm`"
              label=""
              v-tooltip.bottom="showDeceased ? `Hide Deceased` : `Show Deceased`"
              class="!text-sm ml-2"
              @click="toggleDeceasedVisibility"
            /> -->
            <router-link
              class="!text-sm ml-2 p-button"
              v-tooltip.bottom="`View Details`"
              :to="`/pets/` + slotProps.data.microchip_num"
            >
              <i class="fa-solid fa-paw"></i>
            </router-link>
          </template>
        </template>
      </Column>
      <template #footer>
        <Paginator
          :rows="itemsPerPage"
          :first="1"
          :totalRecords="totalRecords"
          :currentPage="currentPage"
          :rowsPerPageOptions="[25, 50, 100]"
          @page="onPageChange"
          class="!rounded-b-xl text-xs"
        ></Paginator>
      </template>
    </DataTable>
  </div>
  <Dialog
    header="Add New Patient"
    v-model:visible="isModalVisible"
    @hide="isModalVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)]"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <Avatar icon="fas fa-users" shape="circle" />
        <span class="font-bold whitespace-nowrap">New Patient</span>
      </div>
    </template>
    <NewPatient @submitted="handleSubmit" @showOwnerModal="showOwnerModal" />
    <template #footer> </template>
  </Dialog>
  <Dialog
    header="Add New Patient"
    :visible="isModalOwnerVisible"
    @hide="isModalOwnerVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)]"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <Avatar icon="fas fa-users" shape="circle" />
        <span class="font-bold whitespace-nowrap">New Client</span>
      </div>
    </template>
    <NewClientForm @ownerAdded="handleOwnerSubmit" />
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
import axiosInstance from "@/axios"; // Assuming you've created a global axios instance
import Chip from "primevue/chip";
import Paginator from "primevue/paginator";
import Dialog from "primevue/dialog";
import NewPatient from "@/views/AddNewPet.vue"; // Adjust the path as needed
import NewClientForm from "@/views/AddNewOwner.vue";
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
  deceased: { value: null, matchMode: "startsWith" },
});
const onPageChange = (event) => {
  itemsPerPage.value = event.rows;
  currentPage.value = event.page + 1; // PrimeVue Paginator uses zero-based index
  fetchPets(currentPage.value); // Fetch pets for the new page
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
      url += `hideDeceased=true`;
    }
    const response = await axiosInstance.get(
      `/pets?page=${page}&per_page=${itemsPerPage.value}&search=${searchQuery.value}`
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
  showDeceased.value = !showDeceased.value;
  if (showDeceased.value) {
    console.log("showing deseaced");
    currentPage.value = 1;
    fetchPets(currentPage.value, true);
  } else {
    // filters.value.deceased.value = "N"; // Hide deceased
  }
};
onMounted(() => {
  fetchPets();
  window.addEventListener("keydown", handleKeydown);
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

const skeletonRows = Array.from({ length: 10 }).map(() => ({
  owner: "",
  id: "",
  name: "",
  species: "",
  breed: "",
  gender: "",
  date_of_birth: "",
}));
const refreshData = () => {
  loading.value = true; // Set loading state to true to show skeletons
  fetchPets(); // Fetch the pets data again
};
function onSelectionChange(event) {
  // // console.log("Selected Products:", JSON.stringify(selectedPets.value));
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
