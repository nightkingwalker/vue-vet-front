<template>
  <div class="w-full">
    <!-- <h2>Add New Pet</h2> -->
    <form @submit.prevent="submitForm" class="mx-auto w-full">
      <fieldset
        class="p-fieldset p-component w-4/5 flex flex-wrap mx-auto items-center border rounded-lg p-4"
      >
        <legend>Add New Patient</legend>
        <input type="hidden" id="branch_id" value="1" v-model="pet.branch_id" />
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-full md:w-56">
            <AutoComplete
              v-model="pet.owner_id"
              optionLabel="name"
              :suggestions="filteredOwners"
              @complete="searchOwners"
              class="w-full"
            >
              <template #option="slotProps">
                <div class="flex items-center">
                  <div>{{ slotProps.option.name }}</div>
                </div>
              </template>
              <template #footer>
                <Button
                  label="Add New Owner"
                  icon="pi pi-plus"
                  @click="addNewOwner"
                  class="p-button-text w-full"
                />
              </template>
            </AutoComplete>
            <label for="name">Select Owner</label>
          </FloatLabel>
        </div>
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-full md:w-56">
            <InputText id="name" v-model="pet.name" />
            <label for="name">Name</label>
          </FloatLabel>
        </div>
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-full md:w-56">
            <Select
              v-model="pet.species"
              :options="species"
              optionLabel="name"
              class="w-full md:w-56 h-10"
            >
              <template #value="slotProps">
                <div v-if="slotProps.value" class="flex items-center">
                  <div>{{ slotProps.value.value }}</div>
                </div>
                <span v-else>
                  {{ slotProps.placeholder }}
                </span>
              </template>
              <template #option="slotProps">
                <div class="flex items-center">
                  <div>{{ slotProps.option.label }}</div>
                </div>
              </template>
            </Select>

            <label for="dd-city">Select a Species</label>
          </FloatLabel>
        </div>
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-full md:w-56">
            <InputText id="breed" v-model="pet.breed" />

            <label for="dd-city">Breed</label>
          </FloatLabel>
        </div>
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-full md:w-56">
            <Select
              id="gender"
              v-model="pet.gender"
              :options="genders"
              optionLabel="label"
              class="w-full h-10"
            >
              <template #value="slotProps">
                <div v-if="slotProps.value" class="flex items-center">
                  <div>{{ slotProps.value.value }}</div>
                </div>
                <span v-else>
                  {{ slotProps.placeholder }}
                </span>
              </template>
              <template #option="slotProps">
                <div class="flex items-center">
                  <div>{{ slotProps.option.label }}</div>
                </div>
              </template>
            </Select>
            <label for="gender">Select Gender</label>
          </FloatLabel>
        </div>
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-full md:w-56">
            <label for="dob">Date of Birth</label>
            <DatePicker
              id="dob"
              class="w-full"
              v-model="pet.date_of_birth"
              dateFormat="yy-mm-dd"
            />
          </FloatLabel>
        </div>
        <Button type="submit" label="Submit" />
      </fieldset>
    </form>
  </div>
</template>

<script setup>
import { onMounted, ref, onBeforeUnmount } from "vue";
import AutoComplete from "primevue/autocomplete";
import InputText from "primevue/inputtext";
import DatePicker from "primevue/datepicker";
import Fieldset from "primevue/fieldset";
import Select from "primevue/select";
import FloatLabel from "primevue/floatlabel";
import Button from "primevue/button";
import axiosInstance from "@/axios"; // Assuming you've created a global axios instance
import eventBus from "@/eventBus";
import router from "@/router";

const emit = defineEmits(["submitted"]); // Define the event to be emitted
const isModalOwnerVisible = ref(false);
const pet = ref({
  owner_id: null,
  branch_id: 1,
  name: "",
  species: "",
  breed: "",
  gender: "",
  date_of_birth: "",
});
const species = ref([
  { label: "Avian", value: "Avian" }, //Birds
  { label: "Bovine", value: "Bovine" }, // Cows
  { label: "Camelid", value: "Camelid" }, // Camels
  { label: "Canine", value: "Canine" }, //Dogs
  { label: "Caprine", value: "Caprine" }, // Goats
  { label: "Cavies", value: "Cavies" }, // Guinea Pigs
  { label: "Cervidae", value: "Cervidae" }, //Deers
  { label: "Equine", value: "Equine" }, //Horses
  { label: "Feline", value: "Feline" }, // Cats
  { label: "Lapine", value: "Lapine" }, // Rabbits
  { label: "Murine", value: "Murine" }, //Mice
  { label: "Ovine", value: "Ovine" }, // Sheeps
]);
const genders = ref([
  { label: "Male", value: "Male" },
  { label: "Female", value: "Female" },
]);
const owners = ref([]);
const filteredOwners = ref([]);

// Fetch owners from the API
async function fetchOwners() {
  try {
    const response = await axiosInstance.get("/owners");
    // console.log(response.data.data);
    owners.value = response.data.data;
  } catch (error) {
    console.error("Failed to fetch owners:", error);
  }
}

// Search function for AutoComplete
function searchOwners(event) {
  fetchOwners();
  filteredOwners.value = owners.value.filter((owner) =>
    owner.name.toLowerCase().includes(event.query.toLowerCase())
  );
}
const addNewOwner = () => {
  emit("showOwnerModal"); // Emit event to parent to show the owner modal
};

// Form submission
const submitForm = async () => {
  const submissionData = {
    owner_id: pet.value.owner_id.id,
    branch_id: pet.value.branch_id,
    name: pet.value.name,
    species: pet.value.species.value,
    breed: pet.value.breed,
    gender: pet.value.gender.value,
    date_of_birth: pet.value.date_of_birth
      ? pet.value.date_of_birth.toLocaleDateString("en-CA")
      : null,
  };

  // console.log(submissionData); // Verify the structure
  //   // console.log(pet.value.owner_id.id);
  try {
    const response = await axiosInstance.post("/pets", submissionData);
    emit("submitted", response.data); // You may modify this based on your response structure

    // console.log(response);
    eventBus.emit("show-toast", {
      severity: "success",
      summary: "Data Loaded",
      detail: `Pet Added Successfully`,
      life: 5000,
    });
    router.push("/pets");
  } catch (error) {
    eventBus.emit("show-toast", {
      severity: "warn",
      summary: "Error",
      detail: error,
      life: 5000,
    });
  } finally {
  }
};

// Load owners when component is mounted
onMounted(() => {
  fetchOwners();
  eventBus.on("ownerAdded", (event) => {
    // console.log(event);
  });
});

onBeforeUnmount(() => {
  // Clean up the event listener when the component is destroyed
  eventBus.off("ownerAdded", fetchOwners);
});
</script>

<style scoped>
.form-container {
  max-width: 500px;
  margin: auto;
}
.field {
  margin-bottom: 16px;
}
.p-fieldset-content {
  display: flex;
}
</style>
