<template>
    <div class="mt-4">
        <FloatLabel class="w-full">
            <Textarea v-model="localNotes" rows="4" autoResize fluid
                @update:modelValue="emit('update:modelValue', localNotes)" />
            <label>{{ $t("transfer.notes_section.label") }}</label>
        </FloatLabel>
    </div>
</template>

<script setup>
import { ref, watch } from "vue";
import Textarea from "primevue/textarea";
import FloatLabel from "primevue/floatlabel";

const props = defineProps({
    modelValue: {
        type: String,
        default: ""
    }
});

const emit = defineEmits(["update:modelValue"]);

const localNotes = ref(props.modelValue);

watch(() => props.modelValue, (val) => {
    localNotes.value = val;
});
</script>
