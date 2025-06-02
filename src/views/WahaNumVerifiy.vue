<template>
  <div class="w-full mt-4 xl:!text-[12px]">
    <Card
      class="bg-[var(--p-surface-200)] dark:bg-[var(--p-surface-600)] rounded-lg p-6 max-w-2xl mx-auto"
    >
      <template #title>
        <div class="flex items-center gap-3">
          <i class="pi pi-mobile text-2xl text-blue-500"></i>
          <h1 class="xl:!text-[16px] !text-lg font-bold">
            {{ $t("whatsapp_number_verification.title") }}
          </h1>
        </div>
      </template>

      <template #content>
        <div class="space-y-6">
          <div class="bg-white dark:bg-[var(--p-surface-700)] p-4 rounded-lg shadow">
            <div class="flex flex-col gap-4">
              <FloatLabel>
                <Select
                  v-model="selectedCountry"
                  :options="countries"
                  optionLabel="name"
                  optionValue="code"
                  class="w-full"
                  :pt="{
                    root: { class: 'lg:!text-xs h-10' },
                    input: { class: 'lg:!text-xs' },
                  }"
                />
                <label>{{ $t("whatsapp_number_verification.country") }}</label>
              </FloatLabel>

              <FloatLabel>
                <InputNumber
                  v-model="phoneNumber"
                  mode="decimal"
                  :useGrouping="false"
                  class="w-full lg:!text-xs"
                  :pt="{
                    input: { class: 'lg:!text-xs h-10' },
                  }"
                />
                <label>{{ $t("whatsapp_number_verification.phone_number") }}</label>
              </FloatLabel>

              <div
                v-if="verificationSent"
                class="p-3 bg-green-50 dark:bg-green-900 rounded"
              >
                <div class="flex items-center gap-2 text-green-600 dark:text-green-200">
                  <i class="pi pi-check-circle"></i>
                  <span class="lg:!text-xs">
                    {{ $t("whatsapp_number_verification.verification_sent") }}
                  </span>
                </div>
              </div>
            </div>
          </div>

          <div class="flex flex-col sm:flex-row gap-3 justify-between pt-2 border-t">
            <Button
              :label="$t('whatsapp_number_verification.back')"
              severity="secondary"
              size="small"
              class="lg:!text-xs"
              outlined
              @click="router.back()"
            />
            <Button
              :label="
                verificationSent
                  ? $t('whatsapp_number_verification.continue')
                  : $t('whatsapp_number_verification.send_code')
              "
              :icon="isRtl ? 'pi pi-arrow-left' : 'pi pi-arrow-right'"
              size="small"
              class="lg:!text-xs"
              :loading="loading"
              @click="verificationSent ? proceedToQR() : sendVerification()"
            />
          </div>
        </div>
      </template>
    </Card>
  </div>
</template>

<script setup>
import { ref, computed } from "vue";
import { useRouter } from "vue-router";
import { useI18n } from "vue-i18n";
import Select from "primevue/select";
import FloatLabel from "primevue/floatlabel";
import InputNumber from "primevue/inputnumber";
import Button from "primevue/button";
import Card from "primevue/card";
import eventBus from "@/eventBus";
import axiosInstance from "@/axios";

const { t, locale } = useI18n();
const isRtl = computed(() => ["ar", "he", "fa"].includes(locale.value));
const router = useRouter();

const countries = ref([
  { name: "Syrian Arab Republic (+963)", code: "+963" },
  { name: "Saudi Arabia (+966)", code: "+966" },
  { name: "United Arab Emirates (+971)", code: "+971" },
  { name: "Egypt (+20)", code: "+20" },
  { name: "United States (+1)", code: "+1" },
  { name: "United Kingdom (+44)", code: "+44" },
]);

const selectedCountry = ref("+1");
const phoneNumber = ref(null);
const verificationSent = ref(false);
const loading = ref(false);

const sendVerification = async () => {
  loading.value = true;

  try {
    const fullPhone = `${selectedCountry.value}${phoneNumber.value}`.replace(
      /[^0-9]/g,
      ""
    );
    const response = await axiosInstance.get(
      "/whatsapp/check-number?phone=" +
        phoneNumber.value +
        "&country_code=" +
        selectedCountry.value
    );
    // console.log(response);
    if (response.data.success) {
      verificationSent.value = true;

      // Automatically proceed to QR scanning if number exists
      if (response.data.number_exists) {
        proceedToQR(response);
      }
    } else {
      throw new Error(response.data.error || "Verification failed");
    }
  } catch (error) {
    // console.log(error);
    // useToast().add({
    //   severity: "error",
    //   summary: t("whatsapp_number_verification.error_title"),
    //   detail: error.message,
    //   life: 5000,
    // });
    eventBus.emit("show-toast", {
      severity: "error",
      summary: t("whatsapp_number_verification.error_title"),
      detail: t("whatsapp_number_verification." + error.response.data.error),
      life: 5000,
      // });
    });
  } finally {
    loading.value = false;
  }
};

const proceedToQR = (response) => {
  // console.log(response);
  router.push({
    name: "whatsapp-qr-scanner",
    query: {
      phone: `${selectedCountry.value}${phoneNumber.value}`,
      session_id: response.data.session_id, // Pass the session ID to QR scanner
    },
  });
};
</script>
