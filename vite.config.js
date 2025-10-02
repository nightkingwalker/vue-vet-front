import { fileURLToPath, URL } from 'node:url'

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from "node:path"; // ✅ add this

import { createSvgIconsPlugin } from "vite-plugin-svg-icons";


// https://vitejs.dev/config/
export default defineConfig({
    plugins: [
        vue(),
        // createSvgIconsPlugin({
        //     iconDirs: [path.resolve(__dirname, 'src/assets/animals')],
        //     symbolId: 'icon-[name]',
        // })

        createSvgIconsPlugin({
            // Put all your SVGs anywhere under this folder (nested ok)
            iconDirs: [path.resolve(process.cwd(), "src/assets/icons")],
            // sprite id format: "icon-[dir]-[name]"
            // e.g. src/assets/icons/animals/cat.svg -> #icon-animals-cat
            symbolId: "icon-[dir]-[name]",
            svgoOptions: {
                plugins: [
                    // allow coloring via CSS (Tailwind fill-*)
                    { name: "removeAttrs", params: { attrs: "(fill|stroke)" } },
                    { name: "removeViewBox", active: false }
                ]
            }
        })

    ],
    server: {
        // https:true,
        // host: '38.242.154.159',
        host: '172.16.3.4',
        // host: '192.168.1.7'
        // host: 'local.ids-tech.net',
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