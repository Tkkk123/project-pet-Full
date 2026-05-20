const express = require('express')
const router = express.Router()
const dbconfig = require('../util/dbconfig')
const response = require('../util/responseHandler')
const verifyToken = require('../middleware/verifyToken')

/**
 * 密码重置路由
 * 需要验证用户登录状态和原密码
 * POST /user/reset-password
 * @param {string} oldPassword - 原密码
 * @param {string} newPassword - 新密码
 */
router.post('/user/reset-password', verifyToken, async (req, res) => {
    const { oldPassword, newPassword } = req.body
    const userId = req.user.userId

    try {
        // 验证原密码是否正确
        const user = await new Promise((resolve, reject) => {
            dbconfig.sqlConnect(
                'SELECT * FROM users WHERE id = ? AND password = ?',
                [userId, oldPassword],
                (err, result) => {
                    if (err) reject(err)
                    else resolve(result)
                }
            )
        })

        // 如果原密码验证失败
        if (!user.length) {
            return response.error(res, null, '原密码错误', 400)
        }

        // 更新用户密码
        await new Promise((resolve, reject) => {
            dbconfig.sqlConnect(
                'UPDATE users SET password = ? WHERE id = ?',
                [newPassword, userId],
                (err, result) => {
                    if (err) reject(err)
                    else resolve(result)
                }
            )
        })

        // 返回成功响应
        response.success(res, null, '密码修改成功')
    } catch (error) {
        console.error('修改密码失败:', error)
        response.error(res, error, '修改密码失败')
    }
})

module.exports = router 