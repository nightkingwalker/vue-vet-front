<template>
  <div class="w-full lg:!text-[14px]">
    <form @submit.prevent="handleSubmit" class="mx-auto w-full">
      <fieldset
        class="p-fieldset p-component w-9/10 flex flex-wrap justify-between mx-auto items-top border rounded-lg p-2"
      >
        <legend>{{ $t("inventory.add_item.title") }}</legend>

        <!-- Search Section -->
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
              @keydown.enter.prevent="handleBarcodeScan"
            >
              <template #item="slotProps">
                <div class="flex flex-col p-2">
                  <div class="flex justify-between">
                    <span class="font-medium">{{ slotProps.item.name }}</span>
                    <span class="text-sm text-gray-500 ml-2">
                      {{ slotProps.item.brand }}
                    </span>
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
            <label>{{ $t("inventory.add_item.search_label") }}</label>
          </FloatLabel>
          <small class="p-text-secondary">{{
            $t("inventory.add_item.search_hint")
          }}</small>
        </div>

        <!-- Barcode Field -->
        <div class="field mt-6 w-1/2">
          <div class="flex items-center gap-2">
            <FloatLabel class="flex-grow !text-xs">
              <InputText
                id="barcode"
                class="w-full"
                v-model="form.barcode"
                :invalid="invalid.barcode"
                @keydown.enter.prevent="handleBarcodeScan"
              />
              <label for="barcode"
                >{{ $t("inventory.add_item.barcode") }}
                <span class="text-red-600">*</span></label
              >
            </FloatLabel>
            <Button
              icon="pi pi-refresh"
              @click="generateBarcode"
              class="p-button-rounded p-button-text"
              v-tooltip="$t('inventory.add_item.generate_barcode_tooltip')"
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
              :invalid="invalid.category"
              class="w-full"
              :disabled="!!existingItemId || isPredefined"
            />
            <label for="dd-category"
              >{{ $t("inventory.add_item.category") }}
              <span class="text-red-600">*</span></label
            >
          </FloatLabel>
        </div>

        <!-- Type and Brand -->
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%] !text-xs">
            <InputText
              id="type"
              class="w-full"
              v-model="form.type"
              :invalid="invalid.type"
              :disabled="!!existingItemId"
            />
            <label for="type"
              >{{ $t("inventory.add_item.type") }} <span class="text-red-600">*</span>
            </label>
          </FloatLabel>
          <small class="text-[12px] text-gray-300 hover:text-gray-500 cursor-help">{{
            $t("inventory.add_item.food_types")
          }}</small>
        </div>
        <div class="field mt-6 w-1/2">
          <FloatLabel class="w-[95%] !text-xs">
            <InputText
              id="brand"
              class="w-full"
              v-model="form.brand"
              :invalid="invalid.brand"
              :disabled="!!existingItemId"
            />
            <label for="brand"
              >{{ $t("inventory.add_item.brand") }}
              <span class="text-red-600">*</span></label
            >
          </FloatLabel>
        </div>

        <!-- Product Name -->
        <div class="field mt-6 w-full">
          <FloatLabel class="w-[95%] !text-xs">
            <InputText
              id="name"
              class="w-full"
              v-model="form.name"
              :invalid="invalid.name"
              :disabled="!!existingItemId"
            />
            <label for="name"
              >{{ $t("inventory.add_item.product_name") }}
              <span class="text-red-600">*</span></label
            >
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
              :invalid="invalid.description"
              rows="2"
            />
            <label for="description"
              >{{ $t("inventory.add_item.description") }}
              <span class="text-red-600">*</span></label
            >
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
              :invalid="invalid.quantity"
              mode="decimal"
              :min="0.0"
              :max="5000000"
              :minFractionDigits="3"
              :step="1"
            />
            <label for="quantity"
              >{{ $t("inventory.add_item.quantity_to_add") }}
              <span class="text-red-600">*</span></label
            >
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
              :minFractionDigits="3"
              :min="0"
              :max="5000000"
            />
            <label for="purchasePrice">{{
              $t("inventory.add_item.purchase_price")
            }}</label>
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
              :minFractionDigits="3"
              :min="0"
              :max="5000000"
            />
            <label for="sellingPrice">{{ $t("inventory.add_item.selling_price") }}</label>
          </FloatLabel>
        </div>

        <!-- Adjustment Toggle -->
        <div class="field w-full mt-6 flex items-center gap-3">
          <ToggleSwitch v-model="showAdjustmentSection" inputId="adjustmentToggle" />
          <label for="adjustmentToggle" class="text-sm font-medium">
            {{ $t("inventory.add_item.record_as_adjustment") }}
          </label>
        </div>

        <!-- Adjustment Section -->
        <div v-if="showAdjustmentSection" class="field mt-6 w-full border-t pt-4">
          <h4 class="font-medium mb-2">
            {{ $t("inventory.add_item.stock_adjustment") }}
          </h4>
          <div class="w-full flex flex-wrap">
            <!-- Adjustment Type -->
            <div class="field w-1/3 flex flex-wrap">
              <label class="w-full">{{ $t("inventory.add_item.adjustment_type") }}</label>
              <div class="w-1/2 flex flex-col">
                <RadioButton
                  size="small"
                  v-model="adjustmentType"
                  inputId="increase"
                  value="increase"
                />
                <label for="increase" class="text-sm">{{
                  $t("inventory.add_item.increase")
                }}</label>
              </div>
              <div class="w-1/2 flex flex-col">
                <RadioButton
                  size="small"
                  v-model="adjustmentType"
                  inputId="decrease"
                  value="decrease"
                />
                <label for="decrease" class="text-sm">{{
                  $t("inventory.add_item.decrease")
                }}</label>
              </div>
            </div>

            <!-- Adjustment Quantity -->
            <div class="field mt-6 w-1/3">
              <FloatLabel class="w-[95%] !text-xs">
                <InputNumber
                  id="adjustmentQty"
                  fluid
                  class="!text-xs"
                  v-model="adjustmentQty"
                  mode="decimal"
                  :minFractionDigits="3"
                  :step="1"
                />
                <label for="adjustmentQty">{{
                  $t("inventory.add_item.adjustment_amount")
                }}</label>
              </FloatLabel>
            </div>

            <!-- Adjustment Reason -->
            <div class="field mt-6 w-1/3">
              <FloatLabel class="w-[95%] !text-xs">
                <Select
                  v-model="adjustmentReason"
                  fluid
                  :options="adjustmentReasons"
                  optionLabel="label"
                  optionValue="value"
                  class="w-full"
                />
                <label>{{ $t("inventory.add_item.adjustment_reason") }}</label>
              </FloatLabel>
            </div>

            <!-- Adjustment Preview -->
            <div
              v-if="showAdjustmentSection && adjustmentQty > 0"
              class="mt-2 text-sm w-full"
            >
              <span
                :class="{
                  'text-green-600': adjustmentType === 'increase',
                  'text-red-600': adjustmentType === 'decrease',
                }"
                class="text-xs"
              >
                <i
                  class="pi"
                  :class="{
                    'pi-arrow-up text-green-500': adjustmentType === 'increase',
                    'pi-arrow-down text-red-500': adjustmentType === 'decrease',
                  }"
                ></i>
                {{
                  adjustmentType === "increase"
                    ? $t("inventory.add_item.adding_units", { units: adjustmentQty })
                    : $t("inventory.add_item.removing_units", { units: adjustmentQty })
                }}
                <span v-if="adjustmentReason">
                  ({{ $t("inventory.add_item.reason") }}: {{ reasonLabel }})
                </span>
              </span>
            </div>
          </div>

          <!-- Adjustment Notes -->
          <div class="field mt-6 w-full">
            <FloatLabel class="w-[95%] !text-xs">
              <Textarea
                id="adjustmentNotes"
                class="!text-xs"
                v-model="adjustmentNotes"
                rows="2"
              />
              <label for="adjustmentNotes">{{
                $t("inventory.add_item.adjustment_notes")
              }}</label>
            </FloatLabel>
          </div>
        </div>

        <!-- Min Stock and Expiry -->
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
            <label for="minStock">{{ $t("inventory.add_item.min_stock_level") }}</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-1/3">
          <FloatLabel class="w-[95%] !text-xs">
            <DatePicker
              showIcon
              iconDisplay="input"
              showButtonBar
              id="expiryDate"
              v-model="form.expiryDate"
              dateFormat="yy-mm-d"
              :minDate="new Date()"
              class="!text-xs"
            />
            <label for="expiryDate">{{ $t("inventory.add_item.expiry_date") }}</label>
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
              :invalid="invalid.notes"
              rows="2"
            />
            <label for="notes"
              >{{ $t("inventory.add_item.notes") }}
              <span class="text-red-600">*</span></label
            >
          </FloatLabel>
          <small class="text-[12px] text-gray-300 hover:text-gray-500 cursor-help">{{
            $t("inventory.add_item.adjustment_notes_small")
          }}</small>
        </div>

        <!-- Submit Button -->
        <div class="field mt-6 w-full flex justify-end">
          <Button
            type="submit"
            :label="
              !existingItemId
                ? $t('inventory.add_item.create_new_item')
                : $t('inventory.add_item.add_to_existing_item')
            "
            :icon="!existingItemId ? 'pi pi-save' : 'pi pi-plus'"
            class="!text-xs"
          />
        </div>
      </fieldset>
    </form>

    <!-- Confirmation Dialog -->
    <Dialog
      v-model:visible="showMatchDialog"
      :header="$t('inventory.add_item.existing_items_found')"
      :modal="true"
      :style="{ width: '50vw' }"
    >
      <div class="mb-4" v-focustrap="{ disabled: false, autoFocus: true }">
        <p>{{ $t("inventory.add_item.similar_items_found") }}</p>
        <DataTable
          :value="matchedItems"
          selectionMode="single"
          showGridlines
          v-model:selection="selectedMatch"
        >
          <Column field="name" :header="$t('inventory.add_item.name')"></Column>
          <Column field="brand" :header="$t('inventory.add_item.brand')"></Column>
          <Column
            field="quantity"
            :header="$t('inventory.add_item.current_stock')"
          ></Column>
        </DataTable>
      </div>
      <template #footer>
        <Button
          :label="$t('inventory.add_item.add_to_selected')"
          icon="pi pi-plus"
          @click="useExistingItem"
        />
        <Button
          :label="$t('inventory.add_item.create_new_anyway')"
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
import ToggleSwitch from "primevue/toggleswitch";
import RadioButton from "primevue/radiobutton";
import { useI18n } from "vue-i18n";

const { t } = useI18n();
const emit = defineEmits(["submitted"]); // Define the event to be emitted
const route = useRoute();
const toast = useToast();
const confirm = useConfirm();
const searchInput = ref("");
const searchResults = ref([]);
const isPredefined = ref(false);
const showAdjustmentSection = ref(false);

// Form Data
const props = defineProps({
  item: {
    type: Object,
    required: false,
  },
});
const adjustmentType = ref("increase"); // or 'decrease'
const adjustmentQty = ref(0);
const adjustmentReason = ref("");
const adjustmentNotes = ref("");

const adjustmentTypes = ref([
  { label: t("inventory.adjustment_types.increase"), value: "increase" },
  { label: t("inventory.adjustment_types.decrease"), value: "decrease" },
]);

const adjustmentReasons = ref([
  { label: t("inventory.adjustment_reasons.damaged"), value: "damaged" },
  { label: t("inventory.adjustment_reasons.found"), value: "found" },
  { label: t("inventory.adjustment_reasons.theft"), value: "theft" },
  { label: t("inventory.adjustment_reasons.expired"), value: "expired" },
  { label: t("inventory.adjustment_reasons.stocktake"), value: "stocktake" },
  { label: t("inventory.adjustment_reasons.other"), value: "other" },
]);
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
  { label: t("inventory.categories.food"), value: "food" },
  { label: t("inventory.categories.pharmaceutical"), value: "pharmaceutical" },
  { label: t("inventory.categories.miscellaneous"), value: "miscellaneous" },
  { label: t("inventory.categories.toy"), value: "toy" },
  { label: t("inventory.categories.treatment"), value: "treatment" },
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
// console.log("TEST", props.item);
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
const handleBarcodeScan = (event) => {
  // if (event.target.value && /^\d{6,}$/.test(event.target.value)) {
  //   searchByBarcode(event.target.value);
  //   event.target.value = ''; // Clear after scan
  // }
  return;
};
const searchItems = async (event) => {
  if (event.query.trim().length < 2) {
    searchResults.value = [];
    return;
  }
  // console.log(event.query);
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
  } else if (route.path === "/add-inventory-treatment") {
    form.value.category = "treatment";
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
      ? t("inventory.messages.confirm_update_item", {
          quantity: form.value.quantity,
        })
      : t("inventory.messages.confirm_add_item"),
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
const reasonLabel = computed(() => {
  // console.log(adjustmentReasons.value)
  // console.log(adjustmentReason.value);
  const found = adjustmentReasons.value.find((r) => r.value === adjustmentReason.value);
  // console.log(found)
  return found?.label || "NO VALUE";
});
const invalid = ref({});
const submitForm = async () => {
  invalid.value = {
    quantity: form.value.quantity === "" ? true : false,
    barcode: form.value.barcode === "" ? true : false,
    product_name: form.value.name === "" ? true : false,
    category: form.value.category === "" ? true : false,
    type: form.value.type === "" ? true : false,
    brand: form.value.brand === "" ? true : false,
    description: form.value.description === "" ? true : false,
    notes: form.value.notes === "" ? true : false,
  };
  if (
    invalid.value.barcode ||
    invalid.value.name ||
    invalid.value.category ||
    invalid.value.type ||
    invalid.value.brand ||
    invalid.value.description ||
    invalid.value.notes ||
    invalid.value.quantity
  ) {
    toast.add({
      severity: "error",
      summary: t("inventory.messages.items_needed_title"),
      detail: t("inventory.messages.items_needed_details"),
      life: 5000,
    });
    return;
  }
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
  // Handle adjustment case
  if (showAdjustmentSection.value) {
    payload.is_adjustment = true;
    payload.adjustment_type = adjustmentType.value;
    payload.quantity = adjustmentQty.value;
    payload.reason = adjustmentReason.value;
    payload.notes = adjustmentNotes.value;

    // Clear purchase-related fields
    payload.purchase_price = null;
  }
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
    // const endpoint = "/inventory-items/smart-add";
    const endpoint = showAdjustmentSection.value
      ? "/stock-movements/adjustment"
      : "/inventory-items/smart-add";
    console.log("endpoint", endpoint);
    console.log("payload", payload);
    // return;
    const response = await axiosInstance.post(endpoint, payload);

    toast.add({
      severity: "success",
      summary: "Success",
      detail: existingItemId.value
        ? "Stock added to existing item"
        : "New inventory item created",
      life: 5000,
    });
    // emit("submitted", response.data);
    emit("submitted", {
      data: response.data,
      status: response.status,
      otherInfo: "whatever",
    });
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
