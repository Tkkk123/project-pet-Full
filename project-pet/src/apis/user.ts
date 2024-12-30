import request from "@/utils/request";
import { RegisterParams, UserInfo, ResetPasswordParams } from "@/types/user";


export const registerAPI = (data: RegisterParams) => {
  return request({
    url: "/Register",
    method: "POST",
    data,
    withCredentials: true  // 允许跨域请求携带cookie
  });
};


export const loginAPI = (data: UserInfo) => {
  return request({
    url: "/Login",
    method: "POST",
    data,
    withCredentials: true,
  });
};


export const checkTokenApi = () => {
  return request({
    url: "/verify-token",
    method: "GET",
    withCredentials: true,
  });
};


export const logOutApi = () => {
  return request({
    url: "/logout",
    method: "POST",
    withCredentials: true
  });
};


export const resetPasswordAPI = (data: ResetPasswordParams) => {
  return request({
    url: '/reset-password',
    method: 'POST',
    data,
    withCredentials: true
  })
}
