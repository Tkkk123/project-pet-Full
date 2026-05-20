// axios基础的封装
import axios, { InternalAxiosRequestConfig, AxiosRequestConfig } from "axios";
import { AxiosError } from "axios";
import { ElMessage } from "element-plus";
import { hideLoading, showLoading } from "@/loading/loading";
import { ApiResponse } from "@/types/api";
import { API_BASE } from "@/config/api";

// 创建自定义 axios 实例（与 Nginx `/api` 代理及 Express `app.use('/api', ...)` 一致）
const instance = axios.create({
  baseURL: API_BASE,
  timeout: 5000, // 设置请求超时时间
  withCredentials: true  // 添加这行，确保跨域请求时携带 cookie
});

const request = <T = any>(config: AxiosRequestConfig): Promise<T> => {
  return instance.request<any, T>(config);
};

const getPersistedToken = (): string => {
  try {
    const raw = localStorage.getItem("user");
    if (!raw) return "";
    const parsed = JSON.parse(raw);
    const token = parsed?.userInfo?.token;
    return typeof token === "string" ? token : "";
  } catch {
    return "";
  }
};

// 请求拦截器类型
instance.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
    //网络请求时执行全局加载
    showLoading();

    const token = getPersistedToken();
    if (token) {
      config.headers = config.headers || {};
      if (!("Authorization" in config.headers)) {
        config.headers.Authorization = `Bearer ${token}`;
      }
    }

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
instance.interceptors.response.use(
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
