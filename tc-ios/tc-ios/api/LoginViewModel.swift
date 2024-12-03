////
////  LoginViewModel.swift
////  test-swiftui
////
////  Created by LIUWEI on 2024/11/27.
////
//
//import Foundation
//import Combine
//
//@MainActor
//class LoginViewModel: ObservableObject {
//    
//    // 输入字段
//    @Published var username = ""
//    @Published var password = ""
//    @Published var tenantName = ""
//    @Published var rememberMe = false
//    
//    // UI 状态
//    @Published var isLoading = false
//    @Published var showError = false
//    @Published var errorMessage = ""
//    
//    // 配置
//    let tenantEnabled = Bundle.main.infoDictionary?["TENANT_ENABLED"] as? Bool ?? false
//    
//    // 添加 NetworkReachability 实例
//    private let networkReachability = NetworkReachability.shared
//    
//    // 表单验证
//    var isValid: Bool {
//        if tenantEnabled && tenantName.isEmpty {
//            return false
//        }
//        return !username.isEmpty && !password.isEmpty
//    }
//    
//    // 登录方法
//    func login() async {
//        guard isValid else { return }
//        
//        isLoading = true
//        defer { isLoading = false }
//        
//        // 检查网络连接
//            guard networkReachability.isConnected else {
//                await MainActor.run {
//                    errorMessage = "无法连接到网络，请检查网络设置"
//                    showError = true
//                }
//                return
//            }
//        
//        do {
//            // 如果启用了租户，先获取租户ID
//            if tenantEnabled {
//                try await getTenantId()
//            }
//            
//            // 登录请求
//            let loginResponse: LoginResponse = try await NetworkService.shared.request(
//            "/system/auth/login",
//            method: .post,
//            parameters: [
//                "username": username,
//                "password": password
//            ],
//            responseType: LoginResponse.self
//        )
//            
//            // 保存登录状态
//            await AuthManager.shared.setTokens(
//                accessToken: loginResponse.accessToken,
//                refreshToken: loginResponse.refreshToken
//            )
//            
//            // 保存记住我的状态
//            if rememberMe {
//                saveLoginForm()
//            }
//            
//            // 获取用户信息
//            try await fetchUserInfo()
//            
//            // 登录成功，进入主页
//            await MainActor.run {
//                NotificationCenter.default.post(name: .userDidLogin, object: nil)
//            }
//        } catch URLError.notConnectedToInternet {
//                await MainActor.run {
//                    errorMessage = "网络连接已断开"
//                    showError = true
//                }
//        } catch URLError.networkConnectionLost {
//            await MainActor.run {
//                errorMessage = "网络连接已断开"
//                showError = true
//            }
//            
//        } catch DecodingError.keyNotFound(let key, let context) {
//            await MainActor.run {
//                errorMessage = "缺少必要字段：\(key.stringValue)"
//                showError = true
//            }
//        } catch DecodingError.dataCorrupted(let context) {
//            await MainActor.run {
//                errorMessage = "数据格式错误：\(context.debugDescription)"
//                showError = true
//            }
//        } catch {
//            await MainActor.run {
//                errorMessage = "登录失败：\(error.localizedDescription)"
//                showError = true
//            }
//        }
//        }
//        
//        // 获取租户ID
//        private func getTenantId() async throws {
//            let response: TenantResponse = try await NetworkService.shared.request(
//                "/system/tenant/get-id",
//                method: .get,
//                parameters: ["name": tenantName],
//                responseType: TenantResponse.self
//            )
//            await AuthManager.shared.setTenantId(response.tenantId)
//        }
//    
//        // 获取用户信息
//        private func fetchUserInfo() async throws {
//            let user: User = try await NetworkService.shared.request(
//                "/system/user/profile/get",
//                method: .get,
//                responseType: User.self
//            )
//            UserManager.shared.setCurrentUser(user)
//        }
//        
//        // 保存登录表单
//        private func saveLoginForm() {
//            let loginForm = [
//                "username": username,
//                "password": password,
//                "tenantName": tenantName,
//                "rememberMe": "true"
//            ]
//            UserDefaults.standard.set(loginForm, forKey: "loginForm")
//        }
//        
//        // 加载保存的登录表单
//        func loadSavedLoginForm() {
//            guard let loginForm = UserDefaults.standard.dictionary(forKey: "loginForm") as? [String: String] else {
//                return
//            }
//            
//            username = loginForm["username"] ?? ""
//            password = loginForm["password"] ?? ""
//            tenantName = loginForm["tenantName"] ?? ""
//            rememberMe = true
//        }
//        
//        // 忘记密码
//        func forgotPassword() {
//            // 实现忘记密码逻辑
//        }
//    }
//
//struct LoginResponse: Codable {
//    let accessToken: String
//    let refreshToken: String
//    
//}
