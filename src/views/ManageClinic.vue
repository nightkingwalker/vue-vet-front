<template>
  <div class="container mx-auto px-4 py-8">
    <!-- Clinic Header -->
    <div
      class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4"
    >
      <div>
        <h1 class="text-3xl font-bold text-surface-0">{{ clinic.name }}</h1>
        <p class="text-surface-400">{{ clinic.address }}</p>
      </div>
      <div class="flex gap-3">
        <Button
          label="Back to Clinics"
          icon="pi pi-arrow-left"
          class="p-button-text text-emerald-400 hover:text-emerald-300"
          @click="$router.push('/clinics')"
        />

        <Button
          label="Edit Clinic"
          icon="pi pi-pencil"
          class="p-button-outlined p-button-secondary border-surface-500 text-surface-200 hover:border-emerald-400"
          @click="showEditDialog = true"
        />
      </div>
    </div>

    <!-- Stats Cards -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
      <Card class="bg-surface-300 border-surface-500">
        <template #content>
          <div class="flex items-center justify-between">
            <div>
              <span class="block text-surface-400 text-sm">Total Users</span>
              <span class="text-2xl font-semibold text-surface-0">{{
                users.length
              }}</span>
            </div>
            <i class="pi pi-users text-3xl text-emerald-400"></i>
          </div>
        </template>
      </Card>
      <Card class="bg-surface-300 border-surface-500">
        <template #content>
          <div class="flex items-center justify-between">
            <div>
              <span class="block text-surface-400 text-sm">Admins</span>
              <span class="text-2xl font-semibold text-surface-0">{{
                (roleCounts.admin ? roleCounts.admin : 0) +
                  (roleCounts.super_admin ? roleCounts.super_admin : 0) || 0
              }}</span>
            </div>
            <i class="pi pi-shield text-3xl text-emerald-400"></i>
          </div>
        </template>
      </Card>
      <Card class="bg-surface-300 border-surface-500">
        <template #content>
          <div class="flex items-center justify-between">
            <div>
              <span class="block text-surface-400 text-sm">Veterinarians</span>
              <span class="text-2xl font-semibold text-surface-0">{{
                roleCounts.vet || 0
              }}</span>
            </div>
            <i class="pi pi-heart text-3xl text-emerald-400"></i>
          </div>
        </template>
      </Card>
      <Card class="bg-surface-300 border-surface-500">
        <template #content>
          <div class="flex items-center justify-between">
            <div>
              <span class="block text-surface-400 text-sm">Staff</span>
              <span class="text-2xl font-semibold text-surface-0">{{
                roleCounts.staff || 0
              }}</span>
            </div>
            <i class="pi pi-heart text-3xl text-emerald-400"></i>
          </div>
        </template>
      </Card>
    </div>

    <!-- User Management Section -->
    <Card class="bg-surface-300 border-surface-500 mb-6">
      <template #header>
        <div class="flex justify-between items-center p-4 border-b border-surface-500">
          <h2 class="text-xl font-semibold text-surface-0">Clinic Members</h2>
          <div class="w-fit flex gap-2">
            <Button
              icon="pi pi-refresh"
              @click="fetchClinicData"
              class="p-button-text !text-emerald-400 hover:text-emerald-300 text-sm md:text-base"
              v-tooltip.top="$t('owners.actions.refresh')"
            />
            <Button
              icon="fa-solid fa-user-plus"
              class="p-button-text !text-emerald-400 hover:text-emerald-300 border-emerald-600"
              @click="showAddUserDialog = true"
            />
          </div>
        </div>
      </template>
      <template #content>
        <DataTable
          :value="users"
          :loading="loading"
          class="p-datatable-sm"
          :rows="10"
          paginator
          paginatorTemplate="FirstPageLink PrevPageLink PageLinks NextPageLink LastPageLink CurrentPageReport RowsPerPageDropdown"
          :rowsPerPageOptions="[5, 10, 25, 50]"
          currentPageReportTemplate="Showing {first} to {last} of {totalRecords} users"
        >
          <Column field="name" header="Name" sortable>
            <template #body="{ data }">
              <div class="flex items-center gap-3">
                <Avatar
                  :label="data.name.charAt(0)"
                  class="bg-surface-500 text-surface-100"
                  shape="circle"
                />
                <span class="text-surface-100">{{ data.name }}</span>
              </div>
            </template>
          </Column>
          <Column field="email" header="Email" sortable>
            <template #body="{ data }">
              <span class="text-surface-200">{{ data.email }}</span>
            </template>
          </Column>
          <Column field="pivot.role" header="Role" sortable>
            <template #body="{ data }">
              <Tag
                :value="data.pivot.role"
                :severity="getRoleSeverity(data.pivot.role)"
                class="capitalize border-0"
              />
            </template>
          </Column>
          <Column field="joined_at" header="Joined" sortable>
            <template #body="{ data }">
              <span class="text-surface-400">{{
                formatDate(data.pivot.created_at)
              }}</span>
            </template>
          </Column>
          <Column header="Actions" :styles="{ width: '150px' }">
            <template #body="{ data }">
              <div class="flex gap-2">
                <Button
                  icon="pi pi-user-edit"
                  class="p-button-sm p-button-text text-surface-300 hover:text-emerald-400"
                  @click="openEditUserRoleDialog(data)"
                  v-tooltip.top="'Edit Role'"
                />
                <Button
                  icon="pi pi-user-minus"
                  class="p-button-sm p-button-text text-surface-300 hover:text-rose-400"
                  @click="confirmRemoveUser(data)"
                  v-tooltip.top="'Remove User'"
                  :disabled="data.pivot.role === 'super_admin'"
                />
              </div>
            </template>
          </Column>
        </DataTable>
      </template>
    </Card>

    <!-- Add User Dialog -->
    <!--     <Dialog
      v-model:visible="showAddUserDialog"
      header="Add User to Clinic"
      :modal="true"
      :style="{ width: '500px' }"
      class="bg-surface-300 text-surface-100"
    >
      <div class="space-y-4">
        <div>
          <label class="block text-sm font-medium text-surface-200 mb-1"
            >Search Users</label
          >
          <div class="relative">
            <InputText
              v-model="userSearchQuery"
              placeholder="Search by name or email"
              class="w-full bg-surface-400 border-surface-500 text-surface-100 pl-10"
            />
            <i
              class="pi pi-search absolute left-3 top-2/4 -translate-y-2/4 text-surface-400"
            ></i>
          </div>
        </div>

        <div
          v-if="searchResults.length > 0"
          class="border border-surface-500 rounded-lg max-h-60 overflow-y-auto"
        >
          <div
            v-for="user in searchResults"
            :key="user.id"
            class="p-3 hover:bg-surface-400 cursor-pointer flex justify-between items-center border-b border-surface-500 last:border-b-0"
            @click="selectUser(user)"
          >
            <div class="flex items-center gap-3">
              <Avatar
                :label="user.name.charAt(0)"
                class="bg-surface-500 text-surface-100"
                shape="circle"
              />
              <div>
                <p class="text-surface-100 font-medium">{{ user.name }}</p>
                <p class="text-surface-400 text-sm">{{ user.email }}</p>
              </div>
            </div>
            <i class="pi pi-plus text-emerald-400"></i>
          </div>
        </div>

        <div v-if="selectedUser" class="bg-surface-400 p-4 rounded-lg">
          <div class="flex justify-between items-center mb-4">
            <div class="flex items-center gap-3">
              <Avatar
                :label="selectedUser.name.charAt(0)"
                class="bg-surface-500 text-surface-100"
                shape="circle"
              />
              <div>
                <p class="text-surface-100 font-medium">{{ selectedUser.name }}</p>
                <p class="text-surface-400 text-sm">{{ selectedUser.email }}</p>
              </div>
            </div>
            <Button
              icon="pi pi-times"
              class="p-button-text p-button-danger text-surface-400 hover:text-rose-400"
              @click="selectedUser = null"
            />
          </div>

          <div>
            <label class="block text-sm font-medium text-surface-200 mb-1"
              >Assign Role</label
            >
            <Select
              v-model="newUserRole"
              :options="availableRoles"
              optionLabel="label"
              optionValue="value"
              placeholder="Select role"
              class="w-full bg-surface-400 border-surface-500 text-surface-100"
            />
          </div>
        </div>
      </div>

      <template #footer>
        <Button
          label="Cancel"
          icon="pi pi-times"
          class="p-button-text text-surface-300 hover:text-surface-100"
          @click="closeAddUserDialog"
        />
        <Button
          label="Add User"
          icon="pi pi-check"
          class="p-button-primary bg-emerald-600 hover:bg-emerald-500 border-emerald-600"
          :disabled="!selectedUser || !newUserRole"
          :loading="addingUser"
          @click="addUserToClinic"
        />
      </template>
    </Dialog>
 -->
    <Dialog
      v-model:visible="showAddUserDialog"
      :modal="true"
      class="bg-surface-300 text-surface-100"
    >
      <template #header>Invite New Member</template>
      <div class="space-y-4">
        <InputText v-model="inviteEmail" placeholder="user@example.com" />
        <Select
          v-model="inviteRole"
          :options="availableRoles"
          optionLabel="label"
          optionValue="value"
        />
      </div>
      <template #footer>
        <Button label="Send Invite" @click="sendInvite" />
      </template>
    </Dialog>
    <!-- Edit User Role Dialog -->
    <Dialog
      v-model:visible="showEditUserRoleDialog"
      :header="`Edit ${userToEdit?.name}'s Role`"
      :modal="true"
      :style="{ width: '400px' }"
      class="bg-surface-300 text-surface-100"
    >
      <div class="space-y-4">
        <div>
          <label class="block text-sm font-medium text-surface-200 mb-1"
            >Current Role</label
          >
          <InputText
            :value="userToEdit?.pivot.role"
            class="w-full bg-surface-400 border-surface-500 text-surface-100"
            disabled
          />
        </div>

        <div>
          <label class="block text-sm font-medium text-surface-200 mb-1">New Role</label>
          <Select
            v-model="updatedUserRole"
            :options="availableRoles"
            optionLabel="label"
            optionValue="value"
            placeholder="Select new role"
            class="w-full bg-surface-400 border-surface-500 text-surface-100"
          />
        </div>
      </div>

      <template #footer>
        <Button
          label="Cancel"
          icon="pi pi-times"
          class="p-button-text text-surface-300 hover:text-surface-100"
          @click="showEditUserRoleDialog = false"
        />
        <Button
          label="Update Role"
          icon="pi pi-check"
          class="p-button-primary bg-emerald-600 hover:bg-emerald-500 border-emerald-600"
          :disabled="!updatedUserRole || updatedUserRole === userToEdit?.pivot.role"
          :loading="updatingRole"
          @click="updateUserRole"
        />
      </template>
    </Dialog>

    <!-- Remove User Confirmation -->
    <Dialog
      v-model:visible="showRemoveUserConfirm"
      header="Confirm Removal"
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
          Remove {{ userToRemove?.name }} from {{ clinic.name }}?
        </span>
      </div>
      <template #footer>
        <Button
          label="No"
          icon="pi pi-times"
          class="p-button-text text-surface-300 hover:text-surface-100"
          @click="showRemoveUserConfirm = false"
        />
        <Button
          label="Yes, Remove"
          icon="pi pi-check"
          class="p-button-danger bg-rose-600 hover:bg-rose-500 border-rose-600"
          :loading="removingUser"
          @click="removeUserFromClinic"
        />
      </template>
    </Dialog>

    <!-- Edit Clinic Dialog -->
    <Dialog
      v-model:visible="showEditDialog"
      header="Edit Clinic"
      :modal="true"
      :style="{ width: '500px' }"
      class="bg-surface-300 text-surface-100"
    >
      <div class="space-y-4">
        <div>
          <label class="block text-sm font-medium text-surface-200 mb-1"
            >Clinic Name</label
          >
          <InputText
            v-model="clinicForm.name"
            class="w-full bg-surface-400 border-surface-500 text-surface-100"
          />
        </div>
        <div>
          <label class="block text-sm font-medium text-surface-200 mb-1">Address</label>
          <InputText
            v-model="clinicForm.address"
            class="w-full bg-surface-400 border-surface-500 text-surface-100"
          />
        </div>
        <div>
          <label class="block text-sm font-medium text-surface-200 mb-1">Phone</label>
          <InputText
            v-model="clinicForm.phone"
            class="w-full bg-surface-400 border-surface-500 text-surface-100"
          />
        </div>
        <div>
          <label class="block text-sm font-medium text-surface-200 mb-1">Email</label>
          <InputText
            v-model="clinicForm.email"
            type="email"
            class="w-full bg-surface-400 border-surface-500 text-surface-100"
          />
        </div>
      </div>

      <template #footer>
        <Button
          label="Cancel"
          icon="pi pi-times"
          class="p-button-text text-surface-300 hover:text-surface-100"
          @click="showEditDialog = false"
        />
        <Button
          label="Save Changes"
          icon="pi pi-check"
          class="p-button-primary bg-emerald-600 hover:bg-emerald-500 border-emerald-600"
          :loading="savingClinic"
          @click="updateClinic"
        />
      </template>
    </Dialog>

    <!-- Toast for notifications -->
    <Toast position="bottom-right" />
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useToast } from "primevue/usetoast";
import Button from "primevue/button";
import Select from "primevue/select";
import Dialog from "primevue/dialog";
import Card from "primevue/card";
import Tag from "primevue/tag";
import InputText from "primevue/inputtext";
import Avatar from "primevue/avatar";
import Column from "primevue/column";
import DataTable from "primevue/datatable";

import axiosInstance from "@/axios";

const route = useRoute();
const router = useRouter();
const toast = useToast();

const clinicId = route.params.clinic;
const inviteEmail = ref("");
const inviteRole = ref("staff");
const showInviteDialog = ref(false);

// Clinic data
const clinic = ref({});
const clinicForm = ref({
  name: "",
  address: "",
  phone: "",
  email: "",
});
const showEditDialog = ref(false);
const savingClinic = ref(false);

// Users data
const users = ref([]);
const loading = ref(true);

// Add user dialog
const showAddUserDialog = ref(false);
const userSearchQuery = ref("");
const searchResults = ref([]);
const selectedUser = ref(null);
const newUserRole = ref("staff");
const addingUser = ref(false);

// Edit user role dialog
const showEditUserRoleDialog = ref(false);
const userToEdit = ref(null);
const updatedUserRole = ref(null);
const updatingRole = ref(false);

// Remove user confirmation
const showRemoveUserConfirm = ref(false);
const userToRemove = ref(null);
const removingUser = ref(false);

// Available roles
const availableRoles = ref([
  { label: "Admin", value: "admin" },
  { label: "Manager", value: "manager" },
  { label: "Veterinarian", value: "vet" },
  { label: "Staff", value: "staff" },
]);

// Computed role counts
const roleCounts = computed(() => {
  return users.value.reduce((acc, user) => {
    acc[user.pivot.role] = (acc[user.pivot.role] || 0) + 1;
    return acc;
  }, {});
});

const selectUser = (user) => {
  selectedUser.value = user;
  userSearchQuery.value = ""; // Clear search query
  searchResults.value = []; // Clear search results
};
const sendInvite = async () => {
  
  try {
    await axiosInstance.post(`/clinics/${clinicId}/invitations`, {
      email: inviteEmail.value,
      role: inviteRole.value,
    });
    toast.add({ severity: "success", detail: "Invitation sent!" });
  } catch (error) {
    console.error(error)
    toast.add({ severity: "error", detail: error.response?.data?.message });
  }
};
// Fetch clinic and users
const fetchClinicData = async () => {
  try {
    loading.value = true;
    const [clinicRes, usersRes] = await Promise.all([
      axiosInstance.get(`/clinics/${clinicId}`),
      axiosInstance.get(`/clinics/${clinicId}/users`),
    ]);

    clinic.value = clinicRes.data;
    clinicForm.value = { ...clinicRes.data };
    users.value = usersRes.data;
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

// Search users
const searchUsers = async () => {
  if (!userSearchQuery.value.trim()) {
    searchResults.value = [];
    return;
  }

  try {
    const response = await axiosInstance.get("/users/search", {
      params: { q: userSearchQuery.value },
    });
    // Filter out users already in clinic
    searchResults.value = response.data.filter(
      (user) => !users.value.some((u) => u.id === user.id)
    );
  } catch (error) {
    toast.add({
      severity: "error",
      summary: "Error",
      detail: "Failed to search users",
      life: 3000,
    });
  }
};

// Add user to clinic
const addUserToClinic = async () => {
  try {
    addingUser.value = true;
    await axiosInstance.post(`/clinics/${clinicId}/users`, {
      user_id: selectedUser.value.id,
      role: newUserRole.value,
    });

    toast.add({
      severity: "success",
      summary: "Success",
      detail: "User added to clinic",
      life: 3000,
    });

    closeAddUserDialog();
    fetchClinicData();
  } catch (error) {
    toast.add({
      severity: "error",
      summary: "Error",
      detail: "Failed to add user to clinic",
      life: 3000,
    });
  } finally {
    addingUser.value = false;
  }
};

// Open edit role dialog
const openEditUserRoleDialog = (user) => {
  userToEdit.value = user;
  updatedUserRole.value = user.pivot.role;
  showEditUserRoleDialog.value = true;
};

// Update user role
const updateUserRole = async () => {
  try {
    updatingRole.value = true;
    await axiosInstance.put(`/clinics/${clinicId}/users/${userToEdit.value.id}`, {
      role: updatedUserRole.value,
    });

    toast.add({
      severity: "success",
      summary: "Success",
      detail: "User role updated",
      life: 3000,
    });

    showEditUserRoleDialog.value = false;
    fetchClinicData();
  } catch (error) {
    
    toast.add({
      severity: "error",
      summary: "Error",
      detail: "Failed to update user role",
      life: 3000,
    });
  } finally {
    updatingRole.value = false;
  }
};

// Confirm remove user
/* const confirmRemoveUser = (user) => {
  userToRemove.value = user;
  showRemoveUserConfirm.value = true;
};
 */
const confirmRemoveUser = (user) => {
  // Check if user is the last admin
  if (
    (user.pivot.role === "admin" || user.pivot.role === "super_admin") &&
    roleCounts.value.admin + roleCounts.value.super_admin === 1
  ) {
    toast.add({
      severity: "warn",
      summary: "Warning",
      detail: "Cannot remove the last admin of the clinic",
      life: 3000,
    });
    return;
  }

  // Set the user to be removed and show confirmation dialog
  userToRemove.value = user;
  showRemoveUserConfirm.value = true;
};
// const refreshData = ()
// Remove user from clinic
const removeUserFromClinic = async () => {
  try {
    removingUser.value = true;
    await axiosInstance.delete(`/clinics/${clinicId}/users/${userToRemove.value.id}`);

    toast.add({
      severity: "success",
      summary: "Success",
      detail: "User removed from clinic",
      life: 3000,
    });

    showRemoveUserConfirm.value = false;
    fetchClinicData();
  } catch (error) {
    toast.add({
      severity: "error",
      summary: "Error",
      detail: "Failed to remove user from clinic",
      life: 3000,
    });
  } finally {
    removingUser.value = false;
  }
};

// Update clinic
const updateClinic = async () => {
  try {
    savingClinic.value = true;
    await axiosInstance.put(`/clinics/${clinicId}`, clinicForm.value);

    toast.add({
      severity: "success",
      summary: "Success",
      detail: "Clinic updated",
      life: 3000,
    });

    showEditDialog.value = false;
    fetchClinicData();
  } catch (error) {
    toast.add({
      severity: "error",
      summary: "Error",
      detail: "Failed to update clinic",
      life: 3000,
    });
  } finally {
    savingClinic.value = false;
  }
};

// Close add user dialog and reset
const closeAddUserDialog = () => {
  showAddUserDialog.value = false;
  userSearchQuery.value = "";
  searchResults.value = [];
  selectedUser.value = null;
  newUserRole.value = "staff";
};

// Check if user is last admin
const isLastAdmin = (user) => {
  return user.pivot.role === "admin" && roleCounts.value.admin === 1;
};

// Format date
const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString();
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

// Watch search query
watch(userSearchQuery, searchUsers, { debounce: 300 });

// Fetch data on mount
onMounted(() => {
  fetchClinicData();
});
</script>

<style scoped>
/* Custom styles if needed */
</style>
