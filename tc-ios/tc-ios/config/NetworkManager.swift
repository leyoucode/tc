//
//  NetworkManager.swift
//  test-swiftui
//
//  Created by LIUWEI on 2024/11/27.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkManager {
    static let shared = NetworkManager()
    
    func requestData(url: String, method: HTTPMethod, parameters: [String: Any]?, completion: @escaping (JSON?, Error?) -> Void) {
        AF.request(url, method: method, parameters: parameters).responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                completion(json, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
