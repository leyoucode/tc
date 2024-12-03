//
//  ProfileView.swift
//  tc-ios
//
//  Created by LIUWEI on 2024/12/3.
//

import SwiftUI

struct MineView: View {
    @StateObject private var authViewModel = AuthViewModel.shared
    var body: some View {
        VStack {
            Button("退出") {
                authViewModel.logout()
            }
            .padding()
        }
        .padding()
    }
}
