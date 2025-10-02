<template>
    <!--
    name: match the sprite id *after* "icon-"
    examples:
      name="cat"            -> href="#icon-cat"
      name="animals-cat"    -> href="#icon-animals-cat"
  -->
    <svg :class="svgClass" aria-hidden="true" focusable="false" role="img" viewBox="0 0 1024 1024">
        <use :xlink:href="`#icon-${normalizedName}`" />
    </svg>
</template>

<script setup>
import { computed } from "vue";

const props = defineProps({
    /** "cat", "animals-cat", etc. */
    name: { type: String, required: true },
    /** Tailwind classes, e.g., "w-6 h-6 fill-amber-800" */
    class: { type: String, default: "" }
});

const normalizedName = computed(() => props.name.replace(/\//g, "-"));
const svgClass = computed(() => props.class || "w-6 h-6");
</script>
