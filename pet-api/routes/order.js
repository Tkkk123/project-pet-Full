const express = require('express')
const router = express.Router()
const dbconfig = require('../util/dbconfig')
const verifyToken = require('../middleware/verifyToken')

// SQL 查询语句
// 结算页预检（历史前端占位接口，返回空结构避免 404）
router.get('/member/orders/pre', verifyToken, async (req, res) => {
    res.json({
        code: 200,
        message: 'ok',
        data: { userAddresses: [] }
    })
})

const orderQueries = {
    createOrder: `
        INSERT INTO orders (user_id, status, total_price) 
        VALUES (?, ?, ?)
    `,
    createOrderDetail: `
        INSERT INTO order_details 
        (order_id, product_id, quantity, price, color, size, gender, product_name, product_picture) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    `,
    getOrders: (type) => `
        SELECT 
            od.order_id as id,
            o.user_id,
            o.status,
            o.total_price as payMoney,
            DATE_FORMAT(o.created_at, '%Y-%m-%d %H:%i:%s') as createTime,
            JSON_ARRAYAGG(
                JSON_OBJECT(
                    'id', od.product_id,
                    'name', od.product_name,
                    'image', od.product_picture,
                    'price', od.price,
                    'quantity', od.quantity,
                    'attrsText', CONCAT(od.gender, ' ', od.color, ' ', od.size)
                )
            ) as skus
        FROM order_details od
        INNER JOIN orders o ON od.order_id = o.id
        WHERE o.user_id = ?
        ${type !== 'all' ? 'AND o.status = ?' : ''}
        GROUP BY od.order_id, o.user_id, o.status, o.total_price, o.created_at 
        ORDER BY o.created_at DESC
    `
}

// 创建订单
router.post('/member/orders', verifyToken, async (req, res) => {
    const userId = req.user.userId
    const { products, totalPrice } = req.body

    try {
        const conn = await dbconfig.getConnection()

        try {
            await new Promise((resolve, reject) => {
                conn.beginTransaction((err) => (err ? reject(err) : resolve()))
            })

            const orderResult = await new Promise((resolve, reject) => {
                conn.query(
                    orderQueries.createOrder,
                    [userId, 'pending', totalPrice],
                    (err, result) => (err ? reject(err) : resolve(result))
                )
            })

            const orderId = orderResult.insertId

            for (const product of products) {
                await new Promise((resolve, reject) => {
                    conn.query(
                        orderQueries.createOrderDetail,
                        [
                            orderId,
                            product.id,
                            product.count,
                            product.price,
                            product.color,
                            product.size,
                            product.gender,
                            product.name,
                            product.picture
                        ],
                        (err) => (err ? reject(err) : resolve())
                    )
                })
            }

            await new Promise((resolve, reject) => {
                conn.commit((err) => (err ? reject(err) : resolve()))
            })

            res.json({
                code: 200,
                message: '订单创建成功',
                data: { orderId }
            })
        } catch (error) {
            await new Promise((resolve) => conn.rollback(() => resolve()))
            console.error('创建订单失败:', error)
            res.status(500).json({
                code: 500,
                message: '创建订单失败',
                error: error.message
            })
        } finally {
            conn.release()
        }

    } catch (error) {
        console.error('创建订单失败:', error)
        res.status(500).json({
            code: 500,
            message: '创建订单失败',
            error: error.message
        })
    }
})

// 获取订单列表
router.get('/member/orders', verifyToken, async (req, res) => {
    const userId = req.user.userId
    const { type = 'all' } = req.query

    try {
        const params = type === 'all' ? [userId] : [userId, type]
        const orders = await new Promise((resolve, reject) => {
            dbconfig.sqlConnect(orderQueries.getOrders(type), params,
                (err, result) => err ? reject(err) : resolve(result || [])
            )
        })

        const formattedOrders = orders.map(order => {
            try {
                let skusArray = []
                if (order.skus) {
                    skusArray = Array.isArray(order.skus) ? order.skus : JSON.parse(order.skus)
                }

                return {
                    id: order.id,
                    userId: order.user_id,
                    status: order.status,
                    payMoney: Number(order.payMoney),
                    createTime: order.createTime,
                    orderState: {
                        'pending': '待付款',
                        'completed': '已完成',
                        'cancelled': '已取消'
                    }[order.status] || order.status,
                    skus: skusArray
                }
            } catch (error) {
                console.error('处理订单数据失败:', error)
                return null
            }
        }).filter(Boolean)

        res.json({
            code: 200,
            message: '获取订单列表成功',
            data: formattedOrders
        })

    } catch (error) {
        console.error('获取订单列表失败:', error)
        res.status(500).json({
            code: 500,
            message: '获取订单列表失败',
            error: error.message
        })
    }
})

// 更新订单状态
router.put('/member/orders/:orderId/status', verifyToken, async (req, res) => {
    const { orderId } = req.params
    const { status } = req.body
    const userId = req.user.userId

    try {
        // 验证订单所属
        const order = await new Promise((resolve, reject) => {
            dbconfig.sqlConnect('SELECT * FROM orders WHERE id = ? AND user_id = ?',
                [orderId, userId],
                (err, result) => err ? reject(err) : resolve(result[0])
            )
        })

        if (!order) {
            return res.status(403).json({
                code: 403,
                message: '无权操作此订单'
            })
        }

        // 更新订单状态
        await new Promise((resolve, reject) => {
            dbconfig.sqlConnect('UPDATE orders SET status = ? WHERE id = ?',
                [status, orderId],
                (err) => err ? reject(err) : resolve()
            )
        })

        res.json({
            code: 200,
            message: '订单状态更新成功'
        })

    } catch (error) {
        console.error('更新订单状态失败:', error)
        res.status(500).json({
            code: 500,
            message: '更新订单状态失败',
            error: error.message
        })
    }
})

module.exports = router 
