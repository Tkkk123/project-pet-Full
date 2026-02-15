const redisClient = require("../util/redisClient");

// Token 验证中间件（改为读取 Authorization）
const verifyToken = async (req, res, next) => {
    try {
        // 1️⃣ 从请求头读取 Authorization
        const authHeader = req.headers.authorization;

        if (!authHeader || !authHeader.startsWith("Bearer ")) {
            return res.status(401).json({
                code: 401,
                message: "未登录或未提供 token"
            });
        }

        // 2️⃣ 提取 token
        const token = authHeader.split(" ")[1];

        if (!token) {
            return res.status(401).json({
                code: 401,
                message: "token 格式错误"
            });
        }

        // 3️⃣ 去 Redis 校验
        const tokenDataString = await redisClient.get(token);

        if (!tokenDataString) {
            return res.status(401).json({
                code: 401,
                message: "token 无效或已过期"
            });
        }

        // 4️⃣ 解析用户信息
        const userData = JSON.parse(tokenDataString);

        req.user = userData;   // { userId, account }
        req.userId = userData.userId;

        next();
    } catch (err) {
        console.error("verifyToken error:", err);
        return res.status(500).json({
            code: 500,
            message: "服务器内部错误"
        });
    }
};

module.exports = verifyToken;
