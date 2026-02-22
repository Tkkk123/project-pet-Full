import { createRouter, createWebHistory } from "vue-router";
import LayoutView from "@/views/Layout/LayoutView.vue";
import mainView from "@/views/main/mainView.vue";
const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/",
      component: LayoutView,
      children: [
        {
          path: "/",
          component: mainView,
        },
        {
          path: "detail/:id",
          component: () => import('@/views/Detail/DetailView.vue'),
        },
        {
          path: "cartlist",
          component: () => import('@/views/CartList/index.vue'),
        },
        {
          path: "checkout",
          component: () => import('@/views/Checkout/index.vue'),
        },
        {
          path: "pay",
          component: () => import('@/views/Pay/index.vue')
        },
        {
          path: '/pay/callback',
          component: () => import('@/views/Pay/PayCallback.vue')
        },
        {
          path: "member",
          component: () => import('@/views/Member/index.vue'),
          children: [
            {
              path: "",
              component: () => import('@/views/Member/components/UserInfo.vue'),
            },
            {
              path: "order",
              component: () => import('@/views/Member/components/UserOrder.vue'),
            },
            {
              path: "pet",
              component: () => import('@/views/Member/components/PetManage.vue')
            },
            {
              path: "reset-password",
              component: () => import('@/views/Member/components/ResetPassword.vue'),
            }
          ],
        },
      ],
    },
    {
      path: "/login",
      component: () => import('@/views/Login/index.vue'),
    },

  ],
  scrollBehavior(to, from, savedPosition) {
    // 每次跳转时都滚动到顶部
    return { top: 0 };
  },
});

export default router;
