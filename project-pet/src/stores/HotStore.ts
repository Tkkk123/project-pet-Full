import { defineStore } from "pinia";
import { ScrollApi } from "@/apis/ScrollData";
import { reactive } from "vue";

export const useScrollStore = defineStore("Scroll", () => {
  const HotList = reactive({
    main_title: "",
    sub_title: "",
    products: [] as any[],
  });
  const getHot = async () => {
    const res = await ScrollApi();
    if (res.code === 200 && res.data) {
      Object.assign(HotList, res.data);
    }
  };

  return {
    getHot,
    HotList
  };
},

);
