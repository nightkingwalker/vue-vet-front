<template>
  <div class="flex gap-2 h-[calc(100vh-60px)] overflow-y-auto my-4 w-full">
    <div
      class="w-1/4 h-fit bg-[var(--p-surface-200)] dark:bg-[var(--p-surface-600)] rounded-lg p-2"
    >
      <Card class="w-full">
        <template #header>
          <!-- <img alt="user header" src="/images/usercard.png" /> -->
          <Button
            @click="router.go(-1)"
            class="p-button p-component p-button-icon-only !w-6 h-6 !text-xs m-2"
            icon="pi pi-arrow-left !text-xs"
            v-tooltip.top="{
              value: 'Go back',
              pt: {
                arrow: {
                  style: {
                    borderTopColor: 'var(--p-primary-color)',
                  },
                },
                text:
                  '!bg-[var(--p-primary-color)] !font-thin 2xl:!text-lg lg:!text-xs shadow-md',
              },
            }"
          />

          <div class="flex justify-center mt-8"><i class="fas fa-paw text-3xl"></i></div>
        </template>
        <template #title>
          <Skeleton v-if="loading" width="12rem" height="2rem" />
          <div v-else>{{ pet.name }}</div></template
        >
        <template #subtitle>
          <Skeleton v-if="loading" width="12rem" height="2rem" />
          <Chip
            v-else
            v-tooltip.top="{
              value: 'Microchip/Serial Number',
              pt: {
                arrow: {
                  style: {
                    borderTopColor: 'var(--p-primary-color)',
                  },
                },
                text:
                  '!bg-[var(--p-primary-color)] !font-thin 2xl:!text-lg lg:!text-xs shadow-md',
              },
            }"
            class="!text-sm border"
          >
            <i class="fas fa-microchip"></i> {{ pet.microchip_num }}
          </Chip>
          <Skeleton v-if="loading" class="mt-2" width="12rem" height="2rem" />
          <Chip v-else class="2xl:text-xs text-sm mt-2 border">
            <i class="fas fa-users"></i> {{ pet.owner.name }}
          </Chip>
        </template>
        <template #content>
          <div v-if="loading">
            <Skeleton width="12rem" height="2rem" />
            <Skeleton class="mt-2" width="9rem" height="2rem" />
            <Skeleton class="mt-2" width="10rem" height="2rem" />
            <Skeleton class="mt-2" width="5rem" height="2rem" />
            <Skeleton class="mt-2" width="5rem" height="2rem" />
          </div>
          <div v-else class="flex flex-wrap gap-1">
            <Chip class="2xl:text-xs text-sm mt-2 border">
              <i :class="getIconClass(pet.species)"></i>
              {{ getSpeciesValue(pet.species) }}
            </Chip>
            <Chip class="2xl:text-xs text-sm mt-2 border">
              {{ pet.breed }}
            </Chip>
            <Chip class="2xl:text-xs text-sm mt-2 border">
              <i
                class="fa-solid fa-venus !text-pink-600"
                v-if="pet.gender === `Female`"
              ></i>
              <i class="fa-solid fa-mars !text-blue-600" v-else></i>
              {{ pet.gender }}
            </Chip>
            <Chip
              class="2xl:text-xs text-sm mt-2 p-button-success p-button-outlined"
              v-if="pet.neutered === 'Y'"
            >
              {{ pet.gender === "Male" ? `Neutered` : `Spayed` }}
            </Chip>
            <Chip
              class="2xl:text-xs text-sm mt-2 p-button-danger p-button-outlined"
              v-else
              >Not {{ pet.gender === "Male" ? `Neutered` : `Spayed` }}</Chip
            >
            <Chip class="2xl:text-xs text-sm mt-2 border">
              <i class="fa-solid fa-cake-candles"></i>
              {{
                pet.deceased === "N" ? computeAge(pet.date_of_birth) : pet.date_of_birth
              }}
            </Chip>
            <Chip
              class="2xl:text-xs text-sm mt-2"
              :class="
                `` + pet.deceased === 'Y'
                  ? `!bg-black !text-white`
                  : `!bg-green-500 !text-white`
              "
            >
              <i v-if="pet.deceased === 'Y'" class="fa-solid fa-heart-crack"></i>
              <i v-else class="fa-solid fa-heart"></i>
              {{ pet.deceased === "Y" ? ` Deceased` : `Alive` }}
              {{
                pet.deceased === "Y" && pet.date_of_morta !== "null"
                  ? ": " + pet.date_of_morta
                  : ""
              }}
            </Chip>
          </div>
        </template>
        <template #footer>
          <div class="flex gap-4 mt-1">
            <!-- <Button label="Cancel" severity="secondary" outlined class="w-full" />
            <Button label="Save" class="w-full" /> -->
          </div>
        </template>
      </Card>
    </div>
    <div
      class="w-3/4 min-h-full bg-[var(--p-surface-300)] dark:bg-[var(--p-surface-500)] rounded-lg"
    >
      <DataTable
        :value="visits"
        class="mx-4 my-4 rounded-lg overflow-hidden text-xs"
        stripedRows
        v-if="!loading"
      >
        <template #header>
          <div class="flex flex-wrap items-center justify-between gap-2">
            <span class="text-xl font-bold">Visits History</span>
          </div>
        </template>
        <Column field="start" header="Date" :class="`!rtl w-1/8 `"></Column>
        <Column field="title" header="Title" class="font-normal !rtl"></Column>

        <Column
          field="description"
          header="Description"
          class="font-normal rtl:!text-right"
        >
        </Column>
        <Column field="type" header="Type">
          <template #body="slotProps">
            <Tag
              class="shadow-md border-gray-500 rtl:border-r-2 rtl:border-r-[var(--border-color)] border-l-2 border-l-[var(--border-color)]"
              :style="{
                '--border-color': getEventTheme(slotProps.data.type).lightColors.main,
                '--background-color': getEventTheme(slotProps.data.type).lightColors
                  .container,
                '--text-color': getEventTheme(slotProps.data.type).lightColors
                  .onContainer,
                background: `var(--background-color)`,
                color: `var(--text-color)`,
              }"
            >
              <div class="gap-2 px-1">
                <span class="!text-xs font-normal">{{ slotProps.data.type }}</span>
              </div>
            </Tag>
          </template>
        </Column>
        <Column header="Data" class="w-fit whitespace-nowrap">
          <template #body="slotProps">
            <Button
              type="button"
              icon="fa-solid fa-syringe"
              v-tooltip.top="{
                value: 'View Treatments',
                pt: {
                  arrow: {
                    style: {
                      borderTopColor: 'var(--p-primary-color)',
                    },
                  },
                  text:
                    '!bg-[var(--p-primary-color)] !text-primary-contrast !font-thin 2xl:!text-lg lg:!text-xs',
                },
              }"
              raised
              class="p-component !text-sm ml-2"
              @click.prevent="listTreatments(slotProps.data.id)"
              v-if="slotProps.data.type !== `Grooming`"
            />
            <Button
              v-if="slotProps.data.type !== `Grooming`"
              type="button"
              icon="fa-solid fa-vials"
              v-tooltip.top="{
                value: 'View Tests',
                pt: {
                  arrow: {
                    style: {
                      borderTopColor: 'var(--p-primary-color)',
                    },
                  },
                  text:
                    '!bg-[var(--p-primary-color)] !text-primary-contrast !font-thin 2xl:!text-lg lg:!text-xs',
                },
              }"
              raised
              class="p-component !text-sm ml-2"
              @click.prevent="listTestResults(slotProps.data.id)"
            />
            <Button
              type="button"
              icon="fa-solid fa-pen-to-square"
              v-tooltip.top="{
                value: 'Edit Details',
                pt: {
                  arrow: {
                    style: {
                      borderTopColor: 'var(--p-primary-color)',
                    },
                  },
                  text:
                    '!bg-[var(--p-primary-color)] !text-primary-contrast !font-thin 2xl:!text-lg lg:!text-xs',
                },
              }"
              raised
              class="p-component !text-sm ml-2"
              v-if="slotProps.data.type !== `Grooming`"
            />
          </template>
        </Column>
        <template #footer>
          In total there are {{ visits ? visits.length : 0 }} records.
        </template>
      </DataTable>
    </div>
  </div>
  <Dialog
    header="Treatments"
    v-model:visible="isTreatmentsListVisible"
    @hide="isTreatmentsListVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">Treatments</span>
      </div>
    </template>
    <PetTreatments :medical_record_id="medical_record_id" />
    <template #footer> </template>
  </Dialog>
  <Dialog
    header="Test Results"
    v-model:visible="isTestResultsVisible"
    @hide="isTestResultsVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">Test Results</span>
      </div>
    </template>
    <TestResults :medical_record_id="medical_record_id" />
    <template #footer> </template>
  </Dialog>
</template>
<script setup>
import { ref, onMounted, onBeforeUnmount } from "vue";
import Card from "primevue/card";
import Chip from "primevue/chip";
import router from "@/router";
import { useRoute } from "vue-router";
import Tag from "primevue/tag";
import Button from "primevue/button";
import eventBus from "@/eventBus";
import axiosInstance from "@/axios"; // Assuming axiosInstance is set up correctly
import DataTable from "primevue/datatable";
import Column from "primevue/column";
import Skeleton from "primevue/skeleton"; // optional
import Dialog from "primevue/dialog";
import PetTreatments from "@/views/TreatmentsList.vue"; // Adjust the path as needed
import TestResults from "@/views/TestResults.vue"; // Adjust the path as needed
const isTreatmentsListVisible = ref(false);
const isTestResultsVisible = ref(false);
const route = useRoute();
const petmicrochip = ref(route.params.petmicrochip);
const pet = ref({
  microchip_num: "",
  name: "",
  species: "",
  breed: "",
  gender: "",
  neutered: "",
  date_of_birth: "",
  deceased: "",
  owner: {
    name: "",
  },
});
// console.log(pet.value);
const owner = ref(""); // Initialize owner as an empty string
const loading = ref(true);
const visits = ref([]);
const medical_records = ref([]);
const medical_record_id = ref("");
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
  const yearsText = ageInYears > 0 ? `${ageInYears} ${ageInYears > 1 ? "Y" : "Y"}` : "";
  const monthsText =
    ageInMonths > 0 ? `${ageInMonths} ${ageInMonths > 1 ? "M" : "M"}` : "";

  // Combine them into a single string, handling cases where there are no months or no years
  return `${yearsText}${yearsText && monthsText ? " & " : ""}${monthsText}`;
};
// // console.log(petmicrochip.value);
const fetchPets = async () => {
  loading.value = true;
  try {
    // Make the request using the axios instance with interceptors
    const response = await axiosInstance.get(`/pets/${petmicrochip.value}`);
    pet.value = response.data;
    visits.value = response.data.appointments;
    medical_records.value = response.data.medical_records;
    // totalRecords.value = response.data.total;
    // currentPage.value = response.data.current_page;
    owner.value = pet.value.length > 0 ? pet.value[0].owner.name : "Unknown Owner"; // Set owner name if pets exist
    // // console.log(medical_records.value);
    loading.value = false; // Stop loading once data is fetched
    // // console.log(findRecordById(4));
  } catch (error) {
    //     // showSuccess("warn", "Warning", "Couldent Fetch Data");
  } finally {
  }
};
function getEventTheme(themeName) {
  // // console.log(themeName);
  return eventTheme[themeName] || null; // Return the corresponding theme or null if not found
}
function listTreatments(MedicalRecordId) {
  medical_record_id.value = findRecordById(MedicalRecordId);
  // console.log("MEDIACAL" + medical_record_id.value);
  isTreatmentsListVisible.value = true;
}
function listTestResults(MedicalRecordId) {
  medical_record_id.value = findRecordById(MedicalRecordId);
  // console.log("MEDIACAL" + medical_record_id.value);
  isTestResultsVisible.value = true;
}
const findRecordById = (id) => {
  return medical_records.value.find((record) => record.visit_date === id).id;
};

onMounted(() => {
  fetchPets();
});
</script>
