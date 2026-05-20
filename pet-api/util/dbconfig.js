const mysql = require("mysql");

const config = {
  host: process.env.DB_HOST || '127.0.0.1',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || 'root123456',
  database: process.env.DB_NAME || 'pet',
  port: Number(process.env.DB_PORT) || 3306
};


const pool = mysql.createPool(config);

function sqlConnect(sql, sqlArr = [], callBack) {
  pool.getConnection((err, conn) => {
    if (err) {
      if (typeof callBack === "function") callBack(err);
      return;
    }

    conn.query(sql, sqlArr, (queryErr, result) => {
      try {
        if (typeof callBack === "function") callBack(queryErr, result);
      } finally {
        conn.release();
      }
    });
  });
}

function getConnection() {
  return new Promise((resolve, reject) => {
    pool.getConnection((err, conn) => {
      if (err) reject(err);
      else resolve(conn);
    });
  });
}

function query(sql, params = []) {
  return new Promise((resolve, reject) => {
    pool.query(sql, params, (err, result) => {
      if (err) reject(err);
      else resolve(result);
    });
  });
}

module.exports = {
  config,
  pool,
  sqlConnect,
  getConnection,
  query,
};
