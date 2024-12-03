//
//  AuthRequiredModifier.swift
//  test-swiftui
//
//  Created by LIUWEI on 2024/11/30.
//

import SwiftUI

struct AuthRequiredModifier: ViewModifier {
    @StateObject private var authViewModel = AuthViewModel.shared
    @State private var showLoginSheet = false
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                authViewModel.checkAuthStatus()
                if !authViewModel.isAuthenticated {
                    showLoginSheet = true
                }
            }
            .fullScreenCover(isPresented: $showLoginSheet) {
                // 登录成功后会调用
                authViewModel.checkAuthStatus()
            } content: {
                LoginView(isPresented: $showLoginSheet)
            }
    }
}

extension View {
    func requiresAuth() -> some View {
        modifier(AuthRequiredModifier())
    }
}
