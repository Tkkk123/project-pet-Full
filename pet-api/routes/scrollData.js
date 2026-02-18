var express = require("express");
var router = express.Router();
const dbconfig = require("../util/dbconfig");
const interface = "ScrollData";
const response = require("../util/responseHandler");

// 查询数据并返回
router.get(`/${interface}`, function (req, res, next) {
  const sql = `
    SELECT 
       p.id AS product_id,
       p.name AS product_name,
       p.img AS product_img,
       p.category_id,
       c.id AS category_id,
       s.price AS sku_price,
       s.discount AS sku_discount
    FROM products p
    JOIN categories c ON p.category_id = c.id
    JOIN skus s ON p.id = s.product_id
    ORDER BY p.order_num DESC
    LIMIT 20;
  `;

  let sqlArr = [];
  const callBack = (err, data) => {
    if (err) {
      console.log(interface + "接口连接失败");
      response.error(res, err, "数据库连接失败");
    } else {
      response.success(res, formatScrollData(data), "获取轮播数据成功");
    }
  };

  // 执行 SQL 查询
  dbconfig.sqlConnect(sql, sqlArr, callBack);
});

// 格式化返回数据
function formatScrollData(products) {
  const main_title = "热门宠物";
  const sub_title = "劲爆来袭";
  return {
    main_title,
    sub_title,
    products,  // 将数据库返回的产品数据作为属性
  };
}

module.exports = router;
