<template>
  <div class="w-full">
    <!-- <h2>Add New Pet</h2> -->
    <form @submit.prevent="submitForm" class="mt-8 mx-auto w-4/5">
      <fieldset
        class="p-fieldset p-component w-full flex flex-wrap items-center border rounded-lg p-4"
      >
        <legend>
          {{ owners.name }} <i class="pi pi-angle-double-right"></i> Add New Patient
        </legend>
        <input type="hidden" id="branch_id" value="1" v-model="pet.branch_id" />
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
            <label for="gender">Gender</label>
          </FloatLabel>
        </div>
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-full md:w-56">
            <label for="dob">Date of Birth</label>
            <DatePicker
              showTime
              hourFormat="12"
              fluid
              id="dob"
              class="w-full"
              v-model="pet.date_of_birth"
              dateFormat="yy-mm-dd"
            />
          </FloatLabel>
        </div>
        <!-- Color -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-full">
            <InputText id="color" v-model="pet.color" />
            <label for="color">Color</label>
          </FloatLabel>
        </div>

        <!-- Distinctive Marks -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-full">
            <InputText id="distinctive_marks" v-model="pet.distinctive_marks" />
            <label for="distinctive_marks">Distinctive Marks</label>
          </FloatLabel>
        </div>

        <!-- Behaviour -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-full">
            <InputText id="behaviour" v-model="pet.behaviour" />
            <label for="behaviour">Behaviour</label>
          </FloatLabel>
        </div>

        <!-- Neutered -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-full md:w-56">
            <Select
              v-model="pet.neutered"
              :options="yesno"
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
            <label for="neutered">Neutered</label>
          </FloatLabel>
        </div>

        <!-- Deceased -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-full md:w-56">
            <Select
              v-model="pet.deceased"
              :options="yesno"
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
            <label for="deceased">Deceased</label>
          </FloatLabel>
        </div>

        <!-- Allergies -->
        <div class="field mt-6 w-full">
          <FloatLabel class="w-full">
            <Textarea id="allergies" v-model="pet.allergies" />
            <label for="allergies">Allergies</label>
          </FloatLabel>
        </div>
        <Button type="submit" label="Submit" />
      </fieldset>
    </form>
  </div>
</template>

<script setup>
import { ref } from "vue";
import InputText from "primevue/inputtext";
import Textarea from "primevue/textarea";
import DatePicker from "primevue/datepicker";
import Fieldset from "primevue/fieldset";
import Select from "primevue/select";
import FloatLabel from "primevue/floatlabel";
import Button from "primevue/button";
import axiosInstance from "@/axios"; // Assuming you've created a global axios instance
import eventBus from "@/eventBus";
import router from "@/router";
import { useRoute } from "vue-router";
import Cookies from "js-cookie";
const route = useRoute();
const emit = defineEmits(["submitted"]); // Define the event to be emitted

const pet = ref({
  owner_id: route.params.ownerid,
  branch_id: Cookies.get("M3K8g2387BahBaqyjDe6"),
  name: "",
  species: "",
  breed: "",
  gender: "",
  date_of_birth: "",
  color: "",
  distinctive_marks: "",
  behaviour: "",
  neutered: "",
  deceased: "",
  allergies: "",
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
const yesno = ref([
  { label: "Yes", value: "Yes" },
  { label: "No", value: "No" },
]);
const genders = ref([
  { label: "Male", value: "Male" },
  { label: "Female", value: "Female" },
]);
const owners = ref([]);
const ownerid = route.params.ownerid;
const filteredOwners = ref([]);

// Fetch owners from the API
async function fetchOwners() {
  try {
    const response = await axiosInstance.get("/owners/" + ownerid);
    // // console.log(response.data);
    owners.value = response.data;
  } catch (error) {
    console.error("Failed to fetch owners:", error);
  }
}

// Search function for AutoComplete
function searchOwners(event) {
  filteredOwners.value = owners.value.filter((owner) =>
    owner.name.toLowerCase().includes(event.query.toLowerCase())
  );
}
function addNewOwner() {
  router.push("/new-owner"); // Ensure this route is defined in your router configurations
}
// Form submission
const submitForm = async () => {
  const submissionData = {
    owner_id: pet.value.owner_id,
    branch_id: pet.value.branch_id,
    name: pet.value.name,
    species: pet.value.species.value,
    breed: pet.value.breed,
    gender: pet.value.gender.value,
    date_of_birth: pet.value.date_of_birth
      ? pet.value.date_of_birth.toLocaleDateString("en-CA")
      : null,
    color: pet.value.color,
    distinctive_marks: pet.value.distinctive_marks,
    behaviour: pet.value.behaviour,
    neutered: pet.value.neutered.value === "Yes" ? "Y" : "N",
    deceased: pet.value.deceased.value === "Yes" ? "Y" : "N",
    allergies: pet.value.allergies,
  };
  // console.log(submissionData);
  try {
    const response = await axiosInstance.post("/pets", submissionData);
    // console.log(response);
    emit("submitted", response.data);
    eventBus.emit("show-toast", {
      severity: "success",
      summary: "Data Loaded",
      detail: `Pet Added Successfully`,
      life: 5000,
    });
    await router.push("/" + route.params.ownerid + "/pets");
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
fetchOwners();
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
