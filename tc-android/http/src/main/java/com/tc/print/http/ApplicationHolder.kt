package com.tc.print.http
//
//import android.content.Context
//import java.lang.ref.WeakReference
//
//object ApplicationHolder {
//    private var contextRef: WeakReference<Context>? = null
//
//    fun init(context: Context) {
//        contextRef = WeakReference(context.applicationContext)
//    }
//
//    fun getContext(): Context? {
//        return contextRef?.get()
//    }
//}