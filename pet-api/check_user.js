const mysql = require('mysql');

const conn = mysql.createConnection({
  host: '127.0.0.1', // 宿主机 Node 连本机映射端口（非 Docker 内服务名 mysql）
  user: 'root',
  password: 'root123456', // ❗必须和 docker 一致
  database: 'pet',        // ❗必须和 SHOW DATABASES 一致
  port: 3306
});

conn.query('SELECT * FROM users WHERE username = ?', ['周杰伦123'], (err, results) => {
  if (err) {
    console.log('Error:', err);
  } else {
    console.log('Results:', JSON.stringify(results));
  }
  conn.end();
});
