//
//  HomeView.swift
//  test-swiftui
//
//  Created by LIUWEI on 2024/11/30.
//
import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            IndexView()
                .tabItem {
                    Image(selectedTab == 0 ? "icon_index_selected" : "icon_index_grey")
                        .renderingMode(.original)
                    Text("首页")
                }
                .tag(0)
            
            DeviceView()
                .tabItem {
                    Image(selectedTab == 1 ? "icon_device_selected" : "icon_device_grey")
                        .renderingMode(.original)
                    Text("设备")
                }
                .tag(1)
            
            OrderView()
                .tabItem {
                    Image(selectedTab == 2 ? "icon_order_selected" : "icon_order_grey")
                        .renderingMode(.original)
                    Text("订单")
                }
                .tag(2)
            
            MineView()
                .tabItem {
                    Image(selectedTab == 3 ? "icon_mime_selected" : "icon_mime_grey")
                        .renderingMode(.original)
                    Text("我的")
                }
                .tag(3)
        }
    }
}
