import { reactive } from "vue";
import { defineStore } from "pinia";
import { getPetListAPI } from "@/apis/PetList";
import { AxiosResponse } from "axios";
import { PetListResponse } from "@/types/PetListResponse";

export const usePetListStore = defineStore("PetList", () => {
  const getPetList = reactive([]);

  const getPet = async () => {
    const { Category }: AxiosResponse<PetListResponse> = await getPetListAPI();
    Object.assign(getPetList, Category); // 使用返回的数据更新 getPetList
  };


  return {
    getPetList,
    getPet,
  };
});
