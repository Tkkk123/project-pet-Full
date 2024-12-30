const redisClient = require("../util/redisClient")

// Token 验证中间件
const verifyToken = async (req, res, next) => {
    const token = req.cookies.token
    if (!token) {
        return res.status(401).json({
            code: 401,
            message: '未登录或 token 已过期'
        })
    }

    try {
        const tokenDataString = await redisClient.get(token)
        if (!tokenDataString) {
            return res.status(401).json({
                code: 401,
                message: 'token 无效或已过期'
            })
        }

        req.user = JSON.parse(tokenDataString)
        next()
    } catch (err) {
        console.error('Redis 读取错误：', err)
        return res.status(500).json({
            code: 500,
            message: '服务器内部错误'
        })
    }
}

module.exports = verifyToken 