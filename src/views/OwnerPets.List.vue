<template>
  <DataView :value="pets" :layout="layout"
    class="!rounded-t-xl !rounded-b-xl  !overflow-y-auto h-[calc(100vh-70px)] mt-4 mb-2">
    <template #header>
      <div class="flex justify-between items-center">
        <div class="flex justify-between items-center gap-2">
          <SelectButton v-model="layout" :options="options" :allowEmpty="false">
            <template #option="{ option }">
              <i :class="[option === 'list' ? 'pi pi-bars' : 'pi pi-table']" />
            </template>
          </SelectButton>
          <Button type="button" icon="pi pi-refresh !text-sm" label="" v-tooltip.top="{
  value: $t('owner_pet_list.tooltips.refresh'),
  pt: {
    arrow: {
      style: {
        borderTopColor: 'var(--p-primary-color)',
      },
    },
    text:
      '!bg-[var(--p-primary-color)] !text-primary-contrast !font-thin !text-xs',
  },
}" rounded size="small" class="!text-xs !text-primary mx-2" @click="refreshData" />
          <Button v-tooltip.top="{
            value: $t('owner_pet_list.buttons.new_patient'),
            pt: {
              arrow: {
                style: {
                  borderTopColor: 'var(--p-primary-color)',
                },
              },
              text:
                '!bg-[var(--p-primary-color)] !font-thin 2xl:!text-lg lg:!text-xs shadow-md',
            },
          }" icon="pi pi-plus" @click="showNewPatientModal"
            class="p-button p-button-icon-only !text-sm !font-thin h-8" />
        </div>
        <Breadcrumb :model="items">
          <template #item="{ item, props }">
            <router-link v-if="item.route" v-slot="{ href, navigate }" :to="item.route" custom>
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
        <InputGroup class="!text-gray-800 flex rounded-md overflow-hidden border !border-gray-400 h-8 !w-1/5">
          <InputGroupAddon class="!text-gray-800 px-4 flex flex-col item-center justify-center">
            <i class="pi pi-search"></i>
          </InputGroupAddon>
          <InputText v-model="searchQuery" @input="onSearchChange" @focus="inputFocused = true"
            @blur="inputFocused = false" type="text"
            class="lg:!text-[14px] !text-sm !text-gray-800 focus:!ring-0 focus:!ring-offset-0 focus:!border-gray-400 border-transparent"
            :placeholder="$t('owner_pet_list.search_placeholder')" />
          <Button icon="pi pi-spin pi-spinner-dotted" v-if="loading" @click="clearFilters" />
          <Button icon="pi pi-times" v-else @click="clearFilters" />
        </InputGroup>
      </div>
    </template>
    <template #list v-if="loading">
      <div class="flex flex-col py-4">
        <div v-for="i in 2" :key="i">
          <div class="flex flex-col xl:flex-row xl:items-start p-6 gap-6"
            :class="{ 'border-t border-surface-200 dark:border-surface-700': i !== 0 }">
            <div class="flex flex-col sm:flex-row justify-between items-center xl:items-start flex-1 gap-6">
              <div class="flex flex-col items-center sm:items-start gap-4">
                <Skeleton width="8rem" height="1.5rem" />
                <Skeleton width="6rem" height="1rem" />
                <div class="flex items-center gap-4">
                  <Skeleton width="6rem" height="1rem" />
                  <Skeleton width="3rem" height="1rem" />
                </div>
              </div>
              <div class="flex sm:flex-col items-center sm:items-end gap-4 sm:gap-2">
                <Skeleton width="4rem" height="1.5rem" />
                <Skeleton size="3rem" shape="circle" />
              </div>
            </div>
          </div>
        </div>
      </div>
    </template>
    <template #list="slotProps" v-else>
      <div class="flex flex-col py-4">
        <div v-for="(pet, index) in slotProps.items" :key="index">
          <div class="flex flex-col sm:flex-row sm:items-center p-2 gap-4" :class="{
            'border-t border-surface-200 dark:border-surface-700': index !== 0,
          }">
            <div class="flex flex-col md:flex-row md:items-start flex-1 gap-6">
              <div class="w-fit px-2">
                <div :class="(pet.gender === `Male` ? `bg-blue-600` : 'bg-pink-600') +
                  ` mx-auto w-fit rounded-xl border p-2 dark:bg-surface-500 text-surface-200 text-white`
                  ">
                  <i :class="getIconClass(pet.species) + ` text-xl text-center`"></i>
                </div>
              </div>
              <div class="w-1/6 px-2 flex flex-col md:items-start">
                <div class="text-lg font-medium">{{ pet.name }}</div>
                <div class="lg:text-[14px] text-sm ">{{ $t('owner_pet_list.fields.species') }}: {{
                  getSpeciesValue(pet.species) }}</div>
              </div>
              <div class="w-1/4 flex flex-col md:items-start">
                <span class="lg:text-[14px] text-sm "> {{ $t('owner_pet_list.fields.breed') }}: {{ pet.breed }}</span>
                <span class="lg:text-[14px] text-sm ">{{ $t('owner_pet_list.fields.gender') }}:
                  {{ $t(`pets.status.${pet.gender.toLowerCase()}`) }}</span>
              </div>
              <div class="w-1/4 flex flex-col md:items-start">
                <span class="lg:text-[14px] text-sm "> {{ $t('owner_pet_list.fields.microchip') }}: {{ pet.microchip_num
                }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </template>
    <template #grid v-if="loading">
      <div class="grid grid-cols-12 gap-2 py-4">
        <div v-for="i in 4" :key="i" class="col-span-12 sm:col-span-6 md:col-span-4 xl:col-span-3 p-2">
          <div
            class="p-6 border border-surface-200 dark:border-surface-700 bg-zinc-100 dark:bg-[var(--p-surface-700)] rounded-lg flex flex-col">
            <div class="text-lg font-medium border-b pb-2">
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
      <div class="grid xl:grid-cols-12 grid-cols-10 p-4">
        <div v-for="(pet, index) in slotProps.items" :key="index"
          class="col-span-12 sm:col-span-6 md:col-span-2.5 lg:col-span-2 xl:col-span-3 p-2">
          <div
            class="p-6 border border-surface-200 dark:border-surface-700 bg-zinc-100 dark:bg-[var(--p-surface-500)] rounded-lg flex flex-col shadow"
            :class="pet.gender === `Male` ? `!border-blue-600` : '!border-pink-600'">
            <div class="">
              <div class="lg:text-xs text-lg font-medium border-b flex items-center gap-2 pb-2">
                <a v-if="pet.gender === 'Male'"
                  class="bg-blue-600 text-white w-8 text-sm rounded-lg text-center flex flex-col justify-center ltr:!mr-2 rtl:!ml-2">
                  <i :class="getIconClass(pet.species) + ` text-sm text-center`"></i>
                </a>
                <a v-else
                  class="bg-pink-600 text-white w-8 text-sm rounded-lg text-center flex flex-col justify-center ltr:!mr-2 rtl:!ml-2">
                  <i :class="getIconClass(pet.species) + ` text-sm text-center`"></i>
                </a>
                {{ pet.name }}
              </div>
              <div class="mt-4 text-sm">
                <div class="lg:text-[14px] text-sm ">{{ $t('owner_pet_list.fields.species') }}:
                  {{ getSpeciesValue(pet.species) }}</div>
                <div class="lg:text-[14px] text-sm ">
                  {{ $t('owner_pet_list.fields.breed') }}:
                  {{ pet.breed }}
                </div>
              </div>
              <div class="flex flex-col gap-6 mt-6">
                <div class="flex gap-2">
                  <RouterLink
                    class="p-button p-component !text-xs !bg-[var(--p-primary-color)] !text-[var(--p-primary-contrast-color)]"
                    icon="fas fa-paw" :label="$t('owner_pet_list.buttons.details')" outlined v-tooltip.top="{
                      value: $t('owner_pet_list.tooltips.view_details'),
                      pt: {
                        arrow: {
                          style: {
                            borderTopColor: 'var(--p-primary-color)',
                          },
                        },
                        text:
                          '!bg-[var(--p-primary-color)] !text-primary-contrast !font-thin !text-xs',
                      },
                    }" :to="{
                      name: 'PetDetails',
                      params: { petmicrochip: pet.microchip_num },
                    }">
                    <i class="fas fa-paw"></i><span>{{ $t('owner_pet_list.buttons.details') }}</span>
                  </RouterLink>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </template>
    <template #footer>
      <Paginator :rows="itemsPerPage" :first="1" :totalRecords="totalRecords" :currentPage="currentPage"
        :rowsPerPageOptions="[25, 50, 100]" @page="onPageChange" class="text-xs"></Paginator>
    </template>
  </DataView>
  <Dialog :header="$t('owner_pet_list.modal.header')" v-model:visible="isModalVisible" @hide="isModalVisible = false"
    modal :closable="true" class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)]">
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <Avatar icon="fas fa-users" shape="circle" />
        <span class="font-bold whitespace-nowrap">{{ $t('owner_pet_list.modal.header') }}</span>
      </div>
    </template>
    <NewPatient @submitted="handleSubmit" v-focustrap="{
      disabled: false,
      autoFocus: true,
    }" />
    <template #footer> </template>
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
    required: true
  }
});
const pets = ref([
  {
    id: 0,
    owner: {
      name: "s",
      id: 0,
    },
  },
  {
    id: 0,
    owner: {
      name: "",
      id: 0,
    },
  },
]);
const isModalVisible = ref(false);
const currentPage = ref(1); // Track the current page
const totalRecords = ref(0); // Total number of records
const itemsPerPage = ref(25); // Number of items per page (matching your API response)const layout = ref("grid");
const layout = ref("grid");
const loading = ref(true);
const owner = ref([]); // Initialize owner as an empty string
const options = ref(["list", "grid"]);
// const ownerid = ref(route.params.ownerid);
const searchQuery = ref(""); // Reactive search query
const items = ref([
  { label: t("app.menu.owners"), route: "/owners" },
  {
    label: pets.value[0].owner.name + " Patients",
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
    // Make the request using the axios instance with interceptors
    const response = await axiosInstance.get(
      `/owners/${route.params.ownerid}/pets?page=` +
      page +
      `&per_page=` +
      itemsPerPage.value +
      `&search=${searchQuery.value}`
    );
    pets.value = response.data.data;
    totalRecords.value = response.data.total;
    currentPage.value = response.data.current_page;
    // owner.value = pets.value.length > 0 ? pets.value[0].owner : ["Unknown Owner"]; // Set owner name if pets exist
    items.value = [
      { label: t("app.menu.owners"), route: "/owners" },
      {
        label: pets.value[0].owner.name + " Patients",
        route: "/" + route.params.ownerid + "/pets",
      },
    ];
    // console.log(pets.value);
    loading.value = false; // Stop loading once data is fetched
  } catch (error) {
    //     // showSuccess("warn", "Warning", "Couldent Fetch Data");
  } finally {
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
function getIconClass(speciesLabel) {
  const found = species.value.find((spec) => spec.label === speciesLabel);
  return found ? found.icon : "fa-solid fa-paw";
}
const getSpeciesValue = (label) => {
  // const found = species.value.find((species) => species.label === label);
  // return found ? found.value : null;
  // console.log(label);
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
</style>
