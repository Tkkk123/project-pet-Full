import { defineStore } from "pinia";
import { computed, ref } from "vue";
import { CartItem } from "@/types/CartItem";


export const useCartStore = defineStore(
  "cart",
  () => {
    // 购物车列表，数组中的元素是 CartItem 类型
    const cartList = ref<CartItem[]>([]);

    // 添加商品到购物车的方法
    const addCart = (goods: CartItem) => {

      const { id, name, picture, price, count, size, color, gender } = goods;
      const itemIndex = cartList.value.findIndex(
        (item) => item.id === id && item.gender === gender && item.color === color && item.size === size
      );
      if (itemIndex !== -1) {
        // 商品已存在于购物车中，更新数量
        cartList.value[itemIndex].count += count;
      } else {
        // 商品不存在于购物车中，将其添加到购物车
        cartList.value.push({
          id,
          name,
          picture,
          price,
          count,
          gender,
          color,
          size,
          selected: false, // 默认不选中
        });
      }
    };

    // 删除购物车中的商品
    const delCart = (id: number) => {
      const idx = cartList.value.findIndex((item) => item.id === id);
      if (idx !== -1) {
        cartList.value.splice(idx, 1);
      }
    };

    // 清除购物车
    const clearCart = () => {
      cartList.value = [];
    };

    // 单选功能
    const singleCheck = (id: number, gender: string, color: string, size: string, selected: boolean) => {
      const item = cartList.value.find(
        (item) => item.id === id && item.gender === gender && item.color === color && item.size === size
      );
      if (item) {
        item.selected = selected;
      }
    };

    // 全选功能
    const allCheck = (selected: boolean) => {
      cartList.value.forEach((item) => (item.selected = selected));
    };

    // 计算属性
    const allCount = computed(() =>
      cartList.value.reduce((a, c) => a + c.count, 0)
    );
    const allPrice = computed(() =>
      cartList.value.reduce((a, c) => a + c.count * c.price, 0)
    );
    const selectedCount = computed(() =>
      cartList.value
        .filter((item) => item.selected)
        .reduce((a, c) => a + c.count, 0)
    );
    const selectedPrice = computed(() =>
      cartList.value
        .filter((item) => item.selected)
        .reduce((a, c) => a + c.count * c.price, 0)
    );
    const isAll = computed(() => cartList.value.every((item) => item.selected));

    return {
      cartList,
      allCount,
      allPrice,
      isAll,
      selectedCount,
      selectedPrice,
      clearCart,
      addCart,
      delCart,
      singleCheck,
      allCheck,
    };
  },
  {
    persist: true, // 将购物车数据持久化
  }
);
