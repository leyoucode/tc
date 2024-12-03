//
//  NetworkResponse.swift
//  test-swiftui
//
//  Created by LIUWEI on 2024/11/27.
//

struct NetworkResponse<T: Codable>: Codable {
    let code: Int
    let msg: String
    let data: T
}

struct NetworkError: Error {
    let code: Int
    let msg: String
}
