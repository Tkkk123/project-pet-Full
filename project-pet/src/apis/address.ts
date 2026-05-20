import request from '@/utils/request'
import type { AddAddressParams } from '@/types/address'

const BASE_URL = "user/address";

// 地址相关 API
export const addressAPI = {
    // 获取地址列表
    getList() {
        return request({
            url: BASE_URL,
            method: 'GET',
            withCredentials: true
        })
    },

    // 添加地址
    add(data: AddAddressParams) {
        return request({
            url: BASE_URL,
            method: 'POST',
            data,
            withCredentials: true
        })
    },

    // 删除地址
    delete(id: number) {
        return request({
            url: `${BASE_URL}/${id}`,
            method: 'DELETE'
        })
    }
} 