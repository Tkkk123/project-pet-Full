var express = require("express");
var router = express.Router();
const dbconfig = require("../util/dbconfig");
const response = require("../util/responseHandler");

const interface = "PetData";

// 查询所有产品及其对应的SKU信息
router.get(`/${interface}`, function (req, res, next) {
  const sql = `
    SELECT 
       p.id AS product_id,
       p.name AS product_name,
       p.img AS product_img,
       p.category_id,
       c.id AS category_id,
       c.main_title AS category_main_title,
       c.sub_title AS category_sub_title,
       c.picture AS category_picture,
       s.price AS sku_price,
       s.discount AS sku_discount,
       s.quantity AS sku_quantity
    FROM products p
    JOIN categories c ON p.category_id = c.id
    JOIN skus s ON p.id = s.product_id;
  `;

  dbconfig.sqlConnect(sql, [], (err, data) => {
    if (err) {
      console.error(interface + "接口连接失败", err);
      return response.error(res, err, "数据库连接失败");
    }
    const processedData = processData(data); // 处理查询结果
    response.success(res, processedData, "获取商品列表成功");
  });
});

// 处理查询结果，将产品数据按分类分组，每个分类随机抽取 9 个产品
function processData(products) {
  const categorized = {};

  products.forEach((product) => {
    const categoryId = product.category_id;

    if (!categorized[categoryId]) {
      categorized[categoryId] = {
        category_id: categoryId,
        category_main_title: product.category_main_title,
        category_sub_title: product.category_sub_title,
        category_picture: product.category_picture,
        products: [],
      };
    }

    categorized[categoryId].products.push({
      id: product.product_id,
      name: product.product_name,
      img: product.product_img,
      sku: {
        price: product.sku_price,
        quantity: product.sku_quantity,
        discount: product.sku_discount,
      },
    });
  });

  // 转换为数组
  const categoryArray = Object.values(categorized);

  // 每个分类随机抽取最多 9 个产品
  categoryArray.forEach((category) => {
    category.products = randomSample(category.products, 9);
  });

  return categoryArray;
}

// 随机选择 n 个元素
function randomSample(array, n) {
  if (array.length <= n) return array;

  const shuffled = array.slice();
  for (let i = shuffled.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
  }
  return shuffled.slice(0, n);
}

module.exports = router;