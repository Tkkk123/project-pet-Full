const express = require('express')
const verifyToken = require('../middleware/verifyToken')
const dbPromise = require('../util/dbPromise')
const response = require('../util/responseHandler')

const router = express.Router()

router.get('/pets', verifyToken, async (req, res) => {
    try {
        const userId = req.user?.id ?? req.user?.userId

        const pets = await dbPromise.query('SELECT * FROM pets WHERE user_id = ?', [userId])

        response.success(res, pets, '获取宠物列表成功')
    } catch (error) {
        response.error(res, error, '获取宠物列表失败')
    }
})



router.post('/pets', verifyToken, async (req, res) => {
    try {
        const userId = req.user.userId
        const {
            name,
            species,
            breed,
            birthday,
            weight,
            health_note,
            allergy_note,
            preference
        } = req.body || {}

        const tags = []
        const weightNumber = Number(weight)

        if (species === 'dog' && Number.isFinite(weightNumber) && weightNumber < 10) {
            tags.push('小型犬')
        }

        if (birthday) {
            const birthdayDate = new Date(birthday)
            if (!Number.isNaN(birthdayDate.getTime())) {
                const oneYearAgo = new Date()
                oneYearAgo.setFullYear(oneYearAgo.getFullYear() - 1)
                if (birthdayDate > oneYearAgo) tags.push('幼年期')
            }
        }

        if (typeof health_note === 'string' && health_note.includes('肠胃')) {
            tags.push('肠胃敏感')
        }

        const tagsString = tags.join(',')

        const sql = `
            INSERT INTO pets 
            (user_id, name, species, breed, birthday, weight, health_note, allergy_note, preference, tags)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `

        const result = await dbPromise.query(sql, [
            userId,
            name,
            species,
            breed,
            birthday,
            Number.isFinite(weightNumber) ? weightNumber : null,
            health_note,
            allergy_note,
            preference,
            tagsString
        ])

        response.success(res, { id: result.insertId, tags: tagsString }, '创建宠物成功')
    } catch (error) {
        response.error(res, error, '创建宠物失败')
    }
})

module.exports = router
