import request from "@/utils/request";

export function getDetailAPI(id: number) {
  return request({
    url: `/Detail/${id}`,
  });
}
