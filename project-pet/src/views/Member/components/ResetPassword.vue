<script setup>
import { ref, reactive } from 'vue'
import { ElMessage } from 'element-plus'
import { resetPasswordAPI } from '@/apis/user'
import { useRouter } from 'vue-router'

const router = useRouter()
const formData = reactive({
    oldPassword: '',
    newPassword: '',
    confirmPassword: ''
})

const rules = {
    oldPassword: [
        { required: true, message: '请输入原密码', trigger: 'blur' },
        { min: 6, message: '密码不能少于6位', trigger: 'blur' }
    ],
    newPassword: [
        { required: true, message: '请输入新密码', trigger: 'blur' },
        { min: 6, message: '密码不能少于6位', trigger: 'blur' }
    ],
    confirmPassword: [
        { required: true, message: '请确认新密码', trigger: 'blur' },
        {
            validator: (rule, value, callback) => {
                if (value !== formData.newPassword) {
                    callback(new Error('两次输入的密码不一致'))
                } else {
                    callback()
                }
            },
            trigger: 'blur'
        }
    ]
}

const formRef = ref(null)
const loading = ref(false)

// 重置密码
const resetPassword = async () => {
    try {
        await formRef.value.validate()
        loading.value = true
        const res = await resetPasswordAPI({
            oldPassword: formData.oldPassword,
            newPassword: formData.newPassword
        })
        if (res.code === 200) {
            ElMessage.success('密码修改成功，请重新登录')
            router.push('/login')
        }
    } catch (error) {
        console.error('修改密码失败:', error)
        ElMessage.error(error.response?.data?.message || '修改密码失败')
    } finally {
        loading.value = false
    }
}
</script>

<template>
    <div class="reset-password">
        <h3>修改密码</h3>
        <el-form ref="formRef" :model="formData" :rules="rules" label-width="100px">
            <el-form-item label="原密码" prop="oldPassword">
                <el-input v-model="formData.oldPassword" type="password" placeholder="请输入原密码" show-password />
            </el-form-item>

            <el-form-item label="新密码" prop="newPassword">
                <el-input v-model="formData.newPassword" type="password" placeholder="请输入新密码" show-password />
            </el-form-item>

            <el-form-item label="确认密码" prop="confirmPassword">
                <el-input v-model="formData.confirmPassword" type="password" placeholder="请再次输入新密码" show-password />
            </el-form-item>

            <el-form-item>
                <el-button type="primary" :loading="loading" @click="resetPassword">
                    确认修改
                </el-button>
            </el-form-item>
        </el-form>
    </div>
</template>

<style scoped lang="less">
.reset-password {
    padding: 20px;
    background: #fff;
    border-radius: 4px;

    h3 {
        margin-bottom: 20px;
        font-weight: normal;
    }
}
</style>