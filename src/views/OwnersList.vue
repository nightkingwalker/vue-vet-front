<template>
  <DataView :value="owners" :layout="layout" class="!rounded-xl !overflow-hidden my-4">
    <template #header>
      <div class="flex justify-between items-center">
        <div class="flex gap-2 justify-end items-center">
          <SelectButton v-model="layout" :options="options" :allowEmpty="false">
            <template #option="{ option }">
              <i :class="[option === 'list' ? 'pi pi-bars' : 'pi pi-table']" />
            </template>
          </SelectButton>
          <Button
            type="button"
            icon="pi pi-refresh !text-sm"
            label=""
            v-tooltip.top="{
              value: 'Refresh Data',
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
            class="p-button p-button-icon-only !text-sm !font-thin h-7"
            @click="refreshData"
          />
          <Button
            icon="pi pi-plus"
            @click="showModal"
            v-tooltip.top="{
              value: 'New Owner',
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
            class="p-button p-button-icon-only !text-sm !font-thin h-7"
          />
        </div>
        <h2 class="text-xl">Owners List</h2>
        <InputGroup
          class="!text-gray-800 flex rounded-md overflow-hidden border !border-gray-400 h-8 !w-1/5"
        >
          <InputGroupAddon
            class="!text-gray-800 px-4 flex flex-col item-center justify-center"
          >
            <i class="pi pi-search"></i
          ></InputGroupAddon>
          <InputText
            v-model="searchQuery"
            @input="onSearchChange"
            type="text"
            class="!text-sm !text-gray-800 focus:!ring-0 focus:!ring-offset-0 focus:!border-gray-400 border-transparent"
            placeholder="Search Owners"
          />
          <Button
            icon="pi pi-spin pi-spinner-dotted"
            v-if="loading"
            @click="clearFilters"
          />
          <Button icon="pi pi-times" v-else @click="clearFilters" />
        </InputGroup>
      </div>
    </template>
    <template #list v-if="loading">
      <div class="flex flex-col">
        <div v-for="i in 2" :key="i">
          <div
            class="flex flex-col xl:flex-row xl:items-start p-6 gap-6"
            :class="{ 'border-t border-surface-200 dark:border-surface-700': i !== 0 }"
          >
            <!-- <Skeleton class="!w-9/12 sm:!w-64 xl:!w-40 !h-24 mx-auto" /> -->
            <div
              class="flex flex-col sm:flex-row justify-between items-center xl:items-start flex-1 gap-6"
            >
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
      <!--contents-->
      <div class="flex flex-col p-4">
        <div v-for="(owner, index) in slotProps.items" :key="index">
          <div
            class="flex flex-col sm:flex-row sm:items-center px-6 py-2 border-surface-200 dark:border-surface-700 bg-gray-50 dark:bg-[var(--p-surface-700)] hover:bg-[var(--p-surface-300)] dark:hover:bg-[var(--p-surface-500)]"
            :class="{
              'border-t border-surface-200 dark:border-surface-700': index !== 0,
            }"
          >
            <div
              class="flex flex-col md:flex-row justify-between md:items-center flex-1 gap-6"
            >
              <div class="w-1/4">
                <div class="text-lg font-medium border-b-2 w-fit">
                  {{ owner.name }}
                </div>
                <div class="text-sm">
                  <i class="fa-solid fa-at mr-2"></i>
                  <!-- {{ owner.email }} -->
                  <span v-if="owner.showDetails">{{ owner.email }}</span>
                  <span v-else>******@****.***</span>
                </div>
              </div>
              <div class="flex flex-col md:items-start gap-2 w-1/3">
                <span class="text-sm">
                  <i class="fa-solid fa-phone-volume mr-2 mt-2"></i>
                  <a
                    v-if="owner.showDetails"
                    :href="`https://wa.me/` + owner.phone"
                    target="_blank"
                    v-tooltip.top="{
                      value: 'WhatsApp ',
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
                  >
                    +{{ owner.phone }}
                  </a>
                  <span v-else class="2xl:!text-lg lg:!text-xs">+***********</span></span
                >
                <span class="text-sm"
                  ><i class="fa-solid fa-location-dot mr-2"></i>{{ owner.address }}</span
                >
              </div>
              <div class="flex gap-1">
                <Button
                  type="button"
                  icon="fas fa-user-pen 2xl:!text-lg lg:!text-xs"
                  label=""
                  v-tooltip.top="{
                    value: 'Edit',
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
                  class="p-component text-xs !bg-[var(--p-primary-color)] !text-[var(--p-primary-contrast-color)]"
                />
                <router-link
                  :to="`/` + owner.id + `/pets`"
                  class="p-button p-component text-xs !bg-[var(--p-primary-color)] !text-[var(--p-primary-contrast-color)]"
                  v-tooltip.top="{
                    value: 'Pets',
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
                >
                  <i class="fas fa-paw 2xl:!text-lg lg:!text-xs"></i>
                </router-link>
                <Button
                  type="button"
                  icon="fas fa-plus !text-sm"
                  label=""
                  v-tooltip.top="{
                    value: 'New Pet',
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
                  class="p-component text-xs !bg-[var(--p-primary-color)] !text-[var(--p-primary-contrast-color)]"
                />
                <Button
                  class="p-button p-component 2xl:!text-lg lg:!text-xs"
                  :icon="
                    owner.showDetails
                      ? `pi pi-eye 2xl:!text-lg lg:!text-xs`
                      : `pi pi-eye-slash 2xl:!text-lg lg:!text-xs`
                  "
                  v-tooltip.top="{
                    value: 'View Details',
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
                  @click="toggleDetails(owner)"
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </template>
    <template #grid v-if="loading">
      <div class="grid grid-cols-12 gap-2">
        <div
          v-for="i in 4"
          :key="i"
          class="col-span-12 sm:col-span-6 md:col-span-5 xl:col-span-3 p-2"
        >
          <div
            class="p-6 border border-surface-200 dark:border-surface-700 bg-surface-0 dark:bg-surface-900 rounded-lg flex flex-col"
          >
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
            <div class="flex flex-col gap-6 mt-1">
              <div class="flex gap-2">
                <Skeleton class="w-full" height="1.5rem" />
              </div>
            </div>
          </div>
        </div>
      </div>
    </template>

    <template #grid="slotProps" v-else>
      <!--contents-->
      <div class="grid xl:grid-cols-12 grid-cols-10 p-4">
        <div
          v-for="(owner, index) in slotProps.items"
          :key="index"
          class="col-span-12 sm:col-span-6 md:col-span-2.5 lg:col-span-2 xl:col-span-3 p-2"
        >
          <div
            class="p-6 border border-surface-200 dark:border-surface-700 bg-zinc-100 dark:bg-[var(--p-surface-500)] rounded-lg flex flex-col shadow"
          >
            <div class="">
              <div class="text-lg font-medium border-b">{{ owner.name }}</div>

              <div class="mt-4 text-sm">
                <div class="2xl:!text-lg lg:!text-xs">
                  <!-- <i class="fa-solid fa-at mr-2 mt-2"></i>{{ owner.email }} -->
                  <i class="fa-solid fa-at mr-2 mt-2"></i>
                  <span v-if="owner.showDetails">{{ owner.email }}</span>
                  <span v-else class="lg:text-xs xl:text-xs">******@****.***</span>
                </div>
                <div>
                  <i class="fa-solid fa-phone-volume mr-2 mt-2"></i>
                  <a
                    v-if="owner.showDetails"
                    @click="showWahaModal(owner.phone)"
                    target="_blank"
                    v-tooltip.top="{
                      value: 'Send WhatsApp Message to ' + owner.phone,
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
                    class="cursor-pointer"
                  >
                    +{{ owner.phone }}
                  </a>
                  <span v-else>***********</span>
                </div>
                <div class="whitespace-normal">
                  <i class="fa-solid fa-location-dot mr-2 mt-2"></i>
                  {{ owner.address }}
                </div>
              </div>
              <div class="flex flex-col gap-6 mt-6">
                <div class="flex gap-1 justify-between">
                  <Button
                    type="button"
                    icon="fas fa-user-pen 2xl:!text-lg lg:!text-xs"
                    label=""
                    v-tooltip.top="{
                      value: 'Edit',
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
                    class="p-component text-xs !bg-[var(--p-primary-color)] !text-[var(--p-primary-contrast-color)]"
                  />
                  <router-link
                    :to="`/` + owner.id + `/pets`"
                    class="p-button p-component text-xs !bg-[var(--p-primary-color)] !text-[var(--p-primary-contrast-color)]"
                    v-tooltip.top="{
                      value: 'Pets',
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
                  >
                    <i class="fas fa-paw 2xl:!text-lg lg:!text-xs"></i>
                  </router-link>
                  <Button
                    type="button"
                    icon="pi pi-whatsapp !text-sm"
                    label=""
                    @click="showWahaModal(owner.phone)"
                    v-tooltip.top="{
                      value: 'Send WhatsApp Message',
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
                    class="p-component text-xs !bg-[var(--p-primary-color)] !text-[var(--p-primary-contrast-color)]"
                  />
                  <Button
                    class="p-button p-component 2xl:!text-lg lg:!text-xs"
                    :icon="
                      owner.showDetails
                        ? `pi pi-eye 2xl:!text-lg lg:!text-xs`
                        : `pi pi-eye-slash 2xl:!text-lg lg:!text-xs`
                    "
                    v-tooltip.top="{
                      value: 'View Details',
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
                    @click="toggleDetails(owner)"
                  />
                  <Button
                    class="p-button p-component 2xl:!text-lg lg:!text-xs"
                    :icon="`pi pi-times 2xl:!text-lg lg:!text-xs`"
                    v-tooltip.top="{
                      value: 'Deactivate Account',
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
                    @click="deactivateAccount(owner)"
                  />
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </template>
    <template #footer>
      <Paginator
        :rows="itemsPerPage"
        :first="1"
        :totalRecords="totalRecords"
        :currentPage="currentPage"
        :rowsPerPageOptions="[25, 50, 100]"
        @page="onPageChange"
        class="text-xs"
      ></Paginator>
    </template>
  </DataView>

  <Dialog
    header="Add New Client"
    v-model:visible="isModalVisible"
    @hide="isModalVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-4/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)]"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <Avatar icon="fas fa-users" shape="circle" />
        <span class="font-bold whitespace-nowrap">New Client</span>
      </div>
    </template>
    <NewClientForm @ownerAdded="handleSubmit" />
    <template #footer> </template>
  </Dialog>
  <Dialog
    header="Send WhatsApp Message"
    v-model:visible="isModalWahaVisible"
    @hide="isModalWahaVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-4/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)]"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <Avatar icon="fas fa-users" shape="circle" />
        <span class="font-bold whitespace-nowrap">Send WhatsApp Message</span>
      </div>
    </template>
    <SendWhatsApp :contactNumber="whatsAppContact" @submitted="handleWahaSubmit" />
    <template #footer> </template>
  </Dialog>
</template>

<script setup>
import { ref, onMounted, computed } from "vue";
import { RouterLink } from "vue-router";
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
import NewClientForm from "@/views/AddNewOwner.vue"; // Adjust the path as needed
import SendWhatsApp from "@/views/SendWhatsApp.vue"; // Adjust the path as needed
const currentPage = ref(1); // Track the current page
const totalRecords = ref(0); // Total number of records
const itemsPerPage = ref(25); // Number of items per page (matching your API response)const layout = ref("grid");
const searchQuery = ref(""); // Reactive search query

const owners = ref([
  {
    id: 0,
    showDetails: false,
  },
]);
const layout = ref("grid");
const loading = ref(true);
const options = ref(["list", "grid"]);
const whatsAppContact = ref("");
const isModalVisible = ref(false);
const isModalWahaVisible = ref(false);

const showModal = () => {
  isModalVisible.value = true;
};
const refreshData = () => {
  loading.value = true; // Set loading state to true to show skeletons
  fetchOwners(); // Fetch the pets data again
};
const showWahaModal = (phone) => {
  whatsAppContact.value = phone;
  isModalWahaVisible.value = true;
};
const toggleDetails = (owner) => {
  owner.showDetails = !owner.showDetails;
};
const deactivateAccount = (owner) => {
  console.log(owner);
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
      id: owner.id.toString(),
      name: owner.name,
      email: owner.email,
      phone: owner.phone,
      address: owner.address,
      showDetails: false,
    }));

    // const response = await axiosInstance.get("/owners");
    // // console.log(owners.value);
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
  // // console.log(event);
};
const clearFilters = () => {
  // // console.log("clearing filters");
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
const goToAddOwnerPage = async () => {
  await router.push("/new-owner");
};
const goToListOwnerPetsPage = async (ownerid) => {
  await router.push({ path: "/" + ownerid + "/pets" });
};
const goToAddOwnerPetsPage = async (ownerid) => {
  await router.push({ path: "/" + ownerid + "/new-pet" });
};
onMounted(() => {
  fetchOwners();
  eventBus.on("AddOwner", () => {
    console.log("OPEN ADD OWNER");
    showModal();
  });
});
</script>

<style scoped>
.form-container {
  max-width: 800px;
  margin: auto;
}
</style>
