<template>
  <DataView :value="owners" :layout="layout" class="!rounded-lg h-[calc(100vh-70px)]">
    <template #header>
      <div
        class="flex flex-col md:flex-row justify-between items-start md:items-center p-4 bg-surface-300 rounded-t-lg border-b border-surface-500 gap-2"
      >
        <h2 class="text-lg md:text-xl font-semibold text-surface-0">
          {{ $t("owners.title") }}
        </h2>

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
              type="text"
              class="bg-surface-400 border-surface-500 text-surface-100 placeholder-surface-500 text-sm md:text-base"
              :placeholder="$t('owners.search_placeholder')"
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
              v-tooltip.top="$t('owners.actions.refresh')"
            />
            <Button
              icon="pi pi-plus"
              @click="showModal"
              class="p-button-primary bg-emerald-600 hover:bg-emerald-500 border-emerald-600 text-sm md:text-base"
              v-tooltip.top="$t('owners.actions.new_owner')"
            />
          </div>
        </div>
      </div>
    </template>

    <!-- Grid View -->
    <template #grid="slotProps">
      <ScrollPanel style="height: calc(70vh)" class="!overflow-y-auto">
        <div
          class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-3 p-3"
        >
          <div
            v-for="(owner, index) in slotProps.items"
            :key="index"
            class="p-3 border border-surface-500 bg-surface-300 rounded-lg hover:bg-surface-400 transition-all"
          >
            <div class="flex flex-col gap-2">
              <!-- Owner Info -->
              <div class="flex flex-col gap-1">
                <div
                  class="text-base md:text-lg font-medium text-surface-100 border-b border-emerald-500 w-fit mb-1 md:mb-2"
                >
                  {{ owner.name }}
                </div>
                <div
                  class="text-xs md:text-sm text-surface-300 flex items-start gap-1 md:gap-2"
                >
                  <i
                    class="pi pi-envelope mr-1 md:mr-2 !text-emerald-400 text-sm md:text-base"
                  ></i>
                  <span v-if="owner.showDetails" class="truncate">{{ owner.email }}</span>
                  <span v-else class="text-surface-500 truncate">******@****.***</span>
                </div>
              </div>

              <!-- Contact Info -->
              <div class="flex flex-col gap-1">
                <div
                  class="text-xs md:text-sm text-surface-300 flex items-start gap-1 md:gap-2"
                >
                  <i
                    class="pi pi-phone mr-1 md:mr-2 !text-emerald-400 text-sm md:text-base"
                  ></i>
                  <span v-if="owner.showDetails" class="!ltr truncate"
                    >+{{ owner.phone }}</span
                  >
                  <span v-else class="text-surface-500 truncate">{{
                    $t("owners.hidden_phone")
                  }}</span>
                </div>
                <div
                  class="text-xs md:text-sm text-surface-300 flex items-start gap-1 md:gap-2"
                >
                  <i
                    class="pi pi-map-marker mr-1 md:mr-2 !text-emerald-400 text-sm md:text-base"
                  ></i>
                  <span class="truncate">{{ owner.address }}</span>
                </div>
              </div>

              <!-- Actions -->
              <div class="flex gap-1 md:gap-2 justify-end mt-2 md:mt-3">
                <Button
                  icon="pi pi-pencil"
                  @click="editOwner(owner)"
                  class="p-button-text text-surface-300 hover:!text-emerald-400 text-sm md:text-base"
                  v-tooltip.top="$t('owners.actions.edit')"
                />
                <router-link
                  :to="`/` + owner.id + `/pets`"
                  class="p-button p-component p-button-icon-only p-button-text text-surface-300 hover:!text-emerald-400 button-transition text-sm md:text-base"
                  v-tooltip.top="$t('owners.actions.pets')"
                >
                  <i class="fas fa-paw"></i>
                </router-link>
                <Button
                  icon="pi pi-whatsapp"
                  @click="showWahaModal(owner)"
                  class="p-button-text text-surface-300 hover:!text-emerald-400 text-sm md:text-base"
                  v-tooltip.top="$t('owners.actions.whatsapp')"
                />
                <Button
                  :icon="owner.showDetails ? 'pi pi-eye-slash' : 'pi pi-eye'"
                  @click="toggleDetails(owner)"
                  class="p-button-text text-surface-300 hover:!text-emerald-400 text-sm md:text-base"
                  v-tooltip.top="
                    owner.showDetails
                      ? $t('owners.actions.hide_details')
                      : $t('owners.actions.view_details')
                  "
                />
                <Button
                  icon="pi pi-trash"
                  @click="deactivateAccount(owner)"
                  class="p-button-text text-surface-300 hover:text-rose-400 text-sm md:text-base"
                  v-tooltip.top="$t('owners.actions.deactivate')"
                />
              </div>
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
  <!-- Dialogs -->
  <Dialog
    v-model:visible="isModalVisible"
    header="New Owner"
    :style="{ width: '50vw' }"
    class="bg-surface-300 text-surface-100"
  >
    <NewClientForm @ownerAdded="handleSubmit" />
  </Dialog>

  <Dialog
    v-model:visible="isModalWahaVisible"
    header="Send WhatsApp"
    :style="{ width: '40vw' }"
    class="bg-surface-300 text-surface-100"
  >
    <SendWhatsApp
      :contactNumber="whatsAppContact"
      :ownerID="selectedOwner"
      @submitted="handleWahaSubmit"
    />
  </Dialog>

  <Dialog
    v-model:visible="isEditOwnerVisible"
    header="Edit Owner"
    :style="{ width: '60vw' }"
    class="bg-surface-300 text-surface-100"
  >
    <EditOwner :owner="selectedOwner" @OwnerUpdated="handleOwnerUpdated" />
  </Dialog>
</template>
<script setup>
import { ref, onMounted, computed } from "vue";
import { RouterLink, useRoute } from "vue-router";
import DataView from "primevue/dataview";
import SelectButton from "primevue/selectbutton";
import Button from "primevue/button";
import InputGroupAddon from "primevue/inputgroupaddon";
import InputGroup from "primevue/inputgroup";
import InputText from "primevue/inputtext";
import Paginator from "primevue/paginator";
import axiosInstance from "@/axios"; // Assuming axiosInstance is set up correctly
import Skeleton from "primevue/skeleton";
import Dialog from "primevue/dialog";
import Avatar from "primevue/avatar";
import eventBus from "@/eventBus";
import router from "@/router";
import NewClientForm from "@/views/AddNewOwner.vue";
import SendWhatsApp from "@/views/SendWhatsApp.vue";
import EditOwner from "@/views/EditOwner.vue";
import { useI18n } from "vue-i18n";
import ScrollPanel from "primevue/scrollpanel";
import { useDevice } from "@/composables/useDevice";

const { isMobile, mobileMenuVisible } = useDevice();
const { t } = useI18n();
const route = useRoute();
const currentPage = ref(1); // Track the current page
const totalRecords = ref(0); // Total number of records
const itemsPerPage = ref(25); // Number of items per page (matching your API response)const layout = ref("grid");
const searchQuery = ref(""); // Reactive search query
const selectedOwner = ref("");
const owners = ref([
  {
    id: 0,
    showDetails: false,
  },
]);
const layout = ref("");
const loading = ref(true);
const options = ref(["list", "grid"]);
const whatsAppContact = ref("");
const isModalVisible = ref(false);
const isModalWahaVisible = ref(false);
const isEditOwnerVisible = ref(false);

const showModal = () => {
  isModalVisible.value = true;
};
layout.value = isMobile ? "grid" : "list";
const refreshData = () => {
  loading.value = true; // Set loading state to true to show skeletons
  fetchOwners(); // Fetch the pets data again
};
const showWahaModal = (owner) => {
  whatsAppContact.value = owner.phone;
  selectedOwner.value = owner.id;
  isModalWahaVisible.value = true;
};
const toggleDetails = (owner) => {
  owner.showDetails = !owner.showDetails;
};
const deactivateAccount = (owner) => {
  // console.log(owner);
};
const editOwner = (owner) => {
  // console.log(owner);
  selectedOwner.value = owner;
  isEditOwnerVisible.value = true;
};
const fetchOwners = async (page = 1) => {
  loading.value = true;
  try {
    const response = await axiosInstance.get(
      `/owners?page=` +
        page +
        `&per_page=` +
        itemsPerPage.value +
        `&search=${searchQuery.value}`
    );
    owners.value = response.data.data.map((owner) => ({
      // id: owner.id.toString(),
      // name: owner.name,
      // email: owner.email,
      // phone: owner.phone,
      // address: owner.address,
      // showDetails: false,
      id: owner.id.toString(),
      name: owner.name,
      email: owner.email,
      phone: owner.phone,
      landline: owner.landline,
      address: owner.address,
      birth_date: owner.birth_date,
      facebook_link: owner.facebook_link,
      instagram_link: owner.instagram_link,
      referral: owner.referral,
      clinic_notes: owner.clinic_notes,
    }));

    // const response = await axiosInstance.get("/owners");
    // console.log(owners.value);
    totalRecords.value = response.data.total;
    currentPage.value = response.data.current_page;
    // owners.value = response.data.data;
    loading.value = false; // Set loading to false after data is fetched
  } catch (error) {
    console.error("Failed to fetch owners:", error);
    loading.value = false; // Ensure loading is set to false even on error
  }
  //   // console.log(loading.value);
};
const deactivateClient = async (data) => {
  try {
    // console.log(owner.value);
    // Make the POST request to the API to create a new client
    const response = await axiosInstance.post("/owners", owner.value);

    // Emit the submitted data back to the parent component
    emit("ownerAdded", response.data.data); // You may modify this based on your response structure
    eventBus.emit("ownerAdded", response.data.data);
    // Clear the form fields after successful submission
    owner.value = {
      name: "",
      email: "",
      phone: "",
      address: "",
    };

    // Optionally, show a success message or perform any other action
    eventBus.emit("show-toast", {
      severity: "success",
      summary: "Client Added",
      detail: "New client has been added successfully.",
      life: 5000,
    });
    await router.push("/owners");
  } catch (error) {
    // Handle the error
    console.error("Error adding new client:", error);
    eventBus.emit("show-toast", {
      severity: "error",
      summary: "Error",
      detail: "Failed to add new client.",
      life: 5000,
    });
  }
};

const onSearchChange = () => {
  if (searchQuery.value.length < 3 && searchQuery.value.length !== 0) {
    return; // Do not proceed with search
  }
  currentPage.value = 1; // Reset to first page on search
  fetchOwners(currentPage.value); // Fetch pets with the updated search query
};
const onPageChange = (event) => {
  itemsPerPage.value = event.rows;
  currentPage.value = event.page + 1; // PrimeVue Paginator uses zero-based index
  fetchOwners(currentPage.value); // Fetch pets for the new page
  // console.log(event);
};
const clearFilters = () => {
  // console.log("clearing filters");
  currentPage.value = 1;
  searchQuery.value = "";
  fetchOwners(currentPage.value);
};
// Handle the submit event from the child component
const handleSubmit = () => {
  isModalVisible.value = false;
  fetchOwners(); // Refresh the owners list
};
const handleWahaSubmit = () => {
  isModalWahaVisible.value = false;
};
const handleOwnerUpdated = () => {
  isEditOwnerVisible.value = false;
  fetchOwners();
};

const goToAddOwnerPage = async () => {
  await router.push("/new-owner");
};
const goToListOwnerPetsPage = async (ownerid) => {
  await router.push({ path: "/" + ownerid + "/pets" });
};
const goToAddOwnerPetsPage = async (ownerid) => {
  await router.push({ path: "/" + ownerid + "/new-pet" });
};
// console.log(route.meta.transition);
onMounted(() => {
  fetchOwners();
  eventBus.on("AddOwner", () => {
    // console.log("OPEN ADD OWNER");
    showModal();
  });
});
</script>

<style>
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
