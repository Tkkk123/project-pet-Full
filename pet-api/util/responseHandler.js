// 统一响应处理
const responseHandler = {
    success(res, data = null, message = '操作成功') {
        res.json({
            code: 200,
            message,
            data
        })
    },

    error(res, error, message = '操作失败', code = 500) {
        console.error(message, error)
        res.status(code).json({
            code,
            message,
            error: error.message
        })
    },

    unauthorized(res, message = '未登录或 token 已过期') {
        res.status(401).json({
            code: 401,
            message
        })
    },

    forbidden(res, message = '无权限执行此操作') {
        res.status(403).json({
            code: 403,
            message
        })
    }
}

module.exports = responseHandler 