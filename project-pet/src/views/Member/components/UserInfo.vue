<script setup>
import { useUserStore } from '@/stores/userStore'
const userStore = useUserStore()

const quickLinks = [
  { name: '我的订单', icon: 'icon-order', path: '/member/order' }
]
</script>

<template>
  <div class="user-info">
    <!-- 用户信息卡片 -->
    <div class="info-card">
      <div class="avatar">
        <img v-lazy="userStore.userInfo.avatar || 'https://img.yzcdn.cn/vant/cat.jpeg'" alt="用户头像">
      </div>
      <div class="info">
        <h3>{{ userStore.userInfo?.account }}</h3>
        <p>欢迎回来</p>
      </div>
    </div>

    <!-- 快捷入口 -->
    <div class="quick-links">
      <RouterLink v-for="link in quickLinks" :key="link.name" :to="link.path" class="link-item">
        <i :class="['iconfont', link.icon]"></i>
        <span>{{ link.name }}</span>
      </RouterLink>
    </div>
  </div>
</template>

<style scoped lang="less">
.user-info {
  .info-card {
    display: flex;
    align-items: center;
    padding: 30px;
    background: linear-gradient(to right, #ff9966, #ff6b35);
    border-radius: 8px;
    color: #fff;

    .avatar {
      width: 100px;
      height: 100px;
      border-radius: 50%;
      border: 4px solid rgba(255, 255, 255, 0.3);
      overflow: hidden;
      margin-right: 20px;

      img {
        width: 100%;
        height: 100%;
        object-fit: cover;
      }
    }

    .info {
      h3 {
        font-size: 24px;
        margin-bottom: 10px;
      }

      p {
        font-size: 16px;
        opacity: 0.8;
      }
    }
  }

  .quick-links {
    margin-top: 30px;
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;

    .link-item {
      display: flex;
      flex-direction: column;
      align-items: center;
      padding: 20px;
      background: #f8f8f8;
      border-radius: 8px;
      transition: all 0.3s;

      .iconfont {
        font-size: 32px;
        color: #ff6b35;
        margin-bottom: 10px;
      }

      span {
        color: #666;
      }

      &:hover {
        background: #fff;
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
        transform: translateY(-2px);

        span {
          color: #ff6b35;
        }
      }
    }
  }
}
</style>