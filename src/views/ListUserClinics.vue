<template>
  <div class="container mx-auto px-4 py-8">
    <div class="flex justify-between items-center mb-8">
      <h1 class="text-3xl font-bold text-surface-0">My Clinics</h1>
      <Button
        label="Add Clinic"
        icon="pi pi-plus"
        class="p-button-primary bg-emerald-600 hover:bg-emerald-500 border-emerald-600"
        @click="showAddClinicDialog = true"
      />
    </div>

    <!-- Clinic List -->
    <Card v-if="loading" class="mb-4 bg-surface-300 border-surface-400">
      <template #content>
        <div class="flex justify-center py-8">
          <ProgressSpinner class="text-emerald-400" />
        </div>
      </template>
    </Card>

    <div v-else-if="clinics.length === 0" class="text-center py-12">
      <i class="pi pi-building text-5xl text-surface-600 mb-4"></i>
      <p class="text-surface-500">You are not associated with any clinics yet.</p>
      <Button
        label="Join a Clinic"
        icon="pi pi-plus"
        class="p-button-text mt-4 text-emerald-400 hover:text-emerald-300"
        @click="showAddClinicDialog = true"
      />
    </div>

    <div v-else class="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
      <Card
        v-for="clinic in clinics"
        :key="clinic.id"
        class="bg-surface-300 border-surface-500 hover:border-emerald-400 transition-all"
      >
        <template #header>
          <div class="bg-surface-400 p-4 rounded-t-lg border-b border-surface-500">
            <div class="flex justify-between items-start">
              <h2 class="text-xl font-semibold text-surface-0">{{ clinic.name }}</h2>
              <Tag
                :value="clinic.pivot.role"
                :severity="getRoleSeverity(clinic.pivot.role)"
                class="capitalize border-0"
              />
            </div>
          </div>
        </template>

        <template #content>
          <div class="space-y-3 text-surface-100">
            <div class="flex items-start gap-2">
              <i class="pi pi-map-marker mt-1 mr-2 text-emerald-400"></i>
              <span>{{ clinic.address }}</span>
            </div>
            <div class="flex items-start gap-2">
              <i class="pi pi-phone mt-1 mr-2 text-emerald-400"></i>
              <span>{{ clinic.phone }}</span>
            </div>
            <div class="flex items-start gap-2">
              <i class="pi pi-envelope mt-1 mr-2 text-emerald-400"></i>
              <span>{{ clinic.email }}</span>
            </div>
          </div>
        </template>

        <template #footer>
          <div class="flex justify-between border-t border-surface-500 pt-3">
            <Button
              label="Branches"
              icon="pi pi-sitemap"
              class="p-button-text p-button-sm text-emerald-400 hover:text-emerald-300"
              @click="viewBranches(clinic)"
            />
            <div>
              <Button
                v-if="['super_admin', 'admin', 'manager'].includes(clinic.pivot.role)"
                icon="pi pi-cog"
                class="p-button-text p-button-sm p-button-secondary text-surface-300 hover:text-surface-100 mr-2"
                @click="manageClinic(clinic)"
              />
              <Button
                icon="pi pi-sign-out"
                class="p-button-text p-button-sm p-button-danger text-rose-400 hover:text-rose-300"
                @click="confirmLeaveClinic(clinic)"
              />
            </div>
          </div>
        </template>
      </Card>
    </div>

    <!-- Add Clinic Dialog -->
    <Dialog
      v-model:visible="showAddClinicDialog"
      header="Join a Clinic"
      :modal="true"
      :style="{ width: '500px' }"
      :breakpoints="{ '960px': '75vw', '640px': '90vw' }"
      class="bg-surface-300 text-surface-100"
    >
      <div class="space-y-4">
        <div>
          <label for="clinicEmail" class="block text-sm font-medium text-surface-200 mb-1"
            >Clinic Email</label
          >
          <InputText
            id="clinicEmail"
            v-model="clinicEmail"
            type="email"
            placeholder="Enter clinic's registered email"
            class="w-full bg-surface-400 border-surface-500 text-surface-100"
          />
        </div>
        <div>
          <label for="role" class="block text-sm font-medium text-surface-200 mb-1"
            >Your Role</label
          >
          <Select
            v-model="selectedRole"
            :options="availableRoles"
            optionLabel="label"
            optionValue="value"
            placeholder="Select your role"
            class="w-full bg-surface-400 border-surface-500 text-surface-100"
          />
        </div>
      </div>

      <template #footer>
        <Button
          label="Cancel"
          icon="pi pi-times"
          class="p-button-text text-surface-300 hover:text-surface-100"
          @click="showAddClinicDialog = false"
        />
        <Button
          label="Join"
          icon="pi pi-check"
          class="p-button-primary bg-emerald-600 hover:bg-emerald-500 border-emerald-600"
          :loading="joiningClinic"
          @click="joinClinic"
        />
      </template>
    </Dialog>

    <!-- Confirmation Dialog -->
    <Dialog
      v-model:visible="showLeaveConfirm"
      header="Confirm Action"
      :modal="true"
      :style="{ width: '400px' }"
      class="bg-surface-300 text-surface-100"
    >
      <div class="confirmation-content flex items-center">
        <i
          class="pi pi-exclamation-triangle mr-3 text-amber-400"
          style="font-size: 2rem"
        />
        <span class="text-surface-200"
          >Are you sure you want to leave {{ clinicToLeave?.name }}?</span
        >
      </div>
      <template #footer>
        <Button
          label="No"
          icon="pi pi-times"
          class="p-button-text text-surface-300 hover:text-surface-100"
          @click="showLeaveConfirm = false"
        />
        <Button
          label="Yes"
          icon="pi pi-check"
          class="p-button-danger bg-rose-600 hover:bg-rose-500 border-rose-600"
          @click="leaveClinic"
        />
      </template>
    </Dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useToast } from "primevue/usetoast";
import axios from "@/axios";
import Button from "primevue/button";
import Select from "primevue/select";
import Dialog from "primevue/dialog";
import Card from "primevue/card";
import Tag from "primevue/tag";
import InputText from "primevue/inputtext";
import ProgressSpinner from "primevue/progressspinner";
import router from "@/router";
const toast = useToast();

// Clinic data
const clinics = ref([]);
const loading = ref(true);

// Add clinic dialog
const showAddClinicDialog = ref(false);
const clinicEmail = ref("");
const selectedRole = ref("staff");
const joiningClinic = ref(false);

// Leave clinic confirmation
const showLeaveConfirm = ref(false);
const clinicToLeave = ref(null);

// Available roles for Select
const availableRoles = ref([
  { label: "Admin", value: "admin" },
  { label: "Manager", value: "manager" },
  { label: "Veterinarian", value: "vet" },
  { label: "Staff", value: "staff" },
]);

// Fetch user's clinics
const fetchClinics = async () => {
  try {
    loading.value = true;
    const response = await axios.get("/clinics");
    clinics.value = response.data;
  } catch (error) {
    toast.add({
      severity: "error",
      summary: "Error",
      detail: "Failed to fetch clinics",
      life: 3000,
    });
  } finally {
    loading.value = false;
  }
};

// Join a new clinic
const joinClinic = async () => {
  if (!clinicEmail.value) {
    toast.add({
      severity: "warn",
      summary: "Warning",
      detail: "Please enter clinic email",
      life: 3000,
    });
    return;
  }

  joiningClinic.value = true;
  try {
    await axios.post("/api/user/clinics", {
      email: clinicEmail.value,
      role: selectedRole.value,
    });

    toast.add({
      severity: "success",
      summary: "Success",
      detail: "Successfully joined clinic",
      life: 3000,
    });

    showAddClinicDialog.value = false;
    clinicEmail.value = "";
    fetchClinics();
  } catch (error) {
    let message = "Failed to join clinic";
    if (error.response?.data?.message) {
      message = error.response.data.message;
    }

    toast.add({
      severity: "error",
      summary: "Error",
      detail: message,
      life: 3000,
    });
  } finally {
    joiningClinic.value = false;
  }
};

// Confirm leave clinic
const confirmLeaveClinic = (clinic) => {
  clinicToLeave.value = clinic;
  showLeaveConfirm.value = true;
};

// Actually leave clinic
const leaveClinic = async () => {
  if (!clinicToLeave.value) return;

  try {
    await axios.delete(`/api/user/clinics/${clinicToLeave.value.id}`);

    toast.add({
      severity: "success",
      summary: "Success",
      detail: `Left ${clinicToLeave.value.name}`,
      life: 3000,
    });

    showLeaveConfirm.value = false;
    fetchClinics();
  } catch (error) {
    toast.add({
      severity: "error",
      summary: "Error",
      detail: "Failed to leave clinic",
      life: 3000,
    });
  }
};

// View branches of a clinic
const viewBranches = async (clinic) => {
  //   console.log(clinic);
  await router.push({ path: "/clinics/" + clinic.id + "/branches" });
  // For now just show a toast
  toast.add({
    severity: "info",
    summary: "Branches",
    detail: `Viewing branches of ${clinic.name}`,
    life: 3000,
  });
};

// Manage clinic (only for admins/managers)
const manageClinic = async (clinic) => {
  console.log(clinic);
  // Navigate to clinic management page
  await router.push({ path: "/" + clinic.id + "/manage" });
  // For now just show a toast
  toast.add({
    severity: "info",
    summary: "Manage Clinic",
    detail: `Managing ${clinic.name}`,
    life: 3000,
  });
};

// Helper to get role severity for tag
const getRoleSeverity = (role) => {
  switch (role) {
    case "admin":
      return "danger";
    case "manager":
      return "warning";
    case "vet":
      return "info";
    default:
      return "success";
  }
};

// Fetch clinics on component mount
onMounted(() => {
  fetchClinics();
});
</script>

<style scoped>
/* Add any custom styles here */
.card-header {
  border-bottom: 1px solid #e5e7eb;
}
</style>
