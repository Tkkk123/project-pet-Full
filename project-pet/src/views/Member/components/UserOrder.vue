<script setup>
import { getUserOrder, updateOrderStatus } from '@/apis/checkout'
import { ref, onMounted, reactive } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'

const router = useRouter()
const route = useRoute()
const currentTab = ref('all')
const loading = ref(false)
const state = reactive({ orderList: [] })

// tab列表
const tabTypes = [
  { name: "all", label: "全部订单" },
  { name: "unpay", label: "待付款" },
  { name: "complete", label: "已完成" },
  { name: "cancel", label: "已取消" }
]

// 状态映射
const typeMap = {
  'all': 'all',
  'unpay': 'pending',
  'complete': 'completed',
  'cancel': 'cancelled'
}

// 获取订单列表
const getOrderList = async (tab = 'all') => {
  loading.value = true
  try {
    const res = await getUserOrder({ type: typeMap[tab] })
    if (res.code === 200) {
      state.orderList = res.data
    }
  } catch (error) {
    ElMessage.error('获取订单列表失败')
  } finally {
    loading.value = false
  }
}

// tab切换
const handleTabChange = (tab) => {
  currentTab.value = tab
  getOrderList(tab)
}

// 订单操作方法
const handleOrder = async (order, action) => {
  const actions = {
    pay: {
      title: '确认支付该订单？',
      status: 'completed',
      success: '支付成功'
    },
    cancel: {
      title: '确定要取消该订单吗？',
      status: 'cancelled',
      success: '订单已取消'
    }
  }

  const currentAction = actions[action]
  if (!currentAction) return

  try {
    await ElMessageBox.confirm(currentAction.title, '提示', {
      type: action === 'pay' ? 'info' : 'warning'
    })
    const res = await updateOrderStatus(order.id, currentAction.status)
    console.log(res);
    if (res.code === 200) {
      ElMessage.success(currentAction.success)
      getOrderList(currentTab.value)
    }
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error(`${currentAction.success}失败`)
    }
  }
}

onMounted(() => {
  const tab = route.query.tab || 'all'
  currentTab.value = tab
  getOrderList(tab)
})
</script>

<template>
  <div class="order-list">
    <el-tabs v-model="currentTab" @tab-change="handleTabChange">
      <el-tab-pane v-for="item in tabTypes" :key="item.name" :name="item.name" :label="item.label">
        <!-- 加载状态 -->
        <div v-if="loading" class="loading-skeleton">
          <div class="skeleton-item" />
        </div>

        <!-- 空状态 -->
        <div v-else-if="!state.orderList.length" class="empty-state">
          <el-empty description="暂无订单数据" />
        </div>

        <!-- 订单列表 -->
        <div v-else class="order-items">
          <div class="order-item" v-for="order in state.orderList" :key="order.id">
            <!-- 订单头部 -->
            <div class="order-header">
              <span class="time">下单时间：{{ order.createTime }}</span>
              <span class="order-id">订单编号：{{ order.id }}</span>
              <span class="status">{{ order.orderState }}</span>
            </div>

            <!-- 订单内容 -->
            <div class="order-body">
              <div class="goods-list">
                <div v-for="sku in order.skus" :key="sku.id" class="goods-item">
                  <img :src="sku.image" :alt="sku.name">
                  <div class="goods-info">
                    <h4>{{ sku.name }}</h4>
                    <p class="attrs">{{ sku.attrsText }}</p>
                    <div class="price-qty">
                      <span class="unit-price">单价：¥{{ Number(sku.price).toFixed(2) }}</span>
                      <span class="price">小计：¥{{ (Number(sku.price) * Number(sku.quantity)).toFixed(2) }}</span>
                      <span class="qty">x{{ sku.quantity }}</span>
                    </div>
                  </div>
                </div>
              </div>

              <!-- 订单底部 -->
              <div class="order-footer">
                <div class="total">
                  <span>实付金额：</span>
                  <span class="price">¥{{ Number(order.payMoney).toFixed(2) }}</span>
                </div>
                <div class="buttons">
                  <el-button v-if="order.orderState === '待付款'" type="primary"
                    @click="handleOrder(order, 'pay')">立即付款</el-button>
                  <el-button v-if="order.orderState === '待付款'" @click="handleOrder(order, 'cancel')">取消订单</el-button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<style scoped lang="less">
.order-list {
  .loading-skeleton {
    padding: 20px;

    .skeleton-item {
      display: flex;
      padding: 20px;
      background: #fff;
      border-radius: 4px;
      margin-bottom: 20px;

      .skeleton-image {
        width: 240px;
        height: 240px;
        background: #f5f5f5;
        border-radius: 4px;
      }

      .skeleton-content {
        flex: 1;
        margin-left: 20px;
        padding: 14px;

        .skeleton-title {
          width: 50%;
          height: 24px;
          background: #f5f5f5;
          border-radius: 4px;
          margin-bottom: 16px;
        }

        .skeleton-text {
          width: 30%;
          height: 16px;
          background: #f5f5f5;
          border-radius: 4px;
        }
      }
    }
  }

  .empty-state {
    padding: 40px;
    text-align: center;
  }

  .order-items {
    .order-item {
      margin-bottom: 20px;
      background: #fff;
      border-radius: 4px;
      overflow: hidden;
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);

      .order-header {
        padding: 20px;
        background: #f8f8f8;
        display: flex;
        align-items: center;
        font-size: 14px;
        color: #666;

        .time {
          margin-right: 20px;
        }

        .order-id {
          margin-right: auto;
        }

        .status {
          color: #ff6b35;
          font-weight: 500;
        }
      }

      .order-body {
        padding: 20px;

        .goods-list {
          .goods-item {
            display: flex;
            padding: 20px 0;
            border-bottom: 1px solid #f5f5f5;

            &:last-child {
              border-bottom: none;
            }

            img {
              width: 80px;
              height: 80px;
              object-fit: cover;
              margin-right: 20px;
              border-radius: 4px;
            }

            .goods-info {
              flex: 1;

              h4 {
                font-size: 16px;
                margin-bottom: 10px;
                color: #333;
              }

              .attrs {
                color: #999;
                font-size: 14px;
                margin-bottom: 10px;
              }

              .price-qty {
                display: flex;
                justify-content: space-between;
                align-items: center;
                color: #666;

                .unit-price {
                  color: #999;
                  font-size: 14px;
                }

                .price {
                  color: #ff6b35;
                  font-size: 16px;
                  font-weight: 500;
                }

                .qty {
                  color: #999;
                }
              }
            }
          }
        }

        .order-footer {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-top: 20px;
          padding-top: 20px;
          border-top: 1px solid #f5f5f5;

          .total {
            font-size: 14px;

            .price {
              color: #ff6b35;
              font-size: 20px;
              font-weight: 500;
              margin-left: 5px;
            }
          }

          .buttons {
            display: flex;
            gap: 10px;

            .el-button {
              padding: 8px 20px;

              &.el-button--primary {
                background-color: #ff6b35;
                border-color: #ff6b35;

                &:hover {
                  background-color: darken(#ff6b35, 10%);
                  border-color: darken(#ff6b35, 10%);
                }
              }
            }
          }
        }
      }
    }
  }
}

// 动画效果
.skeleton-item {
  animation: skeleton-loading 1.5s infinite;
}

@keyframes skeleton-loading {
  0% {
    opacity: 0.6;
  }

  50% {
    opacity: 0.8;
  }

  100% {
    opacity: 0.6;
  }
}
</style>