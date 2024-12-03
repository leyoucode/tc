//
//  AuthViewModel.swift
//  test-swiftui
//
//  Created by LIUWEI on 2024/11/30.
//

import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    static let shared = AuthViewModel()
    
    @Published var isAuthenticated: Bool = false
    
    private init() {
        // 初始化时检查登录状态
        Task {
            isAuthenticated = await AuthManager.shared.accessToken != nil
        }
    }
    
    func checkAuthStatus() {
        Task {
            isAuthenticated = await AuthManager.shared.accessToken != nil
        }
    }
    
    func logout() {
        Task {
            await AuthManager.shared.clearTokens()
            isAuthenticated = false
        }
    }
} 
