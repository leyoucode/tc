package com.tc.print.pos.activity.login

import android.app.Application
import androidx.databinding.ObservableField
import com.blankj.utilcode.util.ToastUtils
import com.tc.print.base.BaseViewModel
import com.tc.print.base.SingleLiveEvent

class LoginViewModel(application: Application): BaseViewModel(application) {

    val username = ObservableField<String>()
    val password = ObservableField<String>()
    val passwordTwice = ObservableField<String>()

    //登录或者注册是否成功
    val actionState = SingleLiveEvent<Boolean>()

    init {

    }

    /**
     * 注册
     */
    fun login() {
        if (checkNull(username.get()) || checkNull(password.get())) {
            ToastUtils.showShort("输入不能为空")
            return
        }
        ToastUtils.showShort("登录")
//        viewModelScope.launch {
//            val data: UserData? = Repository.login(username.get() ?: "", password.get() ?: "")
//            if (data != null) {
//                //保存用户名
//                SPUtils.getInstance().put(Constants.SP_USER_NAME,data.username)
//                //登录成功
//                actionState.postValue(true)
//            } else {
//                actionState.postValue(false)
//            }
//        }
    }

    /**
     * 注册
     */
    fun register() {
        if (checkNull(username.get()) || checkNull(password.get()) || checkNull(passwordTwice.get())) {
            ToastUtils.showShort("输入不能为空")
            return
        }
        ToastUtils.showShort("注册")
//        viewModelScope.launch {
//            val data: UserData? = Repository.register(
//                username.get() ?: "",
//                password.get() ?: "",
//                passwordTwice.get() ?: ""
//            )
//            if (data != null) {
//                //注册成功
//                actionState.postValue(true)
//            } else {
//                actionState.postValue(false)
//            }
//        }
    }

    private fun checkNull(value: String?): Boolean {
        return value.isNullOrEmpty()
    }
}