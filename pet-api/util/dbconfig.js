const mysql = require("mysql");
module.exports = {
  //数据库配置
  config: {
    host: "localhost",
    port: "3306",
    user: "root",
    password: "123456",
    database: "pet-express",
  },
  sqlConnect: function (sql, sqlArr, callBack) {
    var pool = mysql.createPool(this.config);
    pool.getConnection((err, conn) => {
      if (err) {
        console.log("连接失败");
        console.log(err);
      } else {
        conn.query(sql, sqlArr, callBack);
        conn.release();
      }
    });
  },
};
