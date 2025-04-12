<template>
  <div class="w-full">
    <form
      @submit.prevent="submitPayment"
      class="mt-2 md:mx-auto md:w-3/4 sm:mx-8 sm:w-full"
    >
      <fieldset
        class="p-fieldset p-component w-full flex flex-wrap items-center border rounded-lg p-2 justify-start gap-x-2"
      >
        <legend>Add New Payment</legend>

        <div class="field mt-6 w-full">
          <FloatLabel class="w-full">
            <InputNumber
              id="amount"
              fluid
              v-model="payment.amount"
              mode="currency"
              currency="USD"
              :min="0.01"
              :max="maxAmount"
              :disabled="loading"
            />
            <label for="amount">Amount</label>
          </FloatLabel>
          <small class="text-gray-500">Maximum: {{ formatCurrency(maxAmount) }}</small>
        </div>

        <div class="field mt-6 w-full">
          <FloatLabel class="w-full">
            <Select
              fluid
              id="paymentMethod"
              v-model="payment.payment_method_id"
              :options="paymentMethods"
              optionLabel="name"
              optionValue="id"
              :disabled="loading"
              :class="{ 'p-invalid': !payment.payment_method_id && submitted }"
            />
            <label for="paymentMethod">Payment Method</label>
          </FloatLabel>
          <small v-if="!payment.payment_method_id && submitted" class="p-error">
            Payment method is required
          </small>
        </div>

        <div class="field mt-6 w-full">
          <FloatLabel class="w-full">
            <DatePicker
              showIcon
              iconDisplay="input"
              showButtonBar
              id="paymentDate"
              fluid
              v-model="payment.payment_date"
              dateFormat="yy-mm-dd"
              :disabled="loading"
            />
            <label for="paymentDate">Payment Date</label>
          </FloatLabel>
        </div>

        <div class="field mt-6 w-full">
          <FloatLabel class="w-full">
            <TextArea
              fluid
              autoResize
              rows="4"
              id="notes"
              v-model="payment.notes"
              :disabled="loading"
            />
            <label for="notes">Notes</label>
          </FloatLabel>
        </div>

        <div class="flex justify-end gap-2 mt-4 w-full">
          <Button
            label="Cancel"
            icon="pi pi-times"
            @click="$emit('cancel')"
            class="p-button-text"
            :disabled="loading"
          />
          <Button
            type="submit"
            label="Submit Payment"
            icon="pi pi-check"
            :loading="loading"
          />
        </div>
      </fieldset>
    </form>
  </div>
</template>

<script setup>
import { ref, computed } from "vue";
import FloatLabel from "primevue/floatlabel";
import Select from "primevue/select";
import InputNumber from "primevue/inputnumber";
import DatePicker from "primevue/datepicker";
import Button from "primevue/button";
import InputText from "primevue/inputtext";
import TextArea from "primevue/textarea";
import axiosInstance from "@/axios"; // Assuming you've created a global axios instance
import { useToast } from "primevue/usetoast";

const props = defineProps({
  invoice: {
    type: Object,
    required: true,
  },
  paymentMethods: {
    type: Array,
    default: () => [],
  },
});
const toast = useToast();
const emit = defineEmits(["submit", "cancel"]);

const loading = ref(false);
const submitted = ref(false);

const payment = ref({
  amount: 0,
  payment_method_id: null,
  payment_date: new Date(),
  notes: "",
  is_verified: true,
});
const paymentMethods = ref([
  { id: 1, name: "Cash" },
  { id: 2, name: "Credit Card" },
  { id: 3, name: "Bank Transfer" },
]);
const maxAmount = computed(() => {
  return props.invoice.total_amount - props.invoice.amount_paid;
});

const formatCurrency = (value) => {
  return new Intl.NumberFormat("en-US", {
    style: "currency",
    currency: "USD",
  }).format(value);
};

const submitPayment = async () => {
  submitted.value = true;

  if (!payment.value.payment_method_id) {
    return;
  }

  loading.value = true;

  try {
    const response = await axiosInstance.post("/invoice/add-payment", {
      invoice_id: props.invoice.id, // Pass invoice ID in payload
      payment_method_id: payment.value.payment_method_id,
      amount: payment.value.amount,
      payment_date: payment.value.payment_date.toISOString().split("T")[0],
      notes: payment.value.notes,
      is_verified: payment.value.is_verified,
    });
    toast.add({
      severity: "success",
      summary: "Paid",
      detail: "Invoice Payment Added",
      life: 3000,
    });

    emit("submit", response.data.data);
  } catch (error) {
    console.error("Payment error:", error);
    // Handle error (show toast, etc.)
  } finally {
    loading.value = false;
  }
};
payment.value.payment_method_id = 1;
// Initialize with max amount
payment.value.amount = maxAmount.value > 0 ? maxAmount.value : 0;
</script>

<style scoped>
.p-fieldset-content {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
}

.field {
  margin-bottom: 16px;
}

.p-error {
  color: var(--red-500);
  font-size: 0.875rem;
  margin-top: 0.25rem;
  display: block;
}

.text-gray-500 {
  color: var(--gray-500);
  font-size: 0.875rem;
  margin-top: 0.25rem;
  display: block;
}
</style>
