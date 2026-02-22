const express = require("express");
const verifyToken = require("../middleware/verifyToken");
const dbPromise = require("../util/dbPromise");
const response = require("../util/responseHandler");

const router = express.Router();

router.get("/reminders", verifyToken, async (req, res) => {
  try {
    const userId = req.user?.id ?? req.user?.userId;

    // 获取用户所有宠物
    const pets = await dbPromise.query(
      "SELECT id, name, daily_food_ratio FROM pets WHERE user_id = ?",
      [userId]
    );

    if (!pets || pets.length === 0) {
      response.success(res, [], "该用户没有宠物");
      return;
    }

    const reminders = [];

    for (const pet of pets) {
      // 查询该宠物最近的狗粮/猫粮订单
      const orders = await dbPromise.query(
        `SELECT od.quantity, od.estimated_days, o.created_at, p.name AS product_name
         FROM order_details od
         INNER JOIN orders o ON od.order_id = o.id
         INNER JOIN products p ON od.product_id = p.id
         WHERE o.user_id = ? AND p.category_id IN (2,3)
         ORDER BY o.created_at DESC
         LIMIT 1`,
        [userId]
      );

      if (!orders || orders.length === 0) continue;

      const lastOrder = orders[0];
      const quantity = Number(lastOrder.quantity);
      const estimatedDaysFromDb = Number(lastOrder.estimated_days);
      const dailyFood = Number(pet.daily_food_ratio);

      // 计算预计天数
      let estimatedDays = 0;
      if (!isNaN(estimatedDaysFromDb) && estimatedDaysFromDb > 0) {
        estimatedDays = estimatedDaysFromDb;
      } else if (!isNaN(dailyFood) && dailyFood > 0) {
        estimatedDays = Math.floor(quantity / dailyFood);
      } else {
        estimatedDays = quantity;
      }

      // 计算已过去天数
      const createdAt = new Date(lastOrder.created_at);
      const elapsedDays = isNaN(createdAt.getTime())
        ? 0
        : Math.floor((Date.now() - createdAt.getTime()) / (1000 * 60 * 60 * 24));

      const remainingDays = Math.max(0, estimatedDays - elapsedDays);
      const needReminder = remainingDays < 3;

      reminders.push({
        petId: pet.id,
        petName: pet.name,
        productName: lastOrder.product_name,
        remainingDays,
        needReminder
      });
    }

    response.success(res, reminders, "获取所有宠物消耗品提醒成功");
  } catch (error) {
    response.error(res, error, "获取提醒失败");
  }
});

module.exports = router;
