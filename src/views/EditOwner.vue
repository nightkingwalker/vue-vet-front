<template>
  <div class="px-4 lg:!text-[14px]">
    <form @submit.prevent="submitForm" class="mx-auto w-full">
      <fieldset class="p-fieldset p-component w-4/5 flex flex-wrap mx-auto gap-4 items-start border rounded-lg p-4">
        <legend class="px-4 bg-gray-600 text-white dark:bg-zinc-200 dark:text-zinc-800 rounded">
          {{ $t("edit_owner.title") }}
        </legend>

        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <InputText fluid id="name" v-model="owner.name" />
            <label for="name">{{ $t("add_owner.fields.name") }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <InputText fluid id="email" v-model="owner.email" />
            <label for="email">{{ $t("add_owner.fields.email") }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <InputText fluid id="phone" v-model="owner.phone" />
            <label for="phone">{{ $t("add_owner.fields.phone") }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <InputText fluid id="landline" v-model="owner.landline" />
            <label for="landline">{{ $t("add_owner.fields.landline") }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <DatePicker showIcon iconDisplay="input" showButtonBar fluid id="birth_date" v-model="owner.birth_date"
              dateFormat="yy-mm-d" />
            <label for="birth_date">{{ $t("add_owner.fields.birth_date") }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <InputText fluid id="facebook_link" v-model="owner.facebook_link" />
            <label for="facebook_link">{{ $t("add_owner.fields.facebook_link") }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <InputText fluid id="instagram_link" v-model="owner.instagram_link" />
            <label for="instagram_link">{{
              $t("add_owner.fields.instagram_link")
              }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <InputText fluid id="referral" v-model="owner.referral" />
            <label for="referral">{{ $t("add_owner.fields.referral") }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <TextArea autoResize fluid id="referral" v-model="owner.referral" rows="4" />
            <label for="address">{{ $t("add_owner.fields.address") }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-[48%]">
          <FloatLabel class="w-full">
            <TextArea id="clinic_notes" v-model="owner.clinic_notes" autoResize fluid rows="2" />
            <label for="clinic_notes">{{ $t("add_owner.fields.clinic_notes") }}</label>
          </FloatLabel>
        </div>

        <Button type="submit" :label="$t('edit_owner.actions.update')" icon="pi pi-check" class="mt-4 w-full" />
      </fieldset>
    </form>
  </div>
</template>

<script setup>
import { ref, watch } from "vue";
import { useI18n } from "vue-i18n";
import axiosInstance from "@/axios";
import InputText from "primevue/inputtext";
import TextArea from "primevue/textarea";
import FloatLabel from "primevue/floatlabel";
import Button from "primevue/button";
import DatePicker from "primevue/datepicker";
import eventBus from "@/eventBus";
import router from "@/router";

const { t } = useI18n();

const props = defineProps({
  owner: {
    type: Object,
    required: true,
  },
});

const emit = defineEmits(["OwnerUpdated", "close-dialog"]);
const owner = ref({ ...props.owner });

watch(
  () => props.owner,
  (newOwner) => {
    owner.value = { ...newOwner };
  },
  { deep: true }
);

const submitForm = async () => {
  try {
    const formatDate = (isoDateString) => {
      return isoDateString ? new Date(isoDateString).toISOString().split("T")[0] : null;
    };
    owner.value.birth_date = formatDate(owner.value.birth_date);
    const response = await axiosInstance.put(`/owners/${owner.value.id}`, owner.value);
    console.log(response.data);
    emit("OwnerUpdated", response.data);
    emit("close-dialog");

    eventBus.emit("show-toast", {
      severity: "success",
      summary: t("add_owner.title"),
      detail: t("add_owner.messages.success"),
      life: 5000,
    });

    await router.push("/owners");
  } catch (error) {
    console.error("Error updating client:", error);
    eventBus.emit("show-toast", {
      severity: "error",
      summary: t("add_owner.title"),
      detail: t("add_owner.messages.error"),
      life: 5000,
    });
  }
};
</script>

<style scoped>
/* Tailwind and Theming for light/dark modes */
body.dark .text-sm {
  color: #ccc;
}
body .text-sm {
  color: #333;
}
</style>
