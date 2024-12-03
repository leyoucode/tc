package com.tc.print.http.token

import android.content.Context
import com.tc.print.http.ApiResponse
import com.tc.print.http.ApiService
import com.tc.print.http.RetrofitService
import com.tc.print.http.TokenData
import retrofit2.Response

class TokenManager(private val context: Context) {

    private val prefs = context.getSharedPreferences("auth_prefs", Context.MODE_PRIVATE)

    fun getAccessToken(): String? {
        return prefs.getString("access_token", null)
    }

    private fun getRefreshToken(): String? {
        return prefs.getString("refresh_token", null)
    }

    fun updateToken(tokenData: TokenData) {
        prefs.edit().apply {
            putString("access_token", tokenData.accessToken)
            putString("refresh_token", tokenData.refreshToken)
            apply()
        }
    }

    suspend fun refreshToken(): Response<ApiResponse<TokenData>> {
        // 假设有一个API接口用于刷新token
        val api = RetrofitService.getInstance(this).retrofit.create(ApiService::class.java)
        return api.refreshToken(getRefreshToken() ?: "")
    }

    fun clearTokens() {
        prefs.edit().apply {
            remove("access_token")
            remove("refresh_token")
            apply()
        }
    }
}