<template>
  <div class="w-full lg:text-[14px]">
    <form @submit.prevent="submitForm" class="mt-8 mx-auto w-4/5">
      <fieldset
        class="p-fieldset p-component w-full flex flex-wrap gap-4 items-center border rounded-lg p-4"
      >
        <legend>
          {{ owners.name }} <i class="pi pi-angle-double-right"></i>
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
              dateFormat="yy-mm-dd"
            />
            <label for="dob"
              >{{ $t("pet_form.fields.date_of_birth") }}
              <span class="text-red-600">*</span></label
            >
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
        <Button type="submit" :label="$t('pet_form.buttons.submit')" />
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
import Message from "primevue/message";
import axiosInstance from "@/axios"; // Assuming you've created a global axios instance
import eventBus from "@/eventBus";
import router from "@/router";
import { useRoute } from "vue-router";
import Cookies from "js-cookie";
import { useI18n } from "vue-i18n";

const { t } = useI18n();
const route = useRoute();
const emit = defineEmits(["submitted"]); // Define the event to be emitted
const invalid = ref({ pet: {} });
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
  {
    label: t("behavior.Escape_Risk"),
    value: "Escape_Risk",
    en_label: "Escape Risk",
  },
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
const owners = ref([]);
const ownerid = route.params.ownerid;
const filteredOwners = ref([]);
const getYesNoLabel = (value) => {
  const foundSpecies = yesno.value.find((s) => s.value === value);
  return foundSpecies ? foundSpecies.label : value;
};
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
  neutered: "No",
  deceased: "No",
  allergies: "",
});
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
    invalid.value.pet = {
    owner_id: pet.value.owner_id === null ? true : false,
    name: pet.value.name === "" ? true : false,
    species: pet.value.species === "" ? true : false,
    gender: pet.value.gender === "" ? true : false,
    date_of_birth: pet.value.date_of_birth === "" ? true : false,
    behaviour: pet.value.behaviour === "" ? true : false,
    neutered: pet.value.neutered === "" ? true : false,
    deceased: pet.value.deceased === "" ? true : false,
  };
  if (invalid.value.pet.owner_id ||invalid.value.pet.name ||invalid.value.pet.species ||invalid.value.pet.gender ||invalid.value.pet.date_of_birth ||invalid.value.pet.behaviour ||invalid.value.pet.neutered ||invalid.value.pet.deceased) {
    return
  }
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
    console.log(error)
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
