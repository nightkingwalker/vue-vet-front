<template>
  <div>
    <h3 class="font-bold text-sm mb-2">Notes</h3>
    <div class="bg-gray-50 p-4 rounded-lg whitespace-pre-line">
      {{ notes }}
    </div>
  </div>
</template>

<script setup>
defineProps({
  notes: {
    type: String,
    required: true,
  },
});
</script>
