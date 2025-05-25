<template>
  <div class="w-full mt-4 xl:!text-[12px]">
    <Card class="bg-[var(--p-surface-200)] dark:bg-[var(--p-surface-600)] rounded-lg p-6">
      <template #title>
        <div class="flex items-center gap-3">
          <i class="pi pi-whatsapp text-3xl text-green-500"></i>
          <h1 class="xl:!text-[16px] !text-lg font-bold">
            {{ $t("whatsapp_onboarding.title") }}
          </h1>
        </div>
      </template>

      <template #content>
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
          <!-- Left Column - Benefits Illustration -->
          <div class="flex flex-col justify-center">
            <!-- <img
              src="@/assets/images/whatsapp-illustration.svg"
              alt="WhatsApp Benefits"
              class="w-full max-w-md mx-auto mb-6"
            /> -->

            <div class="space-y-3">
              <div
                v-for="(benefit, index) in benefits"
                :key="index"
                class="flex items-start gap-3"
              >
                <i class="pi pi-check-circle text-green-500 mt-1"></i>
                <div>
                  <h3 class="font-semibold xl:!text-[12px]">{{ benefit.title }}</h3>
                  <p class="text-gray-600 dark:text-gray-300 xl:!text-[11px]">
                    {{ benefit.description }}
                  </p>
                </div>
              </div>
            </div>
          </div>

          <!-- Right Column - Setup CTA -->
          <div class="bg-white dark:bg-[var(--p-surface-700)] p-6 rounded-lg shadow">
            <h2 class="xl:!text-[14px] !text-base font-semibold mb-4">
              {{ $t("whatsapp_onboarding.setup_title") }}
            </h2>

            <div class="space-y-4 mb-6">
              <div class="flex items-start gap-3">
                <i class="pi pi-info-circle text-blue-500 mt-1"></i>
                <p class="text-gray-600 dark:text-gray-300 xl:!text-[11px]">
                  {{ $t("whatsapp_onboarding.setup_description") }}
                </p>
              </div>

              <div class="border-t pt-4">
                <h3 class="font-medium xl:!text-[12px] mb-2">
                  {{ $t("whatsapp_onboarding.requirements_title") }}
                </h3>
                <ul class="list-disc pl-5 space-y-1 xl:!text-[11px]">
                  <li>{{ $t("whatsapp_onboarding.requirements.phone") }}</li>
                  <li>{{ $t("whatsapp_onboarding.requirements.business") }}</li>
                  <li>{{ $t("whatsapp_onboarding.requirements.permissions") }}</li>
                </ul>
              </div>
            </div>

            <div class="flex flex-col sm:flex-row gap-3 justify-end">
              <Button
                :label="$t('whatsapp_onboarding.learn_more')"
                severity="secondary"
                size="small"
                class="lg:!text-xs"
                outlined
              />
              <Button
                :label="$t('whatsapp_onboarding.get_started')"
                :icon="isRtl ? 'pi pi-arrow-left' : 'pi pi-arrow-right'"
                size="small"
                class="lg:!text-xs"
                @click="startOnboarding"
              />
            </div>
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
import Button from "primevue/button";
import Card from "primevue/card";
// const isRtl = computed(() => ["ar", "he", "fa"].includes(locale.value));

const { t, locale } = useI18n();
const isRtl = computed(() => ["ar", "he", "fa"].includes(locale.value));
// console.log("isRtl ", isRtl.value);
const router = useRouter();

const benefits = ref([
  {
    title: t("whatsapp_onboarding.benefits.real_time.title"),
    description: t("whatsapp_onboarding.benefits.real_time.description"),
  },
  {
    title: t("whatsapp_onboarding.benefits.high_engagement.title"),
    description: t("whatsapp_onboarding.benefits.high_engagement.description"),
  },
  {
    title: t("whatsapp_onboarding.benefits.secure.title"),
    description: t("whatsapp_onboarding.benefits.secure.description"),
  },
]);

const startOnboarding = () => {
  router.push({ name: "whatsapp-number-verification" });
};
</script>

<style scoped>
/* Custom styles if needed */
</style>
