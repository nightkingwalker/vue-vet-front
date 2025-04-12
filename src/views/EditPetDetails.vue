<template>
  <div class="w-full">
    <!-- <h2>Edit Pet</h2> -->
    <form @submit.prevent="submitForm" class="mt-8 mx-auto w-4/5">
      <fieldset
        class="p-fieldset p-component w-full flex flex-wrap items-center border rounded-lg p-4"
      >
        <legend>Edit Pet: {{ pet.name }}</legend>
        <input type="hidden" id="branch_id" value="1" v-model="pet.branch_id" />

        <!-- Name Field -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-full md:w-56">
            <InputText id="name" v-model="pet.name" />
            <label for="name">Name</label>
          </FloatLabel>
        </div>

        <!-- Species Field -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-full md:w-56">
            <Select
              v-model="pet.species"
              :options="species"
              optionLabel="label"
              class="w-full md:w-56 h-10"
            >
              <template #value="slotProps">
                <div v-if="slotProps.value" class="flex items-center">
                  <div>{{ slotProps.value.value }}</div>
                </div>
                <span v-else>{{ slotProps.placeholder }}</span>
              </template>
            </Select>
            <label for="species">Select a Species</label>
          </FloatLabel>
        </div>

        <!-- Breed Field -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-full md:w-56">
            <InputText id="breed" v-model="pet.breed" />
            <label for="breed">Breed</label>
          </FloatLabel>
        </div>

        <!-- Gender Field -->
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
                <span v-else>{{ slotProps.placeholder }}</span>
              </template>
            </Select>
            <label for="gender">Gender</label>
          </FloatLabel>
        </div>

        <!-- Date of Birth Field -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-full md:w-56">
            <label for="dob">Date of Birth</label>
            <DatePicker
              showIcon
              iconDisplay="input"
              showButtonBar
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

        <!-- Color Field -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-full">
            <InputText id="color" v-model="pet.color" />
            <label for="color">Color</label>
          </FloatLabel>
        </div>

        <!-- Distinctive Marks Field -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-full">
            <InputText id="distinctive_marks" v-model="pet.distinctive_marks" />
            <label for="distinctive_marks">Distinctive Marks</label>
          </FloatLabel>
        </div>

        <!-- Behaviour Field -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-full">
            <InputText id="behaviour" v-model="pet.behaviour" />
            <label for="behaviour">Behaviour</label>
          </FloatLabel>
        </div>

        <!-- Neutered Field -->
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
                <span v-else>{{ slotProps.placeholder }}</span>
              </template>
            </Select>
            <label for="neutered">Neutered</label>
          </FloatLabel>
        </div>

        <!-- Deceased Field -->
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
                <span v-else>{{ slotProps.placeholder }}</span>
              </template>
            </Select>
            <label for="deceased">Deceased</label>
          </FloatLabel>
        </div>

        <!-- Allergies Field -->
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
import { ref, onMounted } from "vue";
import InputText from "primevue/inputtext";
import Textarea from "primevue/textarea";
import DatePicker from "primevue/datepicker";
import Select from "primevue/select";
import FloatLabel from "primevue/floatlabel";
import Button from "primevue/button";
import axiosInstance from "@/axios"; // Assuming you've created a global axios instance
import eventBus from "@/eventBus";
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
  { label: "Avian", value: "Avian" },
  { label: "Bovine", value: "Bovine" },
  { label: "Camelid", value: "Camelid" },
  { label: "Canine", value: "Canine" },
  { label: "Caprine", value: "Caprine" },
  { label: "Cavies", value: "Cavies" },
  { label: "Cervidae", value: "Cervidae" },
  { label: "Equine", value: "Equine" },
  { label: "Feline", value: "Feline" },
  { label: "Lapine", value: "Lapine" },
  { label: "Murine", value: "Murine" },
  { label: "Ovine", value: "Ovine" },
]);

const yesno = ref([
  { label: "Yes", value: "Yes" },
  { label: "No", value: "No" },
]);

const genders = ref([
  { label: "Male", value: "Male" },
  { label: "Female", value: "Female" },
]);

const petmicrochip = ref(route.params.petmicrochip);

const fetchPetDetails = async () => {
  const petId = route.params.petid;
  try {
    const response = await axiosInstance.get(`/pets/${petmicrochip.value}`);
    const petData = response.data;

    // Map the fetched data to the expected format for Select components
    pet.value = {
      ...petData,
      species: species.value.find((opt) => opt.value === petData.species),
      gender: genders.value.find((opt) => opt.value === petData.gender),
      neutered: yesno.value.find(
        (opt) => opt.value === (petData.neutered === "Y" ? "Yes" : "No")
      ),
      deceased: yesno.value.find(
        (opt) => opt.value === (petData.deceased === "Y" ? "Yes" : "No")
      ),
    };
    pet.value.date_of_birth = formatDateForSubmission(pet.value.date_of_birth);

    // console.log(pet.value);
  } catch (error) {
    console.error("Failed to fetch pet details:", error);
  }
};

const formatDateForSubmission = (dateString) => {
  const date = new Date(dateString);
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, "0")}-${String(
    date.getDate()
  ).padStart(2, "0")}`;
};
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
      ? formatDateForSubmission(pet.value.date_of_birth) // Format the date
      : null,
    color: pet.value.color,
    distinctive_marks: pet.value.distinctive_marks,
    behaviour: pet.value.behaviour,
    neutered: pet.value.neutered.value === "Yes" ? "Y" : "N",
    deceased: pet.value.deceased.value === "Yes" ? "Y" : "N",
    allergies: pet.value.allergies,
  };

  try {
    const response = await axiosInstance.put(
      `/pets/${petmicrochip.value}`,
      submissionData
    );
    emit("details_updated", response.data); // Emit the updated pet data
    eventBus.emit("show-toast", {
      severity: "success",
      summary: "Data Updated",
      detail: `Pet details updated successfully`,
      life: 5000,
    });
  } catch (error) {
    eventBus.emit("show-toast", {
      severity: "warn",
      summary: "Error",
      detail: error,
      life: 5000,
    });
  }
};

onMounted(() => {
  fetchPetDetails();
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
