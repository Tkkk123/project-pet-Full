<script setup>
import { useRoute } from "vue-router";
import { onMounted, reactive, ref, computed } from "vue";
import { ElMessage } from "element-plus";
import { useCartStore } from "@/stores/cartStore";
import Sku from "@/views/Sku/index.vue";
import { getDetailAPI } from "@/apis/DetailData";
import request from "@/utils/request";
import Card from "@/views/main/components/Card.vue";
const cartStore = useCartStore();
const route = useRoute();
const DetailData = reactive({});
const recommendList = ref([]);
const recommendLoading = ref(false);
const activeTab = ref("detail");

const productDisplayName = computed(() => {
    return DetailData.product_name || "该商品";
});

const detailHtml = computed(() => {
    const name = productDisplayName.value;
    const category = DetailData.category_main_title || "宠物";
    return `
        <div style="line-height: 1.8; color: #333;">
            <h3 style="margin: 0 0 12px; font-size: 18px;">${name} 图文详情</h3>
            <p style="margin: 0 0 10px;">
                ${name} 为本店精选 ${category} 类目商品，支持正规渠道检疫与健康保障服务。
            </p>
            <p style="margin: 0 0 10px;">
                购买建议：首次饲养建议选择温顺亲人型；到家后注意环境适应与饮食过渡，避免频繁洗澡与惊吓。
            </p>
        </div>
    `;
});

const paramRows = computed(() => {
    const specs = Array.isArray(DetailData.specifications) ? DetailData.specifications : [];
    const specNames = specs.map((s) => s?.special_name).filter(Boolean).join(" / ");
    return [
        { name: "商品名称", value: DetailData.product_name || "—" },
        { name: "所属分类", value: DetailData.category_main_title || "—" },
        { name: "上架时间", value: DetailData.product_created_at || "—" },
        { name: "商品价格", value: DetailData.sku_price != null ? `¥${DetailData.sku_price}` : "—" },
        { name: "库存数量", value: DetailData.sku_quantity != null ? String(DetailData.sku_quantity) : "—" },
        { name: "销量人气", value: DetailData.product_order_num != null ? String(DetailData.product_order_num) : "—" },
        { name: "可选规格", value: specNames || "—" },
    ];
});

const mockReviews = computed(() => {
    const name = productDisplayName.value;
    return [
        {
            id: "r1",
            user: "小橘子",
            time: "2026-01-12",
            rate: 5,
            content: `${name} 到家状态很好，客服解答很耐心，整体体验不错。`,
            avatar: "https://img.yzcdn.cn/vant/cat.jpeg",
        },
        {
            id: "r2",
            user: "阿花",
            time: "2026-01-06",
            rate: 4,
            content: "包装与物流都很稳，建议增加更多饲养指南和注意事项说明。",
            avatar: "https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg",
        },
        {
            id: "r3",
            user: "小贝壳",
            time: "2025-12-29",
            rate: 5,
            content: "性格亲人，上手饲养更安心；希望后续能提供更多相关用品推荐。",
            avatar: "https://img.yzcdn.cn/vant/cat.jpeg",
        },
    ];
});


// 商品状态检查
const goodsStatus = reactive({
    isSoldOut: false,
    isOffShelf: false,
    message: ''
})

//用户选中某个宠物跳转页面后执行
const getGoods = async () => {
    try {
        const res = await getDetailAPI(route.params.id);
        if (res.code === 200) {
            if (!res.data || res.data.length === 0) {
                ElMessage.warning(res.message || '商品信息不存在');
                return;
            }
            Object.assign(DetailData, ...res.data);

            // 检查商品状态
            if (DetailData.sku_quantity <= 0) {
                goodsStatus.isSoldOut = true;
                goodsStatus.message = '该商品已售罄';
                ElMessage.warning(goodsStatus.message);
            }
            if (!DetailData.specifications || DetailData.specifications.length === 0) {
                goodsStatus.isOffShelf = true;
                goodsStatus.message = '商品未上架';
                ElMessage.warning(goodsStatus.message);
            }
        } else {
            ElMessage.error(res.message || '获取商品信息失败');
        }
    } catch (error) {
        console.error('获取商品详情失败:', error);
        ElMessage.error('获取商品详情失败，请稍后重试');
    }
};

// 检查是否可以操作商品
const canOperateGoods = computed(() => {
    return !goodsStatus.isSoldOut && !goodsStatus.isOffShelf;
});

let skuObj = {};

const skuChange = (sku) => {
    skuObj = sku; // 接收子组件传出的数据

};

const addCart = () => {
    // 确保所有规格项都已选择
    const isAllSelected = DetailData.specifications.every(sku => skuObj[sku.special_name]);

    if (isAllSelected) {
        // 字段映射表，将中文字段名转换为英文字段名
        const fieldMapping = {
            "颜色": "color",
            "尺寸": "size",
            "性别": "gender"
        };

        // 创建一个新的对象，将中文字段名转换为英文字段名
        const mappedSkuObj = Object.keys(skuObj).reduce((acc, key) => {
            const mappedKey = fieldMapping[key] || key; // 如果没有映射，则使用原字段名
            acc[mappedKey] = skuObj[key];
            return acc;
        }, {});

        // 所有规格已选择，加入购物车
        cartStore.addCart({
            id: DetailData.product_id,
            name: DetailData.product_name,
            picture: DetailData.product_img,
            price: DetailData.sku_price,
            count: count.value,
            ...mappedSkuObj,  // 将映射后的规格值传入
        });

        ElMessage.success("加入成功！");
    } else {
        ElMessage.warning("请选择完整的规格");
    }
};


const count = ref(1);
const countChange = (value) => {
    if (value < 1) {
        count.value = 1;
    } else {
        count.value = value;
    }
};

const getPersistedToken = () => {
    try {
        const raw = localStorage.getItem("user");
        if (!raw) return "";
        const parsed = JSON.parse(raw);
        const token = parsed?.userInfo?.token;
        return typeof token === "string" ? token : "";
    } catch {
        return "";
    }
};

const mapRecommendProductToCard = (row) => {
    const id = row?.id ?? row?.product_id;
    const name = row?.name ?? row?.product_name ?? "";
    const img = row?.img ?? row?.product_img ?? "";
    const price = row?.sku_price ?? row?.price ?? 0;
    const quantity = row?.sku_quantity ?? row?.quantity ?? 0;
    const discount = row?.sku_discount ?? row?.discount ?? 0;

    return {
        id,
        name,
        img,
        sku: {
            price,
            quantity,
            discount,
        },
    };
};

const getRecommend = async () => {
    const token = getPersistedToken();
    if (!token) {
        recommendList.value = [];
        return;
    }

    recommendLoading.value = true;
    try {
        const petRes = await request({
            url: "/member/pet",
            method: "GET",
        });

        const pets = Array.isArray(petRes?.data) ? petRes.data : [];
        const firstPet = pets[0];
        const petId = firstPet?.id ?? firstPet?.pet_id ?? firstPet?.petId;
        if (!petId) {
            recommendList.value = [];
            return;
        }

        const recRes = await request({
            url: `/member/recommend/${petId}`,
            method: "GET",
        });

        const rows = Array.isArray(recRes?.data) ? recRes.data : [];
        recommendList.value = rows.map(mapRecommendProductToCard).filter((item) => item?.id).slice(0, 6);
    } catch {
        recommendList.value = [];
    } finally {
        recommendLoading.value = false;
    }
};
onMounted(() => {
    getGoods();
    getRecommend();
});




</script>


<template>
    <div class="xtx-goods-page">
        <div v-if="!DetailData.product_id" class="loading-container">
            <el-empty description="商品不存在或已下架" :image-size="200">
                <template #extra>
                    <el-button type="primary" @click="$router.push('/')">
                        返回首页
                    </el-button>
                </template>
            </el-empty>
        </div>

        <div class="container" v-else>
            <div class="bread-container">
                <el-breadcrumb separator=">">
                    <el-breadcrumb-item to="/">首页</el-breadcrumb-item>
                    <el-breadcrumb-item to="/">
                        {{ DetailData.category_main_title }}
                    </el-breadcrumb-item>
                    <el-breadcrumb-item to="/">
                        {{ DetailData.product_name }}
                    </el-breadcrumb-item>
                </el-breadcrumb>
            </div>


            <div class="info-container">
                <div>
                    <div class="goods-info">
                        <div class="media">
                            <img :src="DetailData.product_img" alt="" class="product-image" />
                            <ul class="goods-sales">
                                <li>
                                    <p>销量人气</p>
                                    <p>{{ DetailData.product_order_num }}</p>
                                    <p><i class="iconfont icon-task-filling"></i>销量人气</p>
                                </li>
                                <li>
                                    <p>商品评价</p>
                                    <p>{{ DetailData.product_description ? DetailData.product_description : 0 }}</p>
                                    <p><i class="iconfont icon-comment-filling"></i>查看评价</p>
                                </li>
                                <li>
                                    <p>上架时间</p>
                                    <p>{{ DetailData.product_created_at }}</p>

                                    <p><i class="iconfont icon-favorite-filling"></i>上架时间</p>
                                </li>
                                <li>
                                    <p>剩余宠物</p>
                                    <p>
                                        {{ DetailData.sku_quantity }}
                                    </p>
                                    <p><i class="iconfont icon-dynamic-filling"></i>剩余数量</p>
                                </li>
                            </ul>
                        </div>

                        <div class="spec">

                            <p class="g-name">{{ DetailData.product_name }}</p>
                            <p class="g-price">
                                <span>{{ DetailData.sku_price }}</span>
                                <span></span>
                            </p>
                            <div class="g-service">
                                <dl>
                                    <dt>促销</dt>
                                    <dd>2024年新宠优惠，App领券购买直降120元</dd>
                                </dl>
                                <dl>
                                    <dt>服务</dt>
                                    <dd>
                                        <span>血统纯正</span>
                                        <span>快速退款</span>
                                        <span>免费包邮</span>
                                        <a href="javascript:;">了解详情</a>
                                    </dd>
                                </dl>
                            </div>

                            <Sku v-if="DetailData.specifications && DetailData.specifications.length"
                                :goods="DetailData.specifications" :disabled="!canOperateGoods" @change="skuChange" />

                            <el-input-number v-model="count" @change="countChange" :disabled="!canOperateGoods" />

                            <div class="button-group">
                                <el-button size="large" class="btn" type="primary" @click="addCart"
                                    :disabled="!canOperateGoods">
                                    {{ goodsStatus.message || '加入购物车' }}
                                </el-button>

                                <el-button size="large" class="btn" @click="$router.push('/cartlist')"
                                    :disabled="!canOperateGoods">
                                    去购物车结算
                                </el-button>
                            </div>
                        </div>
                    </div>


                    <div v-if="recommendList.length" class="guess-like">
                        <div class="guess-like__head">
                            <h3 class="guess-like__title">猜你喜欢</h3>
                        </div>
                        <div class="guess-like__body" v-loading="recommendLoading">
                            <ul class="guess-like__list">
                                <li v-for="item in recommendList" :key="item.id">
                                    <Card :cards="item" />
                                </li>
                            </ul>
                        </div>
                    </div>

                    <div class="goods-footer">
                        <div class="goods-article">
                            <div class="goods-tabs">
                                <el-tabs v-model="activeTab">
                                    <el-tab-pane label="图文详情" name="detail">
                                        <div class="detail-rich" v-html="detailHtml"></div>
                                    </el-tab-pane>
                                    <el-tab-pane label="商品参数" name="params">
                                        <el-table :data="paramRows" border style="width: 100%">
                                            <el-table-column prop="name" label="参数" width="160" />
                                            <el-table-column prop="value" label="内容" />
                                        </el-table>
                                    </el-tab-pane>
                                    <el-tab-pane label="用户评价" name="reviews">
                                        <div class="review-list">
                                            <el-card v-for="r in mockReviews" :key="r.id" class="review-card"
                                                shadow="never">
                                                <div class="review-head">
                                                    <el-avatar :size="36" :src="r.avatar" />
                                                    <div class="review-meta">
                                                        <div class="review-user">{{ r.user }}</div>
                                                        <div class="review-time">{{ r.time }}</div>
                                                    </div>
                                                    <el-rate :model-value="r.rate" disabled />
                                                </div>
                                                <div class="review-content">{{ r.content }}</div>
                                            </el-card>
                                        </div>
                                    </el-tab-pane>
                                </el-tabs>
                            </div>
                        </div>
                        <div class="goods-aside">
                            <div class="goods-warn">
                                <el-alert title="购买须知" type="info" show-icon :closable="false">
                                    <template #default>
                                        下单前请确认规格与数量；到家后建议静养适应环境；如有问题可联系在线客服。
                                    </template>
                                </el-alert>
                                <el-divider />
                                <el-alert title="售后保障" type="success" show-icon :closable="false">
                                    <template #default>
                                        支持7天无忧服务与快速退款（展示占位内容，可对接真实规则）。
                                    </template>
                                </el-alert>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</template>



<style scoped lang="less">
.xtx-goods-page {
    width: 1240px;
    margin: 0 auto;

    .goods-info {
        background: #fff;
        display: flex;
        justify-content: space-around;

        .media {
            img {
                width: 500px;
            }
        }

        .spec {
            padding: 0 30px 0 0;

            .el-input-number {
                margin-top: 20px;
            }
        }
    }

    .goods-footer {
        display: flex;
        margin-top: 20px;

        .goods-article {
            width: 940px;
            margin-right: 20px;
        }

        .goods-aside {
            width: 280px;
            min-height: 1000px;
        }
    }

    .goods-tabs {
        min-height: 600px;
        background: #fff;
    }

    .goods-warn {
        min-height: 600px;
        background: #fff;
        margin-top: 20px;
    }

    .number-box {
        display: flex;
        align-items: center;

        .label {
            width: 60px;
            color: #999;
            padding-left: 10px;
        }
    }

    .g-name {
        font-size: 22px;
    }

    .g-desc {
        color: #999;
        margin-top: 10px;
    }

    .g-price {
        margin-top: 10px;

        span {
            &::before {
                content: "¥";
                font-size: 14px;
            }

            &:first-child {
                color: red;
                margin-right: 10px;
                font-size: 22px;
            }

            &:last-child {
                color: #999;
                text-decoration: line-through;
                font-size: 16px;
            }
        }
    }

    .g-service {
        background: #f5f5f5;
        width: 500px;
        padding: 20px 10px 0 10px;
        margin-top: 10px;

        dl {
            padding-bottom: 20px;
            display: flex;
            align-items: center;

            dt {
                width: 50px;
                color: #999;
            }

            dd {
                color: #666;

                &:last-child {
                    span {
                        margin-right: 10px;

                        &::before {
                            content: "•";
                            color: red;
                            margin-right: 2px;
                        }
                    }

                    a {
                        color: red;
                    }
                }
            }
        }
    }

    .goods-sales {
        display: flex;
        width: 500px;
        align-items: center;
        text-align: center;
        height: 140px;

        li {
            flex: 1;
            position: relative;

            ~li::after {
                position: absolute;
                top: 10px;
                left: 0;
                height: 60px;
                border-left: 1px solid #e4e4e4;
                content: "";
            }

            p {
                &:first-child {
                    color: #999;
                }

                &:nth-child(2) {
                    color: red;
                    margin-top: 10px;
                }

                &:last-child {
                    color: #666;
                    margin-top: 10px;

                    i {
                        color: red;
                        font-size: 14px;
                        margin-right: 2px;
                    }

                    &:hover {
                        color: red;
                        cursor: pointer;
                    }
                }
            }
        }
    }
}

.goods-tabs {
    min-height: 600px;
    background: #fff;

    nav {
        height: 70px;
        line-height: 70px;
        display: flex;
        border-bottom: 1px solid #f5f5f5;

        a {
            padding: 0 40px;
            font-size: 18px;
            position: relative;

            >span {
                color: red;
                font-size: 16px;
                margin-left: 10px;
            }
        }
    }
}

.goods-detail {
    padding: 40px;

    .attrs {
        display: flex;
        flex-wrap: wrap;
        margin-bottom: 30px;

        li {
            display: flex;
            margin-bottom: 10px;
            width: 50%;

            .dt {
                width: 100px;
                color: #999;
            }

            .dd {
                flex: 1;
                color: #666;
            }
        }
    }

    >img {
        width: 100%;
    }
}

.btn {
    margin-top: 20px;
}

.bread-container {
    padding: 25px 0;
}

/* 骨架屏样式 */
.skeleton-loader {
    background-color: #f0f0f0;
    height: 200px;
    width: 100%;
    animation: loading 1.5s infinite linear;

}

.skeleton-image {
    background-color: #ccc;
    width: 100%;
    height: 100%;
}

@keyframes loading {
    0% {
        background-position: -200px 0;
    }

    100% {
        background-position: 200px 0;
    }
}

.product-image {
    width: 100%;
    height: auto;
}

.loading-container {
    min-height: 400px;
    display: flex;
    justify-content: center;
    align-items: center;
}

.button-group {
    margin-top: 20px;

    .btn {
        margin-right: 10px;

        &:disabled {
            cursor: not-allowed;
            opacity: 0.6;
        }
    }
}

.guess-like {
    margin-top: 20px;
    background: #fff;
    border-radius: 4px;
    padding: 20px;
}

.guess-like__head {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding-bottom: 10px;
    border-bottom: 1px solid #f5f5f5;
}

.guess-like__title {
    font-size: 18px;
    font-weight: 500;
    margin: 0;
    color: #333;
}

.guess-like__body {
    padding-top: 20px;
}

.guess-like__list {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
    list-style: none;
    padding: 0;
    margin: 0;
}

.goods-footer {
    .goods-tabs {
        padding: 0 20px 20px;
    }

    .goods-warn {
        margin-top: 0;
        padding: 20px;
        box-sizing: border-box;
    }
}

.detail-rich :deep(img) {
    max-width: 100%;
    display: block;
}

.review-list {
    display: flex;
    flex-direction: column;
    gap: 12px;
    padding: 10px 0;
}

.review-head {
    display: flex;
    align-items: center;
    gap: 12px;
}

.review-meta {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 2px;
}

.review-user {
    font-size: 14px;
    font-weight: 500;
    color: #333;
}

.review-time {
    font-size: 12px;
    color: #999;
}

.review-content {
    margin-top: 10px;
    color: #666;
    line-height: 1.8;
}
</style>
