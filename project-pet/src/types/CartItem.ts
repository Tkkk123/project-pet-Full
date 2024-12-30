export interface CartItem {
    id: number;
    name: string;
    picture: string;
    price: number;
    count: number;
    gender: string;
    color: string;
    size: string;
    selected?: boolean; // 选中状态
}