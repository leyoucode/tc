package com.tc.print.pos.activity.main

import android.graphics.BitmapFactory
import androidx.fragment.app.Fragment
import androidx.viewpager2.widget.ViewPager2
import com.blankj.utilcode.util.LogUtils
import com.tc.print.base.BaseActivity
import com.tc.print.base.adapter.Pager2Adapter
import com.tc.print.base.tab.NavigationBottomBar
import com.tc.print.pos.BR
import com.tc.print.pos.R
import com.tc.print.pos.databinding.ActivityTabBinding
import com.tc.print.pos.fragment.device.FragmentDevice
import com.tc.print.pos.fragment.index.FragmentIndex
import com.tc.print.pos.fragment.order.FragmentOrder
import com.tc.print.pos.fragment.mine.FragmentMine

class MainTabActivity : BaseActivity<ActivityTabBinding, MainTabViewModel>() {

    override fun getLayoutId(): Int {
        return R.layout.activity_tab
    }

    override fun getViewModelId(): Int {
        return BR.mainVm
    }

    override fun initViewData() {
        initPageModule()
        val icons = arrayOf(
            BitmapFactory.decodeResource(resources, R.drawable.icon_index_selected),
            BitmapFactory.decodeResource(resources, R.drawable.icon_device_selected),
            BitmapFactory.decodeResource(resources, R.drawable.icon_order_selected),
            BitmapFactory.decodeResource(resources, R.drawable.icon_mime_selected)
        )
        val icons2 = arrayOf(
            BitmapFactory.decodeResource(resources, R.drawable.icon_index_grey),
            BitmapFactory.decodeResource(resources, R.drawable.icon_device_grey),
            BitmapFactory.decodeResource(resources, R.drawable.icon_order_grey),
            BitmapFactory.decodeResource(resources, R.drawable.icon_mime_grey)
        )
        val tabTexts = arrayOf("首页", "设备", "订单", "我的")
        binding?.tabBottomBar?.setSelectedIcons(icons.toList())?.setUnselectIcons(icons2.toList())
            ?.setTabText(tabTexts.toList())?.setupViewpager(binding?.tabViewPager2)?.start()
        binding?.tabBottomBar?.registerTabClickListener(object :
            NavigationBottomBar.OnBottomTabClickListener {
            override fun tabClick(position: Int) {
                LogUtils.d("registerTabClickListener position=$position")
            }
        })
    }

    private fun initPageModule() {
        val pageFragList = mutableListOf<Fragment>()
        pageFragList.add(FragmentIndex())
        pageFragList.add(FragmentDevice())
        pageFragList.add(FragmentOrder())
        pageFragList.add(FragmentMine())

        val pageAdapter = Pager2Adapter(this)
        pageAdapter.setData(pageFragList)
        //默认不做预加载Fragment
        binding?.tabViewPager2?.offscreenPageLimit = ViewPager2.OFFSCREEN_PAGE_LIMIT_DEFAULT
        binding?.tabViewPager2?.adapter = pageAdapter
    }

}