<script setup lang="ts">
import { ref } from "vue";
import AIChatFloat from "@/components/AIChat/AIChatFloat.vue";
import AIChatPanel from "@/components/AIChat/AIChatPanel.vue";

const aiChatVisible = ref(false);
</script>

<template>
  <RouterView />
  <AIChatFloat @open="aiChatVisible = true" />
  <AIChatPanel :visible="aiChatVisible" @close="aiChatVisible = false" />
</template>
