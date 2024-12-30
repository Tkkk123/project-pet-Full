<script setup>
import { addressAPI } from '@/apis/address'
import { useRouter, useRoute } from 'vue-router'
import { onMounted, ref, reactive } from 'vue'
import { useCartStore } from '@/stores/cartStore'
import { useUserStore } from '@/stores/userStore'
import { ElMessage } from 'element-plus'
import { createOrderAPI } from '@/apis/checkout'

const userStore = useUserStore()
const router = useRouter()
const route = useRoute()

const checkInfo = ref({}) // 订单对象
const curAddress = ref({}) // 默认地址
const selectedItems = ref([])
const selectedData = ref(null)

// 获取用户地址列表
const getUserAddressList = async () => {
  try {
    // 先检查登录状态
    if (!userStore.userInfo) {
      ElMessage.warning('请先登录')
      router.push({
        path: '/login',
        query: { redirect: '/checkout' }
      })
      return
    }

    const res = await addressAPI.getList()
    // 添加响应状态判断
    if (res.code === 401) {
      ElMessage.warning('登录已过期，请重新登录')
      router.push({
        path: '/login',
        query: { redirect: '/checkout' }
      })
      return
    }

    if (res.code === 200 && res.data) {
      checkInfo.value.userAddresses = res.data
      if (res.data.length > 0) {
        const defaultAddress = res.data.find(addr => addr.isDefault === 1)
        curAddress.value = defaultAddress || res.data[0]
      }
    }
  } catch (error) {
    if (error.response?.status === 401) {
      ElMessage.warning('登录已过期，请重新登录')
      router.push({
        path: '/login',
        query: { redirect: '/checkout' }
      })
    } else {
      console.error('获取地址列表失败:', error)
      ElMessage.error('获取地址列表失败')
    }
  }
}

onMounted(async () => {
  selectedData.value = calculateSelectedData()
  if (!selectedData.value) {
    ElMessage.error('商品数据无效')
    router.push('/cartlist')
    return
  }
  await getUserAddressList()
})

// 地址管理相关
const showDialog = ref(false)
const showAddAddressDialog = ref(false)
const addressForm = ref(null)

const newAddress = reactive({
  receiver: '',
  contact: '',
  address: '',
  isDefault: 0
})

const addressRules = {
  receiver: [{ required: true, message: '请输入收货人姓名', trigger: 'blur' }],
  contact: [{ required: true, message: '请输入联系方式', trigger: 'blur' }],
  address: [{ required: true, message: '请输入收货地址', trigger: 'blur' }]
}

// 提交新地址
const submitAddress = async () => {
  if (!addressForm.value) return

  await addressForm.value.validate(async (valid) => {
    if (valid) {
      try {
        const res = await addressAPI.add(newAddress)
        if (res.code === 200) {
          ElMessage.success('添加地址成功')
          showAddAddressDialog.value = false
          await getUserAddressList()
          // 如果是第一个地址或设为默认地址，则自动选中
          if (res.data.isDefault === 1 || checkInfo.value.userAddresses.length === 1) {
            curAddress.value = res.data
          }
          addressForm.value.resetFields()
        } else {
          ElMessage.error(res.message || '添加地址失败')
        }
      } catch (error) {
        console.error('添加地址失败:', error)
        ElMessage.error('添加地址失败，请稍后重试')
      }
    }
  })
}

// 切换地址
const switchAddress = (item) => {
  curAddress.value = item
  showDialog.value = false
}

// 创建订单
const createOrder = async () => {
  if (!userStore.userInfo) {
    ElMessage.warning('请先登录')
    router.push({
      path: '/login',
      query: { redirect: '/checkout' }
    })
    return
  }

  try {
    const orderData = {
      products: selectedItems.value.map(item => ({
        id: item.id,
        count: item.count,
        price: item.price,
        color: item.color,
        size: item.size,
        gender: item.gender,
        name: item.name,
        picture: item.picture
      })),
      totalPrice: Number(selectedData.value.totalAmount)
    }

    const res = await createOrderAPI(orderData)

    // 添加响应状态判断
    if (res.code === 401) {
      ElMessage.warning('登录已过期，请重新登录')
      router.push({
        path: '/login',
        query: { redirect: '/checkout' }
      })
      return
    }

    if (res.code === 200) {
      ElMessage.success('下单成功')
      const cartStore = useCartStore()
      cartStore.clearCart()
      router.push({
        path: '/pay',
        query: {
          orderId: res.data.orderId,
          totalAmount: selectedData.value.totalAmount
        }
      })
    } else {
      ElMessage.error(res.message || '下单失败')
    }
  } catch (error) {
    console.error('下单失败:', error)
    ElMessage.error('下单失败，请稍后重试')
  }
}

// 计算商品数据
const calculateSelectedData = () => {
  if (route.query.selectedItems) {
    try {
      const itemsArray = JSON.parse(route.query.selectedItems)
      selectedItems.value = itemsArray

      const itemCount = itemsArray.reduce((total, item) => total + item.count, 0)
      const totalPrice = itemsArray.reduce((total, item) => total + (item.price * item.count), 0)
      const shippingFee = totalPrice * 0.02
      const totalAmount = totalPrice + shippingFee

      return {
        itemCount,
        totalPrice: totalPrice.toFixed(2),
        shippingFee: shippingFee.toFixed(2),
        totalAmount: totalAmount.toFixed(2)
      }
    } catch (error) {
      console.error('解析商品数据失败:', error)
      ElMessage.error('商品数据解析失败')
      return null
    }
  }
  return null
}
</script>


<template>
  <div class="xtx-pay-checkout-page">
    <div class="container">
      <div class="wrapper">
        <!-- 收货地址 -->
        <h3 class="box-title">收货地址</h3>
        <div class="box-body">
          <div class="address">
            <div class="text">
              <div class="none" v-if="!curAddress">您需要先添加收货地址才可提交订单。</div>
              <ul v-else>
                <li>
                  <span>收货人：</span>
                  {{ curAddress.receiver }}
                </li>
                <li>
                  <span>联系方式：</span>
                  {{ curAddress.contact }}
                </li>
                <li>
                  <span>收货地址：</span>
                  {{ curAddress.address }}
                </li>
              </ul>
            </div>
            <div class="action">
              <el-button size="large" @click="showDialog = true" :disabled="!checkInfo.userAddresses?.length">
                切换地址
              </el-button>
              <el-button size="large" type="primary" @click="showAddAddressDialog = true">
                添加地址
              </el-button>
            </div>
          </div>
        </div>
        <!-- 商品信息 -->
        <h3 class="box-title">商品信息</h3>
        <div class="box-body">
          <table class="goods">
            <thead>
              <tr>
                <th width="520">商品信息</th>
                <th width="170">单价</th>
                <th width="170">数量</th>
                <th width="170">小计</th>
                <th width="170">实付</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="item in selectedItems" :key="item.id">
                <td>
                  <a href="javascript:;" class="info">
                    <img :src="item.picture" alt="">
                    <div class="right">
                      <p>{{ item.name }}</p>
                      <p class="attr ellipsis">{{ item.sex }} {{ item.color }}</p>
                    </div>
                  </a>
                </td>
                <td>&yen;{{ item.price }}</td>
                <td>{{ item.count }}</td>
                <td>&yen;{{ (item.price * item.count).toFixed(2) }}</td>
                <td>&yen;{{ (item.price * item.count).toFixed(2) }}</td>
              </tr>
            </tbody>
          </table>
        </div>
        <!-- 金额明细 -->
        <h3 class="box-title">金额明细</h3>
        <div class="box-body">
          <div class="total" v-if="selectedData">
            <dl>
              <dt>商品件数：</dt>
              <dd>{{ selectedData.itemCount }}件</dd>
            </dl>
            <dl>
              <dt>商品总价：</dt>
              <dd>¥{{ selectedData.totalPrice }}</dd>
            </dl>
            <dl>
              <dt>运费：</dt>
              <dd>¥{{ selectedData.shippingFee }}</dd>
            </dl>
            <dl>
              <dt>应付总额：</dt>
              <dd class="price">¥{{ selectedData.totalAmount }}</dd>
            </dl>
          </div>
        </div>
        <!-- 提交订单 -->
        <div class="submit">
          <el-button type="primary" size="large" @click="createOrder" :disabled="!curAddress || !selectedItems.length">
            提交订单
          </el-button>
        </div>
      </div>
    </div>
  </div>
  <!-- 切换地址 -->
  <el-dialog v-model="showDialog" title="切换收货地址" width="30%" center>
    <div class="addressWrapper">
      <div class="text item" v-for="item in checkInfo.userAddresses" :key="item.id"
        :class="{ active: curAddress?.id === item.id }" @click="switchAddress(item)">
        <ul>
          <li><span>收货人：</span>{{ item.receiver }}</li>
          <li><span>联系方式：</span>{{ item.contact }}</li>
          <li><span>收货地址：</span>{{ item.address }}</li>
        </ul>
      </div>
    </div>
  </el-dialog>
  <!-- 添加地址 -->
  <el-dialog v-model="showAddAddressDialog" title="添加收货地址" width="30%" center>
    <el-form ref="addressForm" :model="newAddress" :rules="addressRules" label-width="80px">
      <el-form-item label="收货人" prop="receiver">
        <el-input v-model="newAddress.receiver" placeholder="请输入收货人姓名" />
      </el-form-item>
      <el-form-item label="联系方式" prop="contact">
        <el-input v-model="newAddress.contact" placeholder="请输入联系方式" />
      </el-form-item>
      <el-form-item label="收货地址" prop="address">
        <el-input v-model="newAddress.address" type="textarea" :rows="3" placeholder="请输入详细地址" />
      </el-form-item>
      <el-form-item>
        <el-checkbox v-model="newAddress.isDefault" :true-value="1" :false-value="0">
          设为默认地址
        </el-checkbox>
      </el-form-item>
    </el-form>
    <template #footer>
      <span class="dialog-footer">
        <el-button @click="showAddAddressDialog = false">取消</el-button>
        <el-button type="primary" @click="submitAddress">确定</el-button>
      </span>
    </template>
  </el-dialog>
</template>


<style scoped lang="less">
.xtx-pay-checkout-page {
  width: 1240px;
  margin: 0 auto;

  .wrapper {
    background: #fff;
    padding: 0 20px;

    .box-title {
      font-size: 16px;
      font-weight: normal;
      padding-left: 10px;
      line-height: 70px;
      border-bottom: 1px solid #f5f5f5;
    }

    .box-body {
      padding: 20px 0;
    }
  }
}

.address {
  border: 1px solid #f5f5f5;
  display: flex;
  align-items: center;

  .text {
    flex: 1;
    min-height: 90px;
    display: flex;
    align-items: center;

    .none {
      line-height: 90px;
      color: #999;
      text-align: center;
      width: 100%;
    }

    >ul {
      flex: 1;
      padding: 20px;

      li {
        line-height: 30px;

        span {
          color: #999;
          margin-right: 5px;

          >i {
            width: 0.5em;
            display: inline-block;
          }
        }
      }
    }

    >a {
      color: red;
      width: 160px;
      text-align: center;
      height: 90px;
      line-height: 90px;
      border-right: 1px solid #f5f5f5;
    }
  }

  .action {
    width: 420px;
    text-align: center;

    .btn {
      width: 140px;
      height: 46px;
      line-height: 44px;
      font-size: 14px;

      &:first-child {
        margin-right: 10px;
      }
    }
  }
}

.goods {
  width: 100%;
  border-collapse: collapse;
  border-spacing: 0;

  .info {
    display: flex;
    text-align: left;

    img {
      width: 70px;
      height: 70px;
      margin-right: 20px;
    }

    .right {
      line-height: 24px;

      p {
        &:last-child {
          color: #999;
        }

        .attr {
          font-size: 14px;
          color: #333;
        }
      }
    }
  }

  tr {
    th {
      background: #f5f5f5;
      font-weight: normal;
    }

    td,
    th {
      text-align: center;
      padding: 20px;
      border-bottom: 1px solid #f5f5f5;

      &:first-child {
        border-left: 1px solid #f5f5f5;
      }

      &:last-child {
        border-right: 1px solid #f5f5f5;
      }
    }
  }
}

.my-btn {
  width: 228px;
  height: 50px;
  border: 1px solid #e4e4e4;
  text-align: center;
  line-height: 48px;
  margin-right: 25px;
  color: #666666;
  display: inline-block;

  &.active,
  &:hover {
    border-color: red;
  }
}

.total {
  dl {
    display: flex;
    justify-content: flex-end;
    line-height: 50px;

    dt {
      i {
        display: inline-block;
        width: 2em;
      }
    }

    dd {
      width: 240px;
      text-align: right;
      padding-right: 70px;

      &.price {
        font-size: 20px;
        color: red;
      }
    }
  }
}

.submit {
  text-align: right;
  padding: 60px;
  border-top: 1px solid #f5f5f5;
}

.addressWrapper {
  max-height: 400px;
  overflow-y: auto;
}

.text.item {
  border: 1px solid #f5f5f5;
  margin-bottom: 10px;
  cursor: pointer;
  transition: all 0.3s;

  &.active,
  &:hover {
    border-color: #ff6b35;
    background: #fff6f2;
  }

  ul {
    padding: 15px;
    font-size: 14px;
    line-height: 30px;
  }
}
</style>