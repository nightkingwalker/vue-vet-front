<template>
  <div class="w-full mt-4 xl:!text-[12px]">
    <Card
      class="bg-[var(--p-surface-200)] dark:bg-[var(--p-surface-600)] rounded-lg p-6 max-w-2xl mx-auto"
    >
      <template #title>
        <div class="flex items-center gap-3">
          <i class="pi pi-qrcode text-2xl text-purple-500"></i>
          <h1 class="xl:!text-[16px] !text-lg font-bold">
            {{ $t("whatsapp_qr.title") }}
          </h1>
        </div>
      </template>

      <template #content>
        <div class="space-y-6">
          <div
            class="bg-white dark:bg-[var(--p-surface-700)] p-4 rounded-lg shadow text-center"
          >
            <!-- Connection Status Indicator -->
            <div v-if="connectionStatus" class="p-3 rounded mb-4" :class="statusClasses">
              <div class="flex items-center justify-center gap-2">
                <i :class="statusIcon"></i>
                <span class="lg:!text-xs">{{ connectionStatus }}</span>
              </div>

              <!-- Additional status details when checking -->
              <div v-if="connectionState !== 'checking'" class="mb-4">
                {{ $t("whatsapp_qr.status.checking_details") }}
              </div>
            </div>

            <!-- QR Code Display (only show when not checking) -->
            <div v-if="!isConnected" class="mb-4">
              <div
                class="border-2 border-dashed border-[var(--primary-color)] p-4 inline-block rounded-lg"
              >
                <img
                  v-if="qrCodeUrl"
                  :src="qrCodeUrl"
                  alt="WhatsApp QR Code"
                  class="w-64 h-64 mx-auto"
                />
                <ProgressSpinner v-else class="w-64 h-64 mx-auto" />
              </div>
            </div>

            <!-- Connection Status -->
            <div v-if="connectionStatus" class="p-3 rounded mb-4" :class="statusClasses">
              <div class="flex items-center justify-center gap-2">
                <i :class="statusIcon"></i>
                <span class="lg:!text-xs">{{ connectionStatus }}</span>
              </div>
            </div>

            <!-- Instructions -->
            <div class="text-left mb-6">
              <ol
                class="list-decimal pl-5 space-y-2 lg:!text-xs text-gray-600 dark:text-gray-300"
              >
                <li v-for="(step, index) in $tm('whatsapp_qr.instructions')" :key="index">
                  {{ step }}
                </li>
              </ol>
            </div>

            <!-- Connected Info -->
            <div v-if="isConnected" class="p-3 bg-green-50 dark:bg-green-900 rounded">
              <div
                class="flex items-center justify-center gap-2 text-green-600 dark:text-green-200"
              >
                <i class="pi pi-check-circle"></i>
                <span class="lg:!text-xs">
                  {{ $t("whatsapp_qr.connected_as", { phone: props.phone }) }}
                </span>
              </div>
            </div>
          </div>

          <div class="flex flex-col sm:flex-row gap-3 justify-between pt-2 border-t">
            <Button
              :label="$t('whatsapp_qr.back')"
              severity="secondary"
              size="small"
              class="lg:!text-xs"
              outlined
              @click="router.back()"
            />
            <Button
              :label="isConnected ? $t('whatsapp_qr.finish') : $t('whatsapp_qr.refresh')"
              :icon="isConnected ? 'pi pi-check' : 'pi pi-refresh'"
              size="small"
              class="lg:!text-xs"
              :loading="loading"
              @click="isConnected ? finishSetup() : refreshQR()"
            />
          </div>
        </div>
      </template>
    </Card>
  </div>
  <div v-if="isConnected" class="space-y-4">
    <div class="p-3 bg-green-50 dark:bg-green-900 rounded">
      <div
        class="flex items-center justify-center gap-2 text-green-600 dark:text-green-200"
      >
        <i class="pi pi-check-circle text-xl"></i>
        <span class="font-medium lg:!text-xs">
          {{ $t("whatsapp_qr.fully_connected") }}
        </span>
      </div>
    </div>

    <Card class="!shadow-none">
      <template #content>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div class="space-y-2">
            <div class="flex items-center gap-2">
              <i class="pi pi-check text-green-500"></i>
              <span class="lg:!text-xs">{{
                $t("whatsapp_qr.success_steps.connection")
              }}</span>
            </div>
            <div class="flex items-center gap-2">
              <i class="pi pi-check text-green-500"></i>
              <span class="lg:!text-xs">{{
                $t("whatsapp_qr.success_steps.verification")
              }}</span>
            </div>
          </div>
          <Button
            :label="$t('whatsapp_qr.configure_notifications')"
            icon="pi pi-cog"
            class="lg:!text-xs h-fit"
            @click="router.push({ name: 'notification-templates' })"
          />
        </div>
      </template>
    </Card>

    <Button
      :label="$t('whatsapp_qr.return_to_dashboard')"
      icon="pi pi-home"
      class="w-full lg:!text-xs"
      @click="router.push({ name: 'dashboard' })"
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from "vue";
import { useRouter, useRoute } from "vue-router";
import { useI18n } from "vue-i18n";
import QRCode from "qrcode"; // Import the QRCode library
import ProgressSpinner from "primevue/progressspinner";
import Button from "primevue/button";
import Card from "primevue/card";
import { useToast } from "primevue/usetoast";
import axiosInstance from "@/axios";
import Logo from "@/assets/logo-DOqaXMyT.png";

const { t, locale } = useI18n();
const router = useRouter();
const route = useRoute();
const toast = useToast();
const props = defineProps({
  phone: {
    type: String,
    required: true,
  },
});
const logoUrl = Logo;
const isRtl = computed(() => ["ar", "he", "fa"].includes(locale.value));
// Mock data - replace with actual API calls
const qrCodeUrl = ref(""); // Holds the QR code image URL

const isConnected = ref(false);
const loading = ref(false);
const connectionState = ref("checking"); // 'checking', 'generating', 'waiting', 'connected', 'failed'
const sessionStatus = ref(null);
const sessionId = ref(null);
const phoneNumber = ref(null);

const fetchSessionStatus = async () => {
  try {
    connectionState.value = "checking";
    const response = await axiosInstance.get("/whatsapp/session/prepare");
    console.log(response);

    sessionId.value = response.data.session_id;
    phoneNumber.value = response.data.phone_number;
    sessionStatus.value = response.data.status;

    // Check if status indicates QR code should be shown
    if (response.data.status === "SCAN_QR_CODE") {
      await fetchQRCode();
    } else if (response.data.status === "WORKING") {
      connectionState.value = "connected";
      isConnected.value = true;
    } else {
      throw new Error(
        t("whatsapp_qr.errors.unexpected_status", { status: response.data.status })
      );
    }
  } catch (error) {
    toast.add({
      severity: "error",
      summary: t("whatsapp_qr.errors.status_check_failed"),
      detail: error.message,
      life: 5000,
    });
    connectionState.value = "failed";
  }
};
const generateQRCodeWithLogo = async (text, logoUrl) => {
  try {
    // Generate the base QR code
    const baseQrCodeUrl = await QRCode.toDataURL(text, {
      width: 350,
      margin: 2,
      errorCorrectionLevel: "H", // Important when adding logo
    });

    // Create canvas for QR code
    const canvas = document.createElement("canvas");
    const ctx = canvas.getContext("2d");
    const qrImage = new Image();

    // Load QR code image
    await new Promise((resolve) => {
      qrImage.onload = resolve;
      qrImage.src = baseQrCodeUrl;
    });

    // Set canvas size and draw QR code
    canvas.width = qrImage.width;
    canvas.height = qrImage.height;
    ctx.drawImage(qrImage, 0, 0);

    // Load logo
    const logoImage = new Image();
    await new Promise((resolve) => {
      logoImage.onload = resolve;
      logoImage.src = logoUrl;
    });

    // Calculate logo size and position (centered)
    const logoSize = canvas.width / 4;
    const logoX = (canvas.width - logoSize) / 2;
    const logoY = (canvas.height - logoSize) / 2;

    // Optional: Add white background behind logo
    ctx.fillStyle = "#ffffff";
    ctx.fillRect(logoX - 2, logoY - 2, logoSize + 4, logoSize + 4);

    // Draw logo on QR code
    ctx.drawImage(logoImage, logoX, logoY, logoSize, logoSize);

    // Update the reactive reference
    qrCodeUrl.value = canvas.toDataURL();
  } catch (error) {
    console.error("Error generating QR code with logo:", error);
  }
};

const fetchQRCode = async () => {
  try {
    connectionState.value = "generating";
    loading.value = true;

    // const response = await axios.get("/api/whatsapp/qr-code");
    const response = await axiosInstance.get("/whatsapp/qr-code");
    console.log(response.data.qr_code);
    // qrCodeUrl.value = `https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${encodeURIComponent(
    //   response.data.qr_code
    // )}`;
    // logoUrl
    generateQRCodeWithLogo(response.data.qr_code, logoUrl);
    connectionState.value = "waiting";
    startConnectionPolling();
  } catch (error) {
    toast.add({
      severity: "error",
      summary: t("whatsapp_qr.errors.qr_fetch_failed"),
      detail: error.message,
      life: 5000,
    });
    connectionState.value = "failed";
  } finally {
    loading.value = false;
  }
};

const startConnectionPolling = () => {
  const poll = setInterval(async () => {
    try {
      // const response = await axios.get("/api/whatsapp/session/status");
      const response = await axiosInstance.get("/whatsapp/session/status");

      if (response.data.status === "WORKING") {
        clearInterval(poll);
        connectionState.value = "connected";
        isConnected.value = true;

        // Optional: Add slight delay for better UX
        setTimeout(() => {
          toast.add({
            severity: "success",
            summary: t("whatsapp_qr.connection_success"),
            life: 3000,
          });
        }, 500);
      }
    } catch (error) {
      console.error("Polling error:", error);
    }
  }, 3000);
};

const refreshQR = async () => {
  await fetchSessionStatus();
};

// Simulate QR generation
onMounted(() => {
  fetchSessionStatus();
});

// Update computed properties to include 'checking' state
const connectionStatus = computed(() => {
  switch (connectionState.value) {
    case "checking":
      return t("whatsapp_qr.status.checking");
    case "generating":
      return t("whatsapp_qr.status.generating");
    case "waiting":
      return t("whatsapp_qr.status.waiting");
    case "connected":
      return t("whatsapp_qr.status.connected");
    case "failed":
      return t("whatsapp_qr.status.failed");
    default:
      return "";
  }
});

const statusClasses = computed(() => ({
  "bg-blue-50 dark:bg-blue-900 text-blue-600 dark:text-blue-200":
    connectionState.value === "checking",
  "bg-blue-50 dark:bg-blue-900 text-blue-600 dark:text-blue-200":
    connectionState.value === "generating",
  "bg-amber-50 dark:bg-amber-900 text-amber-600 dark:text-amber-200":
    connectionState.value === "waiting",
  "bg-green-50 dark:bg-green-900 text-green-600 dark:text-green-200":
    connectionState.value === "connected",
  "bg-red-50 dark:bg-red-900 text-red-600 dark:text-red-200":
    connectionState.value === "failed",
}));

const statusIcon = computed(() => {
  switch (connectionState.value) {
    case "checking":
      return "pi pi-spin pi-spinner";
    case "generating":
      return "pi pi-spin pi-spinner";
    case "waiting":
      return "pi pi-clock";
    case "connected":
      return "pi pi-check-circle";
    case "failed":
      return "pi pi-times-circle";
    default:
      return "pi pi-info-circle";
  }
});

const finishSetup = () => {
  router.push({ name: "whatsapp-connection-success" });
};
</script>
