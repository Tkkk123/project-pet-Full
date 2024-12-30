import request from "@/utils/request";
import type { AxiosResponse } from "axios";
import type {
  CreateOrderParams,
  CheckoutResponse,
  OrderListParams,
  OrderListResponse,
  ApiResponse
} from "@/types/checkout";

// 获取详情接口
export const getCheckInfoAPI = () => {
  return request({
    url: "/member/order/pre",
    method: "GET",
    withCredentials: true
  });
};

// 创建订单
export const createOrderAPI = (data: CreateOrderParams) => {
  return request({
    url: "/member/order",
    method: "POST",
    data,
    withCredentials: true
  });
};

// 获取用户订单
export const getUserOrder = (params: OrderListParams = {}) => {
  return request({
    url: "/member/order",
    method: "GET",
    params,
    withCredentials: true
  });
};

// 更新订单状态
export const updateOrderStatus = (
  orderId: number,
  status: string
) => {
  return request({
    url: `/member/order/${orderId}/status`,
    method: 'PUT',
    data: { status },
    withCredentials: true
  });
};