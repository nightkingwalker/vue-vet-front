<template>
  <div class="bg-gray-50 p-4 rounded-lg">
    <h3 class="font-bold text-sm mb-2 border-b pb-1">Bill To</h3>
    <div class="space-y-1">
      <div class="text-sm font-medium">{{ client.name }}</div>
      <div>{{ client.address }}</div>
      <div>Phone: *** *** ****</div>
      <!-- <div>Phone: {{ client.phone }}</div> -->
      <div>Email: {{ client.email }}</div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  client: {
    type: Object,
    required: true,
  },
});
</script>
