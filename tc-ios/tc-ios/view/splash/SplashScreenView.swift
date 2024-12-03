import SwiftUI

struct SplashScreenView: View {
    @StateObject private var authViewModel = AuthViewModel.shared
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            if authViewModel.isAuthenticated {
                MainTabView()
            } else {
                LoginView(isPresented: .constant(true))
            }
        } else {
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200)
//                Text("云打印")
//                    .font(.largeTitle)
//                    .foregroundColor(.blue)
            }
            .scaleEffect(size)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: 1.2)) {
                    self.size = 0.9
                    self.opacity = 1.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
} 

//#Preview {
//    SplashScreenView()
//}
