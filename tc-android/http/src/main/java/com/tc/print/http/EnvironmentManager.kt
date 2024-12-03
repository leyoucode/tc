package com.tc.print.http

enum class Environment(
    val baseUrl: String,
    val description: String
) {
    LOCAL(
        baseUrl = "http://localhost:48080",
        description = "本地开发环境"
    ),
    TEST(
        baseUrl = "https://api-dev.jsd-express.cn/admin-api/",
        description = "测试环境"
    ),
    PROD(
        baseUrl = "https://api.jsd-express.cn",
        description = "生产环境"
    );
}

object EnvironmentManager {
    private var currentEnvironment: Environment = Environment.LOCAL

    fun getCurrentEnvironment(): Environment = currentEnvironment

    fun switchEnvironment(environment: Environment) {
        currentEnvironment = environment
        // 清除旧的网络客户端实例，强制重新创建
        RetrofitService.reset()
    }

    fun getBaseUrl(): String = currentEnvironment.baseUrl
}

