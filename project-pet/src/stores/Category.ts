import { reactive } from "vue";
import { defineStore } from "pinia";
import { getPetListAPI } from "@/apis/PetList";

export const usePetListStore = defineStore("PetList", () => {
  const getPetList = reactive<any[]>([]);

  const getPet = async () => {
    const res = await getPetListAPI();
    if (res.code === 200 && Array.isArray(res.data)) {
      getPetList.splice(0, getPetList.length, ...res.data);
    }
  };


  return {
    getPetList,
    getPet,
  };
});
