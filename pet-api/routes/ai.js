require('dotenv').config();
const express = require("express");
const axios = require("axios");

const router = express.Router();

// SSE 流式处理函数
async function streamOpenClawChat(message, res) {
    const gateway = process.env.OpenClaw_Gateway || process.env.OPENCLAW_GATEWAY;
    const token = process.env.OPENCLAW_GATEWAY_TOKEN || process.env.OpenClaw_Gateway_Token;

    if (!gateway) throw new Error("OpenClaw 网关未配置");
    if (!token) throw new Error("OpenClaw Token 未配置");

    // 设置 SSE 响应头
    res.setHeader('Content-Type', 'text/event-stream');
    res.setHeader('Cache-Control', 'no-cache');
    res.setHeader('Connection', 'keep-alive');

    try {
        const response = await axios.post(
            `${gateway}/v1/chat/completions`,
            {
                model: "openclaw:main",
                messages: [{ role: "user", content: message }],
                stream: true // 开启流式
            },
            {
                headers: {
                    Authorization: `Bearer ${token}`,
                    "Content-Type": "application/json"
                },
                responseType: 'stream', // 关键：接收流式响应
                timeout: 0 // 关闭 axios 超时，由连接保持
            }
        );

        // 将 OpenClaw 的流通过管道转发给前端
        // 注意：OpenClaw (OpenAI API) 返回的已经是 data: {...} 格式
        // 如果需要严格控制，可以监听 data 事件手动 write

        response.data.on('data', (chunk) => {
            // 直接透传 chunk，保持原始 SSE 格式
            // 如果 chunk 只有 JSON 内容没有 data: 前缀，则需要手动包装：
            // const lines = chunk.toString().split('\n').filter(line => line.trim() !== '');
            // for (const line of lines) { res.write(`data: ${line}\n\n`); }

            // 这里假设 OpenClaw 返回标准 SSE 格式
            res.write(chunk);
        });

        response.data.on('end', () => {
            res.end();
        });

        response.data.on('error', (err) => {
            console.error('Stream error:', err);
            res.write(`data: [ERROR]\n\n`);
            res.end();
        });

    } catch (error) {
        console.error("OpenClaw 流式请求异常:", error);
        // 如果还没发送过数据，可以返回 JSON 错误
        // 如果已经发送过，只能断开连接
        if (!res.headersSent) {
            res.status(500).json({ success: false, message: error.message });
        } else {
            res.end();
        }
    }
}

router.post("/chat", async (req, res) => {
    console.log("进入 /ai/chat 流式接口，用户消息:", req.body.message);

    const userMessage = typeof req.body?.message === "string" ? req.body.message.trim() : "";
    if (!userMessage) {
        return res.status(400).json({ success: false, message: "message 不能为空" });
    }

    await streamOpenClawChat(userMessage, res);
});

module.exports = router;
