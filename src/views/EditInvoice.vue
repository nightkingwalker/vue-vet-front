<template>
  <div class="w-full mt-2">
    <div
      class="grid grid-cols-1 lg:grid-cols-3 gap-6 bg-[var(--p-surface-200)] dark:bg-[var(--p-surface-600)] rounded-lg p-2">
      <!-- Left Column - Client & Pet Info -->
      <div class="bg-white p-4 rounded-lg shadow">
        <h2 class="!text-sm font-semibold mb-4 border-b pb-2">
          Client & Pet Information
        </h2>

        <div class="mt-3">
          <FloatLabel variant="on" class="!!2xl:text-lg lg:text-xs">
            <AutoComplete v-model="clientSearch" :suggestions="filteredClients" @complete="searchClients"
              optionLabel="name" size="small" fluid @item-select="selectClient" :disabled="isEditing" />
            <label>Search Client</label>
          </FloatLabel>
        </div>

        <div v-if="selectedClient" class="my-4 p-3 bg-gray-50 rounded">
          <div class="flex justify-between items-center mb-2">
            <span class="font-medium">{{ selectedClient.name }}</span>
            <Button v-if="!isEditing" size="small" icon="pi pi-times"
              class="p-button-text p-button-xs !2xl:text-lg lg:text-xs" @click="clearClient" />
          </div>
          <div class="!!2xl:text-lg lg:text-xs text-gray-600">
            <div>Phone: {{ selectedClient.phone }}</div>
            <div>Email: {{ selectedClient.email }}</div>
          </div>
        </div>

        <div class="mb-4" v-if="selectedClient">
          <FloatLabel variant="on" class="!!2xl:text-lg lg:text-xs">
            <Select v-model="selectedPet" :options="clientPets" @change="selectPet" optionLabel="name" class="w-full"
              :disabled="isEditing" />
            <label>Select Pet</label>
          </FloatLabel>
        </div>

        <div v-if="selectedPet" class="mb-4 p-3 bg-gray-50 rounded">
          <div class="flex justify-between items-center mb-2">
            <span class="font-medium">{{ selectedPet.name }}</span>
            <Button v-if="!isEditing" size="small" icon="pi pi-times"
              class="p-button-text p-button-xs !2xl:text-lg lg:text-xs" @click="clearPet" />
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
        <h2 class="!text-sm font-semibold mb-4 border-b pb-2">Invoice Items</h2>

        <div class="mt-3" v-if="!isEditing">
          <FloatLabel variant="on" class="!!2xl:text-lg lg:text-xs">
            <AutoComplete v-model="itemSearch" :suggestions="filteredItems" @complete="searchItems"
              optionLabel="displayText" size="small" fluid @item-select="selectItem" @keyup.enter="handleBarcodeEnter"
              @keydown.enter.prevent="handleBarcodeEnter">
              <template #item="slotProps">
                <div class="flex items-center justify-between p-2">
                  <div>
                    <div class="font-medium">{{ slotProps.item.name }}</div>
                    <div class="!!2xl:text-lg lg:text-xs text-gray-500">
                      {{ slotProps.item.brand }}
                    </div>
                  </div>
                  <div class="flex items-center">
                    <span class="!!2xl:text-lg lg:text-xs font-semibold ltr:mr-2 rtl:ml-2">${{
                      slotProps.item.selling_price }}</span>
                    <Tag v-if="slotProps.item.quantity <= 0" value="Out of stock" severity="danger" />
                    <Tag v-else-if="
                        slotProps.item.expiry_date &&
                        new Date(slotProps.item.expiry_date) < new Date()
                      " value="Expired" severity="warning" />
                    <Tag v-else value="In stock" severity="success" />
                  </div>
                </div>
              </template>
            </AutoComplete>
            <label>Search Items</label>
          </FloatLabel>
        </div>

        <div v-if="selectedItem && !isEditing" class="mb-4 p-3 bg-gray-50 rounded">
          <div class="flex justify-between items-start mb-2">
            <div>
              <div class="font-medium">{{ selectedItem.name }}</div>
              <div class="!!2xl:text-lg lg:text-xs text-gray-500">
                {{ selectedItem.brand }}
              </div>
            </div>
            <Button size="small" icon="pi pi-times" class="p-button-text p-button-xs !2xl:text-lg lg:text-xs"
              @click="clearItem" />
          </div>

          <div class="grid grid-cols-2 gap-4 mt-3">
            <div class="w-full">
              <FloatLabel variant="on" class="!!2xl:text-lg lg:text-xs">
                <InputNumber class="!!2xl:text-lg lg:text-xs" v-model="itemPrice" mode="currency" currency="SYP"
                  :min="0" fluid size="small" />
                <label>Price</label>
              </FloatLabel>
            </div>
            <div class="w-full">
              <FloatLabel variant="on" class="!!2xl:text-lg lg:text-xs">
                <InputNumber class="!!2xl:text-lg lg:text-xs" v-model="itemQuantity" :min="0.01"
                  :max="selectedItem ? selectedItem.quantity : null" fluid size="small" />
                <label>Quantity</label>
              </FloatLabel>
            </div>
            <div class="w-full">
              <FloatLabel variant="on" class="!!2xl:text-lg lg:text-xs">
                <InputNumber class="!!2xl:text-lg lg:text-xs" v-model="itemDiscount" mode="currency" currency="SYP"
                  :min="0" fluid size="small" />
                <label for="">Discount</label>
              </FloatLabel>
            </div>
            <div class="w-full">
              <FloatLabel variant="on" class="!!2xl:text-lg lg:text-xs">
                <InputNumber v-model="itemTaxRate" suffix="%" :min="0" :max="100" fluid class="!!2xl:text-lg lg:text-xs"
                  size="small" />
                <label>Tax Rate</label>
              </FloatLabel>
            </div>
          </div>

          <div class="mt-3 flex justify-end">
            <Button size="small" label="Add to Invoice" class="!!2xl:text-lg lg:text-xs" icon="pi pi-plus"
              @click="addItemToInvoice" />
          </div>
        </div>

        <div class="mt-3">
          <DataTable :value="invoiceItems" class="p-datatable-sm" :scrollable="true" scrollHeight="300px">
            <Column field="name" header="Item" class="!2xl:text-lg lg:text-xs"></Column>
            <Column field="quantity" header="Qty" class="!2xl:text-lg lg:text-xs" style="width: 80px">
              <template #body="slotProps">
                <InputNumber v-if="!isEditing" v-model="slotProps.data.quantity" :min="0.01" size="small" fluid
                  @update:modelValue="updateItemQuantity(slotProps.index, $event)" />
                <span v-else>{{ slotProps.data.quantity }}</span>
              </template>
            </Column>
            <Column header="Price" class="!2xl:text-lg lg:text-xs" style="width: 100px">
              <template #body="slotProps">
                <InputNumber v-if="!isEditing" v-model="slotProps.data.unit_price" mode="decimal" :min="0" size="small"
                  fluid @update:modelValue="updateItemPrice(slotProps.index, $event)" />
                <span v-else>${{ slotProps.data.unit_price.toFixed(2) }}</span>
              </template>
            </Column>
            <Column header="Total" class="!2xl:text-lg lg:text-xs" style="width: 100px">
              <template #body="slotProps">
                ${{ calculateItemTotal(slotProps.data).toFixed(2) }}
              </template>
            </Column>
            <Column header="Actions" class="!2xl:text-lg lg:text-xs" style="width: 80px">
              <template #body="slotProps">
                <Button v-if="!isEditing" size="small" icon="pi pi-trash" class="p-button-text p-button-danger"
                  @click="removeItem(slotProps.index)" />
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
            <InputText v-model="invoiceNumber" size="small" class="w-full !!2xl:text-lg lg:text-xs" disabled />
            <label>Invoice Number</label>
          </FloatLabel>
        </div>

        <div class="grid grid-cols-2 gap-4 mt-6">
          <div>
            <FloatLabel variant="on" class="!!2xl:text-lg lg:text-xs">
              <DatePicker showIcon iconDisplay="input" showButtonBar size="small" v-model="invoiceDate"
                dateFormat="yy-mm-dd" class="w-full" :disabled="isEditing" />
              <label>Invoice Date</label>
            </FloatLabel>
          </div>
          <div>
            <FloatLabel variant="on" class="!!2xl:text-lg lg:text-xs">
              <DatePicker showIcon iconDisplay="input" showButtonBar size="small" v-model="dueDate"
                dateFormat="yy-mm-dd" class="w-full" :disabled="isEditing" />
              <label>Due Date</label>
            </FloatLabel>
          </div>
        </div>

        <div class="mt-3 flex gap-2 justify-between">
          <FloatLabel variant="on" class="!!2xl:text-lg lg:text-xs !w-1/2">
            <Select v-model="paymentTerms" size="small" :options="paymentTermOptions" optionLabel="label"
              optionValue="value" fluid class="!2xl:text-lg lg:text-xs" :disabled="isEditing" />
            <label>Payment Terms</label>
          </FloatLabel>
          <FloatLabel variant="on" class="!!2xl:text-lg lg:text-xs !w-1/2">
            <Select size="small" v-model="status" :options="statusOptions" optionLabel="label" optionValue="value" fluid
              class="!2xl:text-lg lg:text-xs" :disabled="isEditing" />
            <label>Status</label>
          </FloatLabel>
        </div>

        <div class="mt-3 flex gap-2 justify-between">
          <FloatLabel variant="on" class="!2xl:text-lg lg:text-xs !w-1/2">
            <InputNumber v-model="depositRequired" showButtons mode="decimal" size="small" currency="SYP" :min="0"
              :step="0.25" :max="totalAmount" fluid class="!2xl:text-lg lg:text-xs" :disabled="isEditing" />
            <label>Deposit Required</label>
          </FloatLabel>

          <FloatLabel variant="on" class="!2xl:text-lg lg:text-xs w-1/2">
            <Select size="small" v-model="depositPaymentMethod" :options="paymentMethods" optionLabel="name"
              optionValue="id" fluid class="!2xl:text-lg lg:text-xs" :disabled="isEditing" />
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
          <div v-if="depositRequired > 0" class="flex justify-between mb-2 !2xl:text-lg lg:text-xs">
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
            <Textarea v-model="notes" rows="3" class="w-full" :disabled="isEditing" />
            <label>Notes</label>
          </FloatLabel>
        </div>

        <div class="mt-3 flex justify-end gap-2" v-if="!isEditing">
          <Button size="small" label="Save Draft" severity="secondary" @click="saveDraft" />
          <Button size="small" label="Update Invoice" @click="updateInvoice" />
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
import Cookies from "js-cookie";

const props = defineProps({
  invoiceData: {
    type: Object,
    required: true,
  },
  isEditing: {
    type: Boolean,
    default: false,
  },
});
// console.log(props);
const emit = defineEmits(["close", "updated"]);

const toast = useToast();

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
  } catch (error) {
    console.error("Error loading pets:", error);
    clientPets.value = [];
  }
};

const selectPet = (event) => {
  selectedPet.value = event.value;
  selectedPet.value.age = computeAge(selectedPet.value.date_of_birth);
};

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
      params: { branch_id: Cookies.get("M3K8g2387BahBaqyjDe6"), query: event.query },
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
/*   if (!itemSearch.value) return;

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
  } */
  return
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

const computeAge = (dateOfBirth) => {
  const birthDate = new Date(dateOfBirth);
  const currentDate = new Date();
  const currentYear = currentDate.getFullYear();
  const currentMonth = currentDate.getMonth();
  const birthYear = birthDate.getFullYear();
  const birthMonth = birthDate.getMonth();

  let ageInYears = currentYear - birthYear;
  let ageInMonths = currentMonth - birthMonth;

  if (ageInMonths < 0) {
    ageInYears--;
    ageInMonths += 12;
  }

  const yearsText = ageInYears > 0 ? `${ageInYears} ${ageInYears > 1 ? "Y" : "Y"}` : "";
  const monthsText =
    ageInMonths > 0 ? `${ageInMonths} ${ageInMonths > 1 ? "M" : "M"}` : "";

  return `${yearsText}${yearsText && monthsText ? " & " : ""}${monthsText}`;
};

const removeItem = (index) => {
  invoiceItems.value.splice(index, 1);
};

const updateItemQuantity = (index, newValue) => {
  invoiceItems.value[index].quantity = newValue;
  invoiceItems.value[index].total_price =
    newValue * invoiceItems.value[index].unit_price -
    invoiceItems.value[index].discount_amount;
};

const updateItemPrice = (index, newValue) => {
  invoiceItems.value[index].unit_price = newValue;
  invoiceItems.value[index].total_price =
    invoiceItems.value[index].quantity * newValue -
    invoiceItems.value[index].discount_amount;
};

const calculateItemTotal = (item) => {
  return item.quantity * item.unit_price - item.discount_amount;
};

const loadPaymentMethods = async () => {
  try {
    const response = await axiosInstance.get("/payment-methods");
    paymentMethods.value = response.data.data;
  } catch (error) {
    console.error("Error loading payment methods:", error);
  }
};

const saveDraft = async () => {
  status.value = "draft";
  await updateInvoice();
};

const updateInvoice = async () => {
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
    branch_id: props.invoiceData.branch_id,
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

  try {
    const response = await axiosInstance.put(
      `/invoices/${props.invoiceData.id}`,
      payload
    );
    toast.add({
      severity: "success",
      summary: "Success",
      detail: "Invoice updated successfully",
      life: 5000,
    });
    emit("updated", response.data.data);
  } catch (error) {
    console.error("Error updating invoice:", error);
    toast.add({
      severity: "error",
      summary: "Error",
      detail: error.response?.data?.message || "Failed to update invoice",
      life: 5000,
    });
  }
};

// Initialize with invoice data
const initializeWithInvoiceData = () => {
  invoiceNumber.value = props.invoiceData.invoice_number;
  invoiceDate.value = new Date(props.invoiceData.date);
  dueDate.value = new Date(props.invoiceData.due_date);
  paymentTerms.value = props.invoiceData.payment_terms;
  status.value = props.invoiceData.status;
  notes.value = props.invoiceData.notes || "";
  depositRequired.value = parseFloat(props.invoiceData.deposit_required);

  // Set client and pet if available
  if (props.invoiceData.client_id) {
    selectedClient.value = props.invoiceData.owner;
    clientSearch.value = props.invoiceData.owner.name;
    loadClientPets();

    if (props.invoiceData.pet_id) {
      selectedPet.value = props.invoiceData.pet;
    }
  }

  // Set invoice items
  invoiceItems.value = props.invoiceData.items.map((item) => ({
    inventory_item_id: item.inventory_item_id,
    description: item.description,
    name: item.inventory_item.brand + " " + item.inventory_item.name,
    quantity: parseFloat(item.quantity),
    unit_price: parseFloat(item.unit_price),
    tax_rate: parseFloat(item.tax_rate),
    discount_amount: parseFloat(item.discount_amount),
    total_price: parseFloat(item.total_price),
  }));

  // Set deposit payment method if available
  if (
    props.invoiceData.payment_status === "paid" ||
    props.invoiceData.payment_status === "partially_paid"
  ) {
    // You might need to fetch the actual payment method from payments if available
    depositPaymentMethod.value = paymentMethods.value[0]?.id;
  }
};
depositPaymentMethod.value = 1;
onMounted(() => {
  loadPaymentMethods();
  initializeWithInvoiceData();
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
