var express = require("express");
var router = express.Router();
const dbconfig = require("../util/dbconfig");
const interface = "PetData";
const response = require("../util/responseHandler");

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

  let sqlArr = [];
  const callBack = (err, data) => {
    if (err) {
      console.log(interface + "接口连接失败");
      response.error(res, err, "数据库连接失败");
    } else {
      const processedData = processData(data); // 处理查询结果
      response.success(res, processedData, "获取商品列表成功");
    }
  };
  dbconfig.sqlConnect(sql, sqlArr, callBack);
});

// 处理查询结果，将产品数据按分类分组，并进行随机筛选
function processData(products) {
  const categorized = {};

  // 按分类分组产品
  products.forEach((product) => {
    const categoryId = product.category_id;

    if (!categorized[categoryId]) {
      categorized[categoryId] = {
        category_id: categoryId,
        category_main_title: product.category_main_title,// 获取分类名称
        category_sub_title: product.category_sub_title,
        category_picture: product.category_picture,
        products: [], // 产品数组
      };
    }

    categorized[categoryId].products.push({
      id: product.product_id,
      name: product.product_name,
      img: product.product_img,
      sku: {
        price: product.sku_price, // 从 skus 表获取 SKU 价格
        quantity: product.sku_quantity, // 从 skus 表获取库存
        discount: product.sku_discount, // 从 skus 表获取折扣
      },
    });
  });

  // 将分类对象转换为数组
  let categoryArray = Object.values(categorized);

  // 随机获取分类
  categoryArray = randomSample(categoryArray, 8);

  // 对每个分类中的产品进行随机抽取 9 个
  categoryArray.forEach((category) => {
    category.products = randomSample(category.products, 9);
  });

  return categoryArray;
}

// 随机选择 n 个元素
function randomSample(array, n) {
  // 如果数组长度小于 n，直接返回整个数组
  if (array.length <= n) return array;

  // 复制一份数组进行洗牌
  const shuffled = array.slice();
  for (let i = shuffled.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
  }

  // 返回前 n 个元素
  return shuffled.slice(0, n);
}

module.exports = router;
