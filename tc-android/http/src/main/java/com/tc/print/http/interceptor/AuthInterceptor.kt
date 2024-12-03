package com.tc.print.http.interceptor

import com.tc.print.http.NetworkConfig
import com.tc.print.http.token.TokenManager
import okhttp3.Interceptor
import okhttp3.Response

class AuthInterceptor(private val tokenManager: TokenManager) : Interceptor {
    override fun intercept(chain: Interceptor.Chain): Response {
        val requestBuilder = chain.request().newBuilder()
        tokenManager.getAccessToken()?.let {
            requestBuilder.addHeader(NetworkConfig.HEADER_AUTHORIZATION, "Bearer $it")
        }
        return chain.proceed(requestBuilder.build())
    }
}