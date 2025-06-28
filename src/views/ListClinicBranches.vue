<template>
  <div class="container mx-auto px-4 py-8">
    <!-- Branch Header -->
    <div
      class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4"
    >
      <div>
        <h1 class="text-3xl font-bold text-surface-0">{{ clinic.name }} Branches</h1>
        <p class="text-surface-400">{{ clinic.address }}</p>
      </div>
      <div class="flex gap-3">
        <Button
          label="Back to Clinic"
          icon="pi pi-arrow-left"
          class="p-button-text text-emerald-400 hover:text-emerald-300"
          @click="$router.push(`/clinics`)"
        />
        <Button
          label="Add Branch"
          icon="pi pi-plus"
          class="p-button-primary bg-emerald-600 hover:bg-emerald-500 border-emerald-600"
          @click="showAddBranchDialog = true"
        />
      </div>
    </div>

    <!-- Branch List -->
    <Card class="bg-surface-300 border-surface-500 mb-6">
      <template #content>
        <DataTable
          :value="branches"
          :loading="loading"
          class="p-datatable-sm"
          :rows="10"
          paginator
          paginatorTemplate="FirstPageLink PrevPageLink PageLinks NextPageLink LastPageLink CurrentPageReport RowsPerPageDropdown"
          :rowsPerPageOptions="[5, 10, 25, 50]"
          currentPageReportTemplate="Showing {first} to {last} of {totalRecords} branches"
        >
          <Column field="name" header="Name" sortable>
            <template #body="{ data }">
              <span class="text-surface-100 font-medium">{{ data.name }}</span>
            </template>
          </Column>
          <Column field="address" header="Address" sortable>
            <template #body="{ data }">
              <span class="text-surface-200">{{ data.address }}</span>
            </template>
          </Column>
          <Column field="phone" header="Phone" sortable>
            <template #body="{ data }">
              <span class="text-surface-200">{{ data.phone }}</span>
            </template>
          </Column>
          <Column header="Actions" :styles="{ width: '150px' }">
            <template #body="{ data }">
              <div class="flex gap-2">
                <Button
                  icon="pi pi-users"
                  class="p-button-sm p-button-text text-surface-300 hover:text-emerald-400"
                  @click="viewBranchUsers(data)"
                  v-tooltip.top="'View Users'"
                />
                <Button
                  icon="pi pi-pencil"
                  class="p-button-sm p-button-text text-surface-300 hover:text-emerald-400"
                  @click="openEditBranchDialog(data)"
                  v-tooltip.top="'Edit Branch'"
                />
                <Button
                  icon="pi pi-trash"
                  class="p-button-sm p-button-text text-surface-300 hover:text-rose-400"
                  @click="confirmDeleteBranch(data)"
                  v-tooltip.top="'Delete Branch'"
                />
              </div>
            </template>
          </Column>
        </DataTable>
      </template>
    </Card>

    <!-- Add Branch Dialog -->
    <Dialog
      v-model:visible="showAddBranchDialog"
      header="Add New Branch"
      :modal="true"
      :style="{ width: '500px' }"
      class="bg-surface-300 text-surface-100"
    >
      <div class="space-y-4">
        <div>
          <label class="block text-sm font-medium text-surface-200 mb-1"
            >Branch Name</label
          >
          <InputText
            v-model="newBranch.name"
            class="w-full bg-surface-400 border-surface-500 text-surface-100"
            placeholder="Enter branch name"
          />
        </div>
        <div>
          <label class="block text-sm font-medium text-surface-200 mb-1">Address</label>
          <InputText
            v-model="newBranch.address"
            class="w-full bg-surface-400 border-surface-500 text-surface-100"
            placeholder="Enter branch address"
          />
        </div>
        <div>
          <label class="block text-sm font-medium text-surface-200 mb-1">Phone</label>
          <InputText
            v-model="newBranch.phone"
            class="w-full bg-surface-400 border-surface-500 text-surface-100"
            placeholder="Enter branch phone"
          />
        </div>
      </div>

      <template #footer>
        <Button
          label="Cancel"
          icon="pi pi-times"
          class="p-button-text text-surface-300 hover:text-surface-100"
          @click="closeAddBranchDialog"
        />
        <Button
          label="Add Branch"
          icon="pi pi-check"
          class="p-button-primary bg-emerald-600 hover:bg-emerald-500 border-emerald-600"
          :loading="addingBranch"
          @click="addBranch"
        />
      </template>
    </Dialog>

    <!-- Edit Branch Dialog -->
    <Dialog
      v-model:visible="showEditBranchDialog"
      :header="`Edit ${branchToEdit?.name}`"
      :modal="true"
      :style="{ width: '500px' }"
      class="bg-surface-300 text-surface-100"
    >
      <div class="space-y-4">
        <div>
          <label class="block text-sm font-medium text-surface-200 mb-1"
            >Branch Name</label
          >
          <InputText
            v-model="branchToEdit.name"
            class="w-full bg-surface-400 border-surface-500 text-surface-100"
          />
        </div>
        <div>
          <label class="block text-sm font-medium text-surface-200 mb-1">Address</label>
          <InputText
            v-model="branchToEdit.address"
            class="w-full bg-surface-400 border-surface-500 text-surface-100"
          />
        </div>
        <div>
          <label class="block text-sm font-medium text-surface-200 mb-1">Phone</label>
          <InputText
            v-model="branchToEdit.phone"
            class="w-full bg-surface-400 border-surface-500 text-surface-100"
          />
        </div>
      </div>

      <template #footer>
        <Button
          label="Cancel"
          icon="pi pi-times"
          class="p-button-text text-surface-300 hover:text-surface-100"
          @click="showEditBranchDialog = false"
        />
        <Button
          label="Save Changes"
          icon="pi pi-check"
          class="p-button-primary bg-emerald-600 hover:bg-emerald-500 border-emerald-600"
          :loading="updatingBranch"
          @click="updateBranch"
        />
      </template>
    </Dialog>

    <!-- Delete Branch Confirmation -->
    <Dialog
      v-model:visible="showDeleteConfirm"
      header="Confirm Deletion"
      :modal="true"
      :style="{ width: '400px' }"
      class="bg-surface-300 text-surface-100"
    >
      <div class="confirmation-content flex items-center">
        <i
          class="pi pi-exclamation-triangle mr-3 text-amber-400"
          style="font-size: 2rem"
        />
        <span class="text-surface-200">
          Delete branch {{ branchToDelete?.name }}? This action cannot be undone.
        </span>
      </div>
      <template #footer>
        <Button
          label="No"
          icon="pi pi-times"
          class="p-button-text text-surface-300 hover:text-surface-100"
          @click="showDeleteConfirm = false"
        />
        <Button
          label="Yes, Delete"
          icon="pi pi-check"
          class="p-button-danger bg-rose-600 hover:bg-rose-500 border-rose-600"
          :loading="deletingBranch"
          @click="deleteBranch"
        />
      </template>
    </Dialog>

    <!-- Toast for notifications -->
    <Toast position="bottom-right" />
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useToast } from "primevue/usetoast";
import axios from "@/axios";
import Button from "primevue/button";
import Select from "primevue/select";
import Dialog from "primevue/dialog";
import Card from "primevue/card";
import Tag from "primevue/tag";
import InputText from "primevue/inputtext";
import Column from "primevue/column";
import DataTable from "primevue/datatable";

const route = useRoute();
const router = useRouter();
const toast = useToast();

const clinicId = route.params.clinic;

// Clinic data
const clinic = ref({});
const branches = ref([]);
const loading = ref(true);

// Add branch dialog
const showAddBranchDialog = ref(false);
const newBranch = ref({
  clinic_id: clinicId,
  name: "",
  address: "",
  phone: "",
});
const addingBranch = ref(false);

// Edit branch dialog
const showEditBranchDialog = ref(false);
const branchToEdit = ref(null);
const updatingBranch = ref(false);

// Delete branch confirmation
const showDeleteConfirm = ref(false);
const branchToDelete = ref(null);
const deletingBranch = ref(false);

// Fetch clinic and branches
const fetchClinicData = async () => {
  try {
    loading.value = true;
    const [clinicRes, branchesRes] = await Promise.all([
      axios.get(`/clinics/${clinicId}`),
      axios.get(`/clinics/${clinicId}/branches`),
    ]);

    clinic.value = clinicRes.data;
    branches.value = branchesRes.data;
  } catch (error) {
    toast.add({
      severity: "error",
      summary: "Error",
      detail: "Failed to fetch clinic data",
      life: 3000,
    });
    router.push("/clinics");
  } finally {
    loading.value = false;
  }
};

// Add new branch
const addBranch = async () => {
  try {
    addingBranch.value = true;
    const response = await axios.post(`/clinics/${clinicId}/branches`, newBranch.value);
    
    toast.add({
      severity: "success",
      summary: "Success",
      detail: "Branch added successfully",
      life: 3000,
    });

    closeAddBranchDialog();
    fetchClinicData();
  } catch (error) {
    
    toast.add({
      severity: "error",
      summary: "Error",
      detail: "Failed to add branch",
      life: 3000,
    });
  } finally {
    addingBranch.value = false;
  }
};

// Open edit branch dialog
const openEditBranchDialog = (branch) => {
  branchToEdit.value = { ...branch };
  showEditBranchDialog.value = true;
};

// Update branch
const updateBranch = async () => {
  try {
    updatingBranch.value = true;
    await axios.put(`/branches/${branchToEdit.value.id}`, branchToEdit.value);

    toast.add({
      severity: "success",
      summary: "Success",
      detail: "Branch updated successfully",
      life: 3000,
    });

    showEditBranchDialog.value = false;
    fetchClinicData();
  } catch (error) {
    toast.add({
      severity: "error",
      summary: "Error",
      detail: "Failed to update branch",
      life: 3000,
    });
  } finally {
    updatingBranch.value = false;
  }
};

// Confirm delete branch
const confirmDeleteBranch = (branch) => {
  branchToDelete.value = branch;
  showDeleteConfirm.value = true;
};

// Delete branch
const deleteBranch = async () => {
  try {
    deletingBranch.value = true;
    await axios.delete(`/branches/${branchToDelete.value.id}`);

    toast.add({
      severity: "success",
      summary: "Success",
      detail: "Branch deleted successfully",
      life: 3000,
    });

    showDeleteConfirm.value = false;
    fetchClinicData();
  } catch (error) {
    toast.add({
      severity: "error",
      summary: "Error",
      detail: "Failed to delete branch",
      life: 3000,
    });
  } finally {
    deletingBranch.value = false;
  }
};

// View branch users
const viewBranchUsers = (branch) => {
  router.push(`/branches/${branch.id}/users`);
};

// Close add branch dialog
const closeAddBranchDialog = () => {
  showAddBranchDialog.value = false;
  newBranch.value = {
    name: "",
    address: "",
    phone: "",
  };
};

// Fetch data on mount
onMounted(() => {
  fetchClinicData();
});
</script>

<style scoped>
/* Custom styles if needed */
</style>
