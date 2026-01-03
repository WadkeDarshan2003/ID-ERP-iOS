import SwiftUI

// MARK: - Launch Screen
struct LaunchScreen: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]),
                    startPoint: .topLeadingToBottomTrailing,
                    endPoint: .bottomTrailingToTopLeading
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Image(systemName: "building.2.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                    
                    Text("ID ERP")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Enterprise Resource Planning")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    ProgressView()
                        .tint(.white)
                        .padding(.top, 20)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    LaunchScreen()
}
