<template>
  <div class="w-full lg:text-[14px]">
    <form @submit.prevent="submitForm" class="mx-auto w-full">
      <fieldset
        class="p-fieldset p-component w-4/5 flex flex-wrap gap-4 items-start mx-auto items-top border rounded-lg p-4">
        <legend>{{ $t("pet_form.title") }}</legend>
        <input type="hidden" id="branch_id" value="1" v-model="pet.branch_id" />

        <!-- Select Owner -->
        <div class="field mt-3 w-[48%]">
          <FloatLabel class="w-full">
            <AutoComplete autoFocus fluid required :invalid="invalid.pet.owner_id" v-model="pet.owner_id"
              optionLabel="name" :suggestions="filteredOwners" @complete="searchOwners" class="w-full">
              <template #option="slotProps">
                <div class="flex items-center">
                  <div>{{ slotProps.option.name }}</div>
                </div>
              </template>
              <template #footer>
                <Button :label="$t('pet_form.buttons.add_new_owner')" icon="pi pi-plus" @click="addNewOwner"
                  class="p-button-text w-full" />
              </template>
            </AutoComplete>
            <label for="owner">{{ $t("pet_form.fields.select_owner") }}
              <span class="text-red-600">*</span></label>
          </FloatLabel>
          <span class="text-[10px] text-red-600" v-if="invalid.pet.owner_id">{{
            $t("form_messages.warnings.invalid_input")
          }}</span>
        </div>

        <div class="field mt-3 w-[48%]">
          <FloatLabel class="w-full">
            <InputText fluid id="name" v-model="pet.name" required :invalid="invalid.pet.name" />
            <label for="name">{{ $t("pet_form.fields.name") }} <span class="text-red-600">*</span></label>
          </FloatLabel>
          <span class="text-[10px] text-red-600" v-if="invalid.pet.name">{{
            $t("form_messages.warnings.invalid_input")
          }}</span>
        </div>
        <div class="field mt-3 w-[48%]">
          <FloatLabel class="w-full">
            <Select required :invalid="invalid.pet.species" fluid v-model="pet.species" :options="species"
              optionLabel="label" optionValue="value" class="w-full h-10" />
            <label for="dd-city">{{ $t("pet_form.fields.select_species") }}
              <span class="text-red-600">*</span></label>
          </FloatLabel>
          <span class="text-[10px] text-red-600" v-if="invalid.pet.species">{{
            $t("form_messages.warnings.invalid_input")
          }}</span>
        </div>
        <div class="field mt-3 w-[48%]">
          <FloatLabel class="w-full">
            <Select id="breed" v-if="pet.species === 'Canine'" fluid v-model="pet.breed" :options="dogsOptions"
              optionLabel="label" optionValue="value" class="w-full h-10" />
            <Select id="breed" v-else-if="pet.species === 'Feline'" fluid v-model="pet.breed" :options="catsOptions"
              optionLabel="label" optionValue="value" class="w-full h-10" />
            <InputText v-else fluid id="breed" v-model="pet.breed" />


            <label for="dd-city">{{ $t("pet_form.fields.breed") }}</label>
          </FloatLabel>
        </div>
        <div class="field mt-3 w-[48%]">
          <FloatLabel class="w-full">
            <Select id="gender" required :invalid="invalid.pet.gender" fluid v-model="pet.gender" :options="genders"
              optionLabel="label" optionValue="value" class="w-full h-10" />
            <label for="gender">{{ $t("pet_form.fields.select_gender") }}
              <span class="text-red-600">*</span></label>
          </FloatLabel>
          <span class="text-[10px] text-red-600" v-if="invalid.pet.gender">{{
            $t("form_messages.warnings.invalid_input")
          }}</span>
        </div>
        <div class="field mt-3 w-[48%]">
          <FloatLabel class="w-full">
            <DatePicker showIcon required :invalid="invalid.pet.date_of_birth" iconDisplay="input" showButtonBar
              hourFormat="12" fluid id="dob" class="w-full" v-model="pet.date_of_birth" dateFormat="yy-mm-d" />
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
            <Select v-model="pet.behaviour" :options="behaviorOptions" required :invalid="invalid.pet.behaviour"
              optionLabel="label" optionValue="value" class="w-full h-10" />
            <label for="behaviour">{{ $t("pet_form.fields.behaviour") }}
              <span class="text-red-600">*</span></label>
          </FloatLabel>
          <span class="text-[10px] text-red-600" v-if="invalid.pet.behaviour">{{
            $t("form_messages.warnings.invalid_input")
          }}</span>
        </div>

        <!-- Neutered -->
        <div class="field mt-3 w-[48%]">
          <FloatLabel class="w-full">
            <Select fluid v-model="pet.neutered" required :invalid="invalid.pet.neutered" :options="yesno"
              optionLabel="label" optionValue="value" class="w-full h-10" />
            <label for="neutered">{{ $t("pet_form.fields.neutered") }}
              <span class="text-red-600">*</span></label>
          </FloatLabel>
          <span class="text-[10px] text-red-600" v-if="invalid.pet.neutered">{{
            $t("form_messages.warnings.invalid_input")
          }}</span>
        </div>

        <!-- Deceased -->
        <div class="field mt-3 w-[48%]">
          <FloatLabel class="w-full">
            <Select fluid required :invalid="invalid.pet.deceased" v-model="pet.deceased" :options="yesno"
              optionLabel="label" optionValue="value" class="w-full h-10" />
            <label for="deceased">{{ $t("pet_form.fields.deceased") }}
              <span class="text-red-600">*</span></label>
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
        <!-- Submit Button -->
        <Button type="submit" :disabled="isSubmitting ? true : false">
          <i class="fa-solid fa-spinner fa-spin" v-if="isSubmitting"></i>
          <span v-else>{{ $t("pet_form.buttons.submit") }}</span>
        </Button>
      </fieldset>
    </form>
  </div>
</template>

<script setup>
import axiosInstance from "@/axios";
import eventBus from "@/eventBus";
import router from "@/router";
import Cookies from "js-cookie";
import AutoComplete from "primevue/autocomplete";
import Button from "primevue/button";
import DatePicker from "primevue/datepicker";
import FloatLabel from "primevue/floatlabel";
import InputText from "primevue/inputtext";
import Select from "primevue/select";
import Textarea from "primevue/textarea";
import { onBeforeUnmount, onMounted, ref } from "vue";
import { useI18n } from "vue-i18n";

const { t } = useI18n();
const emit = defineEmits(["submitted"]); // Define the event to be emitted
const isModalOwnerVisible = ref(false);
const invalid = ref({ pet: {} });
const isSubmitting = ref(false);
const pet = ref({
  owner_id: null,
  branch_id: Cookies.get("M3K8g2387BahBaqyjDe6"),
  name: "",
  species: "",
  breed: "",
  gender: "",
  date_of_birth: null,
  color: "",
  distinctive_marks: "",
  behaviour: "",
  neutered: "",
  deceased: "",
  allergies: "",
});
const yesno = ref([
  { label: t("pet_form.options.yes"), value: "Yes" },
  { label: t("pet_form.options.no"), value: "No" },
]);
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
const catsOptions = ref([
  { label: t("catBreeds.Bengal"), value: "Bengal", en_label: "Bengal" },
  { label: t("catBreeds.British Shorthair"), value: "British Shorthair", en_label: "British Shorthair" },
  { label: t("catBreeds.Domestick"), value: "Domestick", en_label: "Domestick" },
  { label: t("catBreeds.Exotic"), value: "Exotic", en_label: "Exotic" },
  { label: t("catBreeds.Himalayan"), value: "Himalayan", en_label: "Himalayan" },
  { label: t("catBreeds.Himalayan Blue"), value: "Himalayan Blue", en_label: "Himalayan Blue" },
  { label: t("catBreeds.Himalayan Chocolate"), value: "Himalayan Chocolate", en_label: "Himalayan Chocolate" },
  { label: t("catBreeds.Himalayan Orange"), value: "Himalayan Orange", en_label: "Himalayan Orange" },
  { label: t("catBreeds.Maine Coon"), value: "Maine Coon", en_label: "Maine Coon" },
  { label: t("catBreeds.Manx"), value: "Manx", en_label: "Manx" },
  { label: t("catBreeds.Mix"), value: "Mix", en_label: "Mix" },
  { label: t("catBreeds.Other"), value: "Other", en_label: "Other" },
  { label: t("catBreeds.Persian"), value: "Persian", en_label: "Persian" },
  { label: t("catBreeds.Ragdoll"), value: "Ragdoll", en_label: "Ragdoll" },
  { label: t("catBreeds.Russian Blue"), value: "Russian Blue", en_label: "Russian Blue" },
  { label: t("catBreeds.Scottish Fold"), value: "Scottish Fold", en_label: "Scottish Fold" },
  { label: t("catBreeds.Shanshalla"), value: "Shanshalla", en_label: "Shanshalla" },
  { label: t("catBreeds.Siamese"), value: "Siamese", en_label: "Siamese" },
  { label: t("catBreeds.Siberian"), value: "Siberian", en_label: "Siberian" },
  { label: t("catBreeds.Sphynx"), value: "Sphynx", en_label: "Sphynx" },
  { label: t("catBreeds.Turkish Angora"), value: "Turkish Angora", en_label: "Turkish Angora" },
  { label: t("catBreeds.Turkish Van"), value: "Turkish Van", en_label: "Turkish Van" }
]);


const dogsOptions = ref([
  { label: t("dogBreeds.Akita"), value: "Akita", en_label: "Akita" },
  { label: t("dogBreeds.Basset-Houn"), value: "Basset-Houn", en_label: "Basset-Houn" },
  { label: t("dogBreeds.Beagle"), value: "Beagle", en_label: "Beagle" },
  { label: t("dogBreeds.Border Collie"), value: "Border Collie", en_label: "Border Collie" },
  { label: t("dogBreeds.Boxer"), value: "Boxer", en_label: "Boxer" },
  { label: t("dogBreeds.Chihuahua"), value: "Chihuahua", en_label: "Chihuahua" },
  { label: t("dogBreeds.Chow Chow"), value: "Chow Chow", en_label: "Chow Chow" },
  { label: t("dogBreeds.Cocker Spaniel"), value: "Cocker Spaniel", en_label: "Cocker Spaniel" },
  { label: t("dogBreeds.Collie"), value: "Collie", en_label: "Collie" },
  { label: t("dogBreeds.Dalmatian"), value: "Dalmatian", en_label: "Dalmatian" },
  { label: t("dogBreeds.Doberman"), value: "Doberman", en_label: "Doberman" },
  { label: t("dogBreeds.Domestick"), value: "Domestick", en_label: "Domestick" },
  { label: t("dogBreeds.English Bulldog"), value: "English Bulldog", en_label: "English Bulldog" },
  { label: t("dogBreeds.German Shepherd"), value: "German Shepherd", en_label: "German Shepherd" },
  { label: t("dogBreeds.Golden Retriever"), value: "Golden Retriever", en_label: "Golden Retriever" },
  { label: t("dogBreeds.Great Dane"), value: "Great Dane", en_label: "Great Dane" },
  { label: t("dogBreeds.Labrador Retriever"), value: "Labrador Retriever", en_label: "Labrador Retriever" },
  { label: t("dogBreeds.Malinois"), value: "Malinois", en_label: "Malinois" },
  { label: t("dogBreeds.Maltese"), value: "Maltese", en_label: "Maltese" },
  { label: t("dogBreeds.Other"), value: "Other", en_label: "Other" },
  { label: t("dogBreeds.Pekingese"), value: "Pekingese", en_label: "Pekingese" },
  { label: t("dogBreeds.Pit Bull"), value: "Pit Bull", en_label: "Pit Bull" },
  { label: t("dogBreeds.Pointer"), value: "Pointer", en_label: "Pointer" },
  { label: t("dogBreeds.Pomeranian"), value: "Pomeranian", en_label: "Pomeranian" },
  { label: t("dogBreeds.Poodle"), value: "Poodle", en_label: "Poodle" },
  { label: t("dogBreeds.Pug"), value: "Pug", en_label: "Pug" },
  { label: t("dogBreeds.Rottweiler"), value: "Rottweiler", en_label: "Rottweiler" },
  { label: t("dogBreeds.Saluki"), value: "Saluki", en_label: "Saluki" },
  { label: t("dogBreeds.Siberian Husky"), value: "Siberian Husky", en_label: "Siberian Husky" },
  { label: t("dogBreeds.Yorkshire Terrier"), value: "Yorkshire Terrier", en_label: "Yorkshire Terrier" }
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
const filteredOwners = ref([]);

// Fetch owners from the API
async function fetchOwners() {
  try {
    const response = await axiosInstance.get("/owners");
    
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
  if (isSubmitting.value) return;
  invalid.value.pet = {
    owner_id: pet.value.owner_id === null ? true : false,
    name: pet.value.name === "" ? true : false,
    species: pet.value.species === "" ? true : false,
    gender: pet.value.gender === "" ? true : false,
    // date_of_birth: pet.value.date_of_birth === "" ? true : false,
    behaviour: pet.value.behaviour === "" ? true : false,
    neutered: pet.value.neutered === "" ? true : false,
    deceased: pet.value.deceased === "" ? true : false,
  };
  if (
    invalid.value.pet.owner_id ||
    invalid.value.pet.name ||
    invalid.value.pet.species ||
    invalid.value.pet.gender ||
    // invalid.value.pet.date_of_birth ||
    invalid.value.pet.behaviour ||
    invalid.value.pet.neutered ||
    invalid.value.pet.deceased
  ) {
    return;
  }
  const submissionData = {
    owner_id: pet.value.owner_id.id,
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

   // Verify the structure
  
  try {
    isSubmitting.value = true;
    const response = await axiosInstance.post("/pets", submissionData);
    emit("submitted", response.data); // You may modify this based on your response structure

    
    eventBus.emit("show-toast", {
      severity: "success",
      summary: t("pet_form.toast.success"),
      detail: t("pet_form.toast.success"),
      life: 5000,
    });
    isSubmitting.value = false;
    router.push("/pets");
  } catch (error) {
    eventBus.emit("show-toast", {
      severity: "warn",
      summary: "Error",
      detail: error,
      life: 5000,
    });
    isSubmitting.value = false;
  } finally {
  }
};

// Load owners when component is mounted
onMounted(() => {
  fetchOwners();
  eventBus.on("ownerAdded", (event) => {
    
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
