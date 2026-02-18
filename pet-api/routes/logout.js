var express = require("express");
const redisClient = require("../util/redisClient");
var router = express.Router();
const interface = "logout";
const response = require("../util/responseHandler");

router.post(`/${interface}`, async (req, res) => {
    const authHeader = req.headers.authorization;
    const token = typeof authHeader === "string" && authHeader.startsWith("Bearer ")
        ? authHeader.slice("Bearer ".length).trim()
        : "";

    if (!token) return response.unauthorized(res, "未登录或未提供 token");

    try {
        const delCount = await redisClient.del(token);

        if (delCount === 0) {
            return response.error(res, new Error("Token 不存在或已过期"), "Token 不存在或已过期", 404);
        }

        response.success(res, null, "退出登录成功");
    } catch (err) {
        response.error(res, err, "退出登录失败");
    }
});


module.exports = router;
