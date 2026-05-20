<template>
    <Transition name="ai-chat-fade">
        <div v-if="visible" class="ai-chat">
            <div class="ai-chat__header">
                <div class="ai-chat__title">AI 助手</div>
                <el-button class="ai-chat__close" type="primary" link @click="emit('close')">
                    <el-icon :size="18">
                        <Close />
                    </el-icon>
                </el-button>
            </div>

            <div ref="messagesRef" class="ai-chat__messages">
                <div v-for="msg in messages" :key="msg.id" class="ai-msg"
                    :class="msg.role === 'user' ? 'ai-msg--user' : 'ai-msg--assistant'">
                    <div class="ai-msg__bubble">
                        <template v-if="msg.loading && !msg.content">
                            <span class="ai-msg__loading">正在思考…</span>
                        </template>
                        <template v-else>
                            {{ msg.content }}
                        </template>
                    </div>
                </div>
            </div>

            <div class="ai-chat__footer">
                <el-input v-model="input" class="ai-chat__input" type="textarea" :autosize="{ minRows: 1, maxRows: 3 }"
                    placeholder="请输入问题，回车发送" :disabled="sending" @keydown="onKeydown" />
                <el-button type="primary" :disabled="sending || !canSend" @click="send">
                    发送
                </el-button>
            </div>
        </div>
    </Transition>
</template>

<script setup lang="ts">
import { computed, nextTick, ref, watch } from "vue";
import { ElMessage } from "element-plus";
import { Close } from "@element-plus/icons-vue";
import { streamChatWithAI } from "@/apis/ai";

interface ChatMessage {
    id: string;
    role: "user" | "assistant";
    content: string;
    loading?: boolean;
}

const props = defineProps<{
    visible: boolean;
}>();

const emit = defineEmits<{
    (e: "close"): void;
}>();

const messages = ref<ChatMessage[]>([]);
const input = ref("");
const sending = ref(false);
const messagesRef = ref<HTMLElement | null>(null);

const canSend = computed(() => input.value.trim().length > 0);

function createId() {
    const g = globalThis as unknown as { crypto?: { randomUUID?: () => string } };
    if (g.crypto?.randomUUID) return g.crypto.randomUUID();
    return `${Date.now()}-${Math.random().toString(16).slice(2)}`;
}

function scrollToBottom() {
    const el = messagesRef.value;
    if (!el) return;
    el.scrollTop = el.scrollHeight;
}

async function safeScroll() {
    await nextTick();
    scrollToBottom();
}

function showError(message: string) {
    ElMessage.error(message);
}

function appendUserMessage(content: string) {
    const msg: ChatMessage = { id: createId(), role: "user", content };
    messages.value.push(msg);
    return msg;
}

function appendAssistantLoadingMessage() {
    const msg: ChatMessage = {
        id: createId(),
        role: "assistant",
        content: "",
        loading: true
    };

    messages.value.push(msg);

    return messages.value[messages.value.length - 1];
}

// ===== [新增] 系统消息发送：不展示用户气泡、不污染输入框 =====
async function sendSystemMessage(message: string) {
    if (sending.value) return;

    const systemText = message.trim();
    if (!systemText) return;

    const assistantMsg = appendAssistantLoadingMessage();
    await safeScroll();

    sending.value = true;

    streamChatWithAI(
        systemText,
        async (chunk) => {
            console.log('chunk', chunk);

            assistantMsg.content += chunk;
            await nextTick();
            scrollToBottom();
        },
        () => {
            assistantMsg.loading = false;
            sending.value = false;
            safeScroll();
        },
        (err) => {
            console.error("前端捕获错误:", err);
            assistantMsg.loading = false;
            sending.value = false;
            if (!assistantMsg.content) {
                assistantMsg.content = "请求失败，请稍后重试";
            } else {
                assistantMsg.content += "\n[请求中断]";
            }
            showError(err?.message || "AI 请求失败");
            safeScroll();
        }
    );
}

// ===== [新增] 暴露方法给父组件调用 =====
defineExpose({
    sendSystemMessage
});

async function send() {
    if (sending.value || !canSend.value) return;

    const userText = input.value.trim();
    input.value = "";

    appendUserMessage(userText);
    const assistantMsg = appendAssistantLoadingMessage();
    await safeScroll();

    sending.value = true;

    // 使用流式调用
    streamChatWithAI(
        userText,
        (chunk) => {
            // 收到数据块
            // 如果是第一次收到，清空可能存在的占位符（如果有的话），但这里初始化是 ""
            assistantMsg.content += chunk;
            // 实时滚动
            scrollToBottom();
        },
        () => {
            // 完成
            assistantMsg.loading = false;
            sending.value = false;
            safeScroll();
        },
        (err) => {
            // 错误
            console.error("前端捕获错误:", err);
            assistantMsg.loading = false;
            sending.value = false;
            if (!assistantMsg.content) {
                assistantMsg.content = "请求失败，请稍后重试";
            } else {
                assistantMsg.content += "\n[请求中断]";
            }
            showError(err?.message || "AI 请求失败");
            safeScroll();
        }
    );
}

function onKeydown(e: KeyboardEvent) {
    if (e.key !== "Enter") return;
    if (e.shiftKey) return;
    e.preventDefault();
    send();
}

watch(
    () => props.visible,
    async (v) => {
        if (!v) return;
        await safeScroll();
    }
);

watch(
    () => messages.value.length,
    async () => {
        await safeScroll();
    }
);
</script>

<style scoped lang="less">
.ai-chat-fade-enter-active,
.ai-chat-fade-leave-active {
    transition: opacity 0.18s ease, transform 0.18s ease;
}

.ai-chat-fade-enter-from,
.ai-chat-fade-leave-to {
    opacity: 0;
    transform: translateY(8px);
}

.ai-chat {
    position: fixed;
    right: 24px;
    bottom: 88px;
    width: 360px;
    height: 500px;
    background: #fff;
    border-radius: 12px;
    border: 1px solid var(--el-border-color-light);
    box-shadow: 0 12px 26px rgba(0, 0, 0, 0.12);
    display: flex;
    flex-direction: column;
    overflow: hidden;
    z-index: 3001;
}

.ai-chat__header {
    height: 48px;
    padding: 0 12px 0 14px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    border-bottom: 1px solid var(--el-border-color-light);
    background: #fff;
}

.ai-chat__title {
    font-size: 14px;
    font-weight: 600;
    color: var(--el-text-color-primary);
}

.ai-chat__close {
    padding: 6px;
}

.ai-chat__messages {
    flex: 1;
    padding: 12px;
    overflow-y: auto;
}

.ai-msg {
    display: flex;
    margin-bottom: 10px;
}

.ai-msg--user {
    justify-content: flex-end;
}

.ai-msg--assistant {
    justify-content: flex-start;
}

.ai-msg__bubble {
    max-width: 70%;
    padding: 10px 12px;
    border-radius: 10px;
    line-height: 1.5;
    white-space: pre-wrap;
    word-break: break-word;
    font-size: 13px;
}

.ai-msg--user .ai-msg__bubble {
    background: var(--el-color-primary);
    color: #fff;
}

.ai-msg--assistant .ai-msg__bubble {
    background: #f4f4f5;
    color: var(--el-text-color-primary);
}

.ai-msg__loading {
    opacity: 0.8;
}

.ai-chat__footer {
    padding: 10px 12px 12px;
    border-top: 1px solid var(--el-border-color-light);
    display: flex;
    gap: 10px;
    align-items: flex-end;
}

.ai-chat__input {
    flex: 1;
}
</style>
