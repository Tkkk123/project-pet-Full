<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'

const route = useRoute()
const router = useRouter()
const orderId = ref(route.query.orderId)
const payType = ref(route.query.payType)
const redirect = ref(route.query.redirect)

const goToOrderList = () => {
    if (redirect.value) {
        router.push(redirect.value)
    } else {
        router.push('/member/order')
    }
}

onMounted(() => {
    if (!orderId.value || !payType.value) {
        ElMessage.error('支付信息无效')
        router.push('/member/order')
    }
})
</script>

<template>
    <div class="pay-callback-page">
        <div class="container">
            <div class="callback-info">
                <i class="el-icon-success"></i>
                <p class="title">支付成功</p>
                <p class="order-info">订单号：{{ orderId }}</p>
                <p class="pay-type">支付方式：{{ payType === 'wx' ? '微信支付' : '支付宝支付' }}</p>
                <el-button type="primary" @click="goToOrderList">查看订单</el-button>
            </div>
        </div>
    </div>
</template>

<style scoped lang="less">
.pay-callback-page {
    padding: 100px 0;

    .callback-info {
        width: 500px;
        margin: 0 auto;
        text-align: center;
        background: #fff;
        padding: 40px;
        border-radius: 4px;

        i {
            font-size: 40px;
            color: #1dc779;
        }

        .title {
            font-size: 24px;
            margin: 20px 0;
        }

        .order-info,
        .pay-type {
            color: #666;
            margin-bottom: 10px;
        }

        .el-button {
            margin-top: 20px;
        }
    }
}
</style>