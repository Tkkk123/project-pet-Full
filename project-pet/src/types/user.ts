/**
 * 用户登录信息接口
 */
export interface UserInfo {
    account: string;   // 用户账号
    password: string;  // 用户密码
}

/**
 * API通用响应接口
 */
export interface ApiResponse {
    code: number;      // 响应状态码
    message: string;   // 响应消息
    data?: any;        // 响应数据（可选）
    error?: any;       // 错误信息（可选）
}

/**
 * 注册请求参数接口
 */
export interface RegisterParams extends UserInfo {  // 接口继承
    email: string;     // 电子邮箱
    phone: string;     // 手机号码
}

/**
 * 注册响应接口
 */
export interface RegisterResponse {
    code: number;      // 响应状态码
    message: string;   // 响应消息
    data?: {
        userId?: number;   // 用户ID
        account?: string;  // 用户账号
    };
    error?: any;      // 错误信息
}

/**
 * 密码重置参数接口
 */
export interface ResetPasswordParams {
    oldPassword: string;   // 原密码
    newPassword: string;   // 新密码
}