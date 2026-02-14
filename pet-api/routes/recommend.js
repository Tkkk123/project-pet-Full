const express = require('express')
const verifyToken = require('../middleware/verifyToken')
const dbPromise = require('../util/dbPromise')
const response = require('../util/responseHandler')

const router = express.Router()

router.get('/recommend/test', (req, res) => {
  res.json({ message: 'recommend route ok' })
})

router.get('/recommend/:petId', verifyToken, async (req, res) => {
  try {
    const petId = req.params.petId

    const petRows = await dbPromise.query('SELECT tags FROM pets WHERE id = ? LIMIT 1', [petId])
    const tagsString = petRows?.[0]?.tags || ''
    const tags = String(tagsString)
      .split(',')
      .map((t) => t.trim())
      .filter(Boolean)

    if (tags.length === 0) {
      response.success(res, [], '推荐商品获取成功')
      return
    }

    const conditions = tags.map(() => 'tags LIKE ?').join(' OR ')
    const params = tags.map((t) => `%${t}%`)
    const sql = `SELECT * FROM products WHERE ${conditions} LIMIT 6`

    const products = await dbPromise.query(sql, params)

    response.success(res, products || [], '推荐商品获取成功')
  } catch (error) {
    response.error(res, error, '推荐商品获取失败')
  }
})

module.exports = router
