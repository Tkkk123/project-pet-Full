import { reactive } from "vue";
import { defineStore } from "pinia";
import { getPetListAPI } from "@/apis/PetList";

export const usePetListStore = defineStore("PetList", () => {
  const getPetList = reactive([]);
  const getPet = async () => {
    const { Category } = await getPetListAPI();
    Object.assign(getPetList, Category)
  };

  return {
    getPetList,
    getPet,
  };
});
