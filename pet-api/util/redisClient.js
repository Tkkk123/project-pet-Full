const redis = require('redis');

// 创建 Redis 客户端
const client = redis.createClient({
    url: 'redis://localhost:6379', // Redis 地址
});

client.on('connect', () => {
    console.log('Connected to Redis');
});

client.on('error', (err) => {
    console.error('Redis Client Error:', err);
});

// 确保 Redis 客户端在使用前连接
(async () => {
    try {
        await client.connect(); // 使用 connect 方法连接 Redis
    } catch (err) {
        console.error('Error connecting to Redis:', err);
    }
})();

module.exports = client; // 导出已连接的客户端实例
