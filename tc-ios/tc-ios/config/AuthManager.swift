//
//  AuthManager.swift
//  test-swiftui
//
//  Created by LIUWEI on 2024/11/27.
//

import Foundation
import KeychainAccess

import Foundation
import KeychainAccess

actor AuthManager {
    static let shared = AuthManager()
    
    private let keychain = Keychain(service: "com.yourapp.auth")
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    private let tenantIdKey = "tenantId"
    
    private var isRefreshing = false
    private var refreshTask: Task<Void, Error>?
    
    private init() {}
    
    var accessToken: String? {
        get { try? keychain.get(accessTokenKey) }
        set {
            if let token = newValue {
                try? keychain.set(token, key: accessTokenKey)
            } else {
                try? keychain.remove(accessTokenKey)
            }
        }
    }
    
    var refreshToken: String? {
        get { try? keychain.get(refreshTokenKey) }
        set {
            if let token = newValue {
                try? keychain.set(token, key: refreshTokenKey)
            } else {
                try? keychain.remove(refreshTokenKey)
            }
        }
    }
    
    var tenantId: String? {
        get { try? keychain.get(tenantIdKey) }
        set {
            if let id = newValue {
                try? keychain.set(id, key: tenantIdKey)
            } else {
                try? keychain.remove(tenantIdKey)
            }
        }
    }
    
    func setTenantId(_ tenantId: String) {
        self.tenantId = tenantId
    }
    
    func setTokens(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    func clearTokens() {
        accessToken = nil
        refreshToken = nil
        tenantId = nil
    }
    
    func refreshTokenIfNeeded() async throws {
        // 如果已经在刷新，等待当前刷新任务完成
        if let existingTask = refreshTask {
            return try await existingTask.value
        }
        
        guard !isRefreshing else { return }
        
        guard let refreshToken = refreshToken else {
            throw AuthError.noRefreshToken
        }
        
        isRefreshing = true
        
        // 创建新的刷新任务
        let task = Task {
            defer {
                isRefreshing = false
                refreshTask = nil
            }
            
            // 这里应该是你的实际刷新token的网络请求
            let response: RefreshTokenResponse = try await NetworkService.shared.request(
                "/auth/refresh-token",
                method: .post,
                parameters: ["refreshToken": refreshToken],
                responseType: RefreshTokenResponse.self
            )
            
            // 保存新的token
            setTokens(accessToken: response.accessToken, refreshToken: response.refreshToken)
        }
        
        refreshTask = task
        try await task.value
    }
}

enum AuthError: Error {
    case noRefreshToken
    case refreshFailed
}

struct RefreshTokenResponse: Codable {
    let accessToken: String
    let refreshToken: String
}
