/*
 Navicat Premium Data Transfer

 Source Server         : mysql
 Source Server Type    : MySQL
 Source Server Version : 80017
 Source Host           : localhost:3306
 Source Schema         : pet-express

 Target Server Type    : MySQL
 Target Server Version : 80017
 File Encoding         : 65001

 Date: 08/03/2026 21:49:19
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admins
-- ----------------------------
DROP TABLE IF EXISTS `admins`;
CREATE TABLE `admins`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '管理员ID',
  `username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '管理员账号',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '管理员密码（加密存储）',
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'super_admin' COMMENT '角色类型',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '账号状态 1正常 0禁用',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统管理员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admins
-- ----------------------------
INSERT INTO `admins` VALUES (1, 'admin', '123456', 'super_admin', 1, '2026-03-01 22:48:43', '2026-03-01 22:48:43');

-- ----------------------------
-- Table structure for categories
-- ----------------------------
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories`  (
  `id` int(11) NOT NULL,
  `main_title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `sub_title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `picture` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of categories
-- ----------------------------
INSERT INTO `categories` VALUES (2, '狗粮专区', '犬用食品', 'https://img.boqiicdn.com/Data/U/P/img91405b8f86335f8da.jpg');
INSERT INTO `categories` VALUES (3, '猫粮专区', '猫用食品', 'https://img.boqiicdn.com/Data/U/P/img22075b8f866787dfc.jpg');
INSERT INTO `categories` VALUES (4, '宠物药品', '驱虫护理', 'https://img.boqiicdn.com/Data/U/P/img22075b8f866787dfc.jpg');
INSERT INTO `categories` VALUES (5, '宠物疫苗', '疫苗服务', 'https://img.boqiicdn.com/Data/U/P/img91405b8f86335f8da.jpg');
INSERT INTO `categories` VALUES (1005000, '挑选狗狗', '陪伴一生', 'https://img.boqiicdn.com/Data/U/P/img91405b8f86335f8da.jpg');
INSERT INTO `categories` VALUES (1005002, '挑选猫猫', '可爱精灵', 'https://img.boqiicdn.com/Data/U/P/img22075b8f866787dfc.jpg');

-- ----------------------------
-- Table structure for faq
-- ----------------------------
DROP TABLE IF EXISTS `faq`;
CREATE TABLE `faq`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `keyword` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `answer` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of faq
-- ----------------------------
INSERT INTO `faq` VALUES (1, '幼猫粮', '推荐幼猫专用奶粉，注意每日喂食量');
INSERT INTO `faq` VALUES (2, '皮肤病', '请带宠物去宠物医院检查皮肤状况');
INSERT INTO `faq` VALUES (3, '驱虫', '按体重选择驱虫药，每月一次');

-- ----------------------------
-- Table structure for order_details
-- ----------------------------
DROP TABLE IF EXISTS `order_details`;
CREATE TABLE `order_details`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NULL DEFAULT NULL,
  `product_id` bigint(20) NULL DEFAULT NULL,
  `quantity` int(11) NULL DEFAULT NULL,
  `price` decimal(10, 2) NULL DEFAULT NULL,
  `color` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品颜色',
  `size` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品尺寸',
  `gender` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '适用性别',
  `product_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品名称',
  `product_picture` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品图片',
  `estimated_days` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_id`(`order_id`) USING BTREE,
  INDEX `product_id`(`product_id`) USING BTREE,
  CONSTRAINT `order_details_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `order_details_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_details
-- ----------------------------
INSERT INTO `order_details` VALUES (26, 102, 101, 1, 58.00, NULL, '小号', NULL, '幼犬专用狗粮', '/img/dog1.jpg', NULL);

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NULL DEFAULT NULL,
  `status` enum('pending','completed','cancelled') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'pending',
  `total_price` int(10) NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 102 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (102, 1, 'completed', 59, '2026-02-22 16:15:22');

-- ----------------------------
-- Table structure for payment_info
-- ----------------------------
DROP TABLE IF EXISTS `payment_info`;
CREATE TABLE `payment_info`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NULL DEFAULT NULL,
  `payment_method` enum('credit_card','paypal','bank_transfer') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `payment_status` enum('pending','completed','failed') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'pending',
  `transaction_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `payment_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_id`(`order_id`) USING BTREE,
  CONSTRAINT `payment_info_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of payment_info
-- ----------------------------

-- ----------------------------
-- Table structure for pets
-- ----------------------------
DROP TABLE IF EXISTS `pets`;
CREATE TABLE `pets`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `species` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `breed` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `birthday` date NULL DEFAULT NULL,
  `weight` float NULL DEFAULT NULL,
  `health_note` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `allergy_note` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `preference` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `tags` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `daily_food_ratio` float NULL DEFAULT 0.03,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pets
-- ----------------------------
INSERT INTO `pets` VALUES (1, 3, '小白', 'dog', NULL, '2025-01-01', 5, '有肠胃问题', NULL, NULL, '小型犬,肠胃敏感', '2026-02-14 15:59:18', 0.03);
INSERT INTO `pets` VALUES (2, 3, '小黑', 'dog', '柯基', '2023-01-01', 5, '健康良好', '无', '喜欢吃鸡肉味狗粮', '小型犬', '2026-02-15 17:17:23', 0.03);
INSERT INTO `pets` VALUES (3, 3, 'test', 'dog', '金毛', '2002-12-01', 8.5, '无', '无', '无', '小型犬', '2026-02-22 14:04:55', 0.03);
INSERT INTO `pets` VALUES (4, 1, 'test', 'other', '金毛', '2002-12-01', 8.5, '无', '无', '无', '', '2026-02-22 16:43:12', 0.03);

-- ----------------------------
-- Table structure for products
-- ----------------------------
DROP TABLE IF EXISTS `products`;
CREATE TABLE `products`  (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `img` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `order_num` int(11) NULL DEFAULT 0,
  `category_id` int(11) NULL DEFAULT NULL,
  `state` tinyint(1) NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `tags` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `category_id`(`category_id`) USING BTREE,
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of products
-- ----------------------------
INSERT INTO `products` VALUES (101, '幼犬专用狗粮', 'https://m.media-amazon.com/images/I/713uvvCtRXL._AC_UL480_FMwebp_QL65_.jpg', 0, 2, 1, '适合幼年犬成长', '2026-02-19 21:26:00', '2026-02-19 21:26:00', '狗,幼年期,小型犬');
INSERT INTO `products` VALUES (102, '成犬营养狗粮', 'https://m.media-amazon.com/images/I/71j17LT9ZxL._AC_UL480_FMwebp_QL65_.jpg', 0, 2, 1, '适合成年犬', '2026-02-19 21:26:00', '2026-02-19 21:26:00', '狗,成年犬');
INSERT INTO `products` VALUES (103, '肠胃调理狗粮', 'https://m.media-amazon.com/images/I/81BC6p7jRdL._AC_UL480_FMwebp_QL65_.jpg', 0, 2, 1, '改善肠胃问题', '2026-02-19 21:26:00', '2026-02-19 21:26:00', '狗,肠胃敏感');
INSERT INTO `products` VALUES (104, '幼猫成长猫粮', 'https://m.media-amazon.com/images/I/71IFtPR84CL._AC_UL480_FMwebp_QL65_.jpg', 0, 3, 1, '幼猫专用配方', '2026-02-19 21:26:00', '2026-02-19 21:26:00', '猫,幼年期');
INSERT INTO `products` VALUES (105, '成猫营养猫粮', 'https://m.media-amazon.com/images/I/81tEqYI76WL._AC_UL480_FMwebp_QL65_.jpg', 0, 3, 1, '成年猫专用', '2026-02-19 21:26:00', '2026-02-19 21:26:00', '猫,成年');
INSERT INTO `products` VALUES (106, '犬用驱虫药', 'https://m.media-amazon.com/images/I/61HqQOEPqnL._AC_UL480_FMwebp_QL65_.jpg', 0, 4, 1, '每月一次驱虫', '2026-02-19 21:26:00', '2026-02-19 21:26:00', '狗');
INSERT INTO `products` VALUES (107, '猫用驱虫药', 'https://m.media-amazon.com/images/I/71umYIUi+IL._AC_UL480_FMwebp_QL65_.jpg', 0, 4, 1, '每月一次驱虫', '2026-02-19 21:26:00', '2026-02-19 21:26:00', '猫');
INSERT INTO `products` VALUES (108, '犬三联疫苗', 'https://m.media-amazon.com/images/I/61S53nI2hUL._AC_UL480_FMwebp_QL65_.jpg', 0, 5, 1, '年度疫苗', '2026-02-19 21:26:00', '2026-02-19 21:26:00', '狗');
INSERT INTO `products` VALUES (109, '猫三联疫苗', 'https://m.media-amazon.com/images/I/71qaR2LFvgL._AC_UL480_FMwebp_QL65_.jpg', 0, 5, 1, '年度疫苗', '2026-02-19 21:26:00', '2026-02-19 21:26:00', '猫');
INSERT INTO `products` VALUES (15238718450315340, '威尔斯猫', 'http://pic1.jisuapi.cn/pet/upload/197.jpg', 100, 1005002, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37', '肠胃敏感');
INSERT INTO `products` VALUES (17417519300217528, '索马里猫', 'http://pic1.jisuapi.cn/pet/upload/184.jpg', 20, 1005002, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37', NULL);
INSERT INTO `products` VALUES (22825220851116510, '重点色短毛猫', 'http://pic1.jisuapi.cn/pet/upload/192.jpg', 12, 1005002, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37', NULL);
INSERT INTO `products` VALUES (28869519310702544, '柯尼斯卷毛猫', 'http://pic1.jisuapi.cn/pet/upload/191.jpg', 0, 1005002, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37', NULL);
INSERT INTO `products` VALUES (29140519330919600, '俄罗斯蓝猫', 'http://pic1.jisuapi.cn/pet/upload/200.jpg', 40, 1005002, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37', NULL);
INSERT INTO `products` VALUES (31339918150220456, '阿比西尼亚猫', 'http://pic1.jisuapi.cn/pet/upload/182.jpg', 32, 1005002, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37', NULL);
INSERT INTO `products` VALUES (39783720781123070, '缅甸猫', 'http://pic1.jisuapi.cn/pet/upload/194.jpg', 0, 1005002, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37', NULL);
INSERT INTO `products` VALUES (43134719520811640, '希尔卡特猫', 'http://pic1.jisuapi.cn/pet/upload/199.jpg', 30, 1005002, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37', NULL);
INSERT INTO `products` VALUES (140000202206221820, '中华田园犬', 'http://pic1.jisuapi.cn/pet/upload/14.jpg', 0, 1005000, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37', NULL);
INSERT INTO `products` VALUES (140002202206221820, '扭玻利顿犬', 'http://pic1.jisuapi.cn/pet/upload/29.jpg', 0, 1005000, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37', NULL);
INSERT INTO `products` VALUES (230000200504155550, '中国细犬', 'http://pic1.jisuapi.cn/pet/upload/4.jpg', 0, 1005000, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37', '幼年期,小型犬');
INSERT INTO `products` VALUES (230560200504155550, '大丹犬', 'http://pic1.jisuapi.cn/pet/upload/19.jpg', 43, 1005000, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37', NULL);
INSERT INTO `products` VALUES (410000199710157700, '德国牧羊犬', 'http://pic1.jisuapi.cn/pet/upload/9.jpg', 60, 1005000, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37', NULL);
INSERT INTO `products` VALUES (410020199710157700, '泰迪犬', 'http://pic1.jisuapi.cn/pet/upload/24.jpg', 2, 1005000, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37', NULL);
INSERT INTO `products` VALUES (420000198612257500, '美国恶霸犬', 'http://pic1.jisuapi.cn/pet/upload/6.jpg', 0, 1005000, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37', NULL);
INSERT INTO `products` VALUES (420056198612257500, '蝴蝶犬', 'http://pic1.jisuapi.cn/pet/upload/21.jpg', 0, 1005000, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37', NULL);
INSERT INTO `products` VALUES (440000200406247360, '法国斗牛犬', 'http://pic1.jisuapi.cn/pet/upload/10.jpg', 42, 1005000, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37', NULL);
INSERT INTO `products` VALUES (440040200406247360, '边境牧羊犬', 'http://pic1.jisuapi.cn/pet/upload/25.jpg', 0, 1005000, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37', NULL);
INSERT INTO `products` VALUES (450000199008225300, '博美犬', 'http://pic1.jisuapi.cn/pet/upload/3.jpg', 0, 1005000, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37', NULL);
INSERT INTO `products` VALUES (460000198712186430, '小鹿犬', 'http://pic1.jisuapi.cn/pet/upload/8.jpg', 0, 1005000, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37', NULL);
INSERT INTO `products` VALUES (460000199711031100, '拉布拉多', 'http://pic1.jisuapi.cn/pet/upload/1.jpg', 0, 1005000, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37', NULL);
INSERT INTO `products` VALUES (460000199805023800, '金毛寻回犬', 'http://pic1.jisuapi.cn/pet/upload/2.jpg', 0, 1005000, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37', NULL);

-- ----------------------------
-- Table structure for sku_spec_values
-- ----------------------------
DROP TABLE IF EXISTS `sku_spec_values`;
CREATE TABLE `sku_spec_values`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sku_id` bigint(20) NULL DEFAULT NULL,
  `spec_value_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `sku_id`(`sku_id`) USING BTREE,
  INDEX `spec_value_id`(`spec_value_id`) USING BTREE,
  CONSTRAINT `sku_spec_values_ibfk_1` FOREIGN KEY (`sku_id`) REFERENCES `skus` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `sku_spec_values_ibfk_2` FOREIGN KEY (`spec_value_id`) REFERENCES `spec_values` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 449 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sku_spec_values
-- ----------------------------
INSERT INTO `sku_spec_values` VALUES (1, 1, 2);
INSERT INTO `sku_spec_values` VALUES (2, 1, 4);
INSERT INTO `sku_spec_values` VALUES (3, 1, 5);
INSERT INTO `sku_spec_values` VALUES (4, 1, 1);
INSERT INTO `sku_spec_values` VALUES (5, 1, 3);
INSERT INTO `sku_spec_values` VALUES (6, 1, 6);
INSERT INTO `sku_spec_values` VALUES (7, 2, 1);
INSERT INTO `sku_spec_values` VALUES (8, 2, 3);
INSERT INTO `sku_spec_values` VALUES (11, 28, 2);
INSERT INTO `sku_spec_values` VALUES (15, 29, 6);
INSERT INTO `sku_spec_values` VALUES (16, 29, 1);
INSERT INTO `sku_spec_values` VALUES (17, 2, 2);
INSERT INTO `sku_spec_values` VALUES (18, 32, 3);
INSERT INTO `sku_spec_values` VALUES (22, 26, 1);
INSERT INTO `sku_spec_values` VALUES (27, 5, 6);
INSERT INTO `sku_spec_values` VALUES (28, 31, 1);
INSERT INTO `sku_spec_values` VALUES (29, 28, 2);
INSERT INTO `sku_spec_values` VALUES (32, 32, 5);
INSERT INTO `sku_spec_values` VALUES (33, 4, 6);
INSERT INTO `sku_spec_values` VALUES (38, 32, 5);
INSERT INTO `sku_spec_values` VALUES (43, 30, 2);
INSERT INTO `sku_spec_values` VALUES (45, 20, 4);
INSERT INTO `sku_spec_values` VALUES (47, 7, 6);
INSERT INTO `sku_spec_values` VALUES (54, 1, 1);
INSERT INTO `sku_spec_values` VALUES (55, 7, 2);
INSERT INTO `sku_spec_values` VALUES (56, 29, 3);
INSERT INTO `sku_spec_values` VALUES (60, 20, 1);
INSERT INTO `sku_spec_values` VALUES (62, 31, 3);
INSERT INTO `sku_spec_values` VALUES (64, 24, 5);
INSERT INTO `sku_spec_values` VALUES (72, 22, 1);
INSERT INTO `sku_spec_values` VALUES (73, 25, 2);
INSERT INTO `sku_spec_values` VALUES (74, 6, 3);
INSERT INTO `sku_spec_values` VALUES (75, 6, 4);
INSERT INTO `sku_spec_values` VALUES (78, 21, 1);
INSERT INTO `sku_spec_values` VALUES (79, 21, 2);
INSERT INTO `sku_spec_values` VALUES (83, 23, 6);
INSERT INTO `sku_spec_values` VALUES (84, 4, 1);
INSERT INTO `sku_spec_values` VALUES (85, 7, 2);
INSERT INTO `sku_spec_values` VALUES (86, 23, 3);
INSERT INTO `sku_spec_values` VALUES (89, 2, 6);
INSERT INTO `sku_spec_values` VALUES (90, 27, 1);
INSERT INTO `sku_spec_values` VALUES (92, 8, 3);
INSERT INTO `sku_spec_values` VALUES (97, 7, 2);
INSERT INTO `sku_spec_values` VALUES (103, 7, 2);
INSERT INTO `sku_spec_values` VALUES (109, 24, 2);
INSERT INTO `sku_spec_values` VALUES (110, 32, 3);
INSERT INTO `sku_spec_values` VALUES (112, 24, 5);
INSERT INTO `sku_spec_values` VALUES (116, 5, 3);
INSERT INTO `sku_spec_values` VALUES (118, 31, 5);
INSERT INTO `sku_spec_values` VALUES (119, 29, 6);
INSERT INTO `sku_spec_values` VALUES (124, 3, 5);
INSERT INTO `sku_spec_values` VALUES (129, 20, 4);
INSERT INTO `sku_spec_values` VALUES (133, 24, 2);
INSERT INTO `sku_spec_values` VALUES (134, 28, 3);
INSERT INTO `sku_spec_values` VALUES (137, 8, 6);
INSERT INTO `sku_spec_values` VALUES (138, 21, 1);
INSERT INTO `sku_spec_values` VALUES (139, 23, 2);
INSERT INTO `sku_spec_values` VALUES (141, 21, 4);
INSERT INTO `sku_spec_values` VALUES (142, 8, 5);
INSERT INTO `sku_spec_values` VALUES (143, 31, 6);
INSERT INTO `sku_spec_values` VALUES (144, 20, 1);
INSERT INTO `sku_spec_values` VALUES (150, 1, 1);
INSERT INTO `sku_spec_values` VALUES (154, 2, 5);
INSERT INTO `sku_spec_values` VALUES (157, 26, 2);
INSERT INTO `sku_spec_values` VALUES (160, 22, 5);
INSERT INTO `sku_spec_values` VALUES (162, 26, 1);
INSERT INTO `sku_spec_values` VALUES (163, 19, 2);
INSERT INTO `sku_spec_values` VALUES (165, 27, 4);
INSERT INTO `sku_spec_values` VALUES (166, 27, 5);
INSERT INTO `sku_spec_values` VALUES (168, 29, 1);
INSERT INTO `sku_spec_values` VALUES (170, 26, 3);
INSERT INTO `sku_spec_values` VALUES (171, 31, 4);
INSERT INTO `sku_spec_values` VALUES (180, 30, 1);
INSERT INTO `sku_spec_values` VALUES (187, 31, 2);
INSERT INTO `sku_spec_values` VALUES (189, 2, 4);
INSERT INTO `sku_spec_values` VALUES (190, 19, 5);
INSERT INTO `sku_spec_values` VALUES (192, 6, 1);
INSERT INTO `sku_spec_values` VALUES (197, 28, 6);
INSERT INTO `sku_spec_values` VALUES (198, 32, 1);
INSERT INTO `sku_spec_values` VALUES (199, 21, 2);
INSERT INTO `sku_spec_values` VALUES (200, 7, 3);
INSERT INTO `sku_spec_values` VALUES (201, 27, 4);
INSERT INTO `sku_spec_values` VALUES (202, 2, 5);
INSERT INTO `sku_spec_values` VALUES (213, 8, 4);
INSERT INTO `sku_spec_values` VALUES (214, 31, 5);
INSERT INTO `sku_spec_values` VALUES (215, 22, 6);
INSERT INTO `sku_spec_values` VALUES (218, 22, 3);
INSERT INTO `sku_spec_values` VALUES (221, 30, 6);
INSERT INTO `sku_spec_values` VALUES (223, 28, 2);
INSERT INTO `sku_spec_values` VALUES (225, 27, 4);
INSERT INTO `sku_spec_values` VALUES (226, 2, 5);
INSERT INTO `sku_spec_values` VALUES (228, 19, 1);
INSERT INTO `sku_spec_values` VALUES (232, 22, 5);
INSERT INTO `sku_spec_values` VALUES (233, 1, 6);
INSERT INTO `sku_spec_values` VALUES (235, 24, 2);
INSERT INTO `sku_spec_values` VALUES (236, 26, 3);
INSERT INTO `sku_spec_values` VALUES (237, 1, 4);
INSERT INTO `sku_spec_values` VALUES (240, 25, 1);
INSERT INTO `sku_spec_values` VALUES (241, 19, 2);
INSERT INTO `sku_spec_values` VALUES (242, 21, 3);
INSERT INTO `sku_spec_values` VALUES (244, 3, 5);
INSERT INTO `sku_spec_values` VALUES (246, 28, 1);
INSERT INTO `sku_spec_values` VALUES (247, 20, 2);
INSERT INTO `sku_spec_values` VALUES (255, 30, 4);
INSERT INTO `sku_spec_values` VALUES (257, 28, 6);
INSERT INTO `sku_spec_values` VALUES (258, 4, 1);
INSERT INTO `sku_spec_values` VALUES (265, 22, 2);
INSERT INTO `sku_spec_values` VALUES (266, 25, 3);
INSERT INTO `sku_spec_values` VALUES (267, 3, 4);
INSERT INTO `sku_spec_values` VALUES (271, 22, 2);
INSERT INTO `sku_spec_values` VALUES (272, 23, 3);
INSERT INTO `sku_spec_values` VALUES (280, 30, 5);
INSERT INTO `sku_spec_values` VALUES (281, 22, 6);
INSERT INTO `sku_spec_values` VALUES (282, 20, 1);
INSERT INTO `sku_spec_values` VALUES (284, 4, 3);
INSERT INTO `sku_spec_values` VALUES (285, 23, 4);
INSERT INTO `sku_spec_values` VALUES (288, 21, 1);
INSERT INTO `sku_spec_values` VALUES (294, 25, 1);
INSERT INTO `sku_spec_values` VALUES (298, 24, 5);
INSERT INTO `sku_spec_values` VALUES (302, 21, 3);
INSERT INTO `sku_spec_values` VALUES (303, 23, 4);
INSERT INTO `sku_spec_values` VALUES (305, 23, 6);
INSERT INTO `sku_spec_values` VALUES (308, 8, 3);
INSERT INTO `sku_spec_values` VALUES (309, 5, 4);
INSERT INTO `sku_spec_values` VALUES (312, 30, 1);
INSERT INTO `sku_spec_values` VALUES (317, 30, 6);
INSERT INTO `sku_spec_values` VALUES (318, 4, 1);
INSERT INTO `sku_spec_values` VALUES (320, 19, 3);
INSERT INTO `sku_spec_values` VALUES (324, 26, 1);
INSERT INTO `sku_spec_values` VALUES (326, 32, 3);
INSERT INTO `sku_spec_values` VALUES (327, 28, 4);
INSERT INTO `sku_spec_values` VALUES (336, 27, 1);
INSERT INTO `sku_spec_values` VALUES (339, 32, 4);
INSERT INTO `sku_spec_values` VALUES (344, 4, 3);
INSERT INTO `sku_spec_values` VALUES (345, 6, 4);
INSERT INTO `sku_spec_values` VALUES (351, 21, 4);
INSERT INTO `sku_spec_values` VALUES (353, 20, 6);
INSERT INTO `sku_spec_values` VALUES (355, 24, 2);
INSERT INTO `sku_spec_values` VALUES (356, 26, 3);
INSERT INTO `sku_spec_values` VALUES (357, 1, 4);
INSERT INTO `sku_spec_values` VALUES (360, 3, 1);
INSERT INTO `sku_spec_values` VALUES (367, 20, 2);
INSERT INTO `sku_spec_values` VALUES (374, 27, 3);
INSERT INTO `sku_spec_values` VALUES (375, 27, 4);
INSERT INTO `sku_spec_values` VALUES (377, 19, 6);
INSERT INTO `sku_spec_values` VALUES (380, 28, 3);
INSERT INTO `sku_spec_values` VALUES (383, 25, 6);
INSERT INTO `sku_spec_values` VALUES (386, 23, 3);
INSERT INTO `sku_spec_values` VALUES (388, 27, 5);
INSERT INTO `sku_spec_values` VALUES (390, 23, 1);
INSERT INTO `sku_spec_values` VALUES (391, 28, 2);
INSERT INTO `sku_spec_values` VALUES (394, 32, 5);
INSERT INTO `sku_spec_values` VALUES (397, 1, 2);
INSERT INTO `sku_spec_values` VALUES (398, 5, 3);
INSERT INTO `sku_spec_values` VALUES (399, 20, 4);
INSERT INTO `sku_spec_values` VALUES (400, 29, 5);
INSERT INTO `sku_spec_values` VALUES (401, 30, 6);
INSERT INTO `sku_spec_values` VALUES (402, 7, 1);
INSERT INTO `sku_spec_values` VALUES (407, 7, 6);
INSERT INTO `sku_spec_values` VALUES (420, 20, 1);
INSERT INTO `sku_spec_values` VALUES (421, 2, 2);
INSERT INTO `sku_spec_values` VALUES (422, 2, 3);
INSERT INTO `sku_spec_values` VALUES (423, 5, 4);
INSERT INTO `sku_spec_values` VALUES (427, 25, 2);
INSERT INTO `sku_spec_values` VALUES (430, 30, 5);
INSERT INTO `sku_spec_values` VALUES (434, 8, 3);
INSERT INTO `sku_spec_values` VALUES (435, 7, 4);
INSERT INTO `sku_spec_values` VALUES (436, 7, 5);
INSERT INTO `sku_spec_values` VALUES (438, 1011, 4);
INSERT INTO `sku_spec_values` VALUES (439, 1012, 3);
INSERT INTO `sku_spec_values` VALUES (440, 1021, 4);
INSERT INTO `sku_spec_values` VALUES (441, 1022, 3);
INSERT INTO `sku_spec_values` VALUES (442, 1031, 3);
INSERT INTO `sku_spec_values` VALUES (443, 1041, 4);
INSERT INTO `sku_spec_values` VALUES (444, 1042, 3);
INSERT INTO `sku_spec_values` VALUES (445, 1051, 3);
INSERT INTO `sku_spec_values` VALUES (446, 1061, 4);
INSERT INTO `sku_spec_values` VALUES (447, 1071, 4);
INSERT INTO `sku_spec_values` VALUES (448, 1081, 4);
INSERT INTO `sku_spec_values` VALUES (449, 1091, 4);

-- ----------------------------
-- Table structure for skus
-- ----------------------------
DROP TABLE IF EXISTS `skus`;
CREATE TABLE `skus`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) NULL DEFAULT NULL,
  `price` decimal(10, 2) NOT NULL,
  `quantity` int(11) NULL DEFAULT 0,
  `discount` decimal(10, 2) NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `product_id`(`product_id`) USING BTREE,
  CONSTRAINT `skus_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1091 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of skus
-- ----------------------------
INSERT INTO `skus` VALUES (1, 15238718450315340, 1259.61, 50, 0.26, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (2, 17417519300217528, 1324.34, 50, 0.49, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (3, 22825220851116510, 1826.05, 50, 0.57, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (4, 28869519310702544, 1775.77, 50, 0.26, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (5, 29140519330919600, 1305.17, 50, 0.51, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (6, 31339918150220456, 1816.29, 50, 0.18, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (7, 39783720781123070, 1763.01, 50, 0.25, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (8, 43134719520811640, 1150.63, 50, 0.60, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (19, 140000202206221820, 1228.55, 50, 0.44, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (20, 140002202206221820, 1525.29, 50, 0.56, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (21, 230000200504155550, 1923.58, 50, 0.37, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (22, 230560200504155550, 1820.37, 50, 0.56, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (23, 410000199710157700, 1274.81, 50, 0.58, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (24, 410020199710157700, 1837.99, 50, 0.15, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (25, 420000198612257500, 1448.48, 50, 0.38, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (26, 420056198612257500, 1979.20, 50, 0.38, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (27, 440000200406247360, 1568.48, 50, 0.14, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (28, 440040200406247360, 1988.29, 50, 0.48, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (29, 450000199008225300, 1661.25, 50, 0.38, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (30, 460000198712186430, 1669.05, 50, 0.33, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (31, 460000199711031100, 1760.82, 50, 0.44, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (32, 460000199805023800, 1434.14, 50, 0.11, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (1011, 101, 58.00, 200, 0.00, '2026-02-22 16:08:47', '2026-02-22 16:08:47');
INSERT INTO `skus` VALUES (1012, 101, 188.00, 100, 0.10, '2026-02-22 16:08:47', '2026-02-22 16:08:47');
INSERT INTO `skus` VALUES (1021, 102, 65.00, 150, 0.00, '2026-02-22 16:08:47', '2026-02-22 16:08:47');
INSERT INTO `skus` VALUES (1022, 102, 210.00, 80, 0.05, '2026-02-22 16:08:47', '2026-02-22 16:08:47');
INSERT INTO `skus` VALUES (1031, 103, 120.00, 50, 0.00, '2026-02-22 16:08:47', '2026-02-22 16:08:47');
INSERT INTO `skus` VALUES (1041, 104, 45.00, 300, 0.00, '2026-02-22 16:08:47', '2026-02-22 16:08:47');
INSERT INTO `skus` VALUES (1042, 104, 155.00, 120, 0.15, '2026-02-22 16:08:47', '2026-02-22 16:08:47');
INSERT INTO `skus` VALUES (1051, 105, 168.00, 100, 0.00, '2026-02-22 16:08:47', '2026-02-22 16:08:47');
INSERT INTO `skus` VALUES (1061, 106, 89.00, 500, 0.00, '2026-02-22 16:08:47', '2026-02-22 16:08:47');
INSERT INTO `skus` VALUES (1071, 107, 79.00, 400, 0.00, '2026-02-22 16:08:47', '2026-02-22 16:08:47');
INSERT INTO `skus` VALUES (1081, 108, 120.00, 1000, 0.00, '2026-02-22 16:08:47', '2026-02-22 16:08:47');
INSERT INTO `skus` VALUES (1091, 109, 150.00, 1000, 0.00, '2026-02-22 16:08:47', '2026-02-22 16:08:47');

-- ----------------------------
-- Table structure for spec_values
-- ----------------------------
DROP TABLE IF EXISTS `spec_values`;
CREATE TABLE `spec_values`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `specification_id` int(11) NULL DEFAULT NULL,
  `value` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `specification_id`(`specification_id`) USING BTREE,
  CONSTRAINT `spec_values_ibfk_1` FOREIGN KEY (`specification_id`) REFERENCES `specifications` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of spec_values
-- ----------------------------
INSERT INTO `spec_values` VALUES (1, 1, '红色');
INSERT INTO `spec_values` VALUES (2, 1, '蓝色');
INSERT INTO `spec_values` VALUES (3, 2, '大号');
INSERT INTO `spec_values` VALUES (4, 2, '小号');
INSERT INTO `spec_values` VALUES (5, 3, '公');
INSERT INTO `spec_values` VALUES (6, 3, '母');

-- ----------------------------
-- Table structure for specifications
-- ----------------------------
DROP TABLE IF EXISTS `specifications`;
CREATE TABLE `specifications`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '规格属性名称 (例如: 颜色, 尺寸等)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of specifications
-- ----------------------------
INSERT INTO `specifications` VALUES (1, '颜色');
INSERT INTO `specifications` VALUES (2, '尺寸');
INSERT INTO `specifications` VALUES (3, '性别');

-- ----------------------------
-- Table structure for user_addresses
-- ----------------------------
DROP TABLE IF EXISTS `user_addresses`;
CREATE TABLE `user_addresses`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NULL DEFAULT NULL,
  `address_line` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `city` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `state` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `postal_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `country` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `is_default` tinyint(1) NULL DEFAULT 0,
  `receiver` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '收货人姓名',
  `contact` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '联系方式',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  CONSTRAINT `user_addresses_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_addresses
-- ----------------------------
INSERT INTO `user_addresses` VALUES (1, 1, '广东省广州市天河区某某街道某某小区', '广州', '1', '61923', '中国', 0, '周杰伦', '123123');
INSERT INTO `user_addresses` VALUES (2, 1, '广东省广州市白云区某某街道某某小区', NULL, '1', NULL, NULL, 0, '周杰伦2', '8097087');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, '周杰伦', '123456', '123456789.com', '1234567890', '2025-01-13 16:07:56');
INSERT INTO `users` VALUES (2, '周杰伦123', '654321', '123', '123', '2025-01-31 10:45:23');
INSERT INTO `users` VALUES (3, '123456', '123456', '1233', '123312', '2025-01-31 10:49:31');

SET FOREIGN_KEY_CHECKS = 1;
