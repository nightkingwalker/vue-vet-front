/** @type {import('tailwindcss').Config} */
export default {
    content: ['./index.html',
        './src/**/*.{vue,js,ts,jsx,tsx}',
        // 'node_modules/flowbite-vue/**/*.{js,jsx,ts,tsx,vue}',
        // 'node_modules/flowbite/**/*.{js,jsx,ts,tsx}'
    ],
    darkMode: 'class',
    theme: {
        extend: {
            fontFamily: {
                "sans": ['Ubuntu', 'Readex Pro', 'Cairo', 'sans-serif']
            },
            fontSize: {
                'xs': '0.85rem', // 12px
                'sm': '0.975rem', // 14px
                'base': '1.12rem', // 16px
                'lg': '1.25rem', // 18px
                'xl': '1.5rem', // 20px
                '2xl': '1.5rem', // 24px
                '3xl': '1.875rem', // 30px
                '4xl': '2.25rem', // 36px
                '5xl': '3rem', // 48px
            }
        },
    },
    variants: {
        extend: {
            margin: ['rtl'],
            padding: ['rtl'],
            // Add more as needed
        },
    },
    plugins: [
        // require('flowbite/plugin')
        // require('tailwindcss-primeui')
        function({ addVariant }) {
            addVariant('rtl', '&.rtl'); // Custom RTL variant
        },

    ],
}