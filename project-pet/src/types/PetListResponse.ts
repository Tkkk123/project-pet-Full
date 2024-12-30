export interface PetListResponse {
    Category: Array<{
        category_id: number;
        category_main_title: string;
        category_sub_title: string | null;
        category_picture: string;
        products: Array<{
            id: number;
            name: string;
            img: string;
            sku: {
                price: number;
                quantity: number;
                discount: number;
            };
        }>;
    }>;
}