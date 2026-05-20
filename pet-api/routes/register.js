var express = require("express");
var router = express.Router();
const bcrypt = require("bcryptjs");
const dbconfig = require("../util/dbconfig");
const interface = "Register";
const rateLimit = require("express-rate-limit");

const registerLimiter = rateLimit({
  windowMs: 60 * 60 * 1000, // 1小时
  max: 5, // 最多5次注册
  message: { code: 429, message: "注册请求过多，请1小时后再试" },
  standardHeaders: true,
  legacyHeaders: false,
});


router.post("/register", registerLimiter, async function (req, res, next) {
    const { account, password, email, phone } = req.body;

    // 1. 先检查用户是否已存在
    const checkSql = "SELECT * FROM users WHERE username = ? OR email = ?";
    const checkParams = [account, email];

    dbconfig.sqlConnect(checkSql, checkParams, async (checkErr, checkData) => {
        if (checkErr) {
            console.error("查询用户失败:", checkErr);
            return res.status(500).json({
                code: 500,
                message: "服务器错误",
                error: checkErr
            });
        }

        // 如果用户已存在
        if (checkData && checkData.length > 0) {
            return res.status(400).json({
                code: 400,
                message: "用户名或邮箱已存在"
            });
        }

        try {
            // 2. 对密码进行哈希处理
            const hashedPassword = await bcrypt.hash(password, 10);

            // 3. 插入新用户
            const insertSql = `
                INSERT INTO users (username, password, email, phone)
                VALUES (?, ?, ?, ?);
            `;
            const insertParams = [account, hashedPassword, email, phone];

            dbconfig.sqlConnect(insertSql, insertParams, (insertErr, insertData) => {
                if (insertErr) {
                    console.error("注册用户失败:", insertErr);
                    return res.status(500).json({
                        code: 500,
                        message: "注册失败",
                        error: insertErr
                    });
                }

                res.status(200).json({
                    code: 200,
                    message: "注册成功",
                    data: {
                        userId: insertData.insertId,
                        account
                    }
                });
            });
        } catch (hashErr) {
            console.error("密码哈希失败:", hashErr);
            return res.status(500).json({
                code: 500,
                message: "服务器错误"
            });
        }
    });
});

module.exports = router;
