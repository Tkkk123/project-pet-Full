const express = require('express')
const verifyToken = require('../middleware/verifyToken')
const dbPromise = require('../util/dbPromise')
const response = require('../util/responseHandler')

const router = express.Router()



router.get('/reminder/:petId', verifyToken, async (req, res) => {
  try {
    const petId = req.params.petId
    const userId = req.user?.id ?? req.user?.userId

    const petRows = await dbPromise.query(
      'SELECT weight, daily_food_ratio FROM pets WHERE id = ? LIMIT 1',
      [petId]
    )
    const pet = Array.isArray(petRows) && petRows.length ? petRows[0] : {}

    const orderRows = await dbPromise.query(
      `SELECT od.quantity, od.estimated_days, o.created_at
       FROM order_details od
       INNER JOIN orders o ON od.order_id = o.id
       WHERE o.user_id = ?
       ORDER BY o.created_at DESC
       LIMIT 1`,
      [userId]
    )

    if (!Array.isArray(orderRows) || orderRows.length === 0) {
      response.success(res, { needReminder: false, remaining_days: null }, '获取提醒成功')
      return
    }

    const lastOrder = orderRows[0]
    const estFromDb = Number(lastOrder.estimated_days)
    const qty = Number(lastOrder.quantity)
    const daily = Number(pet.daily_food_ratio)

    let estimatedDays = Number.isFinite(estFromDb) && estFromDb >= 0
      ? estFromDb
      : (Number.isFinite(daily) && daily > 0 ? Math.floor(qty / daily) : qty)

    const createdAt = new Date(lastOrder.created_at)
    const elapsedDays = Number.isNaN(createdAt.getTime())
      ? 0
      : Math.floor((Date.now() - createdAt.getTime()) / (1000 * 60 * 60 * 24))

    const remainingDays = Math.max(0, estimatedDays - elapsedDays)
    const needReminder = remainingDays < 3

    response.success(res, { needReminder, remaining_days: remainingDays }, '获取提醒成功')
  } catch (error) {
    response.error(res, error, '获取提醒失败')
  }
})

module.exports = router
