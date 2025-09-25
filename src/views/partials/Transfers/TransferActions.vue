<template>
    <div class="mt-4 flex flex-col gap-2">
        <Button :label="$t('transfer.actions_section.save_draft')" icon="pi pi-save" class="w-full p-button-outlined"
            :loading="loading" @click="$emit('saveDraft')" />

        <Button :label="$t('transfer.actions_section.create_transfer')" icon="pi pi-check" class="w-full"
            :loading="loading" @click="$emit('createTransfer')" />
    </div>
</template>

<script setup>
import Button from "primevue/button";

const props = defineProps({
    loading: {
        type: Boolean,
        default: false,
    },
});

const emit = defineEmits(["saveDraft", "createTransfer"]);
</script>
