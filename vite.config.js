import { fileURLToPath, URL } from 'node:url'

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vitejs.dev/config/
export default defineConfig({
    plugins: [
        vue(),
    ],
    server: {
        // https:true,
        // host: '38.242.154.159',
        // port: 3000,
    },
    resolve: {
        alias: {
            '@': fileURLToPath(new URL('./src',
                import.meta.url))
        }
    }
})