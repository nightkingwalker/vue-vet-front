<template>
  <div class="w-full">
    <form @submit.prevent="submitForm" class="mx-auto w-full">
      <fieldset
        class="p-fieldset p-component w-4/5 flex flex-wrap mx-auto gap-2 items-start border rounded-lg p-4"
      >
        <legend>Edit Appointment</legend>
        <input type="hidden" id="branch_id" value="1" v-model="appointment.branch_id" />
        <input type="hidden" id="appointment_id" v-model="appointment.id" />

        <div class="field mt-6 w-[48%]" :class="appointment.petmicrochip ? `hidden` : ``">
          <FloatLabel class="w-full" v-if="!appointment.petmicrochip">
            <InputGroup class="flex rounded-md overflow-hidden">
              <AutoComplete
                v-model="selectedPet"
                optionLabel="name"
                :suggestions="filteredPets"
                @complete="searchPets"
                class="w-full"
                fluid
              >
                <template #option="slotProps">
                  <div class="flex items-center">
                    <div>{{ slotProps.option.name }}</div>
                  </div>
                </template>
              </AutoComplete>
              <InputGroupAddon
                class="!bg-transparent px-4 flex flex-col item-center justify-center"
                ><i class="pi pi-search"></i
              ></InputGroupAddon>
            </InputGroup>
            <label for="pet">Search Pets</label>
          </FloatLabel>
          <InputText
            id="name"
            v-model="selectedPet"
            class="hidden"
            v-else
            placeholder="Enter pet name"
          />
        </div>

        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <InputText id="title" v-model="appointment.title" fluid />
            <label for="title">Title</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <Textarea
              id="description"
              v-model="appointment.description"
              fluid
              autoResize
              rows="2"
            />
            <label for="description">Description</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <DatePicker
              id="start"
              showTime
              hourFormat="24"
              fluid
              v-model="appointment.start"
              dateFormat="yy-mm-dd"
              class="w-full"
            />
            <label for="start">Start Date & Time</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <label for="end">End Date & Time</label>
            <DatePicker
              showTime
              hourFormat="24"
              id="end"
              v-model="appointment.end"
              dateFormat="yy-mm-dd"
              class="w-full"
            />
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <Select
              v-model="appointment.type"
              :options="appointmentTypes"
              optionLabel="label"
              class="w-full"
            />
            <label for="type">Type</label>
          </FloatLabel>
        </div>
        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <Select
              v-model="appointment.status"
              :options="appointmentStatus"
              optionLabel="label"
              class="w-full"
            />
            <label for="status">Status</label>
          </FloatLabel>
        </div>

        <Button type="submit" label="Update" class="mt-4" />
      </fieldset>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from "vue";
import AutoComplete from "primevue/autocomplete";
import InputGroup from "primevue/inputgroup";
import InputText from "primevue/inputtext";
import DatePicker from "primevue/datepicker";
import Select from "primevue/select";
import FloatLabel from "primevue/floatlabel";
import Button from "primevue/button";
import Textarea from "primevue/textarea";
import axiosInstance from "@/axios"; // Assuming you've created a global axios instance
import eventBus from "@/eventBus";
import Cookies from "js-cookie";
const emit = defineEmits(["updated"]); // Define the event to be emitted

const props = defineProps({
  appointmentId: {
    type: Number,
    required: true,
  },
});
// console.log(props.appointmentId);
const appointment = ref({
  id: null,
  client_id: null,
  branch_id: Cookies.get("M3K8g2387BahBaqyjDe6"),
  title: "",
  description: "",
  type: "",
  start: null,
  end: null,
  status: "",
});

const selectedPet = ref(null);
const filteredPets = ref([]);
const appointmentTypes = ref([
  { label: "Emergency", value: "Emergency" },
  { label: "Non-Emergency", value: "Non-Emergency" },
  { label: "Regular", value: "Regular" },
  { label: "FollowUp", value: "FollowUp" },
  { label: "Surgery", value: "Surgery" },
  { label: "Grooming", value: "Grooming" },
]);
const appointmentStatus = ref([
  { label: "Scheduled", value: "Scheduled" },
  { label: "Walkin", value: "Walkin" },
]);

// Fetch appointment data by ID
// const fetchAppointment = async () => {
//   try {
//     const response = await axiosInstance.get(`/appointments/${props.appointmentId}`);
//     appointment.value = response.data;
//     selectedPet.value = response.data.pet; // Set the selected pet
//   } catch (error) {
//     console.error("Failed to fetch appointment:", error);
//   }
// };
const fetchAppointment = async () => {
  try {
    const response = await axiosInstance.get(`/appointments/${props.appointmentId}`);
    const data = response.data;

    // Map the type and status to match the Select component's structure
    appointment.value = {
      ...data,
      type: appointmentTypes.value.find((type) => type.value === data.type),
      status: appointmentStatus.value.find((status) => status.value === data.status),
    };

    selectedPet.value = data.pet; // Set the selected pet
  } catch (error) {
    console.error("Failed to fetch appointment:", error);
  }
};
// Fetch pets for the autocomplete
const fetchPets = async () => {
  try {
    const response = await axiosInstance.get("/pets");
    filteredPets.value = response.data.data;
  } catch (error) {
    console.error("Failed to fetch pets:", error);
  }
};

// Search function for AutoComplete
const searchPets = async (event) => {
  if (event.query.length < 3) return;
  try {
    const response = await axiosInstance.get(`/pets?search=${event.query}`);
    filteredPets.value = response.data.data;
  } catch (error) {
    console.error("Failed to search pets:", error);
  }
};

// Form submission
const submitForm = async () => {
  if (!selectedPet.value) {
    eventBus.emit("show-toast", {
      severity: "warn",
      summary: "Error",
      detail: "Please select a pet.",
      life: 5000,
    });
    return;
  }

  appointment.value.client_id = selectedPet.value.owner_id;
  appointment.value.pet_id = selectedPet.value.id;
  appointment.value.type = appointment.value.type.value;
  appointment.value.status = appointment.value.status.value;
  // console.log(appointment.value);
  try {
    const response = await axiosInstance.put(
      `/appointments/${appointment.value.id}`,
      appointment.value
    );
    emit("updated", response.data); // Emit event to notify parent component
    eventBus.emit("show-toast", {
      severity: "success",
      summary: "Appointment Updated",
      detail: `Appointment for ${selectedPet.value.name} updated successfully.`,
      life: 5000,
    });
  } catch (error) {
    console.error("Error updating appointment:", error);
    eventBus.emit("show-toast", {
      severity: "error",
      summary: "Error",
      detail: error.response?.data?.message || "Failed to update appointment.",
      life: 5000,
    });
  }
};

// Load appointment and pets when component is mounted
onMounted(() => {
  fetchAppointment();
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
