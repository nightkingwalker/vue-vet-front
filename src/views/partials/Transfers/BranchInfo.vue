<template>
    <div class="bg-white dark:bg-[var(--p-surface-800)] p-4 rounded-lg shadow">
        <h2 class="xl:!text-[12px] !text-sm font-semibold mb-4 border-b pb-2">
            {{ $t("transfer.branch_section.title") }}
        </h2>

        <!-- Source Branch -->
        <div class="mb-4">
            <FloatLabel variant="on" class="lg:!text-xs w-full">
                <Select v-model="localSourceBranch" :options="branches" optionLabel="name" optionValue="id" fluid
                    :disabled="loading" @update:modelValue="(val) => emit('update:sourceBranch', val)" />
                <label>{{ $t("transfer.branch_section.source_branch") }}</label>
            </FloatLabel>
        </div>

        <!-- Destination Branch -->
        <div class="mb-4">
            <FloatLabel variant="on" class="lg:!text-xs w-full">
                <Select v-model="localDestinationBranch" :options="filteredDestinationBranches" optionLabel="name"
                    optionValue="id" fluid :disabled="loading"
                    @update:modelValue="(val) => emit('update:destinationBranch', val)" />
                <label>{{ $t("transfer.branch_section.destination_branch") }}</label>
            </FloatLabel>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted, computed, watch } from "vue";
import { useToast } from "primevue/usetoast";
import axiosInstance from "@/axios";

// PrimeVue
import Select from "primevue/select";
import FloatLabel from "primevue/floatlabel";

const props = defineProps({
    sourceBranch: [String, Number, null],
    destinationBranch: [String, Number, null],
});

const emit = defineEmits(["update:sourceBranch", "update:destinationBranch"]);

const toast = useToast();

const localSourceBranch = ref(props.sourceBranch);
const localDestinationBranch = ref(props.destinationBranch);

const branches = ref([]);
const loading = ref(false);

// ✅ Filter destination options so source branch is excluded
const filteredDestinationBranches = computed(() => {
    if (!localSourceBranch.value) return branches.value;
    return branches.value.filter((b) => b.id !== localSourceBranch.value);
});

onMounted(async () => {
    loading.value = true;
    try {
        const { data } = await axiosInstance.get("/branches");
        branches.value = data.data || data;
    } catch (error) {
        console.error("Error fetching branches:", error);
        toast.add({
            severity: "error",
            summary: t("common.error"),
            detail: "Failed to load branches",
            life: 4000,
        });
    } finally {
        loading.value = false;
    }
});

// Keep props in sync with local state
watch(() => props.sourceBranch, (val) => (localSourceBranch.value = val));
watch(() => props.destinationBranch, (val) => (localDestinationBranch.value = val));
</script>
