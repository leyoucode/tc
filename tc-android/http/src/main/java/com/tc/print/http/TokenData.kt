package com.tc.print.http

data class TokenData(
    val accessToken: String,
    val refreshToken: String
)

data class LoginResponse(
    val accessToken: String,
    val refreshToken: String
)

data class LoginRequest(
    val username: String,
    val password: String
)