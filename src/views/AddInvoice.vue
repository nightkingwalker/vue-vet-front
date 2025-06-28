<template>
  <div class="w-full mt-2 xl:!text-[12px]">
    <div
      class="grid grid-cols-1 lg:grid-cols-3 gap-6 bg-[var(--p-surface-200)] dark:bg-[var(--p-surface-600)] rounded-lg p-2"
    >
      <!-- Left Column - Client & Pet Info -->
      <div class="bg-white p-4 rounded-lg shadow">
        <h2 class="xl:!text-[12px] !text-sm font-semibold mb-4 border-b pb-2">
          {{ $t("add_invoice.client_section.title") }}
        </h2>

        <div class="mt-3">
          <FloatLabel variant="on" class="lg:!text-xs">
            <AutoComplete
              v-model="clientSearch"
              :suggestions="filteredClients"
              @complete="searchClients"
              optionLabel="name"
              size="small"
              fluid
              @item-select="selectClient"
            />
            <label>{{ $t("add_invoice.client_section.search_client") }}</label>
          </FloatLabel>
        </div>

        <div v-if="selectedClient" class="my-4 p-3 bg-gray-50 rounded">
          <div class="flex justify-between items-center mb-2">
            <span class="font-medium">{{ selectedClient.name }}</span>
            <Button
              size="small"
              icon="pi pi-times"
              class="p-button-text p-button-xs lg:!text-xs"
              @click="clearClient"
            />
          </div>
          <div class="lg:!text-xs text-gray-600">
            <div>
              {{ $t("add_invoice.client_section.phone") }}: {{ selectedClient.phone }}
            </div>
            <div>
              {{ $t("add_invoice.client_section.email") }}: {{ selectedClient.email }}
            </div>
          </div>
        </div>

        <div class="mb-4" v-if="selectedClient">
          <FloatLabel variant="on" class="lg:!text-xs">
            <Select
              v-model="selectedPet"
              :options="clientPets"
              @change="selectPet"
              optionLabel="name"
              class="w-full"
            />
            <label>{{ $t("add_invoice.client_section.select_pet") }}</label>
          </FloatLabel>
        </div>

        <div v-if="selectedPet" class="mb-4 p-3 bg-gray-50 rounded">
          <div class="flex justify-between items-center mb-2">
            <span class="font-medium">{{ selectedPet.name }}</span>
            <Button
              size="small"
              icon="pi pi-times"
              class="p-button-text p-button-xs lg:!text-xs"
              @click="clearPet"
            />
          </div>
          <div class="lg:!text-xs text-gray-600">
            <div>
              <b>{{ $t("add_invoice.client_section.species") }}:</b>
              {{ selectedPet.species }}
            </div>
            <div>
              <b>{{ $t("add_invoice.client_section.breed") }}:</b> {{ selectedPet.breed }}
            </div>
            <div>
              <b>{{ $t("add_invoice.client_section.dob") }}:</b>
              {{ computeAge(selectedPet.date_of_birth) }}
            </div>
          </div>
        </div>
      </div>

      <!-- Middle Column - Item Search & List -->
      <div class="bg-white p-4 rounded-lg shadow">
        <h2 class="xl:!text-[12px] !text-sm font-semibold mb-4 border-b pb-2">
          {{ $t("add_invoice.items_section.title") }}
        </h2>

        <div class="mt-3">
          <FloatLabel variant="on" class="lg:!text-xs">
            <AutoComplete
              v-model="itemSearch"
              :suggestions="filteredItems"
              @complete="searchItems"
              optionLabel="displayText"
              size="small"
              fluid
              @item-select="selectItem"
              @keyup.enter="handleBarcodeEnter"
              @keydown.enter.prevent="handleBarcodeEnter"
            >
              <template #item="slotProps">
                <div class="flex items-center justify-between p-2">
                  <div>
                    <div class="font-medium">{{ slotProps.item.name }}</div>
                    <div class="lg:!text-xs text-gray-500">
                      {{ slotProps.item.brand }}
                    </div>
                  </div>
                  <div class="flex items-center">
                    <span class="lg:!text-xs font-semibold ltr:mr-2 rtl:ml-2"
                      >${{ slotProps.item.selling_price }}</span
                    >
                    <Tag
                      v-if="slotProps.item.quantity <= 0"
                      :value="$t('add_invoice.items_section.out_of_stock')"
                      severity="danger"
                    />
                    <Tag
                      v-else-if="
                        slotProps.item.expiry_date &&
                        new Date(slotProps.item.expiry_date) < new Date()
                      "
                      :value="$t('add_invoice.items_section.expired')"
                      severity="warning"
                    />
                    <Tag
                      v-else
                      :value="$t('add_invoice.items_section.in_stock')"
                      severity="success"
                    />
                  </div>
                </div>
              </template>
              <template #option="slotProps">
                <div class="flex items-center">
                  <div>
                    <Chip
                      :icon="
                        slotProps.option.category === 'food'
                          ? 'fa-solid fa-bone'
                          : slotProps.option.category === 'miscellaneous'
                          ? 'fa-solid fa-volleyball'
                          : slotProps.option.category === 'pharmaceutical'
                          ? 'fa-solid fa-pills'
                          : slotProps.option.category === 'grooming'
                          ? 'fa-solid fa-shower'
                          : slotProps.option.category === 'treatment'
                          ? 'fa-solid fa-stethoscope'
                          : 'fa-solid fa-question'
                      "
                    />
                    {{ slotProps.option.brand }} {{ slotProps.option.name }} --
                    {{ slotProps.option.selling_price }}
                    <Tag
                      v-if="
                        slotProps.option.quantity <= slotProps.option.minimum_stock_level
                      "
                      :value="
                        $t('add_invoice.items_section.almost_out_of_stock') +
                        ` ` +
                        slotProps.option.quantity
                      "
                      severity="warn"
                    />
                    <!-- <Tag v-else-if="slotProps.option.quantity <= 0"
                      :value="$t('add_invoice.items_section.out_of_stock')" severity="danger" /> -->
                    <Tag
                      v-else
                      :value="
                        $t('add_invoice.items_section.in_stock') +
                        ` ` +
                        slotProps.option.quantity
                      "
                      severity="success"
                    />
                  </div>
                </div>
              </template>
              <template #footer>
                <Button
                  :label="$t('inventory.actions.add')"
                  icon="pi pi-plus"
                  @click="showModal"
                  class="p-button-text w-full"
                />
              </template>
            </AutoComplete>
            <label>{{ $t("add_invoice.items_section.search_items") }}</label>
          </FloatLabel>
        </div>

        <div v-if="selectedItem" class="mb-4 p-3 bg-gray-50 rounded">
          <div class="flex justify-between items-start mb-2">
            <div>
              <div class="font-medium">{{ selectedItem.name }}</div>
              <div class="lg:!text-xs text-gray-500">
                {{ selectedItem.brand }}
              </div>
            </div>
            <Button
              size="small"
              icon="pi pi-times"
              class="p-button-text p-button-xs lg:!text-xs"
              @click="clearItem"
            />
          </div>

          <div class="grid grid-cols-2 gap-4 mt-3">
            <div class="w-full">
              <FloatLabel variant="on" class="lg:!text-xs">
                <InputNumber
                  class="lg:!text-xs"
                  v-model="itemPrice"
                  mode="currency"
                  currency="SYP"
                  :min="0"
                  fluid
                  size="small"
                />
                <label>{{ $t("add_invoice.items_section.price") }}</label>
              </FloatLabel>
            </div>
            <div class="w-full">
              <FloatLabel variant="on" class="lg:!text-xs">
                <InputNumber
                  class="lg:!text-xs"
                  v-model="itemQuantity"
                  :min="0.01"
                  :max="selectedItem ? selectedItem.quantity : null"
                  fluid
                  size="small"
                />
                <label>{{ $t("add_invoice.items_section.quantity") }}</label>
              </FloatLabel>
            </div>
            <div class="w-full">
              <FloatLabel variant="on" class="lg:!text-xs">
                <InputNumber
                  class="lg:!text-xs"
                  v-model="itemDiscount"
                  mode="currency"
                  currency="SYP"
                  :min="0"
                  fluid
                  size="small"
                />
                <label>{{ $t("add_invoice.items_section.discount") }}</label>
              </FloatLabel>
            </div>
            <div class="w-full">
              <FloatLabel variant="on" class="lg:!text-xs">
                <InputNumber
                  v-model="itemTaxRate"
                  suffix="%"
                  :min="0"
                  :max="100"
                  fluid
                  class="lg:!text-xs"
                  size="small"
                />
                <label>{{ $t("add_invoice.items_section.tax_rate") }}</label>
              </FloatLabel>
            </div>
          </div>

          <div class="mt-3 flex justify-end">
            <Button
              size="small"
              :label="$t('add_invoice.items_section.add_to_invoice')"
              class="lg:!text-xs"
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
            <Column
              field="name"
              :header="$t('add_invoice.items_section.item')"
              class="lg:!text-xs"
            >
            </Column>
            <Column
              field="quantity"
              :header="$t('add_invoice.items_section.qty')"
              class="lg:!text-xs"
              style="width: 80px"
            >
            </Column>
            <Column
              :header="$t('add_invoice.items_section.price')"
              class="lg:!text-xs"
              style="width: 100px"
            >
              <template #body="slotProps">
                ${{ slotProps.data.unit_price.toFixed(2) }}
              </template>
            </Column>
            <Column
              :header="$t('add_invoice.items_section.total')"
              class="lg:!text-xs"
              style="width: 100px"
            >
              <template #body="slotProps">
                ${{
                  (
                    slotProps.data.quantity * slotProps.data.unit_price -
                    slotProps.data.discount_amount
                  ).toFixed(2)
                }}
              </template>
            </Column>
            <Column
              :header="$t('add_invoice.items_section.actions')"
              class="lg:!text-xs"
              style="width: 80px"
            >
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
        <h2 class="xl:!text-[12px] !text-sm font-semibold mb-4 border-b pb-2">
          {{ $t("add_invoice.summary_section.title") }}
        </h2>

        <div class="mt-3">
          <FloatLabel variant="on" class="lg:!text-xs">
            <InputText
              v-model="invoiceNumber"
              size="small"
              class="w-full lg:!text-xs"
              disabled
            />
            <label>{{ $t("add_invoice.summary_section.invoice_number") }}</label>
          </FloatLabel>
        </div>

        <div class="grid grid-cols-2 gap-4 mt-6">
          <div>
            <FloatLabel variant="on" class="lg:!text-xs">
              <DatePicker
                showIcon
                iconDisplay="input"
                showButtonBar
                size="small"
                v-model="invoiceDate"
                dateFormat="yy-mm-d"
                class="w-full"
              />
              <label>{{ $t("add_invoice.summary_section.invoice_date") }}</label>
            </FloatLabel>
          </div>
          <div>
            <FloatLabel variant="on" class="lg:!text-xs">
              <DatePicker
                size="small"
                v-model="dueDate"
                dateFormat="yy-mm-d"
                class="w-full"
              />
              <label>{{ $t("add_invoice.summary_section.due_date") }}</label>
            </FloatLabel>
          </div>
        </div>

        <div class="mt-3 flex gap-2 justify-between">
          <FloatLabel variant="on" class="lg:!text-xs !w-1/2">
            <Select
              v-model="paymentTerms"
              size="small"
              :options="paymentTermOptions"
              optionLabel="label"
              optionValue="value"
              fluid
              class="lg:!text-xs"
            />
            <label>{{ $t("add_invoice.summary_section.payment_terms") }}</label>
          </FloatLabel>
          <FloatLabel variant="on" class="lg:!text-xs !w-1/2">
            <Select
              size="small"
              v-model="status"
              :options="statusOptions"
              optionLabel="label"
              optionValue="value"
              fluid
              class="lg:!text-xs"
            />
            <label>{{ $t("add_invoice.summary_section.status") }}</label>
          </FloatLabel>
        </div>

        <div class="mt-3 flex gap-2 justify-between">
          <FloatLabel variant="on" class="lg:!text-xs !w-1/2">
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
              class="lg:!text-xs"
            />
            <label>{{ $t("add_invoice.summary_section.deposit_required") }}</label>
          </FloatLabel>

          <FloatLabel variant="on" class="lg:!text-xs w-1/2">
            <Select
              size="small"
              v-model="depositPaymentMethod"
              :options="paymentMethods"
              optionLabel="name"
              optionValue="id"
              fluid
              class="lg:!text-xs"
            />
            <label>{{ $t("add_invoice.summary_section.payment_method") }}</label>
          </FloatLabel>
        </div>

        <div class="border-t mt-4 pt-4">
          <div class="flex justify-between mb-2 lg:!text-xs">
            <span class="lg:!text-xs"
              >{{ $t("add_invoice.summary_section.subtotal") }}:</span
            >
            <span class="lg:!text-xs">${{ subtotal.toFixed(2) }}</span>
          </div>
          <div class="flex justify-between mb-2 lg:!text-xs">
            <span class="lg:!text-xs"
              >{{ $t("add_invoice.summary_section.discount") }}:</span
            >
            <span class="lg:!text-xs">-${{ totalDiscount.toFixed(2) }}</span>
          </div>
          <div class="flex justify-between mb-2 lg:!text-xs">
            <span class="lg:!text-xs">{{ $t("add_invoice.summary_section.tax") }}:</span>
            <span class="lg:!text-xs">${{ totalTax.toFixed(2) }}</span>
          </div>
          <div v-if="depositRequired > 0" class="flex justify-between mb-2 lg:!text-xs">
            <span class="lg:!text-xs"
              >{{ $t("add_invoice.summary_section.deposit_required") }}:</span
            >
            <span class="lg:!text-xs">${{ depositRequired.toFixed(2) }}</span>
          </div>
          <div class="flex justify-between font-bold !text-xs border-t pt-2 mt-2">
            <span>{{ $t("add_invoice.summary_section.total") }}:</span>
            <span>${{ totalAmount.toFixed(2) }}</span>
          </div>
          <div v-if="depositRequired > 0" class="flex justify-between font-bold !text-xs">
            <span>{{ $t("add_invoice.summary_section.balance_after_deposit") }}:</span>
            <span>${{ (totalAmount - depositRequired).toFixed(2) }}</span>
          </div>
        </div>

        <div class="mt-3">
          <FloatLabel variant="on" class="lg:!text-xs">
            <Textarea v-model="notes" rows="3" class="w-full" />
            <label>{{ $t("add_invoice.summary_section.notes") }}</label>
          </FloatLabel>
        </div>

        <div class="mt-3 flex justify-end gap-2">
          <Button
            size="small"
            :label="$t('add_invoice.summary_section.save_draft')"
            severity="secondary"
            @click="saveDraft"
          />
          <Button
            size="small"
            :label="$t('add_invoice.summary_section.create_invoice')"
            @click="createInvoice"
          />
        </div>
      </div>
    </div>

    <Dialog
      :header="
        editMode ? $t('inventory.dialog.edit_title') : $t('inventory.dialog.add_title')
      "
      v-model:visible="isModalVisible"
      modal
      :closable="true"
      class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)]"
    >
      <InventoryItemForm
        v-focustrap="{
          disabled: false,
          autoFocus: true,
        }"
        :item="selectedItem"
        :editMode="editMode"
        @submitted="handleSubmit"
      />
    </Dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch, defineAsyncComponent } from "vue";
import { useToast } from "primevue/usetoast";
import axiosInstance from "@/axios";
import InventoryItemForm from "@/views/addInventoryItem.vue";
// const InventoryItemForm = defineAsyncComponent(() =>
//   import("@/views/addInventoryItem.vue")
// );
// PrimeVue Components
import Button from "primevue/button";
import AutoComplete from "primevue/autocomplete";
import Chip from "primevue/chip";
import FloatLabel from "primevue/floatlabel";
import Select from "primevue/select";
import InputNumber from "primevue/inputnumber";
import DataTable from "primevue/datatable";
import Column from "primevue/column";
import DatePicker from "primevue/datepicker";
import Textarea from "primevue/textarea";
import Tag from "primevue/tag";
import InputText from "primevue/inputtext";
import Dialog from "primevue/dialog";
import Cookies from "js-cookie";
import { useI18n } from "vue-i18n"; // };
const { t } = useI18n();
const emit = defineEmits(["invoiceCreated"]);
const toast = useToast();
const props = defineProps({
  pet: {
    type: Object,
    required: false,
  },
  medical_record_id: {
    type: String,
    default: "",
    required: false,
  },
  invoice: {
    type: Object,
    default: null,
  },
  editMode: {
    type: Boolean,
    default: false,
  },
});
// Client & Pet Data
const isModalVisible = ref(false);
const clientSearch = ref("");
const filteredClients = ref([]);
const selectedClient = ref(null);
const clientPets = ref([]);
const selectedPet = ref(null);
const petAge = ref("");
const editMode = ref(false);
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
  { label: t("add_invoice.status_options.draft"), value: "draft" },
  { label: t("add_invoice.status_options.pending"), value: "pending" },
  { label: t("add_invoice.status_options.partially_paid"), value: "partially_paid" },
  { label: t("add_invoice.status_options.paid"), value: "paid" },
  { label: t("add_invoice.status_options.cancelled"), value: "cancelled" },
  { label: t("add_invoice.status_options.refunded"), value: "refunded" },
]);

const paymentTermOptions = ref([
  { label: t("add_invoice.payment_terms.due_on_receipt"), value: "due_on_receipt" },
  { label: t("add_invoice.payment_terms.net_15"), value: "net_15" },
  { label: t("add_invoice.payment_terms.net_30"), value: "net_30" },
  { label: t("add_invoice.payment_terms.50_upfront"), value: "50_upfront" },
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
    
    clientPets.value = response.data.pets.data;
    
  } catch (error) {
    console.error("Error loading pets:", error);
    clientPets.value = [];
  }
};

const selectPet = (event) => {
  selectedPet.value = event.value;
  selectedPet.value.age = computeAge(selectedPet.value.date_of_birth);
  
};
const selectPetProps = (pet) => {
  selectedPet.value = pet;
  selectedPet.value.age = computeAge(selectedPet.value.date_of_birth);
  
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
  
  
  
  
}
const clearPet = () => {
  selectedPet.value = null;
};

const searchItems = async (event) => {
  
  if (event.query.trim().length < 3) {
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
  return;
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
      summary: t("add_invoice.toast.insufficient_stock"),
      detail: t("add_invoice.toast.messages.only_x_available", {
        quantity: selectedItem.value.quantity,
      }),
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
      summary: t("add_invoice.toast.expired_item"),
      detail: t("add_invoice.toast.messages.cannot_add_expired"),
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
    summary: t("add_invoice.toast.item_added"),
    detail: t("add_invoice.toast.messages.item_added_success"),
    life: 3000,
  });
};

const removeItem = (index) => {
  invoiceItems.value.splice(index, 1);
};

/* const loadPaymentMethods = async () => {
  try {
    const response = await axiosInstance.get("/payment-methods");
    paymentMethods.value = response.data.data;
  } catch (error) {
    console.error("Error loading payment methods:", error);
  }
}; */
const loadPaymentMethods = async () => {
  try {
    const response = await axiosInstance.get("/payment-methods");
    paymentMethods.value = response.data.data.map((method) => ({
      ...method,
      // Keep original name for form submission
      originalName: method.name,
      // Add translated name for display
      name: t(
        `add_invoice.payment_methods.${method.name.toLowerCase().replace(" ", "_")}`
      ),
    }));
  } catch (error) {
    console.error("Error loading payment methods:", error);
    toast.add({
      severity: "error",
      summary: t("add_invoice.general.error"),
      detail: t("add_invoice.payment_methods.load_error"),
      life: 5000,
    });
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
      summary: t("add_invoice.toast.error"),
      detail: t("add_invoice.toast.messages.no_items_error"),
      life: 5000,
    });
    return;
  }
  depositPaymentMethod.value = 1;
  if (requiresDeposit.value && !depositPaymentMethod.value) {
    toast.add({
      severity: "error",
      summary: t("add_invoice.toast.error"),
      detail: t("add_invoice.toast.messages.deposit_method_error"),
      life: 5000,
    });
    return;
  }

  const payload = {
    branch_id: Cookies.get("M3K8g2387BahBaqyjDe6"), // Should come from user's session or selection
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
    const response = await axiosInstance.post("/invoices", payload);
    emit("InvoiceCreated");
    toast.add({
      severity: "success",
      summary: t("add_invoice.toast.invoice_created"),
      detail:
        status.value === "draft"
          ? t("add_invoice.toast.messages.invoice_draft_success")
          : t("add_invoice.toast.messages.invoice_created_success"),
      life: 5000,
    });
    // Reset form or redirect
  } catch (error) {
    console.error("Error creating invoice:", error);
    toast.add({
      severity: "error",
      summary: t("add_invoice.toast.error"),
      detail: error.response?.data?.message || t("add_invoice.toast.messages.error"),
      life: 5000,
    });
  }
};
const showModal = () => {
  editMode.value = false;
  selectedItem.value = null;
  isModalVisible.value = true;
};
const handleSubmit = ({ data, status, otherInfo }) => {
  isModalVisible.value = false;
  
  selectItem({
    value: {
      ...data.data,
      displayText: `${data.data.name} (${data.data.brand}) - $${data.data.selling_price}`,
    },
  });
  // searchItems({ query: data.data.barcode })
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
