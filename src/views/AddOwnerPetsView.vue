<template>
  <div class="w-full lg:text-[14px]">
    <p class="text-sm text-gray-600 dark:text-gray-400">{{ statusMessage }}</p>

    <form @submit.prevent="submitForm" class="mt-8 mx-auto w-4/5">
      <fieldset
        class="p-fieldset p-component w-full flex flex-wrap gap-4 items-center border rounded-lg p-4"
      >
        <legend>
          {{ props.ownername }} <i class="pi pi-angle-double-right"></i>
          {{ $t("pet_form.title") }}
        </legend>
        <input type="hidden" id="branch_id" value="1" v-model="pet.branch_id" />
        <div class="field mt-3 w-[48%]">
          <FloatLabel class="w-full">
            <InputText
              fluid
              id="name"
              v-model="pet.name"
              required
              :invalid="invalid.pet.name"
            />
            <label for="name"
              >{{ $t("pet_form.fields.name") }} <span class="text-red-600">*</span></label
            >
          </FloatLabel>
          <span class="text-[10px] text-red-600" v-if="invalid.pet.name">{{
            $t("form_messages.warnings.invalid_input")
          }}</span>
        </div>
        <div class="field mt-3 w-[48%]">
          <FloatLabel class="w-full">
            <Select
              required
              :invalid="invalid.pet.species"
              fluid
              v-model="pet.species"
              :options="species"
              optionLabel="label"
              optionValue="value"
              class="w-full h-10"
            />
            <label for="dd-city"
              >{{ $t("pet_form.fields.select_species") }}
              <span class="text-red-600">*</span></label
            >
          </FloatLabel>
          <span class="text-[10px] text-red-600" v-if="invalid.pet.species">{{
            $t("form_messages.warnings.invalid_input")
          }}</span>
        </div>
        <div class="field mt-3 w-[48%]">
          <FloatLabel class="w-full">
            <InputText fluid id="breed" v-model="pet.breed" />
            <label for="dd-city">{{ $t("pet_form.fields.breed") }}</label>
          </FloatLabel>
        </div>
        <div class="field mt-3 w-[48%]">
          <FloatLabel class="w-full">
            <Select
              id="gender"
              required
              :invalid="invalid.pet.gender"
              fluid
              v-model="pet.gender"
              :options="genders"
              optionLabel="label"
              optionValue="value"
              class="w-full h-10"
            />
            <label for="gender"
              >{{ $t("pet_form.fields.select_gender") }}
              <span class="text-red-600">*</span></label
            >
          </FloatLabel>
          <span class="text-[10px] text-red-600" v-if="invalid.pet.gender">{{
            $t("form_messages.warnings.invalid_input")
          }}</span>
        </div>
        <div class="field mt-3 w-[48%]">
          <FloatLabel class="w-full">
            <DatePicker
              showIcon
              required
              :invalid="invalid.pet.date_of_birth"
              iconDisplay="input"
              showButtonBar
              hourFormat="12"
              fluid
              id="dob"
              class="w-full"
              v-model="pet.date_of_birth"
              dateFormat="yy-mm-d"
            />
            <label for="dob">{{ $t("pet_form.fields.date_of_birth") }} </label>
          </FloatLabel>
          <span class="text-[10px] text-red-600" v-if="invalid.pet.date_of_birth">{{
            $t("form_messages.warnings.invalid_input")
          }}</span>
        </div>
        <!-- Color -->
        <div class="field mt-3 w-[48%]">
          <FloatLabel class="w-full">
            <InputText fluid id="color" v-model="pet.color" />
            <label for="color">{{ $t("pet_form.fields.color") }}</label>
          </FloatLabel>
        </div>

        <!-- Distinctive Marks -->
        <div class="field mt-3 w-[48%]">
          <FloatLabel class="w-full">
            <InputText fluid id="distinctive_marks" v-model="pet.distinctive_marks" />
            <label for="distinctive_marks">{{
              $t("pet_form.fields.distinctive_marks")
            }}</label>
          </FloatLabel>
        </div>

        <!-- Behaviour -->
        <div class="field mt-3 w-[48%]">
          <FloatLabel class="w-full">
            <Select
              v-model="pet.behaviour"
              :options="behaviorOptions"
              required
              :invalid="invalid.pet.behaviour"
              optionLabel="label"
              optionValue="value"
              class="w-full h-10"
            />
            <label for="behaviour"
              >{{ $t("pet_form.fields.behaviour") }}
              <span class="text-red-600">*</span></label
            >
          </FloatLabel>
          <span class="text-[10px] text-red-600" v-if="invalid.pet.behaviour">{{
            $t("form_messages.warnings.invalid_input")
          }}</span>
        </div>

        <!-- Neutered -->
        <div class="field mt-3 w-[48%]">
          <FloatLabel class="w-full">
            <Select
              fluid
              v-model="pet.neutered"
              required
              :invalid="invalid.pet.neutered"
              :options="yesno"
              optionLabel="label"
              optionValue="value"
              class="w-full h-10"
            />
            <label for="neutered"
              >{{ $t("pet_form.fields.neutered") }}
              <span class="text-red-600">*</span></label
            >
          </FloatLabel>
          <span class="text-[10px] text-red-600" v-if="invalid.pet.neutered">{{
            $t("form_messages.warnings.invalid_input")
          }}</span>
        </div>

        <!-- Deceased -->
        <div class="field mt-3 w-[48%]">
          <FloatLabel class="w-full">
            <Select
              fluid
              required
              :invalid="invalid.pet.deceased"
              v-model="pet.deceased"
              :options="yesno"
              optionLabel="label"
              optionValue="value"
              class="w-full h-10"
            />
            <label for="deceased"
              >{{ $t("pet_form.fields.deceased") }}
              <span class="text-red-600">*</span></label
            >
          </FloatLabel>
          <span class="text-[10px] text-red-600" v-if="invalid.pet.deceased">{{
            $t("form_messages.warnings.invalid_input")
          }}</span>
        </div>

        <!-- Allergies -->
        <div class="field mt-3 w-full">
          <FloatLabel class="w-full">
            <Textarea fluid id="allergies" v-model="pet.allergies" />
            <label for="allergies">{{ $t("pet_form.fields.allergies") }}</label>
          </FloatLabel>
        </div>
        <Button type="submit" :disabled="isSubmitting ? true : false">
          <i class="fa-solid fa-spinner fa-spin" v-if="isSubmitting"></i>
          <span v-else>{{ $t("pet_form.buttons.submit") }}</span>
        </Button>
      </fieldset>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted, getCurrentInstance } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useI18n } from "vue-i18n";
import Cookies from "js-cookie";
import axiosInstance from "@/axios";
import eventBus from "@/eventBus";
import { useToast } from "primevue/usetoast";
// PrimeVue Components
import InputText from "primevue/inputtext";
import Textarea from "primevue/textarea";
import DatePicker from "primevue/datepicker";
import Fieldset from "primevue/fieldset";
import Select from "primevue/select";
import FloatLabel from "primevue/floatlabel";
import Button from "primevue/button";
import Message from "primevue/message";

//Local Database
// import { startMonitoring, getOnlineStatus } from "@/utils/connectivity"; // Adjust path if needed
// import { addToQueue } from "@/utils/offlineQueue";
// Initialize i18n and router

const toast = useToast();
const { t } = useI18n();
const route = useRoute();
const router = useRouter();
const isSubmitting = ref(false);
const isOnline = ref(true);
const statusMessage = ref("");
// Define emitted events
const emit = defineEmits(["submitted"]);
const props = defineProps({
  ownername: {
    type: String,
    required: true,
  },
});
// Form validation state
const invalid = ref({ pet: {} });
// Access global properties
const { proxy } = getCurrentInstance();
const { $connectivity, $offlineQueue } = proxy;
// Dropdown options
// const species = ref([
//   { label: t("species.avian"), en_label: "Avian", value: "Birds", icon: "fa-solid fa-dove" },
//   { label: t("species.bovine"), en_label: "Bovine", value: "Cows", icon: "fa-solid fa-cow" },
//   { label: t("species.camelid"), en_label: "Camelid", value: "Camels", icon: "fa-solid fa-paw" },
//   { label: t("species.canine"), en_label: "Canine", value: "Dogs", icon: "fa-solid fa-dog" },
//   { label: t("species.caprine"), en_label: "Caprine", value: "Goats", icon: "fa-solid fa-paw" },
//   { label: t("species.cavies"), en_label: "Cavies", value: "Guinea Pigs", icon: "fa-solid fa-paw" },
//   { label: t("species.cervidae"), en_label: "Cervidae", value: "Deers", icon: "fa-solid fa-paw" },
//   { label: t("species.equine"), en_label: "Equine", value: "Horses", icon: "fa-duotone fa-horse" },
//   { label: t("species.feline"), en_label: "Feline", value: "Cats", icon: "fa-solid fa-cat" },
//   { label: t("species.lapine"), en_label: "Lapine", value: "Rabbits", icon: "fa-solid fad fa-rabbit" },
//   { label: t("species.murine"), en_label: "Murine", value: "Mice", icon: "fa-solid fa-paw" },
//   { label: t("species.ovine"), en_label: "Ovine", value: "Sheeps", icon: "fa-solid fa-sheep" },
// ]);
const species = ref([
  {
    label: t("species.avian"),
    value: "Avian",
    en_label: "Birds",
    icon: "fa-solid fa-dove",
  },
  // {
  //   label: t("species.bovine"),
  //   value: "Bovine",
  //   en_label: "Cows",
  //   icon: "fa-solid fa-cow",
  // },
  // {
  //   label: t("species.camelid"),
  //   value: "Camelid",
  //   en_label: "Camels",
  //   icon: "fa-solid fa-paw",
  // },
  {
    label: t("species.canine"),
    value: "Canine",
    en_label: "Dogs",
    icon: "fa-solid fa-dog",
  },
  // {
  //   label: t("species.caprine"),
  //   value: "Caprine",
  //   en_label: "Goats",
  //   icon: "fa-solid fa-paw",
  // },
  {
    label: t("species.cavies"),
    value: "Cavies",
    en_label: "Guinea Pigs",
    icon: "fa-solid fa-paw",
  },
  // {
  //   label: t("species.cervidae"),
  //   value: "Cervidae",
  //   en_label: "Deers",
  //   icon: "fa-solid fa-paw",
  // },
  // {
  //   label: t("species.equine"),
  //   value: "Equine",
  //   en_label: "Horses",
  //   icon: "fa-duotone fa-horse",
  // },
  {
    label: t("species.feline"),
    value: "Feline",
    en_label: "Cats",
    icon: "fa-solid fa-cat",
  },
  {
    label: t("species.testudines"),
    value: "Testudines",
    en_label: "Turtles",
    icon: "fa-solid fa-cat",
  },
  {
    label: t("species.lapine"),
    value: "Lapine",
    en_label: "Rabbits",
    icon: "fa-solid fad fa-rabbit",
  },
  {
    label: t("species.murine"),
    value: "Murine",
    en_label: "Mice",
    icon: "fa-solid fa-paw",
  },
  // {
  //   label: t("species.ovine"),
  //   value: "Ovine",
  //   en_label: "Sheeps",
  //   icon: "fa-solid fa-sheep",
  // },
]);

const yesno = ref([
  { label: t("pet_form.options.yes"), value: "Yes" },
  { label: t("pet_form.options.no"), value: "No" },
]);

const behaviorOptions = ref([
  { label: t("behavior.Friendly"), value: "Friendly", en_label: "Friendly" },
  { label: t("behavior.Fearful"), value: "Fearful", en_label: "Fearful" },
  { label: t("behavior.Aggressive"), value: "Aggressive", en_label: "Aggressive" },
  {
    label: t("behavior.Fear_Aggression"),
    value: "Fear_Aggression",
    en_label: "Fear Induces Aggression",
  },
  { label: t("behavior.Nervous"), value: "Nervous", en_label: "Nervous" },
  { label: t("behavior.Submissive"), value: "Submissive", en_label: "Submissive" },
  {
    label: t("behavior.Needs_Sedation"),
    value: "Needs_Sedation",
    en_label: "Needs Sedation",
  },
  { label: t("behavior.Biter"), value: "Biter", en_label: "Biter" },
  {
    label: t("behavior.Muzzle_Required"),
    value: "Muzzle_Required",
    en_label: "Muzzle Required",
  },
  { label: t("behavior.Escape_Risk"), value: "Escape_Risk", en_label: "Escape Risk" },
  {
    label: t("behavior.Urinates"),
    value: "Urinates",
    en_label: "Urinates/Defecates from Stress",
  },
]);

const genders = ref([
  { label: t("pet_form.options.male"), value: "Male" },
  { label: t("pet_form.options.female"), value: "Female" },
]);

// Owner data
// const owners = ref([]);
const ownerid = route.params.ownerid;
// const filteredOwners = ref([]);

// Pet form data model
const pet = ref({
  owner_id: route.params.ownerid,
  branch_id: Cookies.get("M3K8g2387BahBaqyjDe6"),
  name: "",
  species: "",
  breed: "",
  gender: "",
  date_of_birth: null,
  color: "",
  distinctive_marks: "",
  behaviour: "",
  neutered: "No",
  deceased: "No",
  allergies: "",
});

/**
 * Helper function to get Yes/No label
 * @param {string} value - The value to find
 * @returns {string} The corresponding label
 */
const getYesNoLabel = (value) => {
  const foundSpecies = yesno.value.find((s) => s.value === value);
  return foundSpecies ? foundSpecies.label : value;
};

/**
 * Fetches owners from the API
 */
async function fetchOwners() {
  if (isSubmitting.value) return;
  try {
    isSubmitting.value = true;
    const response = await axiosInstance.get("/owners/" + ownerid);
    owners.value = response.data;
    isSubmitting.value = false;
  } catch (error) {
    console.error("Failed to fetch owners:", error);
    eventBus.emit("show-toast", {
      severity: "error",
      summary: "Error",
      detail: "Failed to fetch owner data",
      life: 5000,
    });
    isSubmitting.value = false;
  }
}

/**
 * Searches owners for AutoComplete
 * @param {Object} event - The search event
 */
function searchOwners(event) {
  filteredOwners.value = owners.value.filter((owner) =>
    owner.name.toLowerCase().includes(event.query.toLowerCase())
  );
}

/**
 * Navigates to new owner form
 */
function addNewOwner() {
  router.push("/new-owner");
}

/**
 * Validates and submits the pet form
 */
const submitForm = async () => {
  // Validate required fields
  invalid.value.pet = {
    owner_id: pet.value.owner_id === null,
    name: pet.value.name === "",
    species: pet.value.species === "",
    gender: pet.value.gender === "",
    // date_of_birth: pet.value.date_of_birth === "",
    behaviour: pet.value.behaviour === "",
    neutered: pet.value.neutered === "",
    deceased: pet.value.deceased === "",
  };

  // Check if any field is invalid
  if (Object.values(invalid.value.pet).some(Boolean)) {
    return;
  }

  // Prepare submission data
  const submissionData = {
    owner_id: pet.value.owner_id,
    branch_id: pet.value.branch_id,
    name: pet.value.name,
    species: pet.value.species,
    breed: pet.value.breed,
    gender: pet.value.gender,
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
  const submission = {
    data: submissionData,
    endpoint: "/pets", // Adjust based on your backend route
    method: "POST",
  };
  const online = await $connectivity.getOnlineStatus();
  if (online) {
    try {
      // Disable submit button
      isSubmitting.value = true;
      // Submit data to API
      const response = await axiosInstance.post("/pets", submissionData);

      // Emit success events
      // console.log("submitted", response.data);
      eventBus.emit("show-toast", {
        severity: "success",
        summary: "Success",
        detail: "Pet added successfully",
        life: 5000,
      });
      isSubmitting.value = false;
      // Navigate to pets list
      await router.push(`/pets/${response.data.microchip_num}`);
    } catch (error) {
      // Handle submission error
      eventBus.emit("show-toast", {
        severity: "error",
        summary: "Error",
        detail: error.message || "Failed to add pet",
        life: 5000,
      });
      isSubmitting.value = false;
      console.error("Submission error:", error);
    }
  } else {
    // Use global queue method
    await $offlineQueue.addToQueue(submission);
    emit("submittedOffline");
    toast.add({
      severity: "success",
      summary: "Offline",
      detail:
        "You are offline. Data saved locally and will be submitted later. Please close the dialog",
      life: 5000,
    });

    // await router.push(`/${route.params.ownerid}/pets`);
  }
};

// Fetch owners when component is mounted
// fetchOwners();
onMounted(async () => {
  // Use global connectivity check
  isOnline.value = await $connectivity.getOnlineStatus();
  statusMessage.value = isOnline.value
    ? "Your data is being saved online."
    : "You are offline. Your work will be saved locally and synced later.";
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
