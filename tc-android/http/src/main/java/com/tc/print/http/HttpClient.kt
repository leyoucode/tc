package com.tc.print.http
//
//import okhttp3.MultipartBody
//import okhttp3.MediaType.Companion.toMediaTypeOrNull
//import okhttp3.RequestBody.Companion.asRequestBody
//import java.io.File
//
//class HttpClient private constructor(tokenManager: TokenManager) {
//    private val service = RetrofitService.getInstance(tokenManager)
//    private val api = service.createApiService()
//
//    suspend fun <T> get(path: String, params: Map<String, String>? = null): T {
//        return api.get(path, params).data as T
//    }
//
//    suspend fun <T> post(path: String, body: Any): T {
//        return api.post(path, body).data as T
//    }
//
//    suspend fun <T> put(path: String, body: Any): T {
//        return api.put(path, body).data as T
//    }
//
//    suspend fun <T> delete(path: String): T {
//        return api.delete(path).data as T
//    }
//
//    suspend fun <T> upload(path: String, file: File): T {
//        val requestBody = file.asRequestBody("multipart/form-data".toMediaTypeOrNull())
//        val part = MultipartBody.Part.createFormData("file", file.name, requestBody)
//        return api.upload(path, part).data as T
//    }
//
//    companion object {
//        @Volatile
//        private var instance: HttpClient? = null
//
//        fun getInstance(tokenManager: TokenManager): HttpClient {
//            return instance ?: synchronized(this) {
//                instance ?: HttpClient(tokenManager).also { instance = it }
//            }
//        }
//
//        fun reset() {
//            instance = null
//        }
//    }
//}