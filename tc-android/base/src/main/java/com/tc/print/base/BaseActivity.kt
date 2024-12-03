package com.tc.print.base

import android.app.AlertDialog
import android.content.Intent
import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import androidx.databinding.DataBindingUtil
import androidx.databinding.ViewDataBinding
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.tc.print.http.LogoutEvent
import org.greenrobot.eventbus.EventBus
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode
import java.lang.reflect.ParameterizedType

abstract class BaseActivity<B : ViewDataBinding, VM : BaseViewModel> : AppCompatActivity() {

    open var binding: B? = null
    open var viewModel: VM? = null

    /**
     * 返回layout
     */
    abstract fun getLayoutId(): Int

    /**
     * 返回vm id，通过package.BR获取
     */
    abstract fun getViewModelId(): Int

    /**
     * 执行控件与业务逻辑
     */
    abstract fun initViewData()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        initBase()
        setContentView(binding?.root)
        initViewData()
    }

    override fun onStart() {
        super.onStart()
        EventBus.getDefault().register(this)
    }

    override fun onStop() {
        super.onStop()
        EventBus.getDefault().unregister(this)
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    open fun onLogoutEvent(event: LogoutEvent) {
        // 默认处理逻辑，如果有需要可以重写
        handleLogout()
    }

    protected open fun handleLogout() {
        // 默认的登出处理逻辑
        Log.d("BaseActivity", "handleLogout")
        showLogoutDialog()
    }

    // 显示登出对话框
    private fun showLogoutDialog() {
        AlertDialog.Builder(this)
            .setTitle("登录已过期")
            .setMessage("您的登录已过期，请重新登录")
            .setCancelable(false)
            .setPositiveButton("确定") { _, _ ->
                    val intent = Intent(this, LoginActivity::class.java).apply {
                        flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
                    }
                    startActivity(intent)
                Log.d("RetrofitService", "handleLogoutDialog")
            }
            .show()
    }

    private fun initBase() {
        //初始化binding
        binding = DataBindingUtil.setContentView(this@BaseActivity, getLayoutId())

        //获取ViewModel类型
        val modelClass: Class<BaseViewModel>
        //获取带有泛型的父类
        val type = javaClass.genericSuperclass
        //ParameterizedType参数化类型，即泛型
        modelClass = if (type is ParameterizedType) {
            //getActualTypeArguments获取参数化类型的数组，泛型可能有多个，这里我们默认第二个泛型是ViewModel
            type.actualTypeArguments[1] as Class<BaseViewModel>
        } else {
            //如果没有指定泛型参数，则默认使用ViewModel
            BaseViewModel::class.java
        }

        //初始化viewModel
        viewModel = createViewModel(this, modelClass as Class<VM>)
        //viewmodel与view绑定
        binding?.setVariable(getViewModelId(), viewModel)
        //绑定生命周期
        binding?.lifecycleOwner = this

    }

    override fun onDestroy() {
        super.onDestroy()
        binding?.unbind()
    }


    /**
     * 创建ViewModel 如果 需要自己定义ViewModel 直接复写此方法
     *
     * @param cls
     * @param <T>
     * @return
    </T> */
    open fun <T : ViewModel> createViewModel(activity: FragmentActivity?, cls: Class<T>?): T {
        return ViewModelProvider(activity!!)[cls!!]
    }
}
