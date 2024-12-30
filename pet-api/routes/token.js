var express = require("express");
var router = express.Router();
const redisClient = require("../util/redisClient"); // 引入 Redis 客户端
const interface = "verify-token";

router.get(`/${interface}`, async (req, res) => {
    const token = req.cookies.token; // 从 Cookie 中获取 token


    if (!token) {
        return res.status(401).send({ message: "未登录或 token 不存在" });
    }

    try {
        // 从 Redis 中获取 token 数据
        const tokenDataString = await redisClient.get(token);

        if (!tokenDataString) {
            return res.status(401).send({ message: "token 无效或已过期" });
        }

        // 解析 token 数据
        const tokenData = JSON.parse(tokenDataString);


        res.send({
            data: {
                code: 200,
                message: "token 验证通过",
                data: { userId: tokenData.userId, account: tokenData.account },
            }
        });
    } catch (err) {
        console.error("Redis 读取错误：", err);
        res.status(500).send({ message: "服务器内部错误" });
    }
});

module.exports = router;
