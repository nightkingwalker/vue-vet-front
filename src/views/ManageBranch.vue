<template>
  <div class="container mx-auto px-4 py-8">
    <!-- Branch Header -->
    <div
      class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4"
    >
      <div>
        <h1 class="text-3xl font-bold text-surface-0">{{ branch.name }} Users</h1>
        <p class="text-surface-400">{{ branch.address }}</p>
        <p class="text-surface-400">Clinic: {{ clinic.name }}</p>
      </div>
      <div class="flex gap-3">
        <Button
          label="Back to Branch"
          icon="pi pi-arrow-left"
          class="p-button-text text-emerald-400 hover:text-emerald-300"
          @click="$router.push(`/clinics/${clinic.id}/branches`)"
        />
        <Button
          label="Add User"
          icon="pi pi-plus"
          class="p-button-primary bg-emerald-600 hover:bg-emerald-500 border-emerald-600"
          @click="showAddUserDialog = true"
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
              <span class="block text-surface-400 text-sm">Managers</span>
              <span class="text-2xl font-semibold text-surface-0">{{
                roleCounts.manager || 0
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
            <i class="pi pi-user text-3xl text-emerald-400"></i>
          </div>
        </template>
      </Card>
    </div>

    <!-- User Management Section -->
    <Card class="bg-surface-300 border-surface-500 mb-6">
      <template #header>
        <div class="flex justify-between items-center p-4 border-b border-surface-500">
          <h2 class="text-xl font-semibold text-surface-0">Branch Members</h2>
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
                  :disabled="data.pivot.role === 'manager' && isLastManager(data)"
                />
              </div>
            </template>
          </Column>
        </DataTable>
      </template>
    </Card>

    <!-- Add User Dialog -->
    <Dialog
      v-model:visible="showAddUserDialog"
      header="Add User to Branch"
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
          @click="addUserToBranch"
        />
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
          Remove {{ userToRemove?.name }} from {{ branch.name }}?
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
          @click="removeUserFromBranch"
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
import axios from "@/axios";
import Button from "primevue/button";
import Select from "primevue/select";
import Dialog from "primevue/dialog";
import Card from "primevue/card";
import Tag from "primevue/tag";
import InputText from "primevue/inputtext";
import Avatar from "primevue/avatar";
import Column from "primevue/column";
import DataTable from "primevue/datatable";

const route = useRoute();
const router = useRouter();
const toast = useToast();

const branchId = route.params.branch;

// Branch and clinic data
const branch = ref({});
const clinic = ref({});
const loading = ref(true);

// Users data
const users = ref([]);

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
  { label: "Manager", value: "manager" },
  { label: "Veterinarian", value: "vet" },
  { label: "Receptionist", value: "receptionist" },
  { label: "Staff", value: "staff" },
]);

// Computed role counts
const roleCounts = computed(() => {
  return users.value.reduce((acc, user) => {
    acc[user.pivot.role] = (acc[user.pivot.role] || 0) + 1;
    return acc;
  }, {});
});

// Fetch branch and users
const fetchBranchData = async () => {
  try {
    loading.value = true;
    const [branchRes, usersRes] = await Promise.all([
      axios.get(`/branches/${branchId}`),
      axios.get(`/branches/${branchId}/users`),
    ]);

    branch.value = branchRes.data;
    clinic.value = branchRes.data.clinic;
    // console.log(clinic.value);
    users.value = usersRes.data;
  } catch (error) {
    toast.add({
      severity: "error",
      summary: "Error",
      detail: "Failed to fetch branch data",
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
    const response = await axios.get("/users/search", {
      params: { q: userSearchQuery.value },
    });
    // Filter out users already in branch
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

// Add user to branch
const addUserToBranch = async () => {
  try {
    addingUser.value = true;
    await axios.post(`/branches/${branchId}/users`, {
      user_id: selectedUser.value.id,
      role: newUserRole.value,
      clinic_id: clinic.value.id,
    });

    toast.add({
      severity: "success",
      summary: "Success",
      detail: "User added to branch",
      life: 3000,
    });

    closeAddUserDialog();
    fetchBranchData();
  } catch (error) {
    toast.add({
      severity: "error",
      summary: "Error",
      detail: "Failed to add user to branch",
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
    await axios.put(`/branches/${branchId}/users/${userToEdit.value.id}`, {
      role: updatedUserRole.value,
    });

    toast.add({
      severity: "success",
      summary: "Success",
      detail: "User role updated",
      life: 3000,
    });

    showEditUserRoleDialog.value = false;
    fetchBranchData();
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
const confirmRemoveUser = (user) => {
  userToRemove.value = user;
  showRemoveUserConfirm.value = true;
};

// Remove user from branch
const removeUserFromBranch = async () => {
  try {
    removingUser.value = true;
    await axios.delete(`/branches/${branchId}/users/${userToRemove.value.id}`);

    toast.add({
      severity: "success",
      summary: "Success",
      detail: "User removed from branch",
      life: 3000,
    });

    showRemoveUserConfirm.value = false;
    fetchBranchData();
  } catch (error) {
    toast.add({
      severity: "error",
      summary: "Error",
      detail: "Failed to remove user from branch",
      life: 3000,
    });
  } finally {
    removingUser.value = false;
  }
};

// Close add user dialog
const closeAddUserDialog = () => {
  showAddUserDialog.value = false;
  userSearchQuery.value = "";
  searchResults.value = [];
  selectedUser.value = null;
  newUserRole.value = "staff";
};

// Check if user is last manager
const isLastManager = (user) => {
  return user.pivot.role === "manager" && roleCounts.value.manager === 1;
};

// Format date
const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString();
};

// Helper to get role severity for tag
const getRoleSeverity = (role) => {
  switch (role) {
    case "manager":
      return "danger";
    case "vet":
      return "info";
    case "receptionist":
      return "warning";
    default:
      return "success";
  }
};

// Select user from search results
const selectUser = (user) => {
  selectedUser.value = user;
  userSearchQuery.value = "";
  searchResults.value = [];
};

// Watch search query
watch(userSearchQuery, searchUsers, { debounce: 300 });

// Fetch data on mount
onMounted(() => {
  fetchBranchData();
});
</script>

<style scoped>
/* Custom styles if needed */
</style>
