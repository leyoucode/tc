package com.tc.print.pos.activity.main

import android.app.Application
import androidx.databinding.ObservableField
import com.tc.print.base.BaseViewModel

class MainTabViewModel(application: Application): BaseViewModel(application) {

    val text = ObservableField<String>()
}