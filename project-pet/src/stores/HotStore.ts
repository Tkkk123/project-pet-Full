import { defineStore } from "pinia";
import { ScrollApi } from "@/apis/ScrollData";
import { reactive } from "vue";
import { AxiosResponse } from "axios";
import { PetDataResponse } from "@/types/PetDataResponse";

export const useScrollStore = defineStore("Scroll", () => {
  const HotList = reactive([]);
  const getHot = async () => {
    const { ScrollData }: AxiosResponse<PetDataResponse> = await ScrollApi();
    Object.assign(HotList, ScrollData)
  };

  return {
    getHot,
    HotList
  };
},

);
