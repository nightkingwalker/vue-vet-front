// store/notificationStore.js
import { defineStore } from 'pinia';

export const useNotificationStore = defineStore('notification', {
    state: () => ({
        soundUrl: 'http://soundbible.com/mp3/analog-watch-alarm_daniel-simion.mp3'
    }),
    actions: {
        playSound() {
            const audio = new Audio(this.soundUrl);
            audio.play().catch(error => console.error('Error playing the sound:', error));
        }
    }
});