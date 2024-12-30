<script setup>
import { useRouter } from 'vue-router'
const router = useRouter()

const menuItems = [
  {
    title: '我的账户',
    items: [
      { name: '个人中心', path: '/member', icon: 'icon-user' },
      { name: '修改密码', path: '/member/reset-password', icon: 'icon-lock' }
    ]
  },
  {
    title: '交易管理',
    items: [
      { name: '我的订单', path: '/member/order', icon: 'icon-order' }
    ]
  }
]
</script>

<template>
  <div class="member-layout">
    <!-- 侧边栏 -->
    <div class="member-aside">
      <div class="user-manage">
        <div v-for="menu in menuItems" :key="menu.title" class="menu-group">
          <h4>{{ menu.title }}</h4>
          <div class="links">
            <RouterLink v-for="item in menu.items" :key="item.name" :to="item.path" class="menu-item">
              <i :class="['iconfont', item.icon]"></i>
              {{ item.name }}
            </RouterLink>
          </div>
        </div>
      </div>
    </div>
    <!-- 内容区域 -->
    <div class="member-main">
      <RouterView />
    </div>
  </div>
</template>

<style scoped lang="less">
.member-layout {
  width: 1240px;
  margin: 20px auto;
  display: flex;
  gap: 20px;

  .member-aside {
    width: 220px;
    background-color: #fff;
    border-radius: 4px;

    .menu-group {
      h4 {
        font-size: 18px;
        font-weight: 400;
        padding: 20px 20px 5px;
        border-top: 1px solid #f6f6f6;

        &:first-child {
          border-top: none;
        }
      }

      .links {
        padding: 0 20px;
      }

      .menu-item {
        display: flex;
        align-items: center;
        padding: 15px 0;
        font-size: 14px;
        color: #666;
        position: relative;
        transition: all 0.3s;

        .iconfont {
          font-size: 18px;
          margin-right: 10px;
        }

        &:hover {
          color: #ff6b35;
        }

        &.router-link-active {
          color: #ff6b35;
          font-weight: 500;

          &:before {
            content: '';
            position: absolute;
            left: -20px;
            top: 50%;
            transform: translateY(-50%);
            width: 4px;
            height: 16px;
            background-color: #ff6b35;
            border-radius: 2px;
          }
        }
      }
    }
  }

  .member-main {
    flex: 1;
    background-color: #fff;
    border-radius: 4px;
    padding: 20px;
  }
}
</style>