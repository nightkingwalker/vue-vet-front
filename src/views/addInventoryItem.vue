<template>
  <div class="w-full">
    <form @submit.prevent="handleSubmit" class="mx-auto w-full">
      <fieldset
        class="p-fieldset p-component w-9/10 flex flex-wrap justify-between mx-auto items-top border rounded-lg p-2"
      >
        <legend>Add Inventory Item</legend>

        <!-- Basic Information Section -->
        <div class="mt-6 w-full">
          <FloatLabel class="w-[95%] !text-xs">
            <AutoComplete
              v-model="searchInput"
              :suggestions="filteredSuggestions"
              @complete="searchItems"
              optionLabel="displayText"
              dropdown
              forceSelection
              @item-select="handleItemSelect"
              fluid
            >
              <template #item="slotProps">
                <div class="flex flex-col p-2">
                  <div class="flex justify-between">
                    <span class="font-medium">{{ slotProps.item.name }}</span>
                    <span class="text-sm text-gray-500 ml-2">{{
                      slotProps.item.brand
                    }}</span>
                  </div>
                  <div class="mt-1">
                    <Tag
                      v-if="slotProps.item.barcode"
                      :value="slotProps.item.barcode"
                      severity="info"
                      class="text-xs"
                    />
                  </div>
                </div>
              </template>
            </AutoComplete>
            <label>Search by name, brand, or scan barcode</label>
          </FloatLabel>
          <small class="p-text-secondary">Enter product name or scan barcode</small>
        </div>

        <!-- Barcode Field with Generate Button -->
        <div class="field mt-6 w-1/2">
          <div class="flex items-center gap-2">
            <FloatLabel class="flex-grow !text-xs">
              <InputText id="barcode" class="w-full" v-model="form.barcode" />
              <label for="barcode">Barcode</label>
            </FloatLabel>
            <Button
              icon="pi pi-refresh"
              @click="generateBarcode"
              class="p-button-rounded p-button-text"
              v-tooltip="'Generate new barcode'"
              :disabled="!!existingItemId"
            />
          </div>
        </div>

        <!-- Category Selection -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%] !text-xs">
            <Select
              v-model="form.category"
              :options="categories"
              optionLabel="label"
              optionValue="value"
              class="w-full"
              :disabled="!!existingItemId || isPredefined"
            />
            <label for="dd-category">Category</label>
          </FloatLabel>
        </div>

        <!-- Type and Brand -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%] !text-xs">
            <InputText
              id="type"
              class="w-full"
              v-model="form.type"
              :disabled="!!existingItemId"
            />
            <label for="type">Type</label>
          </FloatLabel>
        </div>
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%] !text-xs">
            <InputText
              id="brand"
              class="w-full"
              v-model="form.brand"
              :disabled="!!existingItemId"
            />
            <label for="brand">Brand</label>
          </FloatLabel>
        </div>

        <!-- Product Name -->
        <div class="field mt-6 w-full">
          <FloatLabel class="w-[95%] !text-xs">
            <InputText
              id="name"
              class="w-full"
              v-model="form.name"
              :disabled="!!existingItemId"
            />
            <label for="name">Product Name</label>
          </FloatLabel>
        </div>

        <!-- Description -->
        <div class="field mt-6 w-full">
          <FloatLabel class="w-[95%] !text-xs">
            <Textarea
              id="description"
              class="!text-xs"
              fluid
              v-model="form.description"
              rows="2"
            />
            <label for="description">Description</label>
          </FloatLabel>
        </div>

        <!-- Quantity and Pricing -->
        <div class="field mt-6 w-1/5">
          <FloatLabel class="w-[95%] !text-xs">
            <InputNumber
              id="quantity"
              class="!text-xs"
              fluid
              v-model="form.quantity"
              mode="decimal"
              :min="0.0"
              :max="5000000"
              :step="1"
            />
            <label for="quantity">Quantity to Add</label>
          </FloatLabel>
        </div>
        <div class="field mt-6 w-1/5">
          <FloatLabel class="w-[95%] !text-xs">
            <InputNumber
              id="purchasePrice"
              class="!text-xs"
              fluid
              v-model="form.purchasePrice"
              mode="currency"
              currency="USD"
              :min="0"
              :max="5000000"
            />
            <label for="purchasePrice">Purchase Price</label>
          </FloatLabel>
        </div>
        <div class="field mt-6 w-2/5">
          <FloatLabel class="w-[95%] !text-xs">
            <InputNumber
              id="sellingPrice"
              class="!text-xs"
              fluid
              v-model="form.sellingPrice"
              mode="currency"
              currency="USD"
              :min="0"
              :max="5000000"
            /><!--:disabled="!!existingItemId"-->
            <label for="sellingPrice">Selling Price</label>
          </FloatLabel>
        </div>
        <div class="field mt-6 w-1/3">
          <FloatLabel class="w-[95%] !text-xs">
            <InputNumber
              id="minStock"
              class="!text-xs"
              fluid
              v-model="form.minStock"
              mode="decimal"
              :min="0"
              :max="1000"
              :step="1"
            />
            <label for="minStock">Minimum Stock Level</label>
          </FloatLabel>
        </div>

        <!-- Expiry Date -->
        <div class="field mt-6 w-1/3">
          <FloatLabel class="w-[95%] !text-xs">
            <DatePicker
              id="expiryDate"
              v-model="form.expiryDate"
              dateFormat="yy-mm-dd"
              :showIcon="true"
              :minDate="new Date()"
              class="!text-xs"
            />
            <label for="expiryDate">Expiry Date</label>
          </FloatLabel>
        </div>

        <!-- Notes -->
        <div class="field mt-6 w-full">
          <FloatLabel class="w-full !text-xs">
            <Textarea
              id="notes"
              class="!text-xs"
              fluid
              v-model="form.notes"
              required
              rows="2"
            />
            <label for="notes">Notes</label>
          </FloatLabel>
        </div>

        <!-- Submit Button -->
        <div class="field mt-6 w-full flex justify-end">
          <Button
            type="submit"
            :label="!existingItemId ? 'Create New Item' : 'Add to Existing Item'"
            :icon="!existingItemId ? 'pi pi-save' : 'pi pi-plus'"
            class="!text-xs"
          />
        </div>
      </fieldset>
    </form>

    <!-- Confirmation Dialog for Existing Items -->
    <Dialog
      v-model:visible="showMatchDialog"
      header="Existing Items Found"
      :modal="true"
      :style="{ width: '50vw' }"
    >
      <div
        class="mb-4"
        v-focustrap="{
          disabled: false,
          autoFocus: true,
        }"
      >
        <p>We found similar items in our system:</p>
        <DataTable
          :value="matchedItems"
          selectionMode="single"
          v-model:selection="selectedMatch"
        >
          <Column field="name" header="Name"></Column>
          <Column field="brand" header="Brand"></Column>
          <Column field="quantity" header="Current Stock"></Column>
        </DataTable>
      </div>
      <template #footer>
        <Button label="Add to Selected" icon="pi pi-plus" @click="useExistingItem" />
        <Button
          label="Create New Anyway"
          icon="pi pi-times"
          @click="createNewItem"
          class="p-button-text text-xs"
        />
      </template>
    </Dialog>
  </div>
</template>

<script setup>
import { ref, computed } from "vue";
import { useToast } from "primevue/usetoast";
// import axiosInstance from "@/axios";

// PrimeVue Components
import InputText from "primevue/inputtext";
import FloatLabel from "primevue/floatlabel";
import Cookies from "js-cookie";
import Button from "primevue/button";
import Dropdown from "primevue/dropdown";
import InputNumber from "primevue/inputnumber";
import Textarea from "primevue/textarea";
import Calendar from "primevue/calendar";
import Dialog from "primevue/dialog";
import DataTable from "primevue/datatable";
import Column from "primevue/column";
import AutoComplete from "primevue/autocomplete";
import Select from "primevue/select";
import DatePicker from "primevue/datepicker";
import Tag from "primevue/tag";
import axiosInstance from "@/axios"; // Assuming you've created a global axios instance
import { useRoute } from "vue-router";
import { watchEffect } from "vue";
import { useConfirm } from "primevue/useconfirm";
const emit = defineEmits(["submitted"]); // Define the event to be emitted
const route = useRoute();
const toast = useToast();
const confirm = useConfirm();
const searchInput = ref("");
const searchResults = ref([]);
const isPredefined = ref(false);
// Form Data
const props = defineProps({
  item: {
    type: Object,
    required: false,
  },
});

const form = ref({
  searchQuery: "",
  barcode: "",
  category: "",
  type: "",
  brand: "",
  name: "",
  description: "",
  quantity: 1,
  purchasePrice: 0,
  sellingPrice: 0,
  minStock: 0,
  expiryDate: null,
  notes: "",
});

const categories = ref([
  { label: "Food", value: "food" },
  { label: "Pharmaceutical", value: "pharmaceutical" },
  { label: "Miscellaneous", value: "miscellaneous" },
  { label: "Toy", value: "toy" },
]);

// Item Matching
const existingItemId = ref(null);
const matchedItems = ref([]);
const showMatchDialog = ref(false);
const selectedMatch = ref(null);

// Generate random barcode
const generateBarcode = () => {
  if (existingItemId.value) return;
  const randomBarcode =
    "8" + Math.floor(100000000000 + Math.random() * 900000000000).toString();
  form.value.barcode = randomBarcode;
};
// // console.log("TEST", props.item);
if (props.item) {
  form.value = {
    ...props.item,
    sellingPrice: props.item.selling_price ? props.item.selling_price : 0,
    purchasePrice: props.item.cost_price ? props.item.cost_price : 0,
    minStock: props.item.minimum_stock_level ? props.item.minimum_stock_level : 0,
    expiryDate: props.item.expiry_date ? new Date(props.item.expiry_date) : null,
  };
  existingItemId.value = props.item.id;
}
const searchItems = async (event) => {
  if (event.query.trim().length < 2) {
    searchResults.value = [];
    return;
  }

  try {
    const { data } = await axiosInstance.get(`/inventory-items/search`, {
      params: {
        branch_id: Cookies.get("M3K8g2387BahBaqyjDe6"),
        query: event.query,
      },
    });

    searchResults.value = data.data.map((item) => ({
      ...item,
      displayText: `${item.name} (${item.brand})`, // For input display
      label: `${item.name} - ${item.brand}`, // For dropdown display
    }));
  } catch (error) {
    console.error("Search error:", error);
    searchResults.value = [];
  }
};

// Add this computed property
const filteredSuggestions = computed(() => {
  return searchResults.value.filter(
    (item) =>
      item.name &&
      typeof item.name === "string" &&
      item.brand &&
      typeof item.brand === "string"
  );
});
const handleItemSelect = (event) => {
  if (!event.value) return;

  const selected = event.value;
  existingItemId.value = selected.id;

  // Update form fields
  form.value = {
    ...form.value,
    barcode: selected.barcode,
    category: selected.category,
    type: selected.type,
    brand: selected.brand,
    name: selected.name,
    description: selected.description || "",
    sellingPrice: parseFloat(selected.selling_price),
    minStock: selected.minimum_stock_level,
    expiryDate: selected.expiry_date ? new Date(selected.expiry_date) : null,
  };

  // Update search input to show the displayText
  searchInput.value = selected.displayText;
};
const handleBarcodeChange = () => {
  if (form.barcode.length > 5) {
    searchItems({ query: form.barcode });
  }
};
// Check for existing items
const checkExistingItems = async () => {
  if (!form.value.searchQuery) return;

  try {
    const response = await axiosInstance.get("/inventory-items/search", {
      params: {
        branch_id: Cookies.get("M3K8g2387BahBaqyjDe6"), // Get from store or props
        query: form.value.searchQuery,
      },
    });

    if (response.data.data.length > 0) {
      matchedItems.value = response.data.data;
      showMatchDialog.value = true;
    }
  } catch (error) {
    console.error("Error searching for items:", error);
  }
};
watchEffect(() => {
  if (route.path === "/add-inventory-pharmaceutical") {
    form.value.category = "pharmaceutical"; // or whatever default you want
    isPredefined.value = true;
  } else if (route.path === "/add-inventory-food") {
    form.value.category = "food";
    isPredefined.value = true;
  } else if (route.path === "/add-inventory-toys") {
    form.value.category = "miscellaneous";
    isPredefined.value = true;
  }
  // Add more route cases as needed
});
// Handle selection of existing item
const useExistingItem = () => {
  if (selectedMatch.value) {
    existingItemId.value = selectedMatch.value.id;
    // Populate form with existing item details (read-only)
    form.value.barcode = selectedMatch.value.barcode;
    form.value.category = selectedMatch.value.category;
    form.value.type = selectedMatch.value.type;
    form.value.brand = selectedMatch.value.brand;
    form.value.name = selectedMatch.value.name;
    form.value.sellingPrice = parseFloat(selectedMatch.value.selling_price);
    showMatchDialog.value = false;
  }
};

// Force create new item
const createNewItem = () => {
  existingItemId.value = null;
  showMatchDialog.value = false;
};

// Form Submission
const handleSubmit = () => {
  confirm.require({
    message: existingItemId.value
      ? `Are you sure you want to add ${form.value.quantity} units to this existing item?`
      : "Are you sure you want to create this new inventory item?",
    header: "Confirmation",
    icon: "pi pi-exclamation-triangle",
    accept: () => submitForm(),
    reject: () => {
      toast.add({
        severity: "warn",
        summary: "Cancelled",
        detail: "Operation cancelled",
        life: 3000,
      });
    },
  });
};

const submitForm = async () => {
  const payload = {
    branch_id: Cookies.get("M3K8g2387BahBaqyjDe6"), // Get from store or props
    search_query: form.value.searchQuery,
    quantity_to_add: form.value.quantity,
    purchase_price: form.value.purchasePrice,
    notes: form.value.notes,
    description: form.value.description,
    expiry_date: form.value.expiryDate
      ? form.value.expiryDate.toISOString().split("T")[0]
      : null,
    selling_price: form.value.sellingPrice,
    minimum_stock_level: form.value.minStock,
  };
  // console.log("payload", payload);
  // Add fields for new items only
  if (!existingItemId.value) {
    Object.assign(payload, {
      category: form.value.category,
      type: form.value.type,
      brand: form.value.brand,
      name: form.value.name,
      description: form.value.description,
      selling_price: form.value.sellingPrice,
      barcode: form.value.barcode,
    });
  } else {
    payload.existing_item_id = existingItemId.value;
  }

  try {
    const endpoint = "/inventory-items/smart-add";
    const response = await axiosInstance.post(endpoint, payload);

    toast.add({
      severity: "success",
      summary: "Success",
      detail: existingItemId.value
        ? "Stock added to existing item"
        : "New inventory item created",
      life: 5000,
    });
    emit("submitted", response.data);
    // Reset form for new entries
    if (!existingItemId.value) {
      resetForm();
    }
  } catch (error) {
    console.error("Error submitting form:", error);
    toast.add({
      severity: "error",
      summary: "Error",
      detail: error.response?.data?.message || "Failed to save inventory item",
      life: 5000,
    });
  }
};

const resetForm = () => {
  form.value = {
    searchQuery: "",
    barcode: "",
    category: "",
    type: "",
    brand: "",
    name: "",
    description: "",
    quantity: 1,
    purchasePrice: 0,
    sellingPrice: 0,
    minStock: 0,
    expiryDate: null,
    notes: "",
  };
  existingItemId.value = null;
};
</script>

<style scoped>
.field {
  margin-bottom: 1rem;
}
/* Responsive adjustments */
@media (max-width: 768px) {
  .field {
    width: 100% !important;
  }
}
</style>
