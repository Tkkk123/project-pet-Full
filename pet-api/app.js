var express = require("express");
var indexRouter = require("./routes/scrollData");
var products = require("./routes/products");
var app = express();
const cors = require("cors");
var http = require("http");
const port = 8234;
var server = http.createServer(app);

// 设置 CORS，允许来自 http://localhost:5173 的请求
app.use(cors({ origin: "http://localhost:5173" }));

// 处理预检请求
app.options("*", cors());

// 路由设置
app.use("/", indexRouter).use("/", products);

server.listen(port, () => {
  console.log(`服务器正在运行，访问地址为: http://localhost:${port}/`);
});
