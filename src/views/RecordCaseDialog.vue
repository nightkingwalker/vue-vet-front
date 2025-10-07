<template>
    <div class="flex flex-col gap-4 p-4">
        <!-- <h3 class="text-lg font-semibold mb-2">{{ t('record_case.title') }}</h3> -->

        <VoiceRecorder @recorded="handleRecordedFile" />

        <div class="flex justify-end gap-2 mt-4">
            <!-- <Button :label="t('record_case.cancel')" @click="$emit('close-dialog')" severity="danger" /> -->
            <Button class="!bg-red-500 hover:!bg-red-600 hover:scale-105 !border-0 !outline-none"
                @click="$emit('close-dialog')">
                {{ t('record_case.cancel') }}
                <i class="pi pi-times ml-2"></i>
            </Button>
            <!-- <Button :label="t('record_case.upload_process')" severity="success" icon="pi pi-upload" -->
            <!-- :disabled="!audioFile" @click="uploadRecording" /> -->
            <Button class="!bg-emerald-500 hover:!bg-emerald-600 hover:scale-105 !border-0 !outline-none"
                :disabled="!audioFile" @click="uploadRecording">
                {{ t('record_case.upload_process') }}
                <i class="pi pi-upload ml-2"></i>
            </Button>
        </div>
    </div>
</template>

<script setup>
import { ref } from "vue";
import { useI18n } from "vue-i18n";
import Button from "primevue/button";
import VoiceRecorder from "@/components/VoiceRecorder.vue";
import axiosInstance from "@/axios";

const { t } = useI18n();

const props = defineProps({
    pet_id: Number,
    owner_id: Number,
    branch_id: Number,
});

const emit = defineEmits(["close-dialog", "recordingUploaded"]);

const audioFile = ref(null);

function handleRecordedFile(file) {
    audioFile.value = file;
}

async function uploadRecording() {
    if (!audioFile.value) return;

    const formData = new FormData();
    formData.append("file", audioFile.value);
    formData.append("pet_id", props.pet_id);
    formData.append("owner_id", props.owner_id);
    formData.append("branch_id", props.branch_id);

    try {
        const res = await axiosInstance.post("/api/audio/upload", formData, {
            headers: { "Content-Type": "multipart/form-data" },
        });

        emit("recordingUploaded", res.data);
        emit("close-dialog");
    } catch (err) {
        console.error("Upload failed:", err);
    }
}
</script>
