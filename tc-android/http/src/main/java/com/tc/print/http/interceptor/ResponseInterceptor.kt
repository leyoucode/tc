package com.tc.print.http.interceptor

import com.tc.print.http.exception.ApiException
import okhttp3.Interceptor
import okhttp3.Response


class ResponseInterceptor : Interceptor {
    override fun intercept(chain: Interceptor.Chain): Response {
        val response = chain.proceed(chain.request())
        if (!response.isSuccessful) {
            // 处理错误响应
            val errorBody = response.body?.string()
            // 解析错误信息并抛出异常
            throw ApiException(errorBody ?: "Unknown error")
        }
        return response
    }
}