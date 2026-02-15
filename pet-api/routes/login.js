var express = require("express");
var router = express.Router();
const dbconfig = require("../util/dbconfig");
const { v4: uuidv4 } = require("uuid");
const redisClient = require("../util/redisClient");

router.post("/Login", async (req, res) => {
    const { account, password } = req.body;

    if (!account || !password) {
        return res.status(400).json({
            code: 400,
            message: "账号或密码不能为空"
        });
    }

    const sql = `SELECT * FROM users WHERE username = ?`;
    const sqlArr = [account];

    const callBack = async (err, data) => {
        if (err) {
            return res.status(500).json({
                code: 500,
                message: "数据库连接失败"
            });
        }

        if (data.length === 0 || data[0].password !== password) {
            return res.status(401).json({
                code: 401,
                message: "账号或密码错误"
            });
        }

        const user = data[0];
        const token = uuidv4();
        const expires = 24 * 60 * 60; // 24小时

        try {
            // 存入 Redis
            await redisClient.set(
                token,
                JSON.stringify({
                    userId: user.id,
                    account: user.username
                }),
                { EX: expires }
            );

            // ✅ 直接返回 token
            return res.json({
                code: 200,
                message: "登录成功",
                data: {
                    token,
                    userId: user.id,
                    account: user.username
                }
            });

        } catch (error) {
            console.error("Redis set error:", error);
            return res.status(500).json({
                code: 500,
                message: "Redis 存储错误"
            });
        }
    };

    dbconfig.sqlConnect(sql, sqlArr, callBack);
});

module.exports = router;
