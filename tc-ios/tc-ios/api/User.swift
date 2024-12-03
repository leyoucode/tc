//
//  User.swift
//  test-swiftui
//
//  Created by LIUWEI on 2024/11/27.
//

import Foundation

struct User: Codable {
    let id: Int
    let username: String
    let nickname: String?
    let email: String?
    let avatar: String?
    let mobile: String?
    let sex: UserSex
    let loginIp: String?
    @OptionalTimestampDate var loginDate: Date?
    @TimestampDate var createTime: Date
    let createPartnerId: Int?
    let createPartnerType: Int?
    let roles: [Role]
    let posts: [String]?
    let socialUsers: [String]?
    
    // CodingKeys 用于处理字段映射
    private enum CodingKeys: String, CodingKey {
        case id, username, nickname, email, avatar, mobile, sex
        case loginIp, loginDate, createTime, createPartnerId, createPartnerType
        case roles, posts, socialUsers
    }
    
    // 用户状态枚举
    enum UserSex: Int, Codable {
        case unknown = 0
        case male = 1
        case female = 2
    }
    
    // 角色模型
    struct Role: Codable {
        let id: Int
        let name: String
    }
    
    
}

// MARK: - 扩展便利属性
extension User {
    var isAdmin: Bool {
        roles.contains { $0.name == "admin" }
    }
    
    var displayName: String {
        nickname ?? username
    }
}
