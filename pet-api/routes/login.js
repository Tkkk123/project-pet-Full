var express = require("express");
var router = express.Router();
const dbconfig = require("../util/dbconfig");
const { v4: uuidv4 } = require("uuid");
const redisClient = require("../util/redisClient"); // 引入 Redis 客户端

router.post("/Login", async (req, res) => {
    const { account, password } = req.body;

    if (!account || !password) {
        return res.status(400).send({ message: "账号或密码不能为空" });
    }

    const sql = `SELECT * FROM users WHERE username = ?`;
    const sqlArr = [account];

    const callBack = async (err, data) => {
        if (err) {
            return res.status(500).send({ message: "数据库连接失败" });
        }

        if (data.length === 0 || data[0].password !== password) {
            return res.status(401).send({ message: "账号或密码错误" });
        }

        const user = data[0];
        const token = uuidv4(); // 生成一个新的 token
        const expires = 24 * 60 * 60; // Redis 的过期时间单位是秒，24 小时

        try {
            // 使用 set 方法存储 token 和用户信息到 Redis 中，设置过期时间
            await redisClient.set(token, JSON.stringify({ userId: user.id, account: user.username }), {
                EX: expires, // 设置过期时间
            });

            // 设置 httpOnly Cookie，确保 token 安全存储
            res.cookie("token", token, {
                httpOnly: true,    // 防止客户端 JavaScript 访问
                secure: true,      // 仅通过 HTTPS 协议传输，确保更安全（适用于生产环境）
                maxAge: 24 * 60 * 60 * 1000, // 设置过期时间为 24 小时
                sameSite: "Strict", // 防止 CSRF 攻击
            });

            // 返回登录成功的响应，不返回 token
            res.send({
                data: {
                    code: 200,
                    message: "登录成功",
                    data: {
                        userId: user.id,
                        account: user.username,
                    },
                }

            });
        } catch (error) {
            console.error("Redis set error:", error);
            return res.status(500).send({ message: "Redis 存储错误" });
        }
    };

    // 执行 SQL 查询
    dbconfig.sqlConnect(sql, sqlArr, callBack);
});

module.exports = router;
