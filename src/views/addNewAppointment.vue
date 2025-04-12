<template>
  <div class="w-full">
    <form @submit.prevent="submitForm" class="mx-auto w-full">
      <fieldset
        class="p-fieldset p-component w-4/5 flex flex-wrap mx-auto gap-2 items-center border rounded-lg p-4"
      >
        <legend>{{ $t("appointment.add_title") }}</legend>
        <input type="hidden" id="branch_id" value="1" v-model="appointment.branch_id" />

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
            <label for="pet">{{ $t("appointment.fields.pet") }}</label>
          </FloatLabel>
          <InputText
            id="name"
            v-model="selectedPet"
            class="hidden"
            v-else
            :placeholder="$t('appointment.fields.pet')"
          />
        </div>

        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <InputText id="title" v-model="appointment.title" fluid />
            <label for="title">{{ $t("appointment.fields.title") }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <InputText id="description" v-model="appointment.description" fluid />
            <label for="description">{{ $t("appointment.fields.description") }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <DatePicker
              showIcon
              iconDisplay="input"
              showButtonBar
              id="start"
              showTime
              hourFormat="24"
              fluid
              v-model="appointment.start"
              dateFormat="yy-mm-dd"
              class="w-full"
            />
            <label for="start">{{ $t("appointment.fields.start") }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <label for="end">{{ $t("appointment.fields.end") }}</label>
            <DatePicker
              showIcon
              iconDisplay="input"
              showButtonBar
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
            <label for="type">{{ $t("appointment.fields.type") }}</label>
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
            <label for="status">{{ $t("appointment.fields.status") }}</label>
          </FloatLabel>
        </div>

        <Button type="submit" :label="$t('appointment.actions.submit')" class="mt-4" />
      </fieldset>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from "vue";
import { useI18n } from "vue-i18n";
import AutoComplete from "primevue/autocomplete";
import InputText from "primevue/inputtext";
import DatePicker from "primevue/datepicker";
import Select from "primevue/select";
import FloatLabel from "primevue/floatlabel";
import Button from "primevue/button";
import InputGroupAddon from "primevue/inputgroupaddon";
import InputGroup from "primevue/inputgroup";
import axiosInstance from "@/axios";
import eventBus from "@/eventBus";
import Cookies from "js-cookie";

const { t } = useI18n();
const emit = defineEmits(["submitted"]);

const props = defineProps(["activeDate", "petMicrochip", "petOwnerID"]);
const appointment = ref({
  client_id: null,
  branch_id: Cookies.get("M3K8g2387BahBaqyjDe6"),
  title: "",
  description: "",
  type: "",
  start: null,
  end: null,
});

const appointmentTypes = ref([
  { label: t("appointment.types.emergency"), value: "Emergency" },
  { label: t("appointment.types.non_emergency"), value: "Non-Emergency" },
  { label: t("appointment.types.regular"), value: "Regular" },
  { label: t("appointment.types.followup"), value: "FollowUp" },
  { label: t("appointment.types.surgery"), value: "Surgery" },
  { label: t("appointment.types.grooming"), value: "Grooming" },
]);

const appointmentStatus = ref([
  { label: t("appointment.statuses.scheduled"), value: "Scheduled" },
  { label: t("appointment.statuses.walkin"), value: "Walkin" },
]);

const selectedPet = ref(null);
const filteredPets = ref([]);
const currentPage = ref(1);
const totalRecords = ref(0);
const itemsPerPage = ref(25);
const searchQuery = ref("");
const loading = ref(false);

function formatLocalDateTime(date) {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  const hours = String(date.getHours()).padStart(2, "0");
  const minutes = String(date.getMinutes()).padStart(2, "0");

  return `${year}-${month}-${day} ${hours}:${minutes}`;
}

watch(
  () => appointment.value.start,
  (newStart) => {
    if (newStart) {
      const startDate = new Date(newStart);
      const endDate = new Date(startDate.getTime() + 60 * 60 * 1000);
      appointment.value.end = formatLocalDateTime(endDate);
    } else {
      appointment.value.end = null;
    }
  }
);

const fetchPets = async (page = 1) => {
  try {
    loading.value = true;
    const response = await axiosInstance.get(
      `/pets?page=${page}&per_page=${itemsPerPage.value}&search=${searchQuery.value}`
    );
    filteredPets.value = response.data.data;
    if (props.petOwnerID) {
      selectedPet.value = response.data.data;
    }
    totalRecords.value = response.data.total;
    currentPage.value = response.data.current_page;
    loading.value = false;
  } catch (error) {
    console.error("Failed to fetch pets:", error);
    eventBus.emit("show-toast", {
      severity: "error",
      summary: t("appointment.add_title"),
      detail: t("appointment.messages.fetch_error"),
      life: 5000,
    });
    loading.value = false;
  }
};

const searchPets = async (event) => {
  if (event.query.length < 3) return;
  searchQuery.value = event.query;
  await fetchPets(currentPage.value);
};

const submitForm = async () => {
  if (!selectedPet.value) {
    eventBus.emit("show-toast", {
      severity: "warn",
      summary: t("appointment.add_title"),
      detail: t("appointment.messages.pet_required"),
      life: 5000,
    });
    return;
  }

  appointment.value.client_id = !props.petOwnerID
    ? selectedPet.value.owner_id
    : selectedPet.value[0].owner_id;
  appointment.value.pet_id = !props.petOwnerID
    ? selectedPet.value.id
    : selectedPet.value[0].id;
  appointment.value.type = appointment.value.type.value;
  appointment.value.status = appointment.value.status.value;

  const formatDateTime = (date) => {
    return `${date.getFullYear()}-${(date.getMonth() + 1)
      .toString()
      .padStart(2, "0")}-${date
      .getDate()
      .toString()
      .padStart(2, "0")} ${date
      .getHours()
      .toString()
      .padStart(2, "0")}:${date
      .getMinutes()
      .toString()
      .padStart(2, "0")}:${date.getSeconds().toString().padStart(2, "0")}`;
  };

  const startDate = new Date(appointment.value.start);
  const endDate = new Date(appointment.value.end);

  appointment.value.start = formatDateTime(startDate);
  appointment.value.end = formatDateTime(endDate);

  try {
    const response = await axiosInstance.post("/appointments", appointment.value);
    emit("submitted", response.data);
    eventBus.emit("show-toast", {
      severity: "success",
      summary: t("appointment.add_title"),
      detail: t("appointment.messages.create_success", {
        petName: !props.petOwnerID ? selectedPet.value.name : selectedPet.value[0].name,
      }),
      life: 5000,
    });
  } catch (error) {
    console.error("Error response:", error);
    eventBus.emit("show-toast", {
      severity: "error",
      summary: t("appointment.add_title"),
      detail: error.response?.data?.message || t("appointment.messages.create_error"),
      life: 5000,
    });
  }
};

onMounted(() => {
  appointment.value.start = props.activeDate;
  appointment.value.end = props.activeDate;
  appointment.value.petmicrochip = props.petMicrochip;
  appointment.value.owner_id = props.petOwnerID;
  if (props.petMicrochip) {
    searchQuery.value = props.petMicrochip;
  }
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
