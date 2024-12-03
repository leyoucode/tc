//
//  LoginView.swift
//  test-swiftui
//
//  Created by LIUWEI on 2024/11/27.
//

import SwiftUI

import SwiftUI

struct LoginView: View {
    @StateObject private var authViewModel = AuthViewModel.shared
    @Binding var isPresented: Bool
    
    @State private var username = "lylsy"
    @State private var password = "lylsy"
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("用户名", text: $username)
                        .autocapitalization(.none)
                    SecureField("密码", text: $password)
                }
                
                if let errorMessage = errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
                
                Section {
                    Button(action: login) {
                        if isLoading {
                            ProgressView()
                        } else {
                            Text("登录")
                        }
                    }
                    .disabled(isLoading || username.isEmpty || password.isEmpty)
                }
            }
            .navigationTitle("登录1")
            .disabled(isLoading)
        }
    }
    
    private func login() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let loginResponse: LoginResponse = try await NetworkService.shared.request(
                    "/system/auth/login",
                    method: .post,
                    parameters: [
                        "username": username,
                        "password": password
                    ],
                    responseType: LoginResponse.self
                )
                
                await AuthManager.shared.setTokens(
                    accessToken: loginResponse.accessToken,
                    refreshToken: loginResponse.refreshToken
                )
                
                authViewModel.checkAuthStatus()
                isPresented = false
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}

// 登录响应模型
struct LoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
}

//struct LoginView: View {
//    @StateObject private var viewModel = LoginViewModel()
//    @Environment(\.dismiss) private var dismiss
//    
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 20) {
//                // Logo
//                Image("logo")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 100, height: 100)
//                
//                // 登录表单
//                LoginForm(viewModel: viewModel)
//                
//                // 其他登录选项
//                OtherLoginOptions()
//                
//                Spacer()
//            }
//            .padding()
//            .navigationTitle("登录")
//            .alert("错误", isPresented: $viewModel.showError) {
//                Button("确定", role: .cancel) {}
//            } message: {
//                Text(viewModel.errorMessage)
//            }
//            .overlay {
//                if viewModel.isLoading {
//                    ProgressView()
//                        .background(.ultraThinMaterial)
//                }
//            }
//        }
//    }
//}
//
//// 登录表单
//private struct LoginForm: View {
//    @ObservedObject var viewModel: LoginViewModel
//    
//    var body: some View {
//        VStack(spacing: 15) {
//            // 租户输入框（如果需要）
//            if viewModel.tenantEnabled {
//                TextField("请输入租户名称", text: $viewModel.tenantName)
//                    .textFieldStyle(.roundedBorder)
//                    .autocapitalization(.none)
//            }
//            
//            // 用户名输入框
//            TextField("请输入用户名", text: $viewModel.username)
//                .textFieldStyle(.roundedBorder)
//                .autocapitalization(.none)
//            
//            // 密码输入框
//            SecureField("请输入密码", text: $viewModel.password)
//                .textFieldStyle(.roundedBorder)
//            
//            // 记住我
//            Toggle("记住我", isOn: $viewModel.rememberMe)
//            
//            // 登录按钮
//            Button {
//                Task {
//                    await viewModel.login()
//                }
//            } label: {
//                Text("登录")
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//            }
//            .disabled(!viewModel.isValid)
//            
//            // 忘记密码
//            Button("忘记密码？") {
//                viewModel.forgotPassword()
//            }
//            .foregroundColor(.blue)
//        }
//    }
//}
//
//// 其他登录选项
//private struct OtherLoginOptions: View {
//    var body: some View {
//        VStack(spacing: 10) {
//            Text("其他登录方式")
//                .foregroundColor(.gray)
//            
//            HStack(spacing: 20) {
//                ForEach(SocialLoginType.allCases) { type in
//                    Button {
//                        // 处理社交登录
//                    } label: {
//                        Image(type.iconName)
//                            .resizable()
//                            .frame(width: 44, height: 44)
//                    }
//                }
//            }
//        }
//    }
//}
