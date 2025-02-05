# Pet Shop 宠物商城项目

## 项目简介

这是一个基于 Vue.js 的宠物商城全栈项目，包含前端商城系统和后端 API 服务。项目实现了完整的电商功能，包括商品展示、购物车、订单管理、用户中心等模块。

## 技术栈

### 前端 (project-pet)

- Vue 3
- Vue Router
- Pinia 状态管理
- Element Plus UI 框架
- Axios 请求库

### 后端 (pet-api)

- Node.js
- Express.js
- MySQL 数据库
- Redis 缓存
  - Token 存储
  - 用户会话管理

## 功能特性

- 用户认证
  - 登录/注册
  - 基于 Redis 的 Token 认证
  - Cookie-based 会话管理
- 商品相关
  - 商品分类展示
  - 商品详情
  - 商品搜索
  - 商品推荐
- 购物功能
  - 购物车管理
  - 订单创建
  - 支付功能
  - 订单跟踪
- 个人中心
  - 订单历史
  - 个人信息修改
  - 收货地址管理

## 本地开发

### 前端启动

cd project-pet
pnpm install
pnpm dev

### 后端启动

cd pet-api
pnpm install
nodemon app.js

## 环境要求

- Node.js
- MySQL
- Redis
- pnpm

## 认证机制

项目使用基于 Redis 的 Token 认证机制：

1. 用户登录后生成唯一 Token
2. Token 和用户信息存储在 Redis 中
3. Token 通过 Cookie 传递
4. 使用中间件统一验证 Token
5. Token 失效时需要重新登录
