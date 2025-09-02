<template>
  <div class="w-full">
    <form @submit.prevent="submitForm" class="mx-auto w-full">
      <fieldset class="p-fieldset p-component w-4/5 flex flex-wrap mx-auto gap-2 items-start border rounded-lg p-4">
        <legend>{{ $t("appointment.edit_title") }}</legend>
        <input type="hidden" id="branch_id" value="1" v-model="appointment.branch_id" />
        <input type="hidden" id="appointment_id" v-model="appointment.id" />

        <div class="field mt-6 w-[48%]" :class="appointment.petmicrochip ? `hidden` : ``">
          <FloatLabel class="w-full" v-if="!appointment.petmicrochip">
            <InputGroup class="flex rounded-md overflow-hidden">
              <AutoComplete v-model="selectedPet" optionLabel="name" :suggestions="filteredPets" @complete="searchPets"
                class="w-full" fluid>
                <template #option="slotProps">
                  <div class="flex items-center">
                    <div>{{ slotProps.option.name }}</div>
                  </div>
                </template>
              </AutoComplete>
              <InputGroupAddon class="!bg-transparent px-4 flex flex-col item-center justify-center"><i
                  class="pi pi-search"></i></InputGroupAddon>
            </InputGroup>
            <label for="pet">{{ $t("appointment.fields.pet") }}</label>
          </FloatLabel>
          <InputText id="name" v-model="selectedPet" class="hidden" v-else
            :placeholder="$t('appointment.fields.pet')" />
        </div>

        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <InputText id="title" v-model="appointment.title" fluid />
            <label for="title">{{ $t("appointment.fields.title") }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <Textarea id="description" v-model="appointment.description" fluid autoResize rows="2" />
            <label for="description">{{ $t("appointment.fields.description") }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <DatePicker showIcon iconDisplay="input" showButtonBar id="start" showTime hourFormat="24" fluid
              v-model="appointment.start" dateFormat="yy-mm-d" class="w-full" />
            <label for="start">{{ $t("appointment.fields.start") }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <label for="end">{{ $t("appointment.fields.end") }}</label>
            <DatePicker showIcon iconDisplay="input" showButtonBar showTime hourFormat="24" id="end"
              v-model="appointment.end" dateFormat="yy-mm-d" class="w-full" />
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <Select v-model="appointment.type" :options="appointmentTypes" optionLabel="label" class="w-full" />
            <label for="type">{{ $t("appointment.fields.type") }}</label>
          </FloatLabel>
        </div>
        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <Select v-model="appointment.status" :options="appointmentStatus" optionLabel="label" class="w-full" />
            <label for="status">{{ $t("appointment.fields.status") }}</label>
          </FloatLabel>
        </div>

        <Button type="submit" :label="$t('appointment.actions.update')" class="mt-4" />
      </fieldset>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useI18n } from "vue-i18n";
import AutoComplete from "primevue/autocomplete";
import InputGroup from "primevue/inputgroup";
import InputText from "primevue/inputtext";
import DatePicker from "primevue/datepicker";
import Select from "primevue/select";
import FloatLabel from "primevue/floatlabel";
import Button from "primevue/button";
import Textarea from "primevue/textarea";
import axiosInstance from "@/axios";
import eventBus from "@/eventBus";
import Cookies from "js-cookie";

const { t } = useI18n();
const emit = defineEmits(["updated"]);

const props = defineProps({
  appointmentId: {
    type: Number,
    required: true,
  },
});

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

const fetchAppointment = async () => {
  try {
    const response = await axiosInstance.get(`/appointments/${props.appointmentId}`);
    const data = response.data;

    appointment.value = {
      ...data,
      type: appointmentTypes.value.find((type) => type.value === data.type),
      status: appointmentStatus.value.find((status) => status.value === data.status),
    };

    selectedPet.value = data.pet;
  } catch (error) {
    console.error("Failed to fetch appointment:", error);
    eventBus.emit("show-toast", {
      severity: "error",
      summary: t("appointment.edit_title"),
      detail: t("appointment.messages.fetch_error"),
      life: 5000,
    });
  }
};

const fetchPets = async () => {
  try {
    const response = await axiosInstance.get("/pets");
    filteredPets.value = response.data.data;
  } catch (error) {
    console.error("Failed to fetch pets:", error);
  }
};

const searchPets = async (event) => {
  if (event.query.length < 3) return;
  try {
    const response = await axiosInstance.get(`/pets?search=${event.query}`);
    filteredPets.value = response.data.data;
  } catch (error) {
    console.error("Failed to search pets:", error);
  }
};

/* const submitForm = async () => {
  if (!selectedPet.value) {
    eventBus.emit("show-toast", {
      severity: "warn",
      summary: t("appointment.edit_title"),
      detail: t("appointment.messages.pet_required"),
      life: 5000,
    });
    return;
  }

  appointment.value.client_id = selectedPet.value.owner_id;
  appointment.value.pet_id = selectedPet.value.id;
  appointment.value.type = appointment.value.type.value;
  appointment.value.status = appointment.value.status.value;

  try {
    const response = await axiosInstance.put(
      `/appointments/${appointment.value.id}`,
      appointment.value
    );
    emit("updated", response.data);
    eventBus.emit("show-toast", {
      severity: "success",
      summary: t("appointment.edit_title"),
      detail: t("appointment.messages.update_success", {
        petName: selectedPet.value.name,
      }),
      life: 5000,
    });
  } catch (error) {
    console.error("Error updating appointment:", error);
    eventBus.emit("show-toast", {
      severity: "error",
      summary: t("appointment.edit_title"),
      detail: error.response?.data?.message || t("appointment.messages.update_error"),
      life: 5000,
    });
  }
};
 */
const submitForm = async () => {
  if (!selectedPet.value) {
    eventBus.emit("show-toast", {
      severity: "warn",
      summary: t("appointment.edit_title"),
      detail: t("appointment.messages.pet_required"),
      life: 5000,
    });
    return;
  }

  // helper to format to "YYYY-MM-DD HH:mm:ss"
  const formatDateTime = (date) => {
    const d = date instanceof Date ? date : new Date(
      typeof date === "string" ? date.replace(" ", "T") : date
    );
    const yyyy = d.getFullYear();
    const mm = String(d.getMonth() + 1).padStart(2, "0");
    const dd = String(d.getDate()).padStart(2, "0");
    const hh = String(d.getHours()).padStart(2, "0");
    const mi = String(d.getMinutes()).padStart(2, "0");
    const ss = String(d.getSeconds()).padStart(2, "0");
    return `${yyyy}-${mm}-${dd} ${hh}:${mi}:${ss}`;
  };

  // build a clean payload so we don't mutate the picker-bound objects
  const payload = {
    ...appointment.value,
    client_id: selectedPet.value.owner_id,
    pet_id: selectedPet.value.id,
    type:
      typeof appointment.value.type === "object"
        ? appointment.value.type.value
        : appointment.value.type,
    status:
      typeof appointment.value.status === "object"
        ? appointment.value.status.value
        : appointment.value.status,
    start: formatDateTime(appointment.value.start),
    end: formatDateTime(appointment.value.end),
  };

  try {
    const response = await axiosInstance.put(
      `/appointments/${appointment.value.id ?? props.appointmentId}`,
      payload
    );
    emit("updated", response.data);
    eventBus.emit("show-toast", {
      severity: "success",
      summary: t("appointment.edit_title"),
      detail: t("appointment.messages.update_success", {
        petName: selectedPet.value.name,
      }),
      life: 5000,
    });
  } catch (error) {
    console.error("Error updating appointment:", error);
    eventBus.emit("show-toast", {
      severity: "error",
      summary: t("appointment.edit_title"),
      detail: error.response?.data?.message || t("appointment.messages.update_error"),
      life: 5000,
    });
  }
};

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
