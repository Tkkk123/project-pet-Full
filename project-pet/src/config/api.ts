/** 后端服务根（不含 /api），生产通过空字符串使用相对路径配合 nginx 反向代理 */
export const API_ORIGIN = (import.meta.env.VITE_API_ORIGIN ?? "").replace(/\/$/, "");

/** 与 Express `app.use('/api', ...)` 对齐；末尾 `/` 避免 axios 将 `url: '/login'` 拼到域名根路径 */
export const API_BASE = `${API_ORIGIN}/api/`;
