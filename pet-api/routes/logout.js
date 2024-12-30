var express = require("express");
const redisClient = require("../util/redisClient");
var router = express.Router();
const interface = "logout";

router.post(`/${interface}`, async (req, res) => {
    const token = req.cookies.token;

    if (!token) {
        return res.status(400).send({ message: "未登录" });
    }

    try {
        // 删除 Redis 中的 token
        const response = await redisClient.del(token);

        if (response === 0) {
            // token 不存在
            return res.status(404).send({ message: "Token 不存在或已过期" });
        }

        // 清除 Cookie
        res.clearCookie("token");

        res.send({ code: 200, message: "退出登录成功" });
    } catch (err) {
        console.error("Redis 删除失败：", err);
        return res.status(500).send({ message: "退出登录失败" });
    }
});


module.exports = router;
