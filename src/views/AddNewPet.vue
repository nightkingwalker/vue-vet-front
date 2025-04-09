<template>
  <div class="w-full">
    <form @submit.prevent="submitForm" class="mx-auto w-full">
      <fieldset
        class="p-fieldset p-component w-4/5 flex flex-wrap mx-auto items-top border rounded-lg p-4"
      >
        <legend>{{ $t("pet_form.title") }}</legend>
        <input type="hidden" id="branch_id" value="1" v-model="pet.branch_id" />

        <!-- Select Owner -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <AutoComplete
              autoFocus
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
                  :label="$t('pet_form.buttons.add_new_owner')"
                  icon="pi pi-plus"
                  @click="addNewOwner"
                  class="p-button-text w-full"
                />
              </template>
            </AutoComplete>
            <label for="owner">{{ $t("pet_form.fields.select_owner") }}</label>
          </FloatLabel>
        </div>

        <!-- Name -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <InputText id="name" class="w-full" v-model="pet.name" />
            <label for="name">{{ $t("pet_form.fields.name") }}</label>
          </FloatLabel>
        </div>

        <!-- Species -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <Select
              v-model="pet.species"
              :options="species"
              optionLabel="label"
              class="w-full h-10"
            >
              <template #value="slotProps">
                <div v-if="slotProps.value" class="flex items-center">
                  <div>{{ slotProps.value.value }}</div>
                </div>
                <span v-else>{{ slotProps.placeholder }}</span>
              </template>
              <template #option="slotProps">
                <div class="flex items-center">
                  <div>{{ slotProps.option.label }}</div>
                </div>
              </template>
            </Select>
            <label for="species">{{ $t("pet_form.fields.select_species") }}</label>
          </FloatLabel>
        </div>

        <!-- Breed -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <InputText id="breed" class="w-full" v-model="pet.breed" />
            <label for="breed">{{ $t("pet_form.fields.breed") }}</label>
          </FloatLabel>
        </div>

        <!-- Gender -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
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
              <template #option="slotProps">
                <div class="flex items-center">
                  <div>{{ slotProps.option.label }}</div>
                </div>
              </template>
            </Select>
            <label for="gender">{{ $t("pet_form.fields.select_gender") }}</label>
          </FloatLabel>
        </div>

        <!-- Date of Birth -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <label for="dob">{{ $t("pet_form.fields.date_of_birth") }}</label>
            <DatePicker
              showTime
              hourFormat="12"
              id="dob"
              class="w-full"
              v-model="pet.date_of_birth"
              dateFormat="yy-mm-dd"
            />
          </FloatLabel>
        </div>

        <!-- Color -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <InputText id="color" class="w-full" v-model="pet.color" />
            <label for="color">{{ $t("pet_form.fields.color") }}</label>
          </FloatLabel>
        </div>

        <!-- Distinctive Marks -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <InputText
              id="distinctive_marks"
              class="w-full"
              v-model="pet.distinctive_marks"
            />
            <label for="distinctive_marks">{{
              $t("pet_form.fields.distinctive_marks")
            }}</label>
          </FloatLabel>
        </div>

        <!-- Behaviour -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <InputText id="behaviour" class="w-full" v-model="pet.behaviour" />
            <label for="behaviour">{{ $t("pet_form.fields.behaviour") }}</label>
          </FloatLabel>
        </div>

        <!-- Neutered -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
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
              <template #option="slotProps">
                <div class="flex items-center">
                  <div>{{ slotProps.option.label }}</div>
                </div>
              </template>
            </Select>
            <label for="neutered">{{ $t("pet_form.fields.neutered") }}</label>
          </FloatLabel>
        </div>

        <!-- Deceased -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
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
              <template #option="slotProps">
                <div class="flex items-center">
                  <div>{{ slotProps.option.label }}</div>
                </div>
              </template>
            </Select>
            <label for="deceased">{{ $t("pet_form.fields.deceased") }}</label>
          </FloatLabel>
        </div>

        <!-- Allergies -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%]">
            <Textarea id="allergies" class="w-full h-24" v-model="pet.allergies" />
            <label for="allergies">{{ $t("pet_form.fields.allergies") }}</label>
          </FloatLabel>
        </div>

        <!-- Submit Button -->
        <Button type="submit" :label="$t('pet_form.buttons.submit')" />
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
import Textarea from "primevue/textarea";
import Select from "primevue/select";
import FloatLabel from "primevue/floatlabel";
import Button from "primevue/button";
import axiosInstance from "@/axios"; // Assuming you've created a global axios instance
import eventBus from "@/eventBus";
import router from "@/router";
import Cookies from "js-cookie";
import { useI18n } from "vue-i18n";

const { t } = useI18n();
const emit = defineEmits(["submitted"]); // Define the event to be emitted
const isModalOwnerVisible = ref(false);
const pet = ref({
  owner_id: null,
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
const yesno = ref([
  { label: t("pet_form.options.yes"), value: "Yes" },
  { label: t("pet_form.options.no"), value: "No" },
]);
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
    // // console.log(response.data.data);
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
    color: pet.value.color,
    distinctive_marks: pet.value.distinctive_marks,
    behaviour: pet.value.behaviour,
    neutered: pet.value.neutered.value === "Yes" ? "Y" : "N",
    deceased: pet.value.deceased.value === "Yes" ? "Y" : "N",
    allergies: pet.value.allergies,
  };

  // // console.log(submissionData); // Verify the structure
  // console.log(submissionData);
  try {
    const response = await axiosInstance.post("/pets", submissionData);
    emit("submitted", response.data); // You may modify this based on your response structure

    // // console.log(response);
    eventBus.emit("show-toast", {
      severity: "success",
      summary: t("pet_form.toast.success"),
      detail: t("pet_form.toast.success"),
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
    // // console.log(event);
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
