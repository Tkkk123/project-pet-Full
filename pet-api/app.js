var express = require("express");
var indexRouter = require("./routes/scrollData");
var products = require("./routes/products");
const detai = require("./routes/detail");
const login = require("./routes/login");
const register = require("./routes/register");
const token = require("./routes/token");
const logout = require("./routes/logout");
const address = require("./routes/address");
const order = require("./routes/order");
const user = require("./routes/user");
const pet = require("./routes/pet");
const recommend = require("./routes/recommend");
const customerService = require("./routes/customerService");
const reminderRouter = require("./routes/reminder");
const authRouter = require("./routes/auth");
const aiRouter = require("./routes/ai");



var app = express();
const cors = require("cors");
var http = require("http");
const cookieParser = require('cookie-parser');
const port = Number(process.env.PORT) || 8234;
var server = http.createServer(app);
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
// 设置 CORS，允许来自 http://localhost:5173 的请求
app.use(
  cors({
    origin: "http://localhost:5173", // 允许的前端域名
    credentials: true, // 允许携带 Cookie
  })
);

// 处理预检请求
app.options("*", cors());

// 路由设置
app.use(cookieParser())
  .use("/", indexRouter)
  .use("/", products)
  .use("/", detai)
  .use("/", login)
  .use("/", register)
  .use("/", token)
  .use("/", logout)
  .use("/", address)
  .use("/", order)
  .use("/", user)
  .use("/member", pet)
  .use("/member", recommend)
  .use("/member", customerService)
  .use("/member", reminderRouter)
  .use("/auth", authRouter)
  .use("/ai", aiRouter);
server.listen(port, () => {
  console.log(`服务器正在运行，访问地址为: http://localhost:${port}/`);
});
