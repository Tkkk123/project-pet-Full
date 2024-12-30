import { defineStore } from "pinia";
import { ref } from "vue";
import { loginAPI, checkTokenApi, logOutApi } from "@/apis/user";
import { useCartStore } from "./cartStore";

// 定义用户信息的类型
interface UserInfo {
  account: string;
  password: string;
}

export const useUserStore = defineStore(
  "user",
  () => {
    const cartStore = useCartStore();

    // 定义用户信息的 state
    const userInfo = ref<UserInfo | null>(null); // 初始值为 null

    // 登录方法
    const login = async ({ account, password }: { account: string; password: string }): Promise<boolean> => {
      try {
        const res = await loginAPI({ account, password });
        if (res.data.code === 200) {
          userInfo.value = res.data.data;
          // 更新用户信息
          return true;
        } else {
          console.error(res.data.message);
          return false;
        }
      } catch (error) {
        console.error("登录失败", error);
        return false;
      }
    };

    // 校验 Token 方法
    const verifyToken = async (): Promise<boolean> => {
      try {
        const res = await checkTokenApi();
        if (res.data.code === 200) {
          userInfo.value = res.data.data;
          // console.log("Token 校验成功", userInfo.value);
          // 更新用户信息
          return true;
        } else {
          console.warn("Token 校验失败");
          userInfo.value = null;
          return false;
        }
      } catch (error) {
        userInfo.value = null;
        console.log("用户Token已清除");
        return false;
      }
    };

    // 退出登录方法
    const logout = async () => {
      try {
        await logOutApi(); // 调用后端接口清理 Token
        userInfo.value = null; // 清空用户信息
        cartStore.clearCart(); // 清空购物车信息
      } catch (error) {
        console.error("退出登录失败", error);
      }
    };

    return {
      userInfo,
      login,
      verifyToken,
      logout,
    };
  },
  {
    persist: true, // 持久化存储用户信息
  }
);
