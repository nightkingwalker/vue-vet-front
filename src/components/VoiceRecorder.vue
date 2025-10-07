<template>
    <div class="flex flex-col items-center justify-center gap-4 p-6 text-center">
        <small class="text-gray-900 dark:text-gray-200">{{ t('voice_recorder.introduction') }}</small>
        <!-- Mic Button -->
        <div class="relative">
            <div v-if="isRecording"
                class="absolute inset-0 animate-ping bg-red-400/30 rounded-full pointer-events-none"></div>

            <div class="rounded-full w-20 h-20 flex items-center justify-center cursor-pointer transition-all duration-300 shadow-md"
                :class="isRecording
                    ? 'bg-red-500 hover:bg-red-600 animate-pulse ring-4 ring-red-300/40'
                    : 'bg-emerald-500 hover:bg-emerald-600 hover:scale-105'
                    " @click="toggleRecording">
                <i :class="isRecording ? 'pi pi-stop text-white text-3xl' : 'pi pi-microphone text-white text-3xl'"></i>
            </div>
        </div>

        <!-- Status -->
        <div class="text-sm text-gray-600 dark:text-gray-300">
            <template v-if="isRecording">
                <i class="pi pi-wave-pulse text-red-400"></i>
                <span class="ml-2">{{ t('voice_recorder.listening') }}</span>
            </template>
            <template v-else-if="audioUrl">
                <span class="text-emerald-500 font-medium">{{ t('voice_recorder.recording_complete') }}</span>
            </template>
            <template v-else>
                <span class="text-gray-400">{{ t('voice_recorder.press_to_start') }}</span>
            </template>
        </div>

        <!-- Playback -->
        <div v-if="audioUrl" class="flex flex-col items-center gap-3 mt-2">
            <audio :src="audioUrl" controls class="w-64 rounded-lg shadow-inner"></audio>
            <div class="flex gap-3">
                <Button icon="fas fa-check" :label="t('voice_recorder.upload')" severity="info"
                    @click="$emit('recorded', audioBlob)" />
                <Button icon="pi pi-trash" :label="t('voice_recorder.discard')" severity="danger"
                    @click="resetRecording" />
            </div>
        </div>

        <!-- Error -->
        <p v-if="errorMessage" class="text-red-600 text-sm mt-3">
            <i class="pi pi-exclamation-triangle mr-1"></i>
            {{ t('voice_recorder.mic_error') }}
        </p>
    </div>
</template>

<script setup>
import { ref } from "vue";
import { useI18n } from "vue-i18n";
import Button from "primevue/button";

const { t } = useI18n();
const emit = defineEmits(["recorded"]);

const isRecording = ref(false);
const mediaRecorder = ref(null);
const audioChunks = ref([]);
const audioBlob = ref(null);
const audioUrl = ref(null);
const errorMessage = ref(null);
let audioStream = null;

/**
 * Start or stop recording
 */
const toggleRecording = async () => {
    try {
        if (!isRecording.value) {
            if (audioStream) {
                audioStream.getTracks().forEach((t) => t.stop());
                audioStream = null;
            }

            audioStream = await navigator.mediaDevices.getUserMedia({ audio: true });
            mediaRecorder.value = new MediaRecorder(audioStream);
            audioChunks.value = [];

            mediaRecorder.value.ondataavailable = (e) => {
                if (e.data.size > 0) audioChunks.value.push(e.data);
            };

            mediaRecorder.value.onstop = () => {
                audioBlob.value = new Blob(audioChunks.value, { type: "audio/wav" });
                audioUrl.value = URL.createObjectURL(audioBlob.value);
                if (audioStream) {
                    audioStream.getTracks().forEach((t) => t.stop());
                    audioStream = null;
                }
            };

            mediaRecorder.value.start();
            isRecording.value = true;
            errorMessage.value = null;
        } else {
            if (mediaRecorder.value && mediaRecorder.value.state === "recording") {
                mediaRecorder.value.stop();
            }
            isRecording.value = false;
        }
    } catch (err) {
        console.error("Microphone error:", err);
        errorMessage.value = true;
        isRecording.value = false;
    }
};

/**
 * Reset the recording
 */
const resetRecording = () => {
    audioBlob.value = null;
    audioUrl.value = null;
};
</script>

<style scoped>
@keyframes glowPulse {

    0%,
    100% {
        box-shadow: 0 0 0px rgba(239, 68, 68, 0.2);
    }

    50% {
        box-shadow: 0 0 20px rgba(239, 68, 68, 0.6);
    }
}
</style>
