package com.tc.print.http

object NetworkConfig {
    const val CONNECT_TIMEOUT = 30L
    const val READ_TIMEOUT = 30L
    const val WRITE_TIMEOUT = 30L

    const val RESULT_CODE_SUCCESS = 0
    const val RESULT_CODE_UNAUTHORIZED = 401

    const val HEADER_CONTENT_TYPE = "Content-Type"
    const val HEADER_AUTHORIZATION = "Authorization"
    const val HEADER_TENANT_ID = "tenant-id"

    const val DEFAULT_CONTENT_TYPE = "application/json"
}