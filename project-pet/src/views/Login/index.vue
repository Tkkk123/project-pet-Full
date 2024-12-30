<script setup>

// 表单校验（账号名+密码）

import { ref } from 'vue'
import { ElMessage } from 'element-plus'
import { useRouter, useRoute } from 'vue-router'
import { useUserStore } from '@/stores/userStore'
import { registerAPI } from '@/apis/user'

const userStore = useUserStore()
const route = useRoute()
const router = useRouter()

// 修改登录/注册的状态 (1: 注册, 2: 登录)
const type = ref(2)  // 默认显示登录状态

// 统一使用form数据
const form = ref({
  account: '',
  password: '',
  confirmPassword: '',
  email: '',
  phone: '',
  agree: false  // 添加 agree 字段到表单数据中
})

// 统一的校验规则
const rules = {
  account: [
    { required: true, message: '用户名不能为空', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '密码不能为空', trigger: 'blur' },
    { min: 6, max: 14, message: '密码长度为6-14个字符', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请确认密码', trigger: 'blur' },
    {
      validator: (rule, value, callback) => {
        if (value !== form.value.password) {
          callback(new Error('两次输入的密码不一致'))
        } else {
          callback()
        }
      },
      trigger: 'blur'
    }
  ],
  email: [
    { required: true, message: '邮箱不能为空', trigger: 'blur' },
    // { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
  ],
  phone: [
    { required: true, message: '手机号不能为空', trigger: 'blur' },
    // { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号格式', trigger: 'blur' }
  ],
  agree: [
    {
      validator: (rule, value, callback) => {
        if (value) {
          callback()
        } else {
          callback(new Error('请勾选协议'))
        }
      },
      trigger: 'change'
    }
  ]
}

//  获取form实例做统一校验
const formRef = ref(null)
const doLogin = () => {
  const { account, password } = form.value
  // 调用实例方法
  formRef.value.validate(async (valid) => {
    // valid: 所有表单都通过校验才为true
    if (valid) {
      const loginResult = await userStore.login({ account, password })
      if (loginResult) {
        ElMessage({ type: 'success', message: '登录成功' })
        // 获取重定向地址
        const redirect = route.query.redirect || '/'
        router.replace({ path: redirect })
      } else {
        ElMessage({ type: 'error', message: '用户名或密码错误' })
      }
    }
  })
}

// 注册方法
const doRegister = () => {
  formRef.value.validate(async (valid) => {
    if (valid) {
      try {
        // 调用注册API
        const res = await registerAPI({
          account: form.value.account,
          password: form.value.password,
          email: form.value.email,
          phone: form.value.phone
        })

        if (res.code === 200) {
          ElMessage.success('注册成功')
          type.value = 2  // 注册成功后切换到登录状态
          // 清空表单
          form.value = {
            account: form.value.account,
            password: form.value.password,
            confirmPassword: '',
            email: '',
            phone: '',
            agree: true
          }
        } else {
          ElMessage.error(res.msg || '注册失败')
        }
      } catch (error) {
        ElMessage.error('注册失败，请稍后重试')
        console.error('注册错误:', error)
      }
    }
  })
}

</script>


<template>
  <div>
    <header class="login-header">
      <div class="container m-top-20">
        <h1 class="logo">
          <RouterLink to="/">宠物帮帮居</RouterLink>
        </h1>
      </div>
    </header>
    <section class="login-section">
      <div class="wrapper">
        <nav>
          <el-radio-group v-model="type" size="large">
            <el-radio-button :value="2">账户登录</el-radio-button>
            <el-radio-button :value="1">立即注册</el-radio-button>
          </el-radio-group>
        </nav>
        <div class="account-box">
          <el-form ref="formRef" :model="form" :rules="rules" label-position="right" label-width="80px"
            class="login-form">
            <!-- 复用的登录字段 -->
            <el-form-item prop="account" label="账户">
              <el-input v-model="form.account" />
            </el-form-item>
            <el-form-item prop="password" label="密码">
              <el-input type="password" v-model="form.password" />
            </el-form-item>

            <!-- 注册时的额外字段 -->
            <el-form-item v-if="type === 1" prop="confirmPassword" label="确认密码">
              <el-input type="password" v-model="form.confirmPassword" />
            </el-form-item>
            <el-form-item v-if="type === 1" prop="email" label="邮箱">
              <el-input v-model="form.email" />
            </el-form-item>
            <el-form-item v-if="type === 1" prop="phone" label="手机号">
              <el-input v-model="form.phone" />
            </el-form-item>

            <!-- 修改协议勾选的表单项，仅在注册时显示和验证 -->
            <el-form-item v-if="type === 1" prop="agree" label-width="22px">
              <el-checkbox size="large" v-model="form.agree">
                我已同意隐私条款和服务条款
              </el-checkbox>
            </el-form-item>

            <!-- 修改提交按钮的样式 -->
            <el-form-item class="submit-item">
              <el-button size="large" class="subBtn" @click="type === 2 ? doLogin() : doRegister()">
                {{ type === 2 ? '点击登录' : '立即注册' }}
              </el-button>
            </el-form-item>
          </el-form>
        </div>
      </div>
    </section>

    <footer class="login-footer">
      <div class="container">
        <p>
          <a href="javascript:;">关于我们</a>
          <a href="javascript:;">帮助中心</a>
          <a href="javascript:;">售后服务</a>
          <a href="javascript:;">配送与验收</a>
          <a href="javascript:;">商务合作</a>
          <a href="javascript:;">搜索推荐</a>
          <a href="javascript:;">友情链接</a>
        </p>
        <p>CopyRight &copy; 宠物帮帮居</p>
      </div>
    </footer>

    <div class="extra-links">
      <router-link to="/member/reset-password">忘记密码？</router-link>
    </div>
  </div>
</template>

<style scoped lang='less'>
.login-header {
  background: #fff;
  border-bottom: 1px solid #e4e4e4;

  .container {
    display: flex;
    align-items: flex-end;
    justify-content: space-between;
  }

  .logo {

    display: block;
    height: 80px;
    width: 100%;
    text-indent: -9999px;
    background: url('@/assets/宠物帮帮居.png') no-repeat 18px/ contain;
    padding-left: 20px;
  }

  .sub {
    flex: 1;
    font-size: 24px;
    font-weight: normal;
    margin-bottom: 38px;
    margin-left: 20px;
    color: #666;
  }

  .entry {
    width: 120px;
    margin-bottom: 38px;
    font-size: 16px;

    i {
      font-size: 14px;
      color: red;
      letter-spacing: -5px;
    }
  }
}

.login-section {
  background: url('@/assets/Carousel.png') no-repeat center / cover;
  height: 600px;
  position: relative;

  .wrapper {
    width: 380px;
    height: fit-content;
    background: #fff;
    position: absolute;
    left: 50%;
    top: 100px;
    transform: translate3d(100px, 0, 0);
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
    border-radius: 8px;
    // padding-bottom: 30px;

    nav {
      font-size: 14px;
      height: 55px;
      margin-bottom: 30px;
      border-bottom: 1px solid #f5f5f5;
      display: flex;
      padding: 0 40px;
      justify-content: center;
      align-items: center;

      :deep(.el-radio-group) {
        --el-color-primary: #ff8659;

        .el-radio-button__inner {
          // padding: 8px 30px;
          font-size: 16px;
        }
      }
    }
  }
}

.login-footer {
  padding: 30px 0 50px;
  background: #fff;

  p {
    text-align: center;
    color: #999;
    padding-top: 20px;

    a {
      line-height: 1;
      padding: 0 10px;
      color: #999;
      display: inline-block;

      ~a {
        border-left: 1px solid #ccc;
      }
    }
  }
}

.account-box {
  .login-form {
    padding: 0 50px;
    height: fit-content;

    :deep(.el-form-item) {
      .el-form-item__content {
        width: 280px;

      }

      .el-input__wrapper {
        box-shadow: 0 0 0 1px #dcdfe6;
        transition: all 0.3s;

        &:hover {
          box-shadow: 0 0 0 1px #ff8659;
        }

        &.is-focus {
          box-shadow: 0 0 0 1px #ff6b35;
        }
      }

      .el-checkbox__inner {
        &:hover {
          border-color: #ff8659;
        }

        &.is-checked .el-checkbox__inner {
          background-color: #ff6b35;
          border-color: #ff6b35;
        }
      }
    }
  }

  .submit-item {
    text-align: center;

    :deep(.el-form-item__content) {
      justify-content: center;
      margin-left: 0 !important;
    }
  }
}

.subBtn {
  background: #ff6b35;
  width: 280px;
  color: #fff;
  border: none;
  transition: all 0.3s;
  height: 44px;
  font-size: 16px;
  border-radius: 22px;

  &:hover {
    background: #ff8659;
    color: #fff;
  }

  &:active {
    background: #e55a2b;
  }
}
</style>