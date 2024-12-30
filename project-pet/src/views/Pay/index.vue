<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { createOrderAPI, updateOrderStatus } from '@/apis/checkout'

const route = useRoute()
const router = useRouter()
const orderId = ref(route.query.orderId)
const countdown = ref(1800) // 30分钟支付倒计时
const timer = ref(null)
const totalAmount = ref(route.query.totalAmount || '0.00') // 从路由获取订单金额
const redirect = ref(route.query.redirect)

// 选择支付方式并直接触发支付
const handlePay = async () => {
  try {
    // 更新订单状态为已完成
    const res = await updateOrderStatus(orderId.value, 'completed')
    if (res.code === 200) {
      ElMessage.success('支付成功')
      // 跳转到订单列表页，显示已完成标签
      router.push(redirect.value || '/member/order?tab=complete')
    } else {
      ElMessage.error(res.message || '支付失败')
    }
  } catch (error) {
    console.error('支付处理失败:', error)
    ElMessage.error('支付失败，请稍后重试')
  }
}

// 取消支付
const cancelPay = () => {
  router.push('/member/order?tab=unpay')
}

// 格式化倒计时
const formatTime = (time) => {
  const minutes = Math.floor(time / 60)
  const seconds = time % 60
  return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`
}

// 开始倒计时
const startCountdown = () => {
  timer.value = setInterval(() => {
    if (countdown.value > 0) {
      countdown.value--
    } else {
      clearInterval(timer.value)
      ElMessage.warning('支付超时，订单已取消')
      router.push('/member/order')
    }
  }, 1000)
}

onMounted(() => {
  if (!orderId.value || !totalAmount.value) {
    ElMessage.error('订单信息不完整')
    router.push('/member/order')
  }
  startCountdown()
})

onUnmounted(() => {
  if (timer.value) {
    clearInterval(timer.value)
  }
})
</script>

<template>
  <div class="xtx-pay-page">
    <div class="container">
      <div class="wrapper">
        <!-- 付款信息 -->
        <div class="pay-info">
          <div class="tip">
            <div class="status">订单提交成功！请尽快完成支付。</div>
            <div class="countdown">支付剩余时间：{{ formatTime(countdown) }}</div>
            <div class="amount">
              <span>应付总额：</span>
              <span class="price">¥{{ totalAmount }}</span>
            </div>
            <div class="order-id">订单编号：{{ orderId }}</div>
          </div>
        </div>
        <!-- 付款方式 -->
        <div class="pay-type">
          <p class="head">选择以下支付方式付款</p>
          <div class="item">
            <p>支付平台</p>
            <a class="btn wx" @click="handlePay" href="javascript:;"></a>
            <a class="btn alipay" @click="handlePay" href="javascript:;"></a>
          </div>
          <div class="item">
            <p>支付方式</p>
            <a class="btn" @click="handlePay">招商银行</a>
            <a class="btn" @click="handlePay">工商银行</a>
            <a class="btn" @click="handlePay">建设银行</a>
            <a class="btn" @click="handlePay">农业银行</a>
            <a class="btn" @click="handlePay">交通银行</a>
          </div>
        </div>
        <div class="pay-actions">
          <el-button type="primary" size="large" @click="handlePay">
            确认支付
          </el-button>
          <el-button size="large" @click="cancelPay">
            取消支付
          </el-button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped lang="less">
.xtx-pay-page {
  background: #f5f5f5;
  padding: 20px 0;

  .container {
    padding: 0 20px;
  }

  .wrapper {
    background: #fff;
    padding: 20px 0;
  }
}

.pay-info {
  background: #fff;
  padding: 40px 0;
  text-align: center;

  .tip {
    .status {
      font-size: 24px;
      font-weight: 500;
      margin-bottom: 10px;
    }

    .countdown {
      color: #999;
      font-size: 14px;
      margin-bottom: 15px;
    }

    .amount {
      margin-bottom: 10px;

      span {
        &:first-child {
          font-size: 16px;
          color: #999;
        }

        &.price {
          color: #ff6b35;
          font-size: 24px;
          font-weight: 500;
          margin-left: 5px;
        }
      }
    }

    .order-id {
      font-size: 14px;
      color: #999;
    }
  }
}

.pay-type {
  margin-top: 20px;
  padding: 0 40px 40px;

  .head {
    font-size: 16px;
    font-weight: 500;
    padding: 20px 0;
    border-bottom: 1px solid #f5f5f5;
    margin-bottom: 20px;
  }

  .item {
    margin-bottom: 30px;

    p {
      font-size: 14px;
      margin-bottom: 15px;
      color: #666;
    }

    .btn {
      width: 150px;
      height: 50px;
      border: 1px solid #e4e4e4;
      text-align: center;
      line-height: 48px;
      margin-right: 20px;
      color: #666666;
      display: inline-block;
      cursor: pointer;
      transition: all 0.3s;

      &:hover {
        border-color: #ff6b35;
        color: #ff6b35;
      }

      &.alipay {
        background: url(https://cdn.cnbj1.fds.api.mi-img.com/mi-mall/7b6b02396368c9314528c0bbd85a2e06.png) no-repeat center / contain;
      }

      &.wx {
        background: url(https://cdn.cnbj1.fds.api.mi-img.com/mi-mall/c66f98cff8649bd5ba722c2e8067c6ca.jpg) no-repeat center / contain;
      }
    }
  }
}

.pay-actions {
  margin-top: 20px;
  text-align: center;

  .el-button {
    margin: 0 10px;
    min-width: 120px;
  }
}
</style>