import SwiftUI

struct ContentView: View {
    @State private var glowing = true

    var body: some View {
        NavigationView {
            VStack {
                Group {
                    Text("Welcome to")
                        .font(.system(size: 38, weight: .light, design: .monospaced))
                        .foregroundColor(.primary)
                        .frame(maxHeight: 5, alignment: .topLeading)
                        .padding(9)
                    
                    GradientText(text: "Profound", fontSize: 45, glowing: $glowing)
                }
                .multilineTextAlignment(.center)
                .padding()
                
                Spacer()
                NavigationLink(destination: QuestionView()) {
                    Text("Let's Get Started")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom, 30)
            }
            .padding()
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1.5).repeatCount(3, autoreverses: true)) {
                    glowing.toggle()
                }
            }
        }
    }
}

struct GradientText: View {
    var text: String
    var fontSize: CGFloat
    @Binding var glowing: Bool
    
    var body: some View {
        ZStack {
            Text(text)
                .font(.system(size: fontSize, weight: .bold, design: .monospaced))
                .foregroundColor(.clear)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue, .purple, .red]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .mask(
                        Text(text)
                            .font(.system(size: fontSize, weight: .bold, design: .monospaced))
                    )
                )
            
            Text(text)
                .font(.system(size: fontSize, weight: .bold, design: .monospaced))
                .foregroundColor(.clear)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue.opacity(0.5), .purple.opacity(0.5), .red.opacity(0.5)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .mask(
                        Text(text)
                            .font(.system(size: fontSize, weight: .bold, design: .monospaced))
                    )
                )
                .blur(radius: glowing ? 15 : 0)
        }
    }
}


#Preview {
    ContentView()
}

