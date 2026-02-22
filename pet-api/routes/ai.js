require('dotenv').config();
const express = require("express");
const axios = require("axios");

const router = express.Router();
const verifyToken = require("../middleware/verifyToken");

// SSE 流式处理函数
async function streamOpenClawChat(message, userToken, res) {

    console.log('userToken', userToken);

    const gateway = process.env.OpenClaw_Gateway || process.env.OPENCLAW_GATEWAY;
    const openClawToken = process.env.OPENCLAW_GATEWAY_TOKEN || process.env.OpenClaw_Gateway_Token;

    if (!gateway) throw new Error("OpenClaw 网关未配置");
    if (!openClawToken) throw new Error("OpenClaw Token 未配置");

    // 设置 SSE 响应头
    res.setHeader('Content-Type', 'text/event-stream');
    res.setHeader('Cache-Control', 'no-cache');
    res.setHeader('Connection', 'keep-alive');

    try {
        // 将当前商城 token 也传给 OpenClaw
        const payload = {
            model: "openclaw:main",
            messages: [
                {
                    role: "user",
                    content: `${message},我的token是${userToken}`,
                }
            ],
            stream: true,
        };

        const response = await axios.post(
            `${gateway}/v1/chat/completions`,
            payload,
            {
                headers: {
                    Authorization: `Bearer ${openClawToken}`, // 用 OpenClaw 的账户 token 调 OpenClaw 服务
                    "Content-Type": "application/json"
                },
                responseType: 'stream',
                timeout: 0
            }
        );

        response.data.on('data', (chunk) => {
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
        if (!res.headersSent) {
            res.status(500).json({ success: false, message: error.message });
        } else {
            res.end();
        }
    }
}

router.post("/chat", verifyToken, async (req, res) => {
    console.log("进入 /ai/chat 流式接口，用户消息:", req.body.message);

    const userMessage = typeof req.body?.message === "string" ? req.body.message.trim() : "";
    if (!userMessage) {
        return res.status(400).json({ success: false, message: "message 不能为空" });
    }

    // 从 verifyToken 中获取当前用户商城 token


    const userToken = req.headers.authorization?.split(" ")[1];

    await streamOpenClawChat(userMessage, userToken, res);
});

module.exports = router;