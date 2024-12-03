package com.tc.print.http

import okhttp3.MultipartBody
import retrofit2.Response
import retrofit2.http.Body
import retrofit2.http.DELETE
import retrofit2.http.GET
import retrofit2.http.Multipart
import retrofit2.http.POST
import retrofit2.http.PUT
import retrofit2.http.Part
import retrofit2.http.Path
import retrofit2.http.Query
import retrofit2.http.QueryMap

interface ApiService {

    @GET("/{path}")
    suspend fun get(
        @Path("path") path: String,
        @QueryMap params: Map<String, String>? = null
    ): ApiResponse<Any>

    @POST("/{path}")
    suspend fun post(
        @Path("path") path: String,
        @Body body: Any
    ): ApiResponse<Any>

    @PUT("/{path}")
    suspend fun put(
        @Path("path") path: String,
        @Body body: Any
    ): ApiResponse<Any>

    @DELETE("/{path}")
    suspend fun delete(
        @Path("path") path: String
    ): ApiResponse<Any>

    @Multipart
    @POST("/{path}")
    suspend fun upload(
        @Path("path") path: String,
        @Part file: MultipartBody.Part
    ): ApiResponse<Any>

    @POST("/auth/refresh-token")
    suspend fun refreshToken(
        @Query("refreshToken") refreshToken: String
    ): Response<ApiResponse<TokenData>>

    @POST("system/auth/login")
    suspend fun login(@Body loginRequest: LoginRequest): ApiResponse<LoginResponse>
}