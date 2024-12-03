//
//  SocialLoginType.swift
//  test-swiftui
//
//  Created by LIUWEI on 2024/11/27.
//

enum SocialLoginType: String, CaseIterable, Identifiable {
    case wechat
    case qq
    case weibo
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .wechat: return "icon_wechat"
        case .qq: return "icon_qq"
        case .weibo: return "icon_weibo"
        }
    }
}
