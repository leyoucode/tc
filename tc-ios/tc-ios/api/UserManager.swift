//
//  UserManager.swift
//  test-swiftui
//
//  Created by LIUWEI on 2024/11/27.
//

import Foundation
import Combine

class UserManager: ObservableObject {
    static let shared = UserManager()
    
    @Published var currentUser: User?
    
    private init() {}
    
    func setCurrentUser(_ user: User) {
        currentUser = user
    }
    
    func clearCurrentUser() {
        currentUser = nil
    }
}
