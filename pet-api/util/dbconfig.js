const mysql = require("mysql");

const config = {
  host: "localhost",
  port: "3306",
  user: "root",
  password: "123456",
  database: "pet-express",
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
