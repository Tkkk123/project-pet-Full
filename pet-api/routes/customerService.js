const express = require('express')
const verifyToken = require('../middleware/verifyToken')
const dbPromise = require('../util/dbPromise')
const response = require('../util/responseHandler')

const router = express.Router()

router.post('/customer-service/test', (req, res) => {
  res.json({ message: 'customer service route ok' })
})

router.post('/customer-service', verifyToken, async (req, res) => {
  try {
    const { question } = req.body || {}
    const q = typeof question === 'string' ? question.trim() : ''

    if (!q) {
      response.success(res, { answer: '暂未匹配到知识库，将转人工或AI回答' }, '查询成功')
      return
    }

    const rows = await dbPromise.query('SELECT * FROM faq WHERE keyword LIKE ?', [`%${q}%`])

    if (Array.isArray(rows) && rows.length > 0) {
      response.success(res, { answer: rows[0].answer }, '查询成功')
      return
    }

    response.success(res, { answer: '暂未匹配到知识库，将转人工或AI回答' }, '查询成功')
  } catch (error) {
    response.error(res, error, '查询失败')
  }
})

module.exports = router
