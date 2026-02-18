const mysql = require('mysql');
const conn = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '123456',
  database: 'pet-express'
});

conn.query('SELECT * FROM users WHERE username = ?', ['周杰伦123'], (err, results) => {
  if (err) {
    console.log('Error:', err);
  } else {
    console.log('Results:', JSON.stringify(results));
  }
  conn.end();
});
