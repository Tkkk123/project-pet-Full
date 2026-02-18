<template>
  <button class="ai-float" type="button" @click="emit('open')">
    <el-icon class="ai-float__icon" :size="20">
      <ChatDotRound />
    </el-icon>
  </button>
</template>

<script setup lang="ts">
import { ChatDotRound } from "@element-plus/icons-vue";

const emit = defineEmits<{
  (e: "open"): void;
}>();
</script>

<style scoped lang="less">
.ai-float {
  position: fixed;
  right: 24px;
  bottom: 24px;
  width: 52px;
  height: 52px;
  border-radius: 50%;
  border: none;
  background: var(--el-color-primary);
  color: #fff;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
  transition: transform 0.16s ease, box-shadow 0.16s ease;
  z-index: 3000;
  user-select: none;
}

.ai-float:hover {
  transform: scale(1.04);
  box-shadow: 0 10px 22px rgba(0, 0, 0, 0.14);
}

.ai-float:active {
  transform: scale(0.98);
}

.ai-float__icon {
  color: #fff;
}
</style>
