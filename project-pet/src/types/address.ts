// 地址基础接口
export interface BaseAddress {
    receiver: string
    contact: string
    address: string
    isDefault?: number
}

// 地址完整信息接口
export interface Address {
    id: number
    receiver: string
    contact: string
    address: string
    isDefault: number
    userId: number
}

// 添加地址请求参数
export type AddAddressParams = Omit<Address, 'id' | 'userId'>

// 通用API响应泛型接口
export interface ApiResponse<T> {
    code: number
    message: string
    data: T
}

// 地址相关响应类型
export type AddressResponse = ApiResponse<Address | Address[]> 