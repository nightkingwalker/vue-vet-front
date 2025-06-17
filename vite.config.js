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
        // host: '172.16.3.8'
        // host: '192.168.1.7'
        host: 'local.ids-tech.net',
        // port: 3000,
        headers: {
            'Cache-Control': 'no-store, max-age=0', // Disable caching in dev
        },
    },
    resolve: {
        alias: {
            '@': fileURLToPath(new URL('./src',
                import.meta.url))
        }
    },
    build: {
        cssCodeSplit: true,
        // Ensure hashed filenames in production (Cloudflare)
        rollupOptions: {
            output: {
                assetFileNames: 'assets/[name]-[hash][extname]',
                chunkFileNames: 'assets/[name]-[hash].js',
                entryFileNames: 'assets/[name]-[hash].js',
            },
        },
    },
})