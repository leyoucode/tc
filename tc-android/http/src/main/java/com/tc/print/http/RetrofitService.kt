package com.tc.print.http
import android.util.Log
import com.blankj.utilcode.BuildConfig
import com.tc.print.http.exception.ApiException
import com.tc.print.http.exception.UnauthorizedException
import com.tc.print.http.interceptor.AuthInterceptor
import com.tc.print.http.interceptor.ResponseInterceptor
import com.tc.print.http.token.TokenManager
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okhttp3.OkHttpClient
import okhttp3.ResponseBody.Companion.toResponseBody
import okhttp3.logging.HttpLoggingInterceptor
import org.greenrobot.eventbus.EventBus
import retrofit2.Call
import retrofit2.HttpException
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.io.IOException
import java.util.concurrent.TimeUnit

class RetrofitService private constructor(private val tokenManager: TokenManager) {

    companion object {
        @Volatile
        private var instance: RetrofitService? = null
        private const val LOG_TAG = "RetrofitService"
        fun getInstance(tokenManager: TokenManager): RetrofitService {
            return instance ?: synchronized(this) {
                instance ?: RetrofitService(tokenManager).also { instance = it }
            }
        }
        // 重置实例
        fun reset() {
            instance = null
        }
    }

    val retrofit: Retrofit by lazy {
        createRetrofit()
    }

    private var isRefreshing = false
    private val requestQueue = mutableListOf<Call<*>>()

    private fun createRetrofit(): Retrofit {
        val loggingInterceptor = HttpLoggingInterceptor { message -> Log.d(LOG_TAG, message) }.apply {
            level = if (BuildConfig.DEBUG) {
                HttpLoggingInterceptor.Level.BODY
            } else {
                HttpLoggingInterceptor.Level.NONE
            }
        }

        val client = OkHttpClient.Builder()
            .addInterceptor(AuthInterceptor(tokenManager))
            .addInterceptor(ResponseInterceptor())
            .addInterceptor(loggingInterceptor)
            .addInterceptor { chain ->
                val request = chain.request()
                
                // 打印请求信息
                Log.d(LOG_TAG, "\n=== HTTP Request ===")
                Log.d(LOG_TAG, "URL: ${request.url}")
                Log.d(LOG_TAG, "Method: ${request.method}")
                Log.d(LOG_TAG, "Headers: ${request.headers}")
                
                val response = chain.proceed(request)
                
                // 打印响应信息
                Log.d(LOG_TAG, "\n=== HTTP Response ===")
                Log.d(LOG_TAG, "Code: ${response.code}")
                Log.d(LOG_TAG, "Headers: ${response.headers}")
                
                // 打印响应体
                response.body?.let { responseBody ->
                    val contentType = responseBody.contentType()
                    val content = responseBody.string()
                    Log.d(LOG_TAG, "Body: $content")
                    
                    // 重建响应体，因为responseBody.string()会消耗响应流
                    val newBody = content.toResponseBody(contentType)
                    response.newBuilder().body(newBody).build()
                } ?: response
            }
            .connectTimeout(NetworkConfig.CONNECT_TIMEOUT, TimeUnit.SECONDS)
            .readTimeout(NetworkConfig.READ_TIMEOUT, TimeUnit.SECONDS)
            .writeTimeout(NetworkConfig.WRITE_TIMEOUT, TimeUnit.SECONDS)
            .build()
        return Retrofit.Builder()
            .baseUrl(EnvironmentManager.getBaseUrl())
            .client(client)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
    }

    // 创建API服务实例
    fun createApiService(): ApiService {
        return retrofit.create(ApiService::class.java)
    }

    // 处理请求的扩展函数
    suspend fun <T> Call<ApiResponse<T>>.executeWithRetry(): ApiResponse<T> {
        return withContext(Dispatchers.IO) {
            try {
                val response = execute()
                handleResponse(response)
            } catch (e: Exception) {
                handleError(e)
            }
        }
    }

    // 处理响应
    private suspend fun <T> handleResponse(response: Response<ApiResponse<T>>): ApiResponse<T> {
        if (!response.isSuccessful) {
            throw HttpException(response)
        }

        val body = response.body() ?: throw ApiException("Response body is null")

        return when (body.code) {
            NetworkConfig.RESULT_CODE_SUCCESS -> body
            NetworkConfig.RESULT_CODE_UNAUTHORIZED -> {
                if (!isRefreshing) {
                    refreshToken()
                }
                throw UnauthorizedException()
            }
            else -> throw ApiException(body.msg ?: "Unknown error")
        }
    }

    // Token刷新
    private suspend fun refreshToken() {
        if (isRefreshing) return

        isRefreshing = true
        try {
            withContext(Dispatchers.IO) {
                val response = tokenManager.refreshToken()
                if (response.isSuccessful) {
                    response.body()?.data?.let { tokenManager.updateToken(it) }
                    retryQueuedRequests()
                } else {
                    handleLogout()
                }
            }
        } catch (e: Exception) {
            handleLogout()
        } finally {
            isRefreshing = false
            requestQueue.clear()
        }
    }

    // 重试队列中的请求
    private suspend fun retryQueuedRequests() {
        withContext(Dispatchers.IO) {
            requestQueue.forEach { call ->
                try {
                    val newCall = call.clone()
                    newCall.request().newBuilder()
                        .header(NetworkConfig.HEADER_AUTHORIZATION, "Bearer ${tokenManager.getAccessToken()}")
                        .build()

                    val response = newCall.execute()
                    if (!response.isSuccessful) {
                        throw HttpException(response)
                    }
                } catch (e: Exception) {
                    when (e) {
                        is IOException -> throw ApiException("网络连接失败，请检查网络设置")
                        is HttpException -> throw ApiException("服务器响应错误: ${e.code()}")
                        else -> throw e
                    }
                }
            }
        }
    }

    // 处理登出逻辑
    private suspend fun handleLogout() {
        withContext(Dispatchers.Main) {
            tokenManager.clearTokens()
            EventBus.getDefault().post(LogoutEvent())
        }
    }

    // 处理错误
    private fun handleError(error: Exception): Nothing {
        throw when (error) {
            is IOException -> ApiException("网络连接失败，请检查网络设置")
            is HttpException -> ApiException("服务器响应错误: ${error.code()}")
            else -> error
        }
    }


}