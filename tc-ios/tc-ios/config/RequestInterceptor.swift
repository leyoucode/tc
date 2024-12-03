//
//  RequestInterceptor.swift
//  test-swiftui
//
//  Created by LIUWEI on 2024/11/27.
//

import Alamofire
import SwiftyJSON

final class RequestInterceptor: Alamofire.RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        
        Task {
            // 获取token和租户ID
            let token = await AuthManager.shared.accessToken
            let tenantId = await AuthManager.shared.tenantId
            
            if let token = token {
                urlRequest.headers.add(.authorization(bearerToken: token))
            }
            
            if let tenantId = tenantId {
                urlRequest.headers.add(name: "tenant-id", value: tenantId)
            }
            
            completion(.success(urlRequest))
        }
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }
        
        Task {
            do {
                try await AuthManager.shared.refreshTokenIfNeeded()
                completion(.retry)
            } catch {
                completion(.doNotRetryWithError(error))
            }
        }
    }
}
