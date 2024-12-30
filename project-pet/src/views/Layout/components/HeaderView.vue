<script setup>
import { useUserStore } from '@/stores/userStore';
import { onMounted, onBeforeUnmount } from 'vue';
import { useRouter } from 'vue-router';
import { ElMessage } from 'element-plus';

const userStore = useUserStore();
const router = useRouter();
let intervalId = null; // 用于存储定时器 ID

// 确认退出登录
const confirm = () => {
    userStore.logout();
    router.push('/');
};

// 检查登录状态
const checkLoginStatus = async () => {
    try {
        const isValid = await userStore.verifyToken();
        if (!isValid) {
            ElMessage({
                type: 'warning',
                message: '登录已过期，请重新登录'
            });
            // 清除用户信息
            userStore.clearUserInfo();
            // 跳转到登录页
            router.push('/login');
        }
    } catch (error) {
        console.error('验证登录状态失败:', error);
        ElMessage.error('网络错误，请稍后重试');
    }
};

// 页面加载时执行
onMounted(() => {
    // 只有在用户已登录的情况下才开启定时检查
    if (userStore.userInfo) {
        checkLoginStatus(); // 初始检查
        // 每 3 分钟检查一次登录状态
        intervalId = setInterval(checkLoginStatus, 3 * 60 * 1000);
    }
});

// 清理定时器
onBeforeUnmount(() => {
    if (intervalId) {
        clearInterval(intervalId);
        intervalId = null;
    }
});
// console.log("持久化用户信息", userStore.userInfo);

</script>

<template>
    <header class="app-top">
        <div class="container">
            <el-row>
                <el-col :span="6" :offset="1">
                    <div class="grid-content title">
                        <router-link to="/">欢迎来到宠物帮帮居-您的宠物生活，我们的责任</router-link>
                    </div>
                </el-col>
                <el-col :span="5" :offset="1" class="box">
                    <!-- 如果用户已登录 -->
                    <template v-if="userStore.userInfo">
                        <li>
                            <router-link to="/member">
                                <i class="iconfont icon-icon_user"></i>
                                {{ userStore.userInfo.account }}
                            </router-link>
                        </li>
                        <li>
                            <el-popconfirm @confirm="confirm" title="确认退出吗?" confirm-button-text="确认"
                                cancel-button-text="取消">
                                <template #reference>
                                    <a href="#">退出登录</a>
                                </template>
                            </el-popconfirm>
                        </li>
                    </template>
                    <!-- 如果用户未登录 -->
                    <template v-else>
                        <li><a href="javascript:;" @click="$router.push('/login')">请先登录</a></li>
                        <li><a href="javascript:;">帮助中心</a></li>
                        <li><a href="javascript:;">关于我们</a></li>
                    </template>
                </el-col>
            </el-row>
        </div>
    </header>
</template>




<style lang="less" scoped>
.app-top {

    background: orange;

    .el-row {
        height: 53px;
        justify-content: space-around;
        align-items: center;

        .box {
            display: flex;
            justify-content: space-evenly;
            align-items: center;
        }

        .el-col {
            .grid-content {
                font-size: 15px;
                color: #333;
            }
        }
    }
}
</style>