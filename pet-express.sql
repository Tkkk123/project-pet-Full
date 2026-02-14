/*
 Navicat Premium Data Transfer

 Source Server         : Express
 Source Server Type    : MySQL
 Source Server Version : 80017
 Source Host           : localhost:3306
 Source Schema         : pet-express

 Target Server Type    : MySQL
 Target Server Version : 80017
 File Encoding         : 65001

 Date: 16/06/2025 23:12:55
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

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
INSERT INTO `categories` VALUES (1005000, '挑选狗狗', '陪伴一生', 'https://img.boqiicdn.com/Data/U/P/img91405b8f86335f8da.jpg');
INSERT INTO `categories` VALUES (1005002, '挑选猫猫', '可爱精灵', 'https://img.boqiicdn.com/Data/U/P/img22075b8f866787dfc.jpg');
INSERT INTO `categories` VALUES (1010000, '其他宠类', NULL, 'https://img.boqiicdn.com/Data/U/P/img91405b8f86335f8da.jpg');
INSERT INTO `categories` VALUES (1011020, '宠物用品', NULL, 'https://img.boqiicdn.com/Data/U/P/img22075b8f866787dfc.jpg');
INSERT INTO `categories` VALUES (1013001, '宠物美容', NULL, 'https://img.boqiicdn.com/Data/U/P/img91405b8f86335f8da.jpg');
INSERT INTO `categories` VALUES (1019000, '宠物训练', NULL, 'https://img.boqiicdn.com/Data/U/P/img22075b8f866787dfc.jpg');
INSERT INTO `categories` VALUES (1043000, '宠物保险', NULL, 'https://img.boqiicdn.com/Data/U/P/img91405b8f86335f8da.jpg');
INSERT INTO `categories` VALUES (1043234, '宠物医疗', NULL, 'https://img.boqiicdn.com/Data/U/P/img22075b8f866787dfc.jpg');
INSERT INTO `categories` VALUES (1044300, '关爱萌宠', NULL, 'https://img.boqiicdn.com/Data/U/P/img91405b8f86335f8da.jpg');
INSERT INTO `categories` VALUES (1049734, '宠物美妆', NULL, 'https://img.boqiicdn.com/Data/U/P/img22075b8f866787dfc.jpg');

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
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_id`(`order_id`) USING BTREE,
  INDEX `product_id`(`product_id`) USING BTREE,
  CONSTRAINT `order_details_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `order_details_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_details
-- ----------------------------
INSERT INTO `order_details` VALUES (1, 1, 15238718450315340, 1, 1259.61, '蓝色', '小号', '母', '威尔斯猫', 'http://pic1.jisuapi.cn/pet/upload/197.jpg');
INSERT INTO `order_details` VALUES (2, 2, 15238718450315340, 1, 1259.61, '红色', '小号', '公', '威尔斯猫', 'http://pic1.jisuapi.cn/pet/upload/197.jpg');
INSERT INTO `order_details` VALUES (3, 3, 15238718450315340, 1, 1259.61, '蓝色', '大号', '公', '威尔斯猫', 'http://pic1.jisuapi.cn/pet/upload/197.jpg');
INSERT INTO `order_details` VALUES (4, 3, 15238718450315340, 1, 1259.61, '红色', '小号', '公', '威尔斯猫', 'http://pic1.jisuapi.cn/pet/upload/197.jpg');
INSERT INTO `order_details` VALUES (5, 4, 15238718450315340, 1, 1259.61, '红色', '小号', '公', '威尔斯猫', 'http://pic1.jisuapi.cn/pet/upload/197.jpg');
INSERT INTO `order_details` VALUES (6, 4, 15238718450315340, 1, 1259.61, '红色', '小号', '母', '威尔斯猫', 'http://pic1.jisuapi.cn/pet/upload/197.jpg');
INSERT INTO `order_details` VALUES (7, 4, 15238718450315340, 2, 1259.61, '红色', '大号', '母', '威尔斯猫', 'http://pic1.jisuapi.cn/pet/upload/197.jpg');
INSERT INTO `order_details` VALUES (8, 4, 15238718450315340, 1, 1259.61, '蓝色', '大号', '母', '威尔斯猫', 'http://pic1.jisuapi.cn/pet/upload/197.jpg');
INSERT INTO `order_details` VALUES (9, 4, 15238718450315340, 1, 1259.61, '蓝色', '大号', '公', '威尔斯猫', 'http://pic1.jisuapi.cn/pet/upload/197.jpg');
INSERT INTO `order_details` VALUES (10, 4, 15238718450315340, 3, 1259.61, '蓝色', '小号', '公', '威尔斯猫', 'http://pic1.jisuapi.cn/pet/upload/197.jpg');
INSERT INTO `order_details` VALUES (11, 5, 15238718450315340, 1, 1259.61, '蓝色', '大号', '公', '威尔斯猫', 'http://pic1.jisuapi.cn/pet/upload/197.jpg');
INSERT INTO `order_details` VALUES (12, 6, 15238718450315340, 1, 1259.61, '蓝色', '小号', '母', '威尔斯猫', 'http://pic1.jisuapi.cn/pet/upload/197.jpg');
INSERT INTO `order_details` VALUES (13, 7, 15238718450315340, 1, 1259.61, '红色', '小号', '母', '威尔斯猫', 'http://pic1.jisuapi.cn/pet/upload/197.jpg');
INSERT INTO `order_details` VALUES (14, 8, 73059420831111150, 1, 1516.52, '红色', '大号', '母', '奥西猫', 'http://pic1.jisuapi.cn/pet/upload/181.jpg');
INSERT INTO `order_details` VALUES (15, 9, 820690199701298300, 1, 1363.32, '蓝色', '大号', '公', '兰波格犬', 'http://pic1.jisuapi.cn/pet/upload/5.jpg');
INSERT INTO `order_details` VALUES (16, 10, 874542185219806600, 1, 1892.36, '蓝色', '小号', '母', '热带草原猫', 'http://pic1.jisuapi.cn/pet/upload/185.jpg');
INSERT INTO `order_details` VALUES (17, 11, 520089199105145800, 1, 1569.14, '蓝色', '小号', '公', '边境牧羊犬', 'http://pic1.jisuapi.cn/pet/upload/25.jpg');
INSERT INTO `order_details` VALUES (18, 12, 581328187006249900, 3, 1036.32, '红色', '小号', '母', '萨摩耶犬', 'http://pic1.jisuapi.cn/pet/upload/20.jpg');

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
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (1, 1, 'completed', 1285, '2025-02-01 13:20:28');
INSERT INTO `orders` VALUES (2, 1, 'completed', 1285, '2025-02-01 13:32:56');
INSERT INTO `orders` VALUES (3, 1, 'cancelled', 2570, '2025-02-01 13:43:29');
INSERT INTO `orders` VALUES (4, 1, 'completed', 11563, '2025-02-02 15:24:54');
INSERT INTO `orders` VALUES (5, 1, 'cancelled', 1285, '2025-02-02 15:25:44');
INSERT INTO `orders` VALUES (6, 1, 'completed', 1285, '2025-02-02 15:46:40');
INSERT INTO `orders` VALUES (7, 1, 'pending', 1285, '2025-02-02 15:57:18');
INSERT INTO `orders` VALUES (8, 1, 'cancelled', 1547, '2025-02-02 16:27:41');
INSERT INTO `orders` VALUES (9, 1, 'completed', 1391, '2025-02-02 16:33:04');
INSERT INTO `orders` VALUES (10, 4, 'completed', 1930, '2025-02-03 14:01:33');
INSERT INTO `orders` VALUES (11, 1, 'completed', 1601, '2025-02-03 15:28:26');
INSERT INTO `orders` VALUES (12, 1, 'completed', 3171, '2025-02-03 15:37:19');

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
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `category_id`(`category_id`) USING BTREE,
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of products
-- ----------------------------
INSERT INTO `products` VALUES (15238718450315340, '威尔斯猫', 'http://pic1.jisuapi.cn/pet/upload/197.jpg', 100, 1005002, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (17417519300217528, '索马里猫', 'http://pic1.jisuapi.cn/pet/upload/184.jpg', 20, 1005002, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (22825220851116510, '重点色短毛猫', 'http://pic1.jisuapi.cn/pet/upload/192.jpg', 12, 1005002, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (28869519310702544, '柯尼斯卷毛猫', 'http://pic1.jisuapi.cn/pet/upload/191.jpg', 0, 1005002, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (29140519330919600, '俄罗斯蓝猫', 'http://pic1.jisuapi.cn/pet/upload/200.jpg', 40, 1005002, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (31339918150220456, '阿比西尼亚猫', 'http://pic1.jisuapi.cn/pet/upload/182.jpg', 32, 1005002, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (39783720781123070, '缅甸猫', 'http://pic1.jisuapi.cn/pet/upload/194.jpg', 0, 1005002, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (43134719520811640, '希尔卡特猫', 'http://pic1.jisuapi.cn/pet/upload/199.jpg', 30, 1005002, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (44125718070616480, '阿舍拉猫', 'http://pic1.jisuapi.cn/pet/upload/186.jpg', 0, 1005002, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (45089199008225250, '银狐犬', 'http://pic1.jisuapi.cn/pet/upload/18.jpg', 27, 1005000, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (49397618130312136, '中国狸花猫', 'http://pic1.jisuapi.cn/pet/upload/188.jpg', 21, 1005002, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (61938919340506540, '马恩岛猫', 'http://pic1.jisuapi.cn/pet/upload/196.jpg', 40, 1005002, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (63134920580833040, '银渐层猫', 'http://pic1.jisuapi.cn/pet/upload/203.jpg', 0, 1005002, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (65247718640620056, '西伯利亚森林猫', 'http://pic1.jisuapi.cn/pet/upload/190.jpg', 5, 1005002, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (65774718071210180, '拉邦猫', 'http://pic1.jisuapi.cn/pet/upload/183.jpg', 0, 1005002, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (73059420831111150, '奥西猫', 'http://pic1.jisuapi.cn/pet/upload/181.jpg', 50, 1005002, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (86934420831119300, '缅因猫', 'http://pic1.jisuapi.cn/pet/upload/195.jpg', 0, 1005002, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (87745818170425890, '美国短毛猫', 'http://pic1.jisuapi.cn/pet/upload/189.jpg', 34, 1005002, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (140000202206221820, '中华田园犬', 'http://pic1.jisuapi.cn/pet/upload/14.jpg', 0, 1005000, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (140002202206221820, '扭玻利顿犬', 'http://pic1.jisuapi.cn/pet/upload/29.jpg', 0, 1005000, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (230000200504155550, '中国细犬', 'http://pic1.jisuapi.cn/pet/upload/4.jpg', 0, 1005000, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (230560200504155550, '大丹犬', 'http://pic1.jisuapi.cn/pet/upload/19.jpg', 43, 1005000, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (410000199710157700, '德国牧羊犬', 'http://pic1.jisuapi.cn/pet/upload/9.jpg', 60, 1005000, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (410020199710157700, '泰迪犬', 'http://pic1.jisuapi.cn/pet/upload/24.jpg', 2, 1005000, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (420000198612257500, '美国恶霸犬', 'http://pic1.jisuapi.cn/pet/upload/6.jpg', 0, 1005000, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (420056198612257500, '蝴蝶犬', 'http://pic1.jisuapi.cn/pet/upload/21.jpg', 0, 1005000, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (440000200406247360, '法国斗牛犬', 'http://pic1.jisuapi.cn/pet/upload/10.jpg', 42, 1005000, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (440040200406247360, '边境牧羊犬', 'http://pic1.jisuapi.cn/pet/upload/25.jpg', 0, 1005000, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (450000199008225300, '博美犬', 'http://pic1.jisuapi.cn/pet/upload/3.jpg', 0, 1005000, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (460000198712186430, '小鹿犬', 'http://pic1.jisuapi.cn/pet/upload/8.jpg', 0, 1005000, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (460000199711031100, '拉布拉多', 'http://pic1.jisuapi.cn/pet/upload/1.jpg', 0, 1005000, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (460000199805023800, '金毛寻回犬', 'http://pic1.jisuapi.cn/pet/upload/2.jpg', 0, 1005000, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (460000200411221570, '芬兰波美拉尼亚丝毛狗', 'http://pic1.jisuapi.cn/pet/upload/12.jpg', 0, 1005000, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (460012199805023800, '比熊犬', 'http://pic1.jisuapi.cn/pet/upload/17.jpg', 0, 1005000, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (460200200411221570, '猎水獭犬', 'http://pic1.jisuapi.cn/pet/upload/27.jpg', 0, 1005000, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (460450198712186430, '寻血猎犬', 'http://pic1.jisuapi.cn/pet/upload/23.jpg', 0, 1005000, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (463220199711031100, '新斯科舍猎鸭寻猎犬', 'http://pic1.jisuapi.cn/pet/upload/16.jpg', 34, 1005000, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (520000199005145800, '兰波格犬', 'http://pic1.jisuapi.cn/pet/upload/5.jpg', 0, 1005000, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (520089199005145800, '萨摩耶犬', 'http://pic1.jisuapi.cn/pet/upload/20.jpg', 0, 1005000, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (520089199105145800, '边境牧羊犬', 'http://pic1.jisuapi.cn/pet/upload/25.jpg', 23, 1011020, 1, NULL, '2024-12-28 14:14:38', '2024-12-28 14:14:38');
INSERT INTO `products` VALUES (581328187006249500, '曼岛猫', 'http://pic1.jisuapi.cn/pet/upload/198.jpg', 0, 1005002, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (581328187006249900, '萨摩耶犬', 'http://pic1.jisuapi.cn/pet/upload/20.jpg', 43, 1019000, 1, NULL, '2024-12-28 14:16:10', '2024-12-28 14:16:10');
INSERT INTO `products` VALUES (656866181110177400, '豹猫', 'http://pic1.jisuapi.cn/pet/upload/186.jpg', 0, 1005002, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (710020198109191800, '吉娃娃', 'http://pic1.jisuapi.cn/pet/upload/28.jpg', 0, 1005000, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (710030198109191800, '史毕诺犬', 'http://pic1.jisuapi.cn/pet/upload/13.jpg', 0, 1005000, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (820000198009306500, '雪纳瑞犬', 'http://pic1.jisuapi.cn/pet/upload/11.jpg', 0, 1005000, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (820000199701298300, '捷克狼犬', 'http://pic1.jisuapi.cn/pet/upload/15.jpg', 54, 1005000, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (820000200006115200, '昆明犬', 'http://pic1.jisuapi.cn/pet/upload/7.jpg', 0, 1005000, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (820030198009306500, '哈士奇', 'http://pic1.jisuapi.cn/pet/upload/26.jpg', 43, 1005000, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (820230200006115200, '拉布拉多', 'http://pic1.jisuapi.cn/pet/upload/1.jpg', 45, 1043234, 1, NULL, '2024-12-28 14:17:33', '2024-12-28 14:17:33');
INSERT INTO `products` VALUES (820230269006115200, '圣伯纳犬', 'http://pic1.jisuapi.cn/pet/upload/22.jpg', 42, 1049734, 1, NULL, '2024-12-28 16:51:18', '2024-12-28 16:51:18');
INSERT INTO `products` VALUES (820560198009306500, '法国斗牛犬', 'http://pic1.jisuapi.cn/pet/upload/10.jpg', 0, 1043000, 0, NULL, '2024-12-28 14:16:49', '2024-12-28 14:16:49');
INSERT INTO `products` VALUES (820690199701298300, '兰波格犬', 'http://pic1.jisuapi.cn/pet/upload/5.jpg', 0, 1044300, 0, NULL, '2024-12-28 14:18:02', '2024-12-28 14:18:02');
INSERT INTO `products` VALUES (821874198812303300, '波斯猫', 'http://pic1.jisuapi.cn/pet/upload/201.jpg', 0, 1005002, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (822030198009306500, '吉娃娃', 'http://pic1.jisuapi.cn/pet/upload/28.jpg', 0, 1013001, 0, NULL, '2024-12-28 14:15:18', '2024-12-28 14:15:18');
INSERT INTO `products` VALUES (827800200006115200, '圣伯纳犬', 'http://pic1.jisuapi.cn/pet/upload/22.jpg', 0, 1005000, 1, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (832929204202103000, '澳大利亚雾猫', 'http://pic1.jisuapi.cn/pet/upload/193.jpg', 0, 1005002, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (874542185211306600, '热带草原猫', 'http://pic1.jisuapi.cn/pet/upload/185.jpg', 0, 1005002, 0, NULL, '2024-12-19 14:58:37', '2024-12-19 14:58:37');
INSERT INTO `products` VALUES (874542185219806600, '热带草原猫', 'http://pic1.jisuapi.cn/pet/upload/185.jpg', 0, 1010000, 1, NULL, '2024-12-28 14:06:07', '2024-12-28 14:06:07');

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
) ENGINE = InnoDB AUTO_INCREMENT = 437 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

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
INSERT INTO `sku_spec_values` VALUES (9, 41, 3);
INSERT INTO `sku_spec_values` VALUES (10, 14, 1);
INSERT INTO `sku_spec_values` VALUES (11, 28, 2);
INSERT INTO `sku_spec_values` VALUES (12, 46, 3);
INSERT INTO `sku_spec_values` VALUES (13, 36, 4);
INSERT INTO `sku_spec_values` VALUES (14, 38, 5);
INSERT INTO `sku_spec_values` VALUES (15, 29, 6);
INSERT INTO `sku_spec_values` VALUES (16, 29, 1);
INSERT INTO `sku_spec_values` VALUES (17, 2, 2);
INSERT INTO `sku_spec_values` VALUES (18, 32, 3);
INSERT INTO `sku_spec_values` VALUES (19, 44, 4);
INSERT INTO `sku_spec_values` VALUES (20, 14, 5);
INSERT INTO `sku_spec_values` VALUES (21, 47, 6);
INSERT INTO `sku_spec_values` VALUES (22, 26, 1);
INSERT INTO `sku_spec_values` VALUES (23, 46, 2);
INSERT INTO `sku_spec_values` VALUES (24, 42, 3);
INSERT INTO `sku_spec_values` VALUES (25, 14, 4);
INSERT INTO `sku_spec_values` VALUES (26, 53, 5);
INSERT INTO `sku_spec_values` VALUES (27, 5, 6);
INSERT INTO `sku_spec_values` VALUES (28, 31, 1);
INSERT INTO `sku_spec_values` VALUES (29, 28, 2);
INSERT INTO `sku_spec_values` VALUES (30, 45, 3);
INSERT INTO `sku_spec_values` VALUES (31, 34, 4);
INSERT INTO `sku_spec_values` VALUES (32, 32, 5);
INSERT INTO `sku_spec_values` VALUES (33, 4, 6);
INSERT INTO `sku_spec_values` VALUES (34, 34, 1);
INSERT INTO `sku_spec_values` VALUES (35, 45, 2);
INSERT INTO `sku_spec_values` VALUES (36, 12, 3);
INSERT INTO `sku_spec_values` VALUES (37, 36, 4);
INSERT INTO `sku_spec_values` VALUES (38, 32, 5);
INSERT INTO `sku_spec_values` VALUES (39, 54, 6);
INSERT INTO `sku_spec_values` VALUES (40, 9, 1);
INSERT INTO `sku_spec_values` VALUES (41, 48, 2);
INSERT INTO `sku_spec_values` VALUES (42, 46, 1);
INSERT INTO `sku_spec_values` VALUES (43, 30, 2);
INSERT INTO `sku_spec_values` VALUES (44, 11, 3);
INSERT INTO `sku_spec_values` VALUES (45, 20, 4);
INSERT INTO `sku_spec_values` VALUES (46, 14, 5);
INSERT INTO `sku_spec_values` VALUES (47, 7, 6);
INSERT INTO `sku_spec_values` VALUES (48, 48, 1);
INSERT INTO `sku_spec_values` VALUES (49, 53, 2);
INSERT INTO `sku_spec_values` VALUES (50, 12, 3);
INSERT INTO `sku_spec_values` VALUES (51, 11, 4);
INSERT INTO `sku_spec_values` VALUES (52, 18, 5);
INSERT INTO `sku_spec_values` VALUES (53, 55, 6);
INSERT INTO `sku_spec_values` VALUES (54, 1, 1);
INSERT INTO `sku_spec_values` VALUES (55, 7, 2);
INSERT INTO `sku_spec_values` VALUES (56, 29, 3);
INSERT INTO `sku_spec_values` VALUES (57, 14, 4);
INSERT INTO `sku_spec_values` VALUES (58, 38, 5);
INSERT INTO `sku_spec_values` VALUES (59, 38, 6);
INSERT INTO `sku_spec_values` VALUES (60, 20, 1);
INSERT INTO `sku_spec_values` VALUES (61, 40, 2);
INSERT INTO `sku_spec_values` VALUES (62, 31, 3);
INSERT INTO `sku_spec_values` VALUES (63, 35, 4);
INSERT INTO `sku_spec_values` VALUES (64, 24, 5);
INSERT INTO `sku_spec_values` VALUES (65, 17, 6);
INSERT INTO `sku_spec_values` VALUES (66, 10, 1);
INSERT INTO `sku_spec_values` VALUES (67, 54, 2);
INSERT INTO `sku_spec_values` VALUES (68, 18, 3);
INSERT INTO `sku_spec_values` VALUES (69, 40, 4);
INSERT INTO `sku_spec_values` VALUES (70, 33, 5);
INSERT INTO `sku_spec_values` VALUES (71, 46, 6);
INSERT INTO `sku_spec_values` VALUES (72, 22, 1);
INSERT INTO `sku_spec_values` VALUES (73, 25, 2);
INSERT INTO `sku_spec_values` VALUES (74, 6, 3);
INSERT INTO `sku_spec_values` VALUES (75, 6, 4);
INSERT INTO `sku_spec_values` VALUES (76, 15, 5);
INSERT INTO `sku_spec_values` VALUES (77, 54, 6);
INSERT INTO `sku_spec_values` VALUES (78, 21, 1);
INSERT INTO `sku_spec_values` VALUES (79, 21, 2);
INSERT INTO `sku_spec_values` VALUES (80, 43, 3);
INSERT INTO `sku_spec_values` VALUES (81, 40, 4);
INSERT INTO `sku_spec_values` VALUES (82, 18, 5);
INSERT INTO `sku_spec_values` VALUES (83, 23, 6);
INSERT INTO `sku_spec_values` VALUES (84, 4, 1);
INSERT INTO `sku_spec_values` VALUES (85, 7, 2);
INSERT INTO `sku_spec_values` VALUES (86, 23, 3);
INSERT INTO `sku_spec_values` VALUES (87, 38, 4);
INSERT INTO `sku_spec_values` VALUES (88, 13, 5);
INSERT INTO `sku_spec_values` VALUES (89, 2, 6);
INSERT INTO `sku_spec_values` VALUES (90, 27, 1);
INSERT INTO `sku_spec_values` VALUES (91, 18, 2);
INSERT INTO `sku_spec_values` VALUES (92, 8, 3);
INSERT INTO `sku_spec_values` VALUES (93, 40, 4);
INSERT INTO `sku_spec_values` VALUES (94, 11, 5);
INSERT INTO `sku_spec_values` VALUES (95, 43, 6);
INSERT INTO `sku_spec_values` VALUES (96, 16, 1);
INSERT INTO `sku_spec_values` VALUES (97, 7, 2);
INSERT INTO `sku_spec_values` VALUES (98, 39, 3);
INSERT INTO `sku_spec_values` VALUES (99, 11, 4);
INSERT INTO `sku_spec_values` VALUES (100, 49, 5);
INSERT INTO `sku_spec_values` VALUES (101, 44, 6);
INSERT INTO `sku_spec_values` VALUES (102, 17, 1);
INSERT INTO `sku_spec_values` VALUES (103, 7, 2);
INSERT INTO `sku_spec_values` VALUES (104, 41, 3);
INSERT INTO `sku_spec_values` VALUES (105, 16, 4);
INSERT INTO `sku_spec_values` VALUES (106, 11, 5);
INSERT INTO `sku_spec_values` VALUES (107, 9, 6);
INSERT INTO `sku_spec_values` VALUES (108, 10, 1);
INSERT INTO `sku_spec_values` VALUES (109, 24, 2);
INSERT INTO `sku_spec_values` VALUES (110, 32, 3);
INSERT INTO `sku_spec_values` VALUES (111, 35, 4);
INSERT INTO `sku_spec_values` VALUES (112, 24, 5);
INSERT INTO `sku_spec_values` VALUES (113, 15, 6);
INSERT INTO `sku_spec_values` VALUES (114, 55, 1);
INSERT INTO `sku_spec_values` VALUES (115, 12, 2);
INSERT INTO `sku_spec_values` VALUES (116, 5, 3);
INSERT INTO `sku_spec_values` VALUES (117, 42, 4);
INSERT INTO `sku_spec_values` VALUES (118, 31, 5);
INSERT INTO `sku_spec_values` VALUES (119, 29, 6);
INSERT INTO `sku_spec_values` VALUES (120, 49, 1);
INSERT INTO `sku_spec_values` VALUES (121, 48, 2);
INSERT INTO `sku_spec_values` VALUES (122, 38, 3);
INSERT INTO `sku_spec_values` VALUES (123, 45, 4);
INSERT INTO `sku_spec_values` VALUES (124, 3, 5);
INSERT INTO `sku_spec_values` VALUES (125, 42, 6);
INSERT INTO `sku_spec_values` VALUES (126, 36, 1);
INSERT INTO `sku_spec_values` VALUES (127, 53, 2);
INSERT INTO `sku_spec_values` VALUES (128, 47, 3);
INSERT INTO `sku_spec_values` VALUES (129, 20, 4);
INSERT INTO `sku_spec_values` VALUES (130, 14, 5);
INSERT INTO `sku_spec_values` VALUES (131, 11, 6);
INSERT INTO `sku_spec_values` VALUES (132, 11, 1);
INSERT INTO `sku_spec_values` VALUES (133, 24, 2);
INSERT INTO `sku_spec_values` VALUES (134, 28, 3);
INSERT INTO `sku_spec_values` VALUES (135, 15, 4);
INSERT INTO `sku_spec_values` VALUES (136, 44, 5);
INSERT INTO `sku_spec_values` VALUES (137, 8, 6);
INSERT INTO `sku_spec_values` VALUES (138, 21, 1);
INSERT INTO `sku_spec_values` VALUES (139, 23, 2);
INSERT INTO `sku_spec_values` VALUES (140, 51, 3);
INSERT INTO `sku_spec_values` VALUES (141, 21, 4);
INSERT INTO `sku_spec_values` VALUES (142, 8, 5);
INSERT INTO `sku_spec_values` VALUES (143, 31, 6);
INSERT INTO `sku_spec_values` VALUES (144, 20, 1);
INSERT INTO `sku_spec_values` VALUES (145, 9, 2);
INSERT INTO `sku_spec_values` VALUES (146, 36, 3);
INSERT INTO `sku_spec_values` VALUES (147, 46, 4);
INSERT INTO `sku_spec_values` VALUES (148, 9, 5);
INSERT INTO `sku_spec_values` VALUES (149, 17, 6);
INSERT INTO `sku_spec_values` VALUES (150, 1, 1);
INSERT INTO `sku_spec_values` VALUES (151, 10, 2);
INSERT INTO `sku_spec_values` VALUES (152, 47, 3);
INSERT INTO `sku_spec_values` VALUES (153, 40, 4);
INSERT INTO `sku_spec_values` VALUES (154, 2, 5);
INSERT INTO `sku_spec_values` VALUES (155, 55, 6);
INSERT INTO `sku_spec_values` VALUES (156, 49, 1);
INSERT INTO `sku_spec_values` VALUES (157, 26, 2);
INSERT INTO `sku_spec_values` VALUES (158, 36, 3);
INSERT INTO `sku_spec_values` VALUES (159, 48, 4);
INSERT INTO `sku_spec_values` VALUES (160, 22, 5);
INSERT INTO `sku_spec_values` VALUES (161, 18, 6);
INSERT INTO `sku_spec_values` VALUES (162, 26, 1);
INSERT INTO `sku_spec_values` VALUES (163, 19, 2);
INSERT INTO `sku_spec_values` VALUES (164, 17, 3);
INSERT INTO `sku_spec_values` VALUES (165, 27, 4);
INSERT INTO `sku_spec_values` VALUES (166, 27, 5);
INSERT INTO `sku_spec_values` VALUES (167, 55, 6);
INSERT INTO `sku_spec_values` VALUES (168, 29, 1);
INSERT INTO `sku_spec_values` VALUES (169, 34, 2);
INSERT INTO `sku_spec_values` VALUES (170, 26, 3);
INSERT INTO `sku_spec_values` VALUES (171, 31, 4);
INSERT INTO `sku_spec_values` VALUES (172, 18, 5);
INSERT INTO `sku_spec_values` VALUES (173, 52, 6);
INSERT INTO `sku_spec_values` VALUES (174, 40, 1);
INSERT INTO `sku_spec_values` VALUES (175, 44, 2);
INSERT INTO `sku_spec_values` VALUES (176, 45, 3);
INSERT INTO `sku_spec_values` VALUES (177, 38, 4);
INSERT INTO `sku_spec_values` VALUES (178, 52, 5);
INSERT INTO `sku_spec_values` VALUES (179, 37, 6);
INSERT INTO `sku_spec_values` VALUES (180, 30, 1);
INSERT INTO `sku_spec_values` VALUES (181, 39, 2);
INSERT INTO `sku_spec_values` VALUES (182, 49, 3);
INSERT INTO `sku_spec_values` VALUES (183, 18, 4);
INSERT INTO `sku_spec_values` VALUES (184, 50, 5);
INSERT INTO `sku_spec_values` VALUES (185, 33, 6);
INSERT INTO `sku_spec_values` VALUES (186, 15, 1);
INSERT INTO `sku_spec_values` VALUES (187, 31, 2);
INSERT INTO `sku_spec_values` VALUES (188, 52, 3);
INSERT INTO `sku_spec_values` VALUES (189, 2, 4);
INSERT INTO `sku_spec_values` VALUES (190, 19, 5);
INSERT INTO `sku_spec_values` VALUES (191, 35, 6);
INSERT INTO `sku_spec_values` VALUES (192, 6, 1);
INSERT INTO `sku_spec_values` VALUES (193, 33, 2);
INSERT INTO `sku_spec_values` VALUES (194, 39, 3);
INSERT INTO `sku_spec_values` VALUES (195, 38, 4);
INSERT INTO `sku_spec_values` VALUES (196, 17, 5);
INSERT INTO `sku_spec_values` VALUES (197, 28, 6);
INSERT INTO `sku_spec_values` VALUES (198, 32, 1);
INSERT INTO `sku_spec_values` VALUES (199, 21, 2);
INSERT INTO `sku_spec_values` VALUES (200, 7, 3);
INSERT INTO `sku_spec_values` VALUES (201, 27, 4);
INSERT INTO `sku_spec_values` VALUES (202, 2, 5);
INSERT INTO `sku_spec_values` VALUES (203, 41, 6);
INSERT INTO `sku_spec_values` VALUES (204, 33, 1);
INSERT INTO `sku_spec_values` VALUES (205, 39, 2);
INSERT INTO `sku_spec_values` VALUES (206, 44, 3);
INSERT INTO `sku_spec_values` VALUES (207, 47, 4);
INSERT INTO `sku_spec_values` VALUES (208, 47, 5);
INSERT INTO `sku_spec_values` VALUES (209, 36, 6);
INSERT INTO `sku_spec_values` VALUES (210, 42, 1);
INSERT INTO `sku_spec_values` VALUES (211, 44, 2);
INSERT INTO `sku_spec_values` VALUES (212, 39, 3);
INSERT INTO `sku_spec_values` VALUES (213, 8, 4);
INSERT INTO `sku_spec_values` VALUES (214, 31, 5);
INSERT INTO `sku_spec_values` VALUES (215, 22, 6);
INSERT INTO `sku_spec_values` VALUES (216, 16, 1);
INSERT INTO `sku_spec_values` VALUES (217, 14, 2);
INSERT INTO `sku_spec_values` VALUES (218, 22, 3);
INSERT INTO `sku_spec_values` VALUES (219, 11, 4);
INSERT INTO `sku_spec_values` VALUES (220, 46, 5);
INSERT INTO `sku_spec_values` VALUES (221, 30, 6);
INSERT INTO `sku_spec_values` VALUES (222, 13, 1);
INSERT INTO `sku_spec_values` VALUES (223, 28, 2);
INSERT INTO `sku_spec_values` VALUES (224, 44, 3);
INSERT INTO `sku_spec_values` VALUES (225, 27, 4);
INSERT INTO `sku_spec_values` VALUES (226, 2, 5);
INSERT INTO `sku_spec_values` VALUES (227, 38, 6);
INSERT INTO `sku_spec_values` VALUES (228, 19, 1);
INSERT INTO `sku_spec_values` VALUES (229, 36, 2);
INSERT INTO `sku_spec_values` VALUES (230, 10, 3);
INSERT INTO `sku_spec_values` VALUES (231, 55, 4);
INSERT INTO `sku_spec_values` VALUES (232, 22, 5);
INSERT INTO `sku_spec_values` VALUES (233, 1, 6);
INSERT INTO `sku_spec_values` VALUES (234, 50, 1);
INSERT INTO `sku_spec_values` VALUES (235, 24, 2);
INSERT INTO `sku_spec_values` VALUES (236, 26, 3);
INSERT INTO `sku_spec_values` VALUES (237, 1, 4);
INSERT INTO `sku_spec_values` VALUES (238, 37, 5);
INSERT INTO `sku_spec_values` VALUES (239, 16, 6);
INSERT INTO `sku_spec_values` VALUES (240, 25, 1);
INSERT INTO `sku_spec_values` VALUES (241, 19, 2);
INSERT INTO `sku_spec_values` VALUES (242, 21, 3);
INSERT INTO `sku_spec_values` VALUES (243, 46, 4);
INSERT INTO `sku_spec_values` VALUES (244, 3, 5);
INSERT INTO `sku_spec_values` VALUES (245, 41, 6);
INSERT INTO `sku_spec_values` VALUES (246, 28, 1);
INSERT INTO `sku_spec_values` VALUES (247, 20, 2);
INSERT INTO `sku_spec_values` VALUES (248, 16, 3);
INSERT INTO `sku_spec_values` VALUES (249, 18, 4);
INSERT INTO `sku_spec_values` VALUES (250, 42, 5);
INSERT INTO `sku_spec_values` VALUES (251, 46, 6);
INSERT INTO `sku_spec_values` VALUES (252, 48, 1);
INSERT INTO `sku_spec_values` VALUES (253, 47, 2);
INSERT INTO `sku_spec_values` VALUES (254, 34, 3);
INSERT INTO `sku_spec_values` VALUES (255, 30, 4);
INSERT INTO `sku_spec_values` VALUES (256, 46, 5);
INSERT INTO `sku_spec_values` VALUES (257, 28, 6);
INSERT INTO `sku_spec_values` VALUES (258, 4, 1);
INSERT INTO `sku_spec_values` VALUES (259, 45, 2);
INSERT INTO `sku_spec_values` VALUES (260, 48, 3);
INSERT INTO `sku_spec_values` VALUES (261, 50, 4);
INSERT INTO `sku_spec_values` VALUES (262, 52, 5);
INSERT INTO `sku_spec_values` VALUES (263, 51, 6);
INSERT INTO `sku_spec_values` VALUES (264, 46, 1);
INSERT INTO `sku_spec_values` VALUES (265, 22, 2);
INSERT INTO `sku_spec_values` VALUES (266, 25, 3);
INSERT INTO `sku_spec_values` VALUES (267, 3, 4);
INSERT INTO `sku_spec_values` VALUES (268, 49, 5);
INSERT INTO `sku_spec_values` VALUES (269, 17, 6);
INSERT INTO `sku_spec_values` VALUES (270, 48, 1);
INSERT INTO `sku_spec_values` VALUES (271, 22, 2);
INSERT INTO `sku_spec_values` VALUES (272, 23, 3);
INSERT INTO `sku_spec_values` VALUES (273, 45, 4);
INSERT INTO `sku_spec_values` VALUES (274, 48, 5);
INSERT INTO `sku_spec_values` VALUES (275, 50, 6);
INSERT INTO `sku_spec_values` VALUES (276, 48, 1);
INSERT INTO `sku_spec_values` VALUES (277, 38, 2);
INSERT INTO `sku_spec_values` VALUES (278, 42, 3);
INSERT INTO `sku_spec_values` VALUES (279, 42, 4);
INSERT INTO `sku_spec_values` VALUES (280, 30, 5);
INSERT INTO `sku_spec_values` VALUES (281, 22, 6);
INSERT INTO `sku_spec_values` VALUES (282, 20, 1);
INSERT INTO `sku_spec_values` VALUES (283, 35, 2);
INSERT INTO `sku_spec_values` VALUES (284, 4, 3);
INSERT INTO `sku_spec_values` VALUES (285, 23, 4);
INSERT INTO `sku_spec_values` VALUES (286, 49, 5);
INSERT INTO `sku_spec_values` VALUES (287, 12, 6);
INSERT INTO `sku_spec_values` VALUES (288, 21, 1);
INSERT INTO `sku_spec_values` VALUES (289, 15, 2);
INSERT INTO `sku_spec_values` VALUES (290, 11, 3);
INSERT INTO `sku_spec_values` VALUES (291, 10, 4);
INSERT INTO `sku_spec_values` VALUES (292, 16, 5);
INSERT INTO `sku_spec_values` VALUES (293, 47, 6);
INSERT INTO `sku_spec_values` VALUES (294, 25, 1);
INSERT INTO `sku_spec_values` VALUES (295, 36, 2);
INSERT INTO `sku_spec_values` VALUES (296, 51, 3);
INSERT INTO `sku_spec_values` VALUES (297, 35, 4);
INSERT INTO `sku_spec_values` VALUES (298, 24, 5);
INSERT INTO `sku_spec_values` VALUES (299, 14, 6);
INSERT INTO `sku_spec_values` VALUES (300, 50, 1);
INSERT INTO `sku_spec_values` VALUES (301, 46, 2);
INSERT INTO `sku_spec_values` VALUES (302, 21, 3);
INSERT INTO `sku_spec_values` VALUES (303, 23, 4);
INSERT INTO `sku_spec_values` VALUES (304, 52, 5);
INSERT INTO `sku_spec_values` VALUES (305, 23, 6);
INSERT INTO `sku_spec_values` VALUES (306, 16, 1);
INSERT INTO `sku_spec_values` VALUES (307, 12, 2);
INSERT INTO `sku_spec_values` VALUES (308, 8, 3);
INSERT INTO `sku_spec_values` VALUES (309, 5, 4);
INSERT INTO `sku_spec_values` VALUES (310, 55, 5);
INSERT INTO `sku_spec_values` VALUES (311, 39, 6);
INSERT INTO `sku_spec_values` VALUES (312, 30, 1);
INSERT INTO `sku_spec_values` VALUES (313, 33, 2);
INSERT INTO `sku_spec_values` VALUES (314, 18, 3);
INSERT INTO `sku_spec_values` VALUES (315, 46, 4);
INSERT INTO `sku_spec_values` VALUES (316, 12, 5);
INSERT INTO `sku_spec_values` VALUES (317, 30, 6);
INSERT INTO `sku_spec_values` VALUES (318, 4, 1);
INSERT INTO `sku_spec_values` VALUES (319, 39, 2);
INSERT INTO `sku_spec_values` VALUES (320, 19, 3);
INSERT INTO `sku_spec_values` VALUES (321, 33, 4);
INSERT INTO `sku_spec_values` VALUES (322, 51, 5);
INSERT INTO `sku_spec_values` VALUES (323, 47, 6);
INSERT INTO `sku_spec_values` VALUES (324, 26, 1);
INSERT INTO `sku_spec_values` VALUES (325, 44, 2);
INSERT INTO `sku_spec_values` VALUES (326, 32, 3);
INSERT INTO `sku_spec_values` VALUES (327, 28, 4);
INSERT INTO `sku_spec_values` VALUES (328, 42, 5);
INSERT INTO `sku_spec_values` VALUES (329, 14, 6);
INSERT INTO `sku_spec_values` VALUES (330, 54, 1);
INSERT INTO `sku_spec_values` VALUES (331, 9, 2);
INSERT INTO `sku_spec_values` VALUES (332, 45, 3);
INSERT INTO `sku_spec_values` VALUES (333, 35, 4);
INSERT INTO `sku_spec_values` VALUES (334, 41, 5);
INSERT INTO `sku_spec_values` VALUES (335, 41, 6);
INSERT INTO `sku_spec_values` VALUES (336, 27, 1);
INSERT INTO `sku_spec_values` VALUES (337, 13, 2);
INSERT INTO `sku_spec_values` VALUES (338, 36, 3);
INSERT INTO `sku_spec_values` VALUES (339, 32, 4);
INSERT INTO `sku_spec_values` VALUES (340, 50, 5);
INSERT INTO `sku_spec_values` VALUES (341, 43, 6);
INSERT INTO `sku_spec_values` VALUES (342, 12, 1);
INSERT INTO `sku_spec_values` VALUES (343, 41, 2);
INSERT INTO `sku_spec_values` VALUES (344, 4, 3);
INSERT INTO `sku_spec_values` VALUES (345, 6, 4);
INSERT INTO `sku_spec_values` VALUES (346, 17, 5);
INSERT INTO `sku_spec_values` VALUES (347, 9, 6);
INSERT INTO `sku_spec_values` VALUES (348, 52, 1);
INSERT INTO `sku_spec_values` VALUES (349, 12, 2);
INSERT INTO `sku_spec_values` VALUES (350, 11, 3);
INSERT INTO `sku_spec_values` VALUES (351, 21, 4);
INSERT INTO `sku_spec_values` VALUES (352, 17, 5);
INSERT INTO `sku_spec_values` VALUES (353, 20, 6);
INSERT INTO `sku_spec_values` VALUES (354, 50, 1);
INSERT INTO `sku_spec_values` VALUES (355, 24, 2);
INSERT INTO `sku_spec_values` VALUES (356, 26, 3);
INSERT INTO `sku_spec_values` VALUES (357, 1, 4);
INSERT INTO `sku_spec_values` VALUES (358, 36, 5);
INSERT INTO `sku_spec_values` VALUES (359, 11, 6);
INSERT INTO `sku_spec_values` VALUES (360, 3, 1);
INSERT INTO `sku_spec_values` VALUES (361, 34, 2);
INSERT INTO `sku_spec_values` VALUES (362, 53, 3);
INSERT INTO `sku_spec_values` VALUES (363, 52, 4);
INSERT INTO `sku_spec_values` VALUES (364, 45, 5);
INSERT INTO `sku_spec_values` VALUES (365, 14, 6);
INSERT INTO `sku_spec_values` VALUES (366, 46, 1);
INSERT INTO `sku_spec_values` VALUES (367, 20, 2);
INSERT INTO `sku_spec_values` VALUES (368, 15, 3);
INSERT INTO `sku_spec_values` VALUES (369, 17, 4);
INSERT INTO `sku_spec_values` VALUES (370, 41, 5);
INSERT INTO `sku_spec_values` VALUES (371, 42, 6);
INSERT INTO `sku_spec_values` VALUES (372, 33, 1);
INSERT INTO `sku_spec_values` VALUES (373, 36, 2);
INSERT INTO `sku_spec_values` VALUES (374, 27, 3);
INSERT INTO `sku_spec_values` VALUES (375, 27, 4);
INSERT INTO `sku_spec_values` VALUES (376, 53, 5);
INSERT INTO `sku_spec_values` VALUES (377, 19, 6);
INSERT INTO `sku_spec_values` VALUES (378, 47, 1);
INSERT INTO `sku_spec_values` VALUES (379, 12, 2);
INSERT INTO `sku_spec_values` VALUES (380, 28, 3);
INSERT INTO `sku_spec_values` VALUES (381, 48, 4);
INSERT INTO `sku_spec_values` VALUES (382, 45, 5);
INSERT INTO `sku_spec_values` VALUES (383, 25, 6);
INSERT INTO `sku_spec_values` VALUES (384, 46, 1);
INSERT INTO `sku_spec_values` VALUES (385, 43, 2);
INSERT INTO `sku_spec_values` VALUES (386, 23, 3);
INSERT INTO `sku_spec_values` VALUES (387, 42, 4);
INSERT INTO `sku_spec_values` VALUES (388, 27, 5);
INSERT INTO `sku_spec_values` VALUES (389, 10, 6);
INSERT INTO `sku_spec_values` VALUES (390, 23, 1);
INSERT INTO `sku_spec_values` VALUES (391, 28, 2);
INSERT INTO `sku_spec_values` VALUES (392, 15, 3);
INSERT INTO `sku_spec_values` VALUES (393, 49, 4);
INSERT INTO `sku_spec_values` VALUES (394, 32, 5);
INSERT INTO `sku_spec_values` VALUES (395, 12, 6);
INSERT INTO `sku_spec_values` VALUES (396, 18, 1);
INSERT INTO `sku_spec_values` VALUES (397, 1, 2);
INSERT INTO `sku_spec_values` VALUES (398, 5, 3);
INSERT INTO `sku_spec_values` VALUES (399, 20, 4);
INSERT INTO `sku_spec_values` VALUES (400, 29, 5);
INSERT INTO `sku_spec_values` VALUES (401, 30, 6);
INSERT INTO `sku_spec_values` VALUES (402, 7, 1);
INSERT INTO `sku_spec_values` VALUES (403, 55, 2);
INSERT INTO `sku_spec_values` VALUES (404, 35, 3);
INSERT INTO `sku_spec_values` VALUES (405, 9, 4);
INSERT INTO `sku_spec_values` VALUES (406, 51, 5);
INSERT INTO `sku_spec_values` VALUES (407, 7, 6);
INSERT INTO `sku_spec_values` VALUES (408, 44, 1);
INSERT INTO `sku_spec_values` VALUES (409, 37, 2);
INSERT INTO `sku_spec_values` VALUES (410, 51, 3);
INSERT INTO `sku_spec_values` VALUES (411, 33, 4);
INSERT INTO `sku_spec_values` VALUES (412, 12, 5);
INSERT INTO `sku_spec_values` VALUES (413, 15, 6);
INSERT INTO `sku_spec_values` VALUES (414, 40, 1);
INSERT INTO `sku_spec_values` VALUES (415, 42, 2);
INSERT INTO `sku_spec_values` VALUES (416, 34, 3);
INSERT INTO `sku_spec_values` VALUES (417, 45, 4);
INSERT INTO `sku_spec_values` VALUES (418, 12, 5);
INSERT INTO `sku_spec_values` VALUES (419, 33, 6);
INSERT INTO `sku_spec_values` VALUES (420, 20, 1);
INSERT INTO `sku_spec_values` VALUES (421, 2, 2);
INSERT INTO `sku_spec_values` VALUES (422, 2, 3);
INSERT INTO `sku_spec_values` VALUES (423, 5, 4);
INSERT INTO `sku_spec_values` VALUES (424, 16, 5);
INSERT INTO `sku_spec_values` VALUES (425, 12, 6);
INSERT INTO `sku_spec_values` VALUES (426, 13, 1);
INSERT INTO `sku_spec_values` VALUES (427, 25, 2);
INSERT INTO `sku_spec_values` VALUES (428, 34, 3);
INSERT INTO `sku_spec_values` VALUES (429, 37, 4);
INSERT INTO `sku_spec_values` VALUES (430, 30, 5);
INSERT INTO `sku_spec_values` VALUES (431, 36, 6);
INSERT INTO `sku_spec_values` VALUES (432, 35, 1);
INSERT INTO `sku_spec_values` VALUES (433, 12, 2);
INSERT INTO `sku_spec_values` VALUES (434, 8, 3);
INSERT INTO `sku_spec_values` VALUES (435, 7, 4);
INSERT INTO `sku_spec_values` VALUES (436, 7, 5);
INSERT INTO `sku_spec_values` VALUES (437, 13, 6);

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
) ENGINE = InnoDB AUTO_INCREMENT = 55 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

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
INSERT INTO `skus` VALUES (9, 44125718070616480, 1994.84, 50, 0.16, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (10, 45089199008225250, 1546.34, 50, 0.38, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (11, 49397618130312136, 1426.88, 50, 0.35, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (12, 61938919340506540, 1193.59, 50, 0.51, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (13, 63134920580833040, 1836.24, 50, 0.37, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (14, 65247718640620056, 1146.35, 50, 0.25, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (15, 65774718071210180, 1254.40, 50, 0.52, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (16, 73059420831111150, 1516.52, 50, 0.27, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (17, 86934420831119300, 1524.30, 50, 0.19, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (18, 87745818170425890, 1313.01, 50, 0.52, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
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
INSERT INTO `skus` VALUES (33, 460000200411221570, 1401.34, 50, 0.00, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (34, 460012199805023800, 1718.09, 50, 0.16, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (35, 460200200411221570, 1031.67, 50, 0.36, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (36, 460450198712186430, 1138.85, 50, 0.21, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (37, 463220199711031100, 1353.13, 50, 0.35, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (38, 520000199005145800, 1459.77, 50, 0.54, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (39, 520089199005145800, 1557.58, 50, 0.56, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (40, 581328187006249500, 1455.99, 50, 0.56, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (41, 656866181110177400, 1645.65, 50, 0.51, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (42, 710020198109191800, 1163.37, 50, 0.29, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (43, 710030198109191800, 1293.27, 50, 0.31, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (44, 820000198009306500, 1101.80, 50, 0.57, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (45, 820000199701298300, 1294.68, 50, 0.33, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (46, 820000200006115200, 1682.73, 50, 0.35, '2024-12-22 16:23:03', '2024-12-22 16:23:03');
INSERT INTO `skus` VALUES (47, 874542185219806600, 1892.36, 50, 0.48, '2024-12-28 14:13:35', '2024-12-28 14:13:35');
INSERT INTO `skus` VALUES (48, 520089199105145800, 1569.14, 50, 0.00, '2024-12-28 14:21:18', '2024-12-28 14:21:18');
INSERT INTO `skus` VALUES (49, 874542185211306600, 1436.23, 50, 0.89, '2024-12-28 14:22:15', '2024-12-28 14:22:15');
INSERT INTO `skus` VALUES (50, 581328187006249900, 1036.32, 50, 0.10, '2024-12-28 14:22:54', '2024-12-28 14:22:54');
INSERT INTO `skus` VALUES (51, 820560198009306500, 1263.36, 50, 0.00, '2024-12-28 14:23:20', '2024-12-28 14:23:20');
INSERT INTO `skus` VALUES (52, 820230200006115200, 1456.36, 50, 0.12, '2024-12-28 14:23:42', '2024-12-28 14:23:42');
INSERT INTO `skus` VALUES (53, 820690199701298300, 1363.32, 50, 0.23, '2024-12-28 14:24:01', '2024-12-28 14:24:01');
INSERT INTO `skus` VALUES (54, 822030198009306500, 1632.36, 50, 0.36, '2024-12-28 16:49:57', '2024-12-28 16:49:57');
INSERT INTO `skus` VALUES (55, 820230269006115200, 1452.36, 50, 0.65, '2024-12-28 16:52:07', '2024-12-28 16:52:07');

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
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_addresses
-- ----------------------------
INSERT INTO `user_addresses` VALUES (1, 1, '广东省广州市天河区某某街道某某小区', '广州', '1', '61923', '中国', 0, '周杰伦', '123123');
INSERT INTO `user_addresses` VALUES (2, 1, '广东省广州市白云区某某街道某某小区', NULL, '1', NULL, NULL, 0, '周杰伦2', '8097087');
INSERT INTO `user_addresses` VALUES (3, 1, '123', NULL, NULL, NULL, NULL, 0, '周杰伦3', '123123123');
INSERT INTO `user_addresses` VALUES (4, 1, 'fsdafadsfa', NULL, NULL, NULL, NULL, 0, '周杰伦4', '123123123');
INSERT INTO `user_addresses` VALUES (5, 1, '1231233123', NULL, NULL, NULL, NULL, 0, '陈奕迅', '1231233');
INSERT INTO `user_addresses` VALUES (6, 4, '123123132', NULL, NULL, NULL, NULL, 0, '周杰伦', '123132');
INSERT INTO `user_addresses` VALUES (7, 1, '124123123', NULL, NULL, NULL, NULL, 1, 'jay', '1233123');

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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, '周杰伦', '123456', '123456789.com', '1234567890', '2025-01-13 16:07:56');
INSERT INTO `users` VALUES (2, '周杰伦123', '123456', '123', '123', '2025-01-31 10:45:23');
INSERT INTO `users` VALUES (3, '123456', '123456', '1233', '123312', '2025-01-31 10:49:31');
INSERT INTO `users` VALUES (4, '陈奕迅', '123456', '123123', '3123123', '2025-02-03 13:59:51');

SET FOREIGN_KEY_CHECKS = 1;
