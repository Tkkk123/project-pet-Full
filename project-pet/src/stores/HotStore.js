import { defineStore } from "pinia";
import { ScrollApi } from "@/apis/ScrollData";
import { reactive } from "vue";


export const useScrollStore = defineStore("Scroll", () => {
  const HotList = reactive([]);
  const getHot = async () => {
    const { ScrollData } = await ScrollApi();
    Object.assign(HotList, ScrollData)
  };

  return {
    getHot,
    HotList
  };
},

);
