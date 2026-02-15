const express = require("express");
const verifyToken = require("../middleware/verifyToken");

const router = express.Router();

// 登录状态检测接口
router.get("/check-auth", verifyToken, (req, res) => {
    return res.json({
        code: 200,
        message: "已登录",
        data: {
            userId: req.user.userId,
            account: req.user.account
        }
    });
});

module.exports = router;
