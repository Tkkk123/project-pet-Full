// axios基础的封装
import axios, { AxiosInstance, InternalAxiosRequestConfig, AxiosResponse } from "axios";
import { AxiosError } from "axios";
import { ElMessage } from "element-plus";
import { hideLoading, showLoading } from "@/loading/loading";
import { ApiResponse } from "@/types/api";

// 创建自定义 axios 实例
const request: AxiosInstance = axios.create({
  baseURL: "http://localhost:8234", //请求的地址基路径
  timeout: 5000, // 设置请求超时时间
  withCredentials: true  // 添加这行，确保跨域请求时携带 cookie
});

// 请求拦截器类型
request.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
    //网络请求时执行全局加载
    showLoading();
    return config;
  },
  (error: any) => {
    //网络请求失败时执行关闭全局加载，输出网络错误
    hideLoading();
    useErrorHandler(error);
    return Promise.reject(error);
  }
);

// 响应拦截器类型
request.interceptors.response.use(
  (response) => {
    //网络请求正常响应关闭全局加载
    hideLoading();
    return response.data;
  },
  (error) => {
    hideLoading();
    useErrorHandler(error);
    return Promise.reject(error);
  }
);

// 统一错误处理函数
export function useErrorHandler(error: AxiosError<ApiResponse>) {
  // 检查 error.response 和 error.response.data 是否存在，并且符合 ErrorResponse 结构
  const errorMessage = error.response?.data?.message || "网络错误,请重试";
  ElMessage({
    type: "warning",
    message: errorMessage,
  });
}

export default request;
