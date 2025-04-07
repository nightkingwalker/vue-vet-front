<template>
  <div class="w-full mt-2">
    <div
      class="grid grid-cols-1 lg:grid-cols-3 gap-6 bg-[var(--p-surface-200)] dark:bg-[var(--p-surface-600)] rounded-lg p-2"
    >
      <!-- Left Column - Client & Pet Info -->
      <div class="bg-white p-4 rounded-lg shadow">
        <h2 class="!text-sm font-semibold mb-4 border-b pb-2">
          Client & Pet Information
        </h2>

        <div class="mt-3">
          <FloatLabel variant="on" class="!!2xl:text-lg lg:text-xs">
            <AutoComplete
              v-model="clientSearch"
              :suggestions="filteredClients"
              @complete="searchClients"
              optionLabel="name"
              size="small"
              fluid
              @item-select="selectClient"
            />
            <label>Search Client</label>
          </FloatLabel>
        </div>

        <div v-if="selectedClient" class="my-4 p-3 bg-gray-50 rounded">
          <div class="flex justify-between items-center mb-2">
            <span class="font-medium">{{ selectedClient.name }}</span>
            <Button
              size="small"
              icon="pi pi-times"
              class="p-button-text p-button-xs !2xl:text-lg lg:text-xs"
              @click="clearClient"
            />
          </div>
          <div class="!!2xl:text-lg lg:text-xs text-gray-600">
            <div>Phone: {{ selectedClient.phone }}</div>
            <div>Email: {{ selectedClient.email }}</div>
          </div>
        </div>

        <div class="mb-4" v-if="selectedClient">
          <FloatLabel variant="on" class="!!2xl:text-lg lg:text-xs">
            <Select
              v-model="selectedPet"
              :options="clientPets"
              @change="selectPet"
              optionLabel="name"
              class="w-full"
            />
            <label>Select Pet</label>
          </FloatLabel>
        </div>

        <div v-if="selectedPet" class="mb-4 p-3 bg-gray-50 rounded">
          <div class="flex justify-between items-center mb-2">
            <span class="font-medium">{{ selectedPet.name }}</span>
            <Button
              size="small"
              icon="pi pi-times"
              class="p-button-text p-button-xs !2xl:text-lg lg:text-xs"
              @click="clearPet"
            />
          </div>
          <div class="!!2xl:text-lg lg:text-xs text-gray-600">
            <div><b>Species:</b> {{ selectedPet.species }}</div>
            <div><b>Breed:</b> {{ selectedPet.breed }}</div>
            <div><b>Date of Birth:</b> {{ computeAge(selectedPet.date_of_birth) }}</div>
          </div>
        </div>
      </div>

      <!-- Middle Column - Item Search & List -->
      <div class="bg-white p-4 rounded-lg shadow">
        <h2 class="!text-sm font-semibold mb-4 border-b pb-2">Add Items</h2>

        <div class="mt-3">
          <FloatLabel variant="on" class="!!2xl:text-lg lg:text-xs">
            <AutoComplete
              v-model="itemSearch"
              :suggestions="filteredItems"
              @complete="searchItems"
              optionLabel="displayText"
              size="small"
              fluid
              @item-select="selectItem"
              @keyup.enter="handleBarcodeEnter"
            >
              <template #item="slotProps">
                <div class="flex items-center justify-between p-2">
                  <div>
                    <div class="font-medium">{{ slotProps.item.name }}</div>
                    <div class="!!2xl:text-lg lg:text-xs text-gray-500">
                      {{ slotProps.item.brand }}
                    </div>
                  </div>
                  <div class="flex items-center">
                    <span class="!!2xl:text-lg lg:text-xs font-semibold mr-2"
                      >${{ slotProps.item.selling_price }}</span
                    >
                    <Tag
                      v-if="slotProps.item.quantity <= 0"
                      value="Out of stock"
                      severity="danger"
                    />
                    <Tag
                      v-else-if="
                        slotProps.item.expiry_date &&
                        new Date(slotProps.item.expiry_date) < new Date()
                      "
                      value="Expired"
                      severity="warning"
                    />
                    <Tag v-else value="In stock" severity="success" />
                  </div>
                </div>
              </template>
            </AutoComplete>
            <label>Search Items</label>
          </FloatLabel>
        </div>

        <div v-if="selectedItem" class="mb-4 p-3 bg-gray-50 rounded">
          <div class="flex justify-between items-start mb-2">
            <div>
              <div class="font-medium">{{ selectedItem.name }}</div>
              <div class="!!2xl:text-lg lg:text-xs text-gray-500">
                {{ selectedItem.brand }}
              </div>
            </div>
            <Button
              size="small"
              icon="pi pi-times"
              class="p-button-text p-button-xs !2xl:text-lg lg:text-xs"
              @click="clearItem"
            />
          </div>

          <div class="grid grid-cols-2 gap-4 mt-3">
            <div class="w-full">
              <FloatLabel variant="on" class="!!2xl:text-lg lg:text-xs">
                <InputNumber
                  class="!!2xl:text-lg lg:text-xs"
                  v-model="itemPrice"
                  mode="currency"
                  currency="SYP"
                  :min="0"
                  fluid
                  size="small"
                />
                <label>Price</label>
              </FloatLabel>
            </div>
            <div class="w-full">
              <FloatLabel variant="on" class="!!2xl:text-lg lg:text-xs">
                <InputNumber
                  class="!!2xl:text-lg lg:text-xs"
                  v-model="itemQuantity"
                  :min="0.01"
                  :max="selectedItem ? selectedItem.quantity : null"
                  fluid
                  size="small"
                />
                <label>Quantity</label>
              </FloatLabel>
            </div>
            <div class="w-full">
              <FloatLabel variant="on" class="!!2xl:text-lg lg:text-xs">
                <InputNumber
                  class="!!2xl:text-lg lg:text-xs"
                  v-model="itemDiscount"
                  mode="currency"
                  currency="SYP"
                  :min="0"
                  fluid
                  size="small"
                />
                <label for="">Discount</label>
              </FloatLabel>
            </div>
            <div class="w-full">
              <FloatLabel variant="on" class="!!2xl:text-lg lg:text-xs">
                <InputNumber
                  v-model="itemTaxRate"
                  suffix="%"
                  :min="0"
                  :max="100"
                  fluid
                  class="!!2xl:text-lg lg:text-xs"
                  size="small"
                />
                <label>Tax Rate</label>
              </FloatLabel>
            </div>
          </div>

          <div class="mt-3 flex justify-end">
            <Button
              size="small"
              label="Add to Invoice"
              class="!!2xl:text-lg lg:text-xs"
              icon="pi pi-plus"
              @click="addItemToInvoice"
            />
          </div>
        </div>

        <div class="mt-3">
          <DataTable
            :value="invoiceItems"
            class="p-datatable-sm"
            :scrollable="true"
            scrollHeight="300px"
          >
            <Column field="name" header="Item" class="!2xl:text-lg lg:text-xs"></Column>
            <Column
              field="quantity"
              header="Qty"
              class="!2xl:text-lg lg:text-xs"
              style="width: 80px"
            ></Column>
            <Column header="Price" class="!2xl:text-lg lg:text-xs" style="width: 100px">
              <template #body="slotProps">
                ${{ slotProps.data.unit_price.toFixed(2) }}
              </template>
            </Column>
            <Column header="Total" class="!2xl:text-lg lg:text-xs" style="width: 100px">
              <template #body="slotProps">
                ${{
                  (
                    slotProps.data.quantity * slotProps.data.unit_price -
                    slotProps.data.discount_amount
                  ).toFixed(2)
                }}
              </template>
            </Column>
            <Column header="Actions" class="!2xl:text-lg lg:text-xs" style="width: 80px">
              <template #body="slotProps">
                <Button
                  size="small"
                  icon="pi pi-trash"
                  class="p-button-text p-button-danger"
                  @click="removeItem(slotProps.index)"
                />
              </template>
            </Column>
          </DataTable>
        </div>
      </div>

      <!-- Right Column - Invoice Summary -->
      <div class="bg-white p-4 rounded-lg shadow">
        <h2 class="!text-sm font-semibold mb-4 border-b pb-2">Invoice Summary</h2>

        <div class="mt-3">
          <FloatLabel variant="on" class="!!2xl:text-lg lg:text-xs">
            <InputText
              v-model="invoiceNumber"
              size="small"
              class="w-full !!2xl:text-lg lg:text-xs"
              disabled
            />
            <label>Invoice Number</label>
          </FloatLabel>
        </div>

        <div class="grid grid-cols-2 gap-4 mt-6">
          <div>
            <FloatLabel variant="on" class="!!2xl:text-lg lg:text-xs">
              <DatePicker
                size="small"
                v-model="invoiceDate"
                dateFormat="yy-mm-dd"
                class="w-full"
              />
              <label>Invoice Date</label>
            </FloatLabel>
          </div>
          <div>
            <FloatLabel variant="on" class="!!2xl:text-lg lg:text-xs">
              <DatePicker
                size="small"
                v-model="dueDate"
                dateFormat="yy-mm-dd"
                class="w-full"
              />
              <label>Due Date</label>
            </FloatLabel>
          </div>
        </div>

        <div class="mt-3 flex gap-2 justify-between">
          <FloatLabel variant="on" class="!!2xl:text-lg lg:text-xs !w-1/2">
            <Select
              v-model="paymentTerms"
              size="small"
              :options="paymentTermOptions"
              optionLabel="label"
              optionValue="value"
              fluid
              class="!2xl:text-lg lg:text-xs"
            />
            <label>Payment Terms</label>
          </FloatLabel>
          <FloatLabel variant="on" class="!!2xl:text-lg lg:text-xs !w-1/2">
            <Select
              size="small"
              v-model="status"
              :options="statusOptions"
              optionLabel="label"
              optionValue="value"
              fluid
              class="!2xl:text-lg lg:text-xs"
            />
            <label>Status</label>
          </FloatLabel>
        </div>

        <div class="mt-3 flex gap-2 justify-between">
          <FloatLabel variant="on" class="!2xl:text-lg lg:text-xs !w-1/2">
            <InputNumber
              v-model="depositRequired"
              showButtons
              mode="decimal"
              size="small"
              currency="SYP"
              :min="0"
              :step="0.25"
              :max="totalAmount"
              fluid
              class="!2xl:text-lg lg:text-xs"
            />
            <label>Deposit Required</label>
          </FloatLabel>

          <FloatLabel variant="on" class="!2xl:text-lg lg:text-xs w-1/2">
            <Select
              size="small"
              v-model="depositPaymentMethod"
              :options="paymentMethods"
              optionLabel="name"
              optionValue="id"
              fluid
              class="!2xl:text-lg lg:text-xs"
            />
            <label>Payment Method</label>
          </FloatLabel>
        </div>

        <div class="border-t mt-4 pt-4">
          <div class="flex justify-between mb-2 !2xl:text-lg lg:text-xs">
            <span class="!2xl:text-lg lg:text-xs">Subtotal:</span>
            <span class="!2xl:text-lg lg:text-xs">${{ subtotal.toFixed(2) }}</span>
          </div>
          <div class="flex justify-between mb-2 !2xl:text-lg lg:text-xs">
            <span class="!2xl:text-lg lg:text-xs">Discount:</span>
            <span class="!2xl:text-lg lg:text-xs">-${{ totalDiscount.toFixed(2) }}</span>
          </div>
          <div class="flex justify-between mb-2 !2xl:text-lg lg:text-xs">
            <span class="!2xl:text-lg lg:text-xs">Tax:</span>
            <span class="!2xl:text-lg lg:text-xs">${{ totalTax.toFixed(2) }}</span>
          </div>
          <div
            v-if="depositRequired > 0"
            class="flex justify-between mb-2 !2xl:text-lg lg:text-xs"
          >
            <span class="!2xl:text-lg lg:text-xs">Deposit Required:</span>
            <span class="!2xl:text-lg lg:text-xs">${{ depositRequired.toFixed(2) }}</span>
          </div>
          <div class="flex justify-between font-bold !text-xs border-t pt-2 mt-2">
            <span>Total:</span>
            <span>${{ totalAmount.toFixed(2) }}</span>
          </div>
          <div v-if="depositRequired > 0" class="flex justify-between font-bold !text-xs">
            <span>Balance After Deposit:</span>
            <span>${{ (totalAmount - depositRequired).toFixed(2) }}</span>
          </div>
        </div>

        <div class="mt-3">
          <FloatLabel variant="on" class="!!2xl:text-lg lg:text-xs">
            <Textarea v-model="notes" rows="3" class="w-full" />
            <label>Notes</label>
          </FloatLabel>
        </div>

        <div class="mt-3 flex justify-end gap-2">
          <Button
            size="small"
            label="Save Draft"
            severity="secondary"
            @click="saveDraft"
          />
          <Button size="small" label="Create Invoice" @click="createInvoice" />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from "vue";
import { useToast } from "primevue/usetoast";
import axiosInstance from "@/axios";

// PrimeVue Components
import Button from "primevue/button";
import AutoComplete from "primevue/autocomplete";
import FloatLabel from "primevue/floatlabel";
import Select from "primevue/select";
import InputNumber from "primevue/inputnumber";
import DataTable from "primevue/datatable";
import Column from "primevue/column";
import DatePicker from "primevue/datepicker";
import Textarea from "primevue/textarea";
import Tag from "primevue/tag";
import InputText from "primevue/inputtext";
const emit = defineEmits();
const toast = useToast();
const props = defineProps({
  pet: {
    type: Object,
    required: false,
  },
  medical_record_id: {
    type: Number,
    default: "",
  },
});

// Client & Pet Data
const clientSearch = ref("");
const filteredClients = ref([]);
const selectedClient = ref(null);
const clientPets = ref([]);
const selectedPet = ref(null);
const petAge = ref("");
// Item Data
const itemSearch = ref("");
const filteredItems = ref([]);
const selectedItem = ref(null);
const itemPrice = ref(0);
const itemQuantity = ref(1);
const itemDiscount = ref(0);
const itemTaxRate = ref(0);

// Invoice Data
const invoiceItems = ref([]);
const invoiceNumber = ref("");
const invoiceDate = ref(new Date());
const dueDate = ref(new Date());
const paymentTerms = ref("due_on_receipt");
const status = ref("pending");
const notes = ref("");
const depositRequired = ref(0);
const depositPaymentMethod = ref(null);
const paymentMethods = ref([]);

// Constants from models
const statusOptions = ref([
  { label: "Draft", value: "draft" },
  { label: "Pending", value: "pending" },
  { label: "Partially Paid", value: "partially_paid" },
  { label: "Paid", value: "paid" },
  { label: "Cancelled", value: "cancelled" },
  { label: "Refunded", value: "refunded" },
]);

const paymentTermOptions = ref([
  { label: "Due on Receipt", value: "due_on_receipt" },
  { label: "Net 15 Days", value: "net_15" },
  { label: "Net 30 Days", value: "net_30" },
  { label: "50% Upfront, 50% on Completion", value: "50_upfront" },
]);

// Computed Properties
const subtotal = computed(() => {
  return invoiceItems.value.reduce((sum, item) => {
    return sum + item.quantity * item.unit_price;
  }, 0);
});

const totalDiscount = computed(() => {
  return invoiceItems.value.reduce((sum, item) => {
    return sum + (item.discount_amount || 0);
  }, 0);
});

const totalTax = computed(() => {
  return invoiceItems.value.reduce((sum, item) => {
    return (
      sum +
      (item.quantity * item.unit_price - item.discount_amount) * (item.tax_rate / 100)
    );
  }, 0);
});

const totalAmount = computed(() => {
  return subtotal.value - totalDiscount.value + totalTax.value;
});

const requiresDeposit = computed(() => {
  return paymentTerms.value === "50_upfront";
});

// Methods
const searchClients = async (event) => {
  if (event.query.trim().length < 2) {
    filteredClients.value = [];
    return;
  }

  try {
    const response = await axiosInstance.get("/owners", {
      params: { search: event.query },
    });
    filteredClients.value = response.data.data;
  } catch (error) {
    console.error("Error searching clients:", error);
    filteredClients.value = [];
  }
};

const selectClient = (event) => {
  selectedClient.value = event.value;
  clientSearch.value = event.value.name;
  loadClientPets();
};

const clearClient = () => {
  selectedClient.value = null;
  clientSearch.value = "";
  clientPets.value = [];
  selectedPet.value = null;
};

const loadClientPets = async () => {
  if (!selectedClient.value) return;

  try {
    const response = await axiosInstance.get(`/owners/${selectedClient.value.id}/pets`);
    clientPets.value = response.data.data;
    console.log(clientPets.value);
  } catch (error) {
    console.error("Error loading pets:", error);
    clientPets.value = [];
  }
};

const selectPet = (event) => {
  selectedPet.value = event.value;
  selectedPet.value.age = computeAge(selectedPet.value.date_of_birth);
  console.log(selectedPet.value);
};
const selectPetProps = (pet) => {
  selectedPet.value = pet;
  selectedPet.value.age = computeAge(selectedPet.value.date_of_birth);
  console.log(selectedPet.value);
};
const computeAge = (dateOfBirth) => {
  const birthDate = new Date(dateOfBirth);
  const currentDate = new Date();
  const currentYear = currentDate.getFullYear();
  const currentMonth = currentDate.getMonth();
  const birthYear = birthDate.getFullYear();
  const birthMonth = birthDate.getMonth();

  let ageInYears = currentYear - birthYear;
  let ageInMonths = currentMonth - birthMonth;

  // Adjust for case where the current month is less than the birth month
  if (ageInMonths < 0) {
    ageInYears--;
    ageInMonths += 12; // Adding 12 because it's a full year back
  }

  // Construct the age string
  const yearsText = ageInYears > 0 ? `${ageInYears} ${ageInYears > 1 ? "Y" : "Y"}` : "";
  const monthsText =
    ageInMonths > 0 ? `${ageInMonths} ${ageInMonths > 1 ? "M" : "M"}` : "";

  // Combine them into a single string, handling cases where there are no months or no years
  return `${yearsText}${yearsText && monthsText ? " & " : ""}${monthsText}`;
};

if (props.pet) {
  selectedClient.value = props.pet.owner;
  clientSearch.value = props.pet.owner.name;
  filteredClients.value = props.pet.owner.name;
  filteredClients.value = props.pet.owner.id;
  // selectedPet.value = props.pet;
  clientPets.value = [props.pet];
  selectPetProps(props.pet);
  console.log("medical_record_id", props.medical_record_id);
  console.log("pet", props.pet.owner);
  console.log("selectedClient", selectedClient.value);
  console.log("selectedPet", selectedPet.value);
}
const clearPet = () => {
  selectedPet.value = null;
};

const searchItems = async (event) => {
  if (event.query.trim().length < 1) {
    filteredItems.value = [];
    return;
  }

  try {
    const response = await axiosInstance.get("/inventory-items/search", {
      params: { branch_id: 1, query: event.query },
    });
    filteredItems.value = response.data.data.map((item) => ({
      ...item,
      displayText: `${item.name} (${item.brand}) - $${item.selling_price}`,
    }));
  } catch (error) {
    console.error("Error searching items:", error);
    filteredItems.value = [];
  }
};

const handleBarcodeEnter = async () => {
  if (!itemSearch.value) return;

  if (/^\d{6,}$/.test(itemSearch.value)) {
    try {
      const response = await axiosInstance.get("/inventory-items/by-barcode", {
        params: { barcode: itemSearch.value },
      });

      if (response.data.data) {
        selectItem({ value: response.data.data });
      }
    } catch (error) {
      console.error("Error searching by barcode:", error);
    }
  }
};

const selectItem = (event) => {
  selectedItem.value = event.value;
  itemSearch.value = event.value.displayText;
  itemPrice.value = parseFloat(event.value.selling_price);
  itemQuantity.value = 1;
  itemDiscount.value = 0;
  itemTaxRate.value = event.value.tax_rate || 0;
};

const clearItem = () => {
  selectedItem.value = null;
  itemSearch.value = "";
};

const addItemToInvoice = () => {
  if (!selectedItem.value) return;

  // Stock availability check
  if (selectedItem.value.quantity < itemQuantity.value) {
    toast.add({
      severity: "error",
      summary: "Insufficient Stock",
      detail: `Only ${selectedItem.value.quantity} available`,
      life: 5000,
    });
    return;
  }
  const formatDate = (isoDateString) => {
    return isoDateString ? new Date(isoDateString).toISOString().split("T")[0] : null;
  };
  // Expiry date check
  if (
    selectedItem.value.expiry_date &&
    new Date(selectedItem.value.expiry_date) < new Date()
  ) {
    toast.add({
      severity: "error",
      summary: "Expired Item",
      detail: "Cannot add expired items to invoice",
      life: 5000,
    });
    return;
  }

  // Check if item already exists in invoice
  const existingItemIndex = invoiceItems.value.findIndex(
    (item) => item.inventory_item_id === selectedItem.value.id
  );

  if (existingItemIndex >= 0) {
    // Update existing item
    invoiceItems.value[existingItemIndex].quantity += itemQuantity.value;
    invoiceItems.value[existingItemIndex].discount_amount += itemDiscount.value;
  } else {
    // Add new item
    invoiceItems.value.push({
      inventory_item_id: selectedItem.value.id,
      description: selectedItem.value.name,
      name: selectedItem.value.brand + " " + selectedItem.value.name,
      quantity: itemQuantity.value,
      unit_price: itemPrice.value,
      tax_rate: itemTaxRate.value,
      discount_amount: itemDiscount.value,
      total_price: itemQuantity.value * itemPrice.value - itemDiscount.value,
    });
  }

  clearItem();
  toast.add({
    severity: "success",
    summary: "Item Added",
    detail: "Item has been added to the invoice",
    life: 3000,
  });
};

const removeItem = (index) => {
  invoiceItems.value.splice(index, 1);
};

const loadPaymentMethods = async () => {
  try {
    const response = await axiosInstance.get("/payment-methods");
    paymentMethods.value = response.data.data;
  } catch (error) {
    console.error("Error loading payment methods:", error);
  }
};

const generateInvoiceNumber = () => {
  const date = new Date();
  const prefix = "INV";
  const year = date.getFullYear().toString().slice(-2);
  const month = (date.getMonth() + 1).toString().padStart(2, "0");
  const random = Math.floor(1000 + Math.random() * 9000);
  invoiceNumber.value = `${prefix}-${year}${month}-${random}`;
};

const saveDraft = async () => {
  status.value = "draft";
  await createInvoice();
};

const createInvoice = async () => {
  if (invoiceItems.value.length === 0) {
    toast.add({
      severity: "error",
      summary: "Error",
      detail: "Invoice must have at least one item",
      life: 5000,
    });
    return;
  }

  if (requiresDeposit.value && !depositPaymentMethod.value) {
    toast.add({
      severity: "error",
      summary: "Error",
      detail: "Please select a payment method for the deposit",
      life: 5000,
    });
    return;
  }

  const payload = {
    branch_id: 1, // Should come from user's session or selection
    client_id: selectedClient.value?.id || null,
    pet_id: selectedPet.value?.id || null,
    invoice_number: invoiceNumber.value,
    date: invoiceDate.value.toISOString().split("T")[0],
    due_date: dueDate.value.toISOString().split("T")[0],
    payment_terms: paymentTerms.value,
    status: status.value,
    subtotal: subtotal.value,
    tax_amount: totalTax.value,
    discount_amount: totalDiscount.value,
    total_amount: totalAmount.value,
    deposit_required: depositRequired.value,
    notes: notes.value,
    medical_record_id: props.medical_record_id,
    items: invoiceItems.value.map((item) => ({
      inventory_item_id: item.inventory_item_id,
      description: item.description,
      quantity: item.quantity,
      unit_price: item.unit_price,
      tax_rate: item.tax_rate,
      discount_amount: item.discount_amount,
      total_price: item.total_price,
    })),
  };
  console.log("PAYLOAD", payload);
  // Add payment if deposit is required
  if (depositRequired.value > 0) {
    payload.payments = [
      {
        payment_method_id: depositPaymentMethod.value,
        amount: depositRequired.value,
        payment_date: new Date().toISOString(),
        is_verified: true,
        type: "deposit",
      },
    ];
  }
  console.log(payload);
  try {
    const response = await axiosInstance.post("/invoices", payload);
    emit("InvoiceCreated");
    toast.add({
      severity: "success",
      summary: "Success",
      detail: `Invoice ${
        status.value === "draft" ? "saved as draft" : "created successfully"
      }`,
      life: 5000,
    });
    // Reset form or redirect
  } catch (error) {
    console.error("Error creating invoice:", error);
    toast.add({
      severity: "error",
      summary: "Error",
      detail: error.response?.data?.message || "Failed to create invoice",
      life: 5000,
    });
  }
};

// Initialize
onMounted(() => {
  generateInvoiceNumber();
  loadPaymentMethods();

  // Set due date to 7 days from now by default
  const due = new Date();
  due.setDate(due.getDate() + 7);
  dueDate.value = due;
});

// Watch paymentTerms and auto-set deposit if payment terms require it
watch(paymentTerms, (newVal) => {
  if (newVal === "50_upfront") {
    depositRequired.value = totalAmount.value * 0.5;
  } else {
    depositRequired.value = 0;
  }
});

// Watch totalAmount to adjust deposit if it changes
watch(totalAmount, (newVal) => {
  if (paymentTerms.value === "50_upfront") {
    depositRequired.value = newVal * 0.5;
  }
});
</script>

<style scoped>
/* Add any custom styles here */
</style>
