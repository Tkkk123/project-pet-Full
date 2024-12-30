const dbconfig = require('./dbconfig')

// 数据库操作 Promise 包装
const dbPromise = {
    query(sql, params = []) {
        return new Promise((resolve, reject) => {
            dbconfig.sqlConnect(sql, params, (err, result) => {
                if (err) reject(err)
                else resolve(result)
            })
        })
    },

    // 事务相关方法
    async transaction(callback) {
        try {
            await this.query('START TRANSACTION')
            const result = await callback()
            await this.query('COMMIT')
            return result
        } catch (error) {
            await this.query('ROLLBACK')
            throw error
        }
    }
}

module.exports = dbPromise 