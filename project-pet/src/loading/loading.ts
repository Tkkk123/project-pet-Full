import { ElLoading } from "element-plus";

// 声明 loadingInstance 为 ElLoading.Service 返回的实例类型
let loadingInstance: ReturnType<typeof ElLoading.service>;

// 全局加载函数
export function showLoading() {
  // ElLoading.service 返回的就是一个带有 close 方法的实例
  loadingInstance = ElLoading.service({
    lock: true,
    text: "加载中.....",
    background: "rgba(0, 0, 0, 0.7)",
  });
}

// 在 0.5 秒后关闭全局加载
export function hideLoading() {
  if (loadingInstance) {
    setTimeout(() => {
      loadingInstance.close(); // 调用 close 方法关闭加载指示器
    }, 500);
  }
}
