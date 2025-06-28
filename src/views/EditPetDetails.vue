<template>
  <div class="w-full">
    <form @submit.prevent="submitForm" class="mt-8 mx-auto w-4/5">
      <fieldset
        class="p-fieldset p-component w-full flex flex-wrap gap-4 items-start justify-start border rounded-lg p-4"
      >
        <legend>{{ $t("pet_details.edit_pet_details") }}: {{ pet.name }}</legend>
        <input type="hidden" id="branch_id" value="1" v-model="pet.branch_id" />

        <!-- Microchip Field -->
        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <InputNumber
              id="microchip_num"
              v-model="pet.microchip_num"
              variant="filled"
              :useGrouping="false"
              fluid
            />
            <label for="microchip_num">{{ $t("pet_form.fields.microchip_num") }}</label>
          </FloatLabel>
        </div>

        <!-- Name Field -->
        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <InputText fluid id="name" v-model="pet.name" />
            <label for="name">{{ $t("pet_form.fields.name") }}</label>
          </FloatLabel>
        </div>

        <!-- Species Field -->
        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <Select
              fluid
              v-model="pet.species"
              :options="species"
              optionLabel="label"
              optionvalue="value"
              class="w-full md:w-56 h-10"
            >
              <template #value="slotProps">
                <div v-if="slotProps.value" class="flex items-center">
                  <div>
                    <!-- {{ $t(`pet_details.species.${slotProps.value.value.toLowerCase()}`) }} -->
                    {{ slotProps.value.label }}
                  </div>
                </div>
                <span v-else>{{ $t("pet_form.fields.select_species") }}</span>
              </template>
            </Select>
            <label for="species">{{ $t("pet_form.fields.select_species") }}</label>
          </FloatLabel>
        </div>

        <!-- Breed Field -->
        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <InputText fluid id="breed" v-model="pet.breed" />
            <label for="breed">{{ $t("pet_form.fields.breed") }}</label>
          </FloatLabel>
        </div>

        <!-- Gender Field -->
        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <Select
              id="gender"
              v-model="pet.gender"
              :options="genders"
              optionLabel="label"
              class="w-full h-10"
            >
              <template #value="slotProps">
                <div v-if="slotProps.value" class="flex items-center">
                  <div>
                    {{ $t(`pet_form.options.${slotProps.value.value.toLowerCase()}`) }}
                  </div>
                </div>
                <span v-else>{{ $t("pet_form.fields.select_gender") }}</span>
              </template>
            </Select>
            <label for="gender">{{ $t("pet_form.fields.select_gender") }}</label>
          </FloatLabel>
        </div>

        <!-- Date of Birth Field -->
        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <label for="dob">{{ $t("pet_form.fields.date_of_birth") }}</label>
            <DatePicker
              showIcon
              iconDisplay="input"
              showButtonBar
              fluid
              id="dob"
              class="w-full"
              v-model="pet.date_of_birth"
              dateFormat="yy-mm-d"
            />
          </FloatLabel>
        </div>

        <!-- Color Field -->
        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <InputText fluid id="color" v-model="pet.color" />
            <label for="color">{{ $t("pet_form.fields.color") }}</label>
          </FloatLabel>
        </div>

        <!-- Distinctive Marks Field -->
        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <InputText fluid id="distinctive_marks" v-model="pet.distinctive_marks" />
            <label for="distinctive_marks">{{
              $t("pet_form.fields.distinctive_marks")
            }}</label>
          </FloatLabel>
        </div>

        <!-- Behaviour Field -->
        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <InputText fluid id="behaviour" v-model="pet.behaviour" />
            <label for="behaviour">{{ $t("pet_form.fields.behaviour") }}</label>
          </FloatLabel>
        </div>

        <!-- Neutered Field -->
        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <Select
              v-model="pet.neutered"
              :options="yesno"
              optionLabel="label"
              class="w-full h-10"
            >
              <template #value="slotProps">
                <div v-if="slotProps.value" class="flex items-center">
                  <div>
                    {{ $t(`pet_form.options.${slotProps.value.value.toLowerCase()}`) }}
                  </div>
                </div>
                <span v-else>{{ $t("pet_form.fields.neutered") }}</span>
              </template>
            </Select>
            <label for="neutered">{{ $t("pet_form.fields.neutered") }}</label>
          </FloatLabel>
        </div>

        <!-- Deceased Field -->
        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <Select
              v-model="pet.deceased"
              :options="yesno"
              optionLabel="label"
              class="w-full h-10"
            >
              <template #value="slotProps">
                <div v-if="slotProps.value" class="flex items-center">
                  <div>
                    {{ $t(`pet_form.options.${slotProps.value.value.toLowerCase()}`) }}
                  </div>
                </div>
                <span v-else>{{ $t("pet_form.fields.deceased") }}</span>
              </template>
            </Select>
            <label for="deceased">{{ $t("pet_form.fields.deceased") }}</label>
          </FloatLabel>
        </div>

        <!-- Allergies Field -->
        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <Textarea id="allergies" fluid v-model="pet.allergies" />
            <label for="allergies">{{ $t("pet_form.fields.allergies") }}</label>
          </FloatLabel>
        </div>

        <Button type="submit" :label="$t('pet_form.buttons.submit')" />
      </fieldset>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useI18n } from "vue-i18n";
import InputText from "primevue/inputtext";
import InputNumber from "primevue/inputnumber";
import Textarea from "primevue/textarea";
import DatePicker from "primevue/datepicker";
import Select from "primevue/select";
import FloatLabel from "primevue/floatlabel";
import Button from "primevue/button";
import axiosInstance from "@/axios";
import eventBus from "@/eventBus";
import { useRoute } from "vue-router";
import Cookies from "js-cookie";

const { t } = useI18n();
const route = useRoute();
const emit = defineEmits(["submitted"]);

const pet = ref({
  owner_id: route.params.ownerid,
  microchip_num: null,
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

const genders = ref([
  { label: t("pet_form.options.male"), value: "Male" },
  { label: t("pet_form.options.female"), value: "Female" },
]);

const petmicrochip = ref(route.params.petmicrochip);

const fetchPetDetails = async () => {
  const petId = route.params.petid;
  try {
    const response = await axiosInstance.get(`/pets/${petmicrochip.value}`);
    const petData = response.data;

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
  } catch (error) {
    console.error(t("pet_form.toast.error"), error);
  }
};

const formatDateForSubmission = (dateString) => {
  const date = new Date(dateString);
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, "0")}-${String(
    date.getDate()
  ).padStart(2, "0")}`;
};

const submitForm = async () => {
  const submissionData = {
    owner_id: pet.value.owner_id,
    branch_id: pet.value.branch_id,
    microchip_num: pet.value.microchip_num,
    name: pet.value.name,
    species: pet.value.species.value,
    breed: pet.value.breed,
    gender: pet.value.gender.value,
    date_of_birth: pet.value.date_of_birth
      ? formatDateForSubmission(pet.value.date_of_birth)
      : null,
    color: pet.value.color,
    distinctive_marks: pet.value.distinctive_marks,
    behaviour: pet.value.behaviour,
    neutered: pet.value.neutered.value === t("pet_form.options.yes") ? "Y" : "N",
    deceased: pet.value.deceased.value === t("pet_form.options.yes") ? "Y" : "N",
    allergies: pet.value.allergies,
  };

  try {
    const response = await axiosInstance.put(
      `/pets/${petmicrochip.value}`,
      submissionData
    );
    emit("details_updated", response.data);
    eventBus.emit("show-toast", {
      severity: "success",
      summary: t("pet_form.toast.success_summary"),
      detail: t("pet_form.toast.success"),
      life: 5000,
    });
  } catch (error) {
    eventBus.emit("show-toast", {
      severity: "warn",
      summary: t("pet_form.toast.error_summary"),
      detail: t("pet_form.toast.error"),
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
