<script setup lang="ts">
import { nextTick, ref, watch } from "vue";
import AIChatFloat from "@/components/AIChat/AIChatFloat.vue";
import AIChatPanel from "@/components/AIChat/AIChatPanel.vue";
import { useUserStore } from "@/stores/userStore";

const userStore = useUserStore();

const aiVisible = ref(false);
const aiRef = ref<{ sendSystemMessage: (message: string) => Promise<void> } | null>(null);

watch(
  () => userStore.userInfo,
  async (next, prev) => {
    if (prev || !next) return;

    // ===== [新增] 登录成功后自动触发 reminderSkill（仅本次会话一次）=====
    if (!sessionStorage.getItem("reminderChecked")) {
      aiVisible.value = true;
      await nextTick();
      await aiRef.value?.sendSystemMessage("查看所有宠物消耗品或服务提醒");
      sessionStorage.setItem("reminderChecked", "true");
    }
  }
);
</script>

<template>
  <RouterView />
  <AIChatFloat @open="aiVisible = true" />
  <AIChatPanel ref="aiRef" :visible="aiVisible" @close="aiVisible = false" />
</template>
