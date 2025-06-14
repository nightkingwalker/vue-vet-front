<template>
  <div class="oauth-callback">
    <ProgressSpinner v-if="loading" />
    <Message v-else severity="error" :closable="false">
      {{ errorMessage }}
      <Button
        :label="t('oauth.return_to_settings')"
        @click="returnToSettings"
        class="mt-2"
      />
    </Message>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useI18n } from "vue-i18n";

const { t } = useI18n();
const route = useRoute();
const router = useRouter();
const loading = ref(true);
const errorMessage = ref("");

onMounted(async () => {
  try {
    const preAuthRoute = localStorage.getItem("preAuthRoute") || "/settings";

    // Send the auth code to backend
    await axiosInstance.get("/google/oauth/callback", {
      params: route.query,
    });

    // Clean up and redirect
    localStorage.removeItem("preAuthRoute");
    router.push(preAuthRoute);
  } catch (error) {
    errorMessage.value = error.response?.data?.message || t("oauth.error_generic");
    loading.value = false;
  }
});

const returnToSettings = () => {
  router.push("/settings");
};
</script>
