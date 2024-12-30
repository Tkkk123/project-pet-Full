import { Address } from "./address"

// 订单商品信息
export interface OrderProduct {
    id: number
    count: number
    price: number
    name: string
    picture: string
}

export interface CheckoutResponse {
    id: number
    count: number
    price: number
    name: string
    picture: string
}
// 创建订单请求参数
export interface CreateOrderParams {
    products: OrderProduct[]
    totalPrice: number
    addressId?: number
    payType?: string
    buyerMessage?: string
}

// 订单查询参数
export interface OrderQueryParams {
    page?: number
    pageSize?: number
    status?: string
    startTime?: string
    endTime?: string
}

// API 响应接口
export interface ApiResponse<T> {
    code: number
    message: string
    data: T
}


// 订单商品信息
export interface OrderSku {
    id: number
    name: string
    image: string
    price: number
    quantity: number
    attrsText: string
}

// 订单信息
export interface Order extends CreateOrderParams {
    id: number
    userId: number
    status: string
    orderState: string
    payMoney: number
    createTime: string
    skus: OrderProduct[]
    address?: Address
    payChannel?: string
    payTime?: string
}

// 订单列表查询参数
export interface OrderListParams {
    type?: 'all' | 'unpay' | 'deliver' | 'receive' | 'comment' | 'complete' | 'cancel'
    page?: number
    pageSize?: number
}

// 订单列表响应
export type OrderListResponse = ApiResponse<Order[]>

// 结算页面相关类型
export interface CheckoutInfo {
    userAddresses: Address[]
}

export interface SelectedData {
    itemCount: number
    totalPrice: string
    shippingFee: string
    totalAmount: string
}

// 表单验证规则
export interface AddressRule {
    required: boolean
    message: string
    trigger: 'blur' | 'change'
}

export interface AddressRules {
    [key: string]: AddressRule[]
}

// 订单数据
export interface OrderData {
    products: OrderProduct[]
    totalPrice: number
} 