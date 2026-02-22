<script setup>
import { onMounted, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import request from '@/utils/request'

const pets = ref([])
const loading = ref(false)

const dialogVisible = ref(false)
const submitting = ref(false)
const formRef = ref(null)

const createDefaultForm = () => ({
  name: '',
  species: 'dog',
  breed: '',
  birthday: '',
  weight: '',
  health_note: '',
  allergy_note: '',
  preference: ''
})

const formData = reactive(createDefaultForm())

const rules = {
  name: [{ required: true, message: '请输入宠物名称', trigger: 'blur' }],
  species: [{ required: true, message: '请选择物种', trigger: 'change' }]
}

const normalizeTags = (tags) => {
  if (!tags) return []
  if (Array.isArray(tags)) return tags.filter(Boolean)
  if (typeof tags !== 'string') return []
  return tags
    .split(',')
    .map((t) => t.trim())
    .filter(Boolean)
}

const getPets = async () => {
  loading.value = true
  try {
    const res = await request({
      url: '/member/pet',
      method: 'GET'
    })

    if (res?.code === 200) {
      pets.value = Array.isArray(res.data) ? res.data : []
    } else {
      pets.value = []
      ElMessage.warning(res?.message || '获取宠物列表失败')
    }
  } finally {
    loading.value = false
  }
}

const openCreateDialog = () => {
  dialogVisible.value = true
}

const resetForm = () => {
  if (formRef.value?.resetFields) {
    formRef.value.resetFields()
  }
  Object.assign(formData, createDefaultForm())
}

const createPet = async () => {
  if (!formRef.value) return

  await formRef.value.validate(async (valid) => {
    if (!valid) return

    submitting.value = true
    try {
      const weightNumber = formData.weight === '' ? null : Number(formData.weight)

      const res = await request({
        url: '/member/pet',
        method: 'POST',
        data: {
          name: formData.name,
          species: formData.species,
          breed: formData.breed,
          birthday: formData.birthday || null,
          weight: Number.isFinite(weightNumber) ? weightNumber : null,
          health_note: formData.health_note,
          allergy_note: formData.allergy_note,
          preference: formData.preference
        }
      })

      if (res?.code === 200) {
        ElMessage.success(res?.message || '新增宠物成功')
        dialogVisible.value = false
        resetForm()
        await getPets()
      } else {
        ElMessage.error(res?.message || '新增宠物失败')
      }
    } finally {
      submitting.value = false
    }
  })
}

onMounted(async () => {
  await getPets()
})
</script>

<template>
  <div class="pet-manage">
    <div class="info-card">
      <div class="info">
        <h3>宠物档案管理</h3>
        <p>管理你的宠物信息，系统会根据档案自动生成标签</p>
      </div>
    </div>

    <div class="toolbar">
      <el-button type="primary" @click="openCreateDialog">新增宠物</el-button>
      <el-button @click="getPets">刷新</el-button>
    </div>

    <div class="table-wrap">
      <el-table :data="pets" v-loading="loading" style="width: 100%">
        <el-table-column prop="name" label="名称" min-width="120" />
        <el-table-column prop="species" label="物种" min-width="90" />
        <el-table-column prop="breed" label="品种" min-width="120" />
        <el-table-column prop="birthday" label="生日" min-width="120" />
        <el-table-column prop="weight" label="体重(kg)" min-width="100" />
        <el-table-column label="标签" min-width="220">
          <template #default="{ row }">
            <div class="tags">
              <el-tag v-for="tag in normalizeTags(row.tags)" :key="tag" type="warning" effect="light">
                {{ tag }}
              </el-tag>
              <span v-if="normalizeTags(row.tags).length === 0" class="empty-text">-</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="health_note" label="健康备注" min-width="180" show-overflow-tooltip />
        <el-table-column prop="allergy_note" label="过敏备注" min-width="180" show-overflow-tooltip />
        <el-table-column prop="preference" label="偏好" min-width="180" show-overflow-tooltip />
      </el-table>

      <div v-if="!loading && pets.length === 0" class="empty">
        <el-empty description="暂无宠物档案" />
      </div>
    </div>

    <el-dialog v-model="dialogVisible" title="新增宠物档案" width="560px" @closed="resetForm">
      <el-form ref="formRef" :model="formData" :rules="rules" label-width="90px" class="pet-form">
        <el-form-item label="名称" prop="name">
          <el-input v-model="formData.name" placeholder="请输入宠物名称" />
        </el-form-item>

        <el-form-item label="物种" prop="species">
          <el-select v-model="formData.species" placeholder="请选择物种" style="width: 100%">
            <el-option label="狗" value="dog" />
            <el-option label="猫" value="cat" />
            <el-option label="其他" value="other" />
          </el-select>
        </el-form-item>

        <el-form-item label="品种">
          <el-input v-model="formData.breed" placeholder="如：金毛 / 英短" />
        </el-form-item>

        <el-form-item label="生日">
          <el-input v-model="formData.birthday" placeholder="YYYY-MM-DD" />
        </el-form-item>

        <el-form-item label="体重(kg)">
          <el-input v-model="formData.weight" placeholder="例如：8.5" />
        </el-form-item>

        <el-form-item label="健康备注">
          <el-input v-model="formData.health_note" type="textarea" :rows="2" placeholder="例如：肠胃敏感" />
        </el-form-item>

        <el-form-item label="过敏备注">
          <el-input v-model="formData.allergy_note" type="textarea" :rows="2" placeholder="例如：对鸡肉过敏" />
        </el-form-item>

        <el-form-item label="偏好">
          <el-input v-model="formData.preference" type="textarea" :rows="2" placeholder="例如：喜欢牛肉味零食" />
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="createPet">确认新增</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped lang="less">
.pet-manage {
  .info-card {
    display: flex;
    align-items: center;
    padding: 30px;
    background: linear-gradient(to right, #ff9966, #ff6b35);
    border-radius: 8px;
    color: #fff;

    .info {
      h3 {
        font-size: 24px;
        margin-bottom: 10px;
      }

      p {
        font-size: 16px;
        opacity: 0.85;
      }
    }
  }

  .toolbar {
    margin-top: 20px;
    display: flex;
    gap: 10px;
  }

  .table-wrap {
    margin-top: 20px;
    width: 100%;
    /* 强制宽度为 100% */
    overflow-x: auto;
    /* 如果内部表格依然很大，允许在此处产生滚动条 */
  }

  .tags {
    display: flex;
    flex-wrap: wrap;
    gap: 6px;
    align-items: center;

    .empty-text {
      color: #999;
    }
  }

  .empty {
    padding: 30px 0;
  }
}
</style>
