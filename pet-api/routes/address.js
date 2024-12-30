const express = require('express')
const router = express.Router()
const dbconfig = require('../util/dbconfig')
const redisClient = require("../util/redisClient") // 引入 Redis 客户端
const verifyToken = require('../middleware/verifyToken')

// 地址查询 SQL
const addressQueries = {
    getList: `
        SELECT 
            id,
            user_id,
            receiver,
            contact,
            address_line as address,
            is_default as isDefault
        FROM user_addresses
        WHERE user_id = ?
        ORDER BY is_default DESC, id ASC
    `,
    updateDefault: `
        UPDATE user_addresses 
        SET is_default = 0 
        WHERE user_id = ?
    `,
    insert: `
        INSERT INTO user_addresses 
        (user_id, receiver, contact, address_line, is_default) 
        VALUES (?, ?, ?, ?, ?)
    `
}

// 获取用户地址列表
router.get('/user/address', verifyToken, function (req, res) {
    const userId = req.user.userId

    dbconfig.sqlConnect(addressQueries.getList, [userId], (err, data) => {
        if (err) {
            console.error('获取地址列表失败:', err)
            return res.status(500).json({
                code: 500,
                message: '获取地址列表失败',
                error: err
            })
        }

        // 格式化返回数据
        const formattedData = data.map(item => ({
            id: item.id,
            userId: item.user_id,
            receiver: item.receiver,
            contact: item.contact,
            address: item.address,
            isDefault: item.isDefault
        }))

        res.status(200).json({
            code: 200,
            message: '获取地址列表成功',
            data: formattedData
        })
    })
})

// 添加新地址
router.post('/user/address', verifyToken, async function (req, res) {
    const userId = req.user.userId
    const { receiver, contact, address, isDefault = 0 } = req.body

    try {
        // 如果设置为默认地址，先更新其他地址
        if (isDefault === 1) {
            await new Promise((resolve, reject) => {
                dbconfig.sqlConnect(addressQueries.updateDefault, [userId], (err) => {
                    if (err) reject(err)
                    else resolve()
                })
            })
        }

        // 插入新地址
        const result = await new Promise((resolve, reject) => {
            dbconfig.sqlConnect(addressQueries.insert,
                [userId, receiver, contact, address, isDefault],
                (err, result) => {
                    if (err) reject(err)
                    else resolve(result)
                }
            )
        })

        res.status(200).json({
            code: 200,
            message: '添加地址成功',
            data: {
                id: result.insertId,
                userId,
                receiver,
                contact,
                address,
                isDefault
            }
        })
    } catch (error) {
        console.error('添加地址失败:', error)
        res.status(500).json({
            code: 500,
            message: '添加地址失败',
            error
        })
    }
})

module.exports = router 