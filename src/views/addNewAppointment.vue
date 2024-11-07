<template>
  <div class="w-full">
    <form @submit.prevent="submitForm" class="mx-auto w-full">
      <fieldset
        class="p-fieldset p-component w-4/5 flex flex-wrap mx-auto items-center border rounded-lg p-4"
      >
        <legend>Add New Appointment</legend>
        <input type="hidden" id="branch_id" value="1" v-model="appointment.branch_id" />
        <input type="hidden" id="client_id" v-model="appointment.client_id" />

        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-full">
            <AutoComplete
              placeholder="Select Pet"
              v-model="selectedPet"
              optionLabel="name"
              :suggestions="filteredPets"
              @complete="searchPets"
              class="w-full"
            >
              <template #option="slotProps">
                <div class="flex items-center">
                  <div>{{ slotProps.option.name }}</div>
                </div>
              </template>
            </AutoComplete>
            <label for="pet">Select Pet</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-full">
            <InputText
              id="title"
              v-model="appointment.title"
              placeholder="Enter appointment title"
            />
            <label for="title">Title</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-full">
            <InputText
              id="description"
              v-model="appointment.description"
              placeholder="Enter description (optional)"
            />
            <label for="description">Description</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-full">
            <DatePicker
              id="start"
              v-model="appointment.start"
              dateFormat="yy-mm-dd"
              placeholder="Select start date and time"
              class="w-full"
            />
            <label for="start">Start Date & Time</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-full">
            <DatePicker
              id="end"
              v-model="appointment.end"
              dateFormat="yy-mm-dd"
              placeholder="Select end date and time"
              class="w-full"
            />
            <label for="end">End Date & Time</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-full">
            <Select
              v-model="appointment.type"
              :options="appointmentTypes"
              optionLabel="label"
              placeholder="Select Appointment Type"
              class="w-full"
            />
            <label for="type">Type</label>
          </FloatLabel>
        </div>
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-full">
            <Select
              v-model="appointment.status"
              :options="appointmentStatus"
              optionLabel="label"
              placeholder="Select Status"
              class="w-full"
            />
            <label for="status">Status</label>
          </FloatLabel>
        </div>

        <Button type="submit" label="Submit" class="mt-4" />
      </fieldset>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from "vue";
import AutoComplete from "primevue/autocomplete";
import InputText from "primevue/inputtext";
import DatePicker from "primevue/datepicker";
import Select from "primevue/select";
import FloatLabel from "primevue/floatlabel";
import Button from "primevue/button";
import axiosInstance from "@/axios"; // Assuming you've created a global axios instance
import eventBus from "@/eventBus";
const emit = defineEmits(["submitted"]); // Define the event to be emitted

const props = defineProps(["activeDate"]); // Receiving activeDate as a prop
const appointment = ref({
  client_id: null, // To be set after selecting the pet
  branch_id: 1,
  title: "",
  description: "",
  type: "",
  start: null,
  end: null,
});

// Options for appointment type
const appointmentTypes = ref([
  { label: "Emergency", value: "Emergency" },
  { label: "Regular", value: "Regular" },
  { label: "FollowUp", value: "FollowUp" },
  { label: "Surgery", value: "Surgery" },
  { label: "Grooming", value: "Grooming" },
]);
const appointmentStatus = ref([
  { label: "Scheduled", value: "Scheduled" },
  { label: "Walkin", value: "Walkin" },
]);

const selectedPet = ref(null);
const filteredPets = ref([]);

const pet = ref({
  owner_id: null,
  branch_id: 1,
  name: "",
  species: "",
  breed: "",
  gender: "",
  date_of_birth: "",
});
const currentPage = ref(1); // Track the current page
const totalRecords = ref(0); // Total number of records
const itemsPerPage = ref(25); // Number of items per page (matching your API response)const layout = ref("grid");

const searchQuery = ref(""); // New reactive search query
const loading = ref(false); // Loading state

// Fetch pets based on search query
const fetchPets = async (page = 1) => {
  try {
    loading.value = true;
    const response = await axiosInstance.get(
      `/pets?page=${page}&per_page=${itemsPerPage.value}&search=${searchQuery.value}`
    );
    filteredPets.value = response.data.data; // Populate filtered pets
    console.log(filteredPets.value);
    totalRecords.value = response.data.total;
    currentPage.value = response.data.current_page;
    loading.value = false;
  } catch (error) {
    console.error("Failed to fetch pets:", error);
    loading.value = false; // Ensure loading is set to false even on error
  }
};

// Search function for AutoComplete
const searchPets = async (event) => {
  if (event.query.length < 3) {
    return; // Prevent search for less than 3 characters
  }
  searchQuery.value = event.query; // Update search query
  await fetchPets(currentPage.value); // Fetch pets with the updated search query
};
const setRandomTime = () => {
  if (appointment.value.start) {
    const startDate = new Date(appointment.value.start);
    const randomHour = Math.floor(Math.random() * 5) + 12; // Generates a number between 12 and 16 (inclusive)
    startDate.setHours(randomHour, 0, 0); // Set hours to a random value between 12:00:00 and 17:00:00
    appointment.value.start = startDate;
    console.log("START: " + appointment.value.start);
    // Set the end time to 15 minutes after the start time
    const endDate = new Date(startDate);
    endDate.setMinutes(endDate.getMinutes() + 15);
    appointment.value.end = endDate;
  }
};
// console.log("ACT" + props.activeDate);
// watch(
//   () => props.activeDate,
//   (newVal) => {
//     if (newVal) {
//       appointment.value.start = new Date(newVal);
//       setRandomTime(); // Call to set random time and end time when activeDate changes
//     }
//   }
// );
// Form submission
const submitForm = async () => {
  // Assign the client_id and pet_id based on the selected pet
  if (selectedPet.value) {
    appointment.value.client_id = selectedPet.value.owner_id; // Assuming this is the client's ID
    appointment.value.pet_id = selectedPet.value.id; // ID of the selected pet
    appointment.value.type = appointment.value.type.value; // Type selected from the dropdown
    appointment.value.status = appointment.value.status.value; // Status selected from the dropdown
  } else {
    eventBus.emit("show-toast", {
      severity: "warn",
      summary: "Error",
      detail: "Please select a pet.",
      life: 5000,
    });
    return; // Stop execution if no pet is selected
  }

  // Generate a random start time between 12:00:00 and 17:00:00
  const randomHour = Math.floor(Math.random() * 5) + 12; // Random hour between 12 and 16
  const randomMinute = Math.floor(Math.random() * 60); // Random minute between 0 and 59

  const startDate = new Date(appointment.value.start);
  startDate.setHours(randomHour, randomMinute, 0, 0); // Set the start time with random HH:MM:SS

  // Set end time to 15 minutes after start
  const endDate = new Date(startDate);
  endDate.setMinutes(endDate.getMinutes() + 15); // Add 15 minutes to the end time

  // Format dates to 'YYYY-MM-DD HH:mm:ss'
  appointment.value.start = `${startDate.getFullYear()}-${(startDate.getMonth() + 1)
    .toString()
    .padStart(2, "0")}-${startDate
    .getDate()
    .toString()
    .padStart(2, "0")} ${startDate
    .getHours()
    .toString()
    .padStart(2, "0")}:${startDate
    .getMinutes()
    .toString()
    .padStart(2, "0")}:${startDate.getSeconds().toString().padStart(2, "0")}`;

  appointment.value.end = `${endDate.getFullYear()}-${(endDate.getMonth() + 1)
    .toString()
    .padStart(2, "0")}-${endDate
    .getDate()
    .toString()
    .padStart(2, "0")} ${endDate
    .getHours()
    .toString()
    .padStart(2, "0")}:${endDate
    .getMinutes()
    .toString()
    .padStart(2, "0")}:${endDate.getSeconds().toString().padStart(2, "0")}`;

  try {
    // Log the data being sent to ensure all required fields are included
    // console.log("Submitting appointment data:", appointment.value);
    const response = await axiosInstance.post("/appointments", appointment.value);
    emit("submitted", response.data); // You may modify this based on your response structure
    console.log(response.data);
    eventBus.emit("show-toast", {
      severity: "success",
      summary: "Appointment Created",
      detail: `Appointment for ${selectedPet.value.name} added successfully.`,
      life: 5000,
    });
    // Reset the form or redirect as needed
  } catch (error) {
    // Log the error response to see the validation errors
    console.error("Error response:", error);
    eventBus.emit("show-toast", {
      severity: "error",
      summary: "Error",
      detail: error.response?.data?.message || "Failed to create appointment.",
      life: 5000,
    });
  }
};

// Load pets when component is mounted
onMounted(() => {
  appointment.value.start = props.activeDate;
  appointment.value.end = props.activeDate;
  setRandomTime();
  fetchPets();
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
