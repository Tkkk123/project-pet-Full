var express = require("express");
var router = express.Router();
const redisClient = require("../util/redisClient"); // 引入 Redis 客户端
const interface = "verify-token";
const response = require("../util/responseHandler");

router.get(`/${interface}`, async (req, res) => {
    const authHeader = req.headers.authorization;
    const token = typeof authHeader === "string" && authHeader.startsWith("Bearer ")
        ? authHeader.slice("Bearer ".length).trim()
        : "";

    if (!token) return response.unauthorized(res, "未登录或未提供 token");

    try {
        const tokenDataString = await redisClient.get(token);

        if (!tokenDataString) {
            return response.unauthorized(res, "token 无效或已过期");
        }

        const tokenData = JSON.parse(tokenDataString);

        response.success(res, { userId: tokenData.userId, account: tokenData.account }, "token 验证通过");
    } catch (err) {
        response.error(res, err, "服务器内部错误");
    }
});

module.exports = router;
