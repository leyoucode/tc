package com.tc.print.pos.fragment.device

import com.tc.print.base.BaseFragment
import com.tc.print.pos.BR
import com.tc.print.pos.R
import com.tc.print.pos.databinding.FragmentDeviceBinding


/**
 * 设备
 */
class FragmentDevice : BaseFragment<FragmentDeviceBinding, DeviceViewModel>() {

    override fun getLayoutId(): Int {
        return R.layout.fragment_device
    }

    override fun getViewModelId(): Int {
        return BR.deviceVm
    }


    override fun initViewData() {

    }
}
