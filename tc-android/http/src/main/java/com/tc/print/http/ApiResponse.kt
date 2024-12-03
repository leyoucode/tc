package com.tc.print.http

data class ApiResponse<T>(
    val code: Int,
    val msg: String?,
    val data: T?
)