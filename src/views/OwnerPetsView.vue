<template>
  <div class="w-full">
    <DataTable
      ref="dt"
      v-model:filters="filters"
      :value="loading ? skeletonRows : pets"
      :row-hover="true"
      :loading="loading"
      paginator
      :rows="50"
      :metaKeySelection="metaKey"
      sortMode="multiple"
      exportFilename="Patients_Details"
      removableSort
      :rowsPerPageOptions="[5, 10, 20, 50]"
      stripedRows
      v-model:selection="selectedPets"
      highlightOnSelect
      dataKey="id"
      @rowSelect="onSelectionChange"
      :exportFunction="beforeExportFunction"
      scrollable
      scrollHeight="600px"
      responsiveLayout="scroll"
      :globalFilterFields="['name', 'species', 'breed', 'gender']"
      filterDisplay="menu"
      class="rounded-xl overflow-hidden drop-shadow-md mt-4"
    >
      <template #header>
        <div class="flex justify-between">
          <div class="flex">
            <Button
              type="button"
              icon="pi pi-filter-slash !text-sm"
              label=""
              outlined
              v-tooltip.bottom="`Clear Filters`"
              class="!text-sm"
              @click="clearFilter()"
            />
            <Button
              type="button"
              icon="pi pi-refresh !text-sm"
              label=""
              outlined
              v-tooltip.bottom="`Refresh Data`"
              class="!text-sm ml-2"
              @click="refreshData"
            />
            <Button
              type="button"
              :icon="showDeceased ? `pi pi-eye-slash !text-sm` : `pi pi-eye !text-sm`"
              label=""
              outlined
              v-tooltip.bottom="showDeceased ? `Hide Deceased` : `Show Deceased`"
              class="!text-sm ml-2"
              @click="toggleDeceasedVisibility"
            />
            <Button
              type="button"
              icon="pi pi-plus !text-sm"
              label="New Patient"
              outlined
              v-tooltip.bottom="`Add New Patient`"
              class="!text-sm ml-2"
              @click="router.push(`/new-pet`)"
            />

            <Button
              icon="pi pi-download !text-sm"
              label="Export"
              outlined
              class="!text-sm ml-2"
              v-tooltip.bottom="`Export`"
              @click="exportCSV($event)"
            />
          </div>
          <h2 class="text-2xl !mb-0 pb-0 flex">
            <i class="fa-solid fa-paw ltr:mr-2 rtl:ml-2"></i> Patients
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
                v-model="filters['global'].value"
                type="text"
                class="!text-sm !text-gray-800 focus:!ring-0 focus:!ring-offset-0 focus:!border-gray-400 border-transparent"
                placeholder="Search All Columns"
              />
            </InputGroup>
          </span>
        </div>
      </template>
      <Column
        selectionMode="multiple"
        class="p-datatable"
        headerStyle="width: 3rem"
      ></Column>
      <Column class="text-md" field="owner" header="Owner">
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="40%" height="1rem" />
          </template>
          <template v-else>
            <!-- Display the owner's name followed by the pet's name -->
            {{ slotProps.data.owner.name }}
          </template>
        </template>
        <template #filter="{ filterModel }">
          <InputText
            v-model="filterModel.value"
            type="text"
            placeholder="Search by owner"
            @input="filterChanged"
          />
        </template>
      </Column>
      <!-- Name Column with filtering -->
      <Column class="text-md" field="name" header="Name" sortable="">
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="40%" height="1rem" />
          </template>
          <template v-else>{{ slotProps.data.name }}</template>
        </template>
        <template #filter="{ filterModel }">
          <InputText
            v-model="filterModel.value"
            type="text"
            placeholder="Search by Name"
          />
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
              class="border shadow-sm"
              :label="getSpeciesValue(slotProps.data.species)"
              :icon="getIconClass(slotProps.data.species)"
            />
          </template>
        </template>
        <template #filter="{ filterModel }">
          <InputText
            v-model="filterModel.value"
            type="text"
            placeholder="Search by species"
          />
        </template>
      </Column>

      <!-- Breed Column with filtering -->
      <Column class="text-md" field="breed" header="Breed">
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="40%" height="1rem" />
          </template>
          <template v-else
            ><Chip outlined :label="slotProps.data.breed" class="border shadow-sm"
          /></template>
        </template>
        <template #filter="{ filterModel }">
          <InputText
            v-model="filterModel.value"
            type="text"
            placeholder="Search by breed"
          />
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
            <div
              v-if="slotProps.data.gender === 'Male'"
              class="bg-blue-600 text-white w-6 rounded-lg text-center"
            >
              <i class="fa-solid fa-mars" v-tooltip.top="slotProps.data.gender"></i>
            </div>
            <div v-else class="bg-pink-600 text-white w-6 rounded-lg text-center">
              <i class="fa-solid fa-venus" v-tooltip.top="slotProps.data.gender"></i>
            </div>
          </template>
        </template>
        <template #filter="{ filterModel }">
          <Select
            v-model="filterModel.value"
            :options="genders"
            placeholder="Select Gender"
            showClear
          />
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
            <div
              v-if="slotProps.data.gender === 'Male' && slotProps.data.neutered === 'N'"
              class="bg-blue-600 text-white w-6 rounded-lg text-center"
            >
              <i class="fa-solid fa-mars" v-tooltip.top="slotProps.data.gender"></i>
            </div>
            <div
              v-else-if="
                slotProps.data.gender === 'Male' && slotProps.data.neutered === 'Y'
              "
              class="bg-gray-600 text-white w-6 rounded-lg text-center"
            >
              <i class="fa-solid fa-neuter" v-tooltip.top="`Neutered`"></i>
            </div>
            <div
              v-else-if="
                slotProps.data.gender === 'Female' && slotProps.data.neutered === 'N'
              "
              class="bg-pink-600 text-white w-6 rounded-lg text-center"
            >
              <i class="fa-solid fa-venus" v-tooltip.top="slotProps.data.gender"></i>
            </div>
            <div v-else class="bg-gray-600 text-white w-6 rounded-lg text-center">
              <i class="fa-solid fa-neuter" v-tooltip.top="`Spayed`"></i>
            </div>
          </template>
        </template>
        <template #filter="{ filterModel }">
          <Select
            v-model="filterModel.value"
            :options="genders"
            placeholder="Select Gender"
            showClear
          />
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
            <div
              v-if="slotProps.data.deceased === 'Y'"
              class="bg-red-600 text-white w-6 rounded-lg text-center"
            >
              <i class="fa-solid fa-face-sad-tear" v-tooltip.top="`Deceased`"></i>
            </div>
            <div v-else class="bg-green-600 text-white w-6 rounded-lg text-center">
              <i class="fa-solid fa-heart fa-beat" v-tooltip.top="`Alive`"></i>
            </div>
          </template>
        </template>
        <template #filter="{ filterModel }">
          <Select
            v-model="filterModel.value"
            :options="status"
            optionLabel="label"
            optionValue="value"
            placeholder="Select Status"
            showClear
          />
        </template>
      </Column>

      <!-- Age Column -->
      <Column class="text-md" field="date_of_birth" header="Age">
        <template #body="slotProps">
          <template v-if="loading">
            <Skeleton width="60%" height="1rem" />
          </template>
          <template v-else>
            {{ computeAge(slotProps.data.date_of_birth) }}
          </template>
        </template>
      </Column>
    </DataTable>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import DataTable from "primevue/datatable";
import Column from "primevue/column";
import Skeleton from "primevue/skeleton";
import InputText from "primevue/inputtext";
import InputGroupAddon from "primevue/inputgroupaddon";
import InputGroup from "primevue/inputgroup";
import Button from "primevue/button";
import Select from "primevue/select";
import axiosInstance from "@/axios"; // Assuming you've created a global axios instance
import eventBus from "@/eventBus";
import router from "@/router";
import Chip from "primevue/chip";
import { useRoute } from "vue-router";
const route = useRoute();

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
const dt = ref();
// Initialize filters object immediately
const filters = ref({
  global: { value: null, matchMode: "contains" },
  name: { value: null, matchMode: "startsWith" },
  species: { value: null, matchMode: "startsWith" },
  breed: { value: null, matchMode: "startsWith" },
  gender: { value: null, matchMode: "equals" },
  owner: { value: null, matchMode: "contains" },
  deceased: { value: null, matchMode: "startsWith" },
});
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
const ownerid = route.params.ownerid;
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

  // Adjust for case where the current month is less than the birth month
  if (ageInMonths < 0) {
    ageInYears--;
    ageInMonths += 12; // Adding 12 because it's a full year back
  }

  // Construct the age string
  const yearsText =
    ageInYears > 0 ? `${ageInYears} ${ageInYears > 1 ? "years" : "year"}` : "";
  const monthsText =
    ageInMonths > 0 ? `${ageInMonths} ${ageInMonths > 1 ? "months" : "month"}` : "";

  // Combine them into a single string, handling cases where there are no months or no years
  return `${yearsText}${yearsText && monthsText ? " and " : ""}${monthsText}`;
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
    selectionOnly: true,
  });
};
// Function to fetch pets data from the API
const fetchPets = async () => {
  //
  try {
    // Make the request using the axios instance with interceptors
    const response = await axiosInstance.get(`/owners/${ownerid}/pets`);

    loading.value = false; // Stop loading once data is fetched
    eventBus.emit("show-toast", {
      severity: "success",
      summary: "Data Loaded",
      detail: "Data list updated successfuly",
      life: 5000,
    });
    pets.value = response.data;
  } catch (error) {
    // showSuccess("warn", "Warning", "Couldent Fetch Data");
  } finally {
  }
};
const toggleDeceasedVisibility = () => {
  showDeceased.value = !showDeceased.value;
  if (showDeceased.value) {
    filters.value.deceased.value = null; // Show all
  } else {
    filters.value.deceased.value = "N"; // Hide deceased
  }
};
// Fetch data when the component is mounted
onMounted(() => {
  fetchPets();
});

// Clear the filters
const clearFilter = () => {
  filters.value = {
    global: { value: null, matchMode: "contains" },
    name: { value: null, matchMode: "startsWith" },
    species: { value: null, matchMode: "startsWith" },
    breed: { value: null, matchMode: "startsWith" },
    gender: { value: null, matchMode: "equals" },
    deceased: { value: null, matchMode: "equals" },
  };
};

// Custom sorting function for owner.name
const ownerSortFunction = (event) => {
  const { data, order } = event;
  data.sort((a, b) => {
    const ownerA = a.owner?.name.toLowerCase() || "";
    const ownerB = b.owner?.name.toLowerCase() || "";
    return order * ownerA.localeCompare(ownerB);
  });
};

// Add a temporary skeleton data
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
function onSelectionChange(event) {}
</script>

<style scoped>
h2 {
  margin-bottom: 1rem;
}
</style>
