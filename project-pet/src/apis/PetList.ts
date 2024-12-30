import request from "@/utils/request";

export const getPetListAPI = () => {
  return request({
    url: "/PetData",
  });
};
