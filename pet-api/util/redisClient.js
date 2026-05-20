const redis = require('redis');

// 创建 Redis 客户端（宿主机 Node 经本机端口连容器内 Redis）
const client = redis.createClient({
    url: process.env.REDIS_URL || 'redis://127.0.0.1:6379'
});


// 连接事件
client.on('connect', () => {
    console.log('Connected to Redis');
});

// 错误监听
client.on('error', (err) => {
    console.error('Redis Client Error:', err);
});

// 启动连接
(async () => {
    try {
        await client.connect();
        console.log('Redis connected successfully');
    } catch (err) {
        console.error('Error connecting to Redis:', err);
    }
})();

module.exports = client;