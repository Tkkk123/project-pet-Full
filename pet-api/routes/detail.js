const express = require("express");
const router = express.Router();
const dbconfig = require("../util/dbconfig");
const dayjs = require("dayjs");
const response = require("../util/responseHandler");

// 查询商品详情
router.get('/products/:id', async (req, res) => {
    const productId = req.params.id;

    const sql = `
        SELECT 
            p.id AS product_id,
            p.name AS product_name,
            p.img AS product_img,
            p.order_num AS product_order_num,
            p.description AS product_description,
            p.created_at AS product_created_at,
            s.price AS sku_price,
            s.quantity AS sku_quantity,
            c.main_title AS category_main_title,
            spe.name AS special_name,
            speValue.value AS specification_value
        FROM products p
        LEFT JOIN categories c ON p.category_id = c.id
        LEFT JOIN skus s ON s.product_id = p.id
        LEFT JOIN sku_spec_values ssv ON s.id = ssv.sku_id
        LEFT JOIN spec_values speValue ON speValue.id = ssv.spec_value_id
        LEFT JOIN specifications spe ON spe.id = speValue.specification_id
        WHERE p.id = ?
    `;

    try {
        const data = await new Promise((resolve, reject) => {
            dbconfig.sqlConnect(sql, [productId], (err, result) => {
                if (err) reject(err);
                else resolve(result);
            });
        });

        // 检查商品是否存在
        if (!data || data.length === 0) {
            return response.error(res, new Error('商品不存在'), '商品不存在或已下架', 404);
        }

        // 检查商品是否有完整信息
        if (!data[0].product_name || !data[0].product_img) {
            return response.error(res, new Error('商品信息不完整'), '商品信息不完整', 400);
        }

        // 检查库存
        if (data[0].sku_quantity <= 0) {
            return response.success(res, assign(data), '商品已售罄');
        }

        // 检查规格信息
        if (!data.some(item => item.special_name && item.specification_value)) {
            return response.success(res, assign(data), '商品规格信息暂未设置');
        }

        response.success(res, assign(data), '获取商品详情成功');

    } catch (error) {
        response.error(res, error, '获取商品详情失败');
    }
});

// 规格合并函数
function assign(data) {
    if (!data || data.length === 0) return null;

    let DetailData = {};
    data.forEach(element => {
        if (!DetailData[element.product_id]) {
            DetailData[element.product_id] = {
                product_id: element.product_id,
                product_name: element.product_name,
                product_img: element.product_img,
                product_order_num: element.product_order_num || 0,
                product_description: element.product_description || '',
                product_created_at: formatDate(element.product_created_at),
                sku_price: element.sku_price || 0,
                sku_quantity: element.sku_quantity || 0,
                category_main_title: element.category_main_title || '未分类',
                specifications: {}
            };
        }

        // 只有当规格信息存在时才添加
        if (element.special_name && element.specification_value) {
            if (!DetailData[element.product_id].specifications[element.special_name]) {
                DetailData[element.product_id].specifications[element.special_name] = [];
            }
            if (!DetailData[element.product_id].specifications[element.special_name]
                .includes(element.specification_value)) {
                DetailData[element.product_id].specifications[element.special_name]
                    .push(element.specification_value);
            }
        }
    });

    // 转换规格格式
    Object.keys(DetailData).forEach(productId => {
        DetailData[productId].specifications = Object.keys(DetailData[productId].specifications)
            .map(specialName => ({
                special_name: specialName,
                specification_values: DetailData[productId].specifications[specialName]
            }));
    });

    return Object.values(DetailData);
}

function formatDate(date) {
    return date ? dayjs(date).format('YYYY-MM-DD') : '';
}

module.exports = router;
