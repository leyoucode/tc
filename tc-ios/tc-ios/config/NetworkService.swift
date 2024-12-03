//
//  NetworkService.swift
//  test-swiftui
//
//  Created by LIUWEI on 2024/11/27.
//

import Alamofire
import SwiftyJSON

class NetworkService {
    // 基础配置
    private struct Constants {
        static let baseURL = Bundle.main.infoDictionary?["BASE_URL"] as? String ?? "https://api-dev.jsd-express.cn"
        static let apiURL = Bundle.main.infoDictionary?["API_URL"] as? String ?? "/admin-api"
        static let timeout: TimeInterval = 30
        static let defaultHeaders: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
    }
    
    // 错误码
    private enum ErrorCode: Int {
        case success = 0
        case unauthorized = 401
        case forbidden = 403
        case notFound = 404
        case serverError = 500
    }
    
    static let shared = NetworkService()
    private let session: Session
    
    private init() {
        // 配置请求拦截器
        let interceptor = RequestInterceptor()
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = Constants.timeout
        
        self.session = Session(
            configuration: configuration,
            interceptor: interceptor
        )
    }
}

// MARK: - 请求方法
extension NetworkService {
    func request<T: Codable>(
        _ path: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        responseType: T.Type
    ) async throws -> T {
        let fullURL = Constants.baseURL + Constants.apiURL + path
        
        let finalHeaders = headers ?? Constants.defaultHeaders
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(
                fullURL,
                method: method,
                parameters: parameters,
                encoding: method == .get ? URLEncoding.default : JSONEncoding.default,
                headers: finalHeaders
            )
            .validate()
            .responseDecodable(of: NetworkResponse<T>.self) { response in
                print("\n------------------------------------")
                print(">>>>>>>> 请求:")
                print(">>>>>>>> \(method.rawValue) \(fullURL)")
                print(">>>>>>>> Request Headers: \(response.request?.allHTTPHeaderFields ?? [:])")
                print(">>>>>>>> Request Parameters: \(parameters ?? [:])")
                print("<<<<<<<< 响应:")
                print("<<<<<<<< Response Code: \(response.response?.statusCode ?? 0)")
                print("<<<<<<<< Response Headers: \(response.response?.allHeaderFields ?? [:])")
                print("<<<<<<<< Response Body: \(String(data: response.data ?? Data(), encoding: .utf8) ?? "数据解析失败")")
                print("------------------------------------\n")
                
                switch response.result {
                case .success(let networkResponse):
                    if networkResponse.code == ErrorCode.success.rawValue {
                        continuation.resume(returning: networkResponse.data)
                    } else {
                        continuation.resume(throwing: NetworkError(code: networkResponse.code, msg: networkResponse.msg))
                    }
                case .failure(let error):
                    // 打印错误信息
                    print("Error: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // 上传文件
    func upload<T: Codable>(
        _ path: String,
        data: Data,
        fileName: String,
        mimeType: String,
        parameters: Parameters? = nil,
        responseType: T.Type
    ) async throws -> T {
        let fullURL = Constants.baseURL + Constants.apiURL + path
        
        return try await withCheckedThrowingContinuation { continuation in
            session.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(
                        data,
                        withName: "file",
                        fileName: fileName,
                        mimeType: mimeType
                    )
                    
                    // 添加其他参数
                    parameters?.forEach { key, value in
                        if let data = "\(value)".data(using: .utf8) {
                            multipartFormData.append(data, withName: key)
                        }
                    }
                },
                to: fullURL
            )
            .responseDecodable(of: NetworkResponse<T>.self) { response in
                switch response.result {
                case .success(let networkResponse):
                    if networkResponse.code == ErrorCode.success.rawValue {
                        continuation.resume(returning: networkResponse.data)
                    } else {
                        continuation.resume(throwing: NetworkError(code: networkResponse.code, msg: networkResponse.msg))
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
