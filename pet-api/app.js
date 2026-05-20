require("dotenv").config();
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
app.use(require("helmet")());
const cors = require("cors");
var http = require("http");
const cookieParser = require('cookie-parser');
const port = Number(process.env.PORT) || 8234;
var server = http.createServer(app);
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
// 设置 CORS，允许来自本地开发环境和生产域名的请求
const allowedOrigins = [
  "http://localhost:5173",
  "http://127.0.0.1:5173",
  "http://www.tk-docker.fun",
  "http://tk-docker.fun",
  "https://www.tk-docker.fun",
  "https://tk-docker.fun",
];
app.use(
  cors({
    origin: (origin, callback) => {
      if (!origin || allowedOrigins.includes(origin)) {
        callback(null, true);
      } else {
        callback(new Error("Not allowed by CORS"));
      }
    },
    credentials: true, // 允许携带 Cookie
  })
);

// 处理预检请求
app.options("*", cors());

// 路由设置
app.use(cookieParser())
  .use("/api", indexRouter)
  .use("/api", products)
  .use("/api", detai)
  .use("/api", login)
  .use("/api", register)
  .use("/api", token)
  .use("/api", logout)
  .use("/api", address)
  .use("/api", order)
  .use("/api", user)
  .use("/api/member", pet)
  .use("/api/member", recommend)
  .use("/api/member", customerService)
  .use("/api/member", reminderRouter)
  .use("/api/auth", authRouter)
  .use("/api/ai", aiRouter);

// 健康检查端点
app.get("/api/health", (req, res) => {
  res.json({ status: "ok", timestamp: new Date().toISOString() });
});

server.listen(port, () => {
  console.log(`服务器正在运行，访问地址为: http://localhost:${port}/`);
});
