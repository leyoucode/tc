package com.tc.print.pos.fragment.mine

import com.tc.print.base.BaseFragment
import com.tc.print.pos.BR
import com.tc.print.pos.R
import com.tc.print.pos.databinding.FragmentMineBinding

/**
 * 我的
 */
class FragmentMine : BaseFragment<FragmentMineBinding, MineViewModel>() {

    override fun getLayoutId(): Int {
        return R.layout.fragment_mine
    }

    override fun getViewModelId(): Int {
        return BR.mineVm
    }

    override fun initViewData() {
    }

}
