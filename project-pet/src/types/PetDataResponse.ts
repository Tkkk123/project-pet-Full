export interface PetDataResponse {
    ScrollData: Array<{
        main_title: string;
        sub_title: string;
        products: Array<{
            product_id: number;
            product_name: string;
            product_img: string;
            category_id: string;
            sku_price: number;
            sku_discount: number;
        }>;
    }>;
}