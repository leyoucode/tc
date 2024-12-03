package com.tc.print.pos.fragment.order

import com.tc.print.base.BaseFragment
import com.tc.print.pos.BR
import com.tc.print.pos.R
import com.tc.print.pos.databinding.FragmentKnowledgeBinding

/**
 * 订单
 */
class FragmentOrder : BaseFragment<FragmentKnowledgeBinding, OrderViewModel>() {

    override fun getLayoutId(): Int {
        return R.layout.fragment_knowledge
    }

    override fun getViewModelId(): Int {
        return BR.orderVm
    }


    override fun initViewData() {

    }

}
