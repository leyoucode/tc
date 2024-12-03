package com.tc.print.pos.fragment.index

import com.tc.print.base.BaseFragment
import com.tc.print.pos.BR
import com.tc.print.pos.R
import com.tc.print.pos.databinding.FragmentHomeBinding

/**
 * 首页
 */
class FragmentIndex : BaseFragment<FragmentHomeBinding, IndexViewModel>() {

    override fun getLayoutId(): Int {
        return R.layout.fragment_home
    }

    override fun getViewModelId(): Int {
        return BR.indexVm
    }

    override fun initViewData() {

    }

}
