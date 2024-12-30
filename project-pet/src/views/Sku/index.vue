<template>
  <div class="goods-sku">
    <dl v-for="item in goods" :key="item.special_name">
      <dt>{{ item.special_name }}</dt>
      <dd>
        <template v-for="value in item.specification_values" :key="value">
          <a :class="{ selected: isSelected(item, value), disabled: disabled }" @click="changeSpec(item, value)">
            {{ value }}
          </a>
        </template>
      </dd>
    </dl>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'

const props = defineProps({
  goods: {
    type: Array,
    default: () => []
  },
  disabled: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['change'])

// 规格选择数据对象
const specSelected = reactive({})

// 规格选择事件
const changeSpec = (item, value) => {
  if (props.disabled) return // 如果禁用，不允许选择
  specSelected[item.special_name] = value
  emit('change', specSelected)
}

// 判断某个规格值是否选中
const isSelected = (item, value) => {
  return specSelected[item.special_name] === value
}
</script>

<style scoped lang="less">
.goods-sku {
  padding-left: 10px;
  padding-top: 20px;

  dl {
    display: flex;
    padding-bottom: 20px;
    align-items: center;

    dt {
      width: 50px;
      color: #999;
    }

    dd {
      flex: 1;
      color: #666;

      a {
        display: inline-block;
        margin-right: 10px;
        padding: 3px 15px;
        border: 1px solid #e4e4e4;
        border-radius: 4px;
        cursor: pointer;
        margin-bottom: 5px;

        &.selected {
          background: #ff6b35;
          border-color: #ff6b35;
          color: #fff;
        }

        &.disabled {
          cursor: not-allowed;
          opacity: 0.6;
          background: #f5f5f5;
          border-color: #e4e4e4;
          color: #999;

          &:hover {
            border-color: #e4e4e4;
            color: #999;
          }
        }

        &:hover {
          border-color: #ff6b35;
          color: #ff6b35;
        }
      }
    }
  }
}
</style>