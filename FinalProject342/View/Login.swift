import SwiftUI

struct Login: View {
    @State private var err: String = ""
    @Environment(\.openURL) var openURL

    var body: some View {
        ZStack {
            // Background image
            Image("golf_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)

            // Content
            VStack(spacing: 20) {
                Spacer()
                
                Text("Welcome to GolfMate")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(radius: 10)

                Button(action: {
                    Task {
                        do {
                            try await Authentication().googleOauth()
                        } catch let error {
                            print(error)
                            err = error.localizedDescription
                        }
                    }
                }) {
                    Label("Sign in with Google", systemImage: "person.badge.key.fill") //login
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 280, height: 50)
                        .background(Color.green.opacity(0.85))
                        .cornerRadius(25)
                        .shadow(radius: 10)
                }
                
                Text(err)
                    .foregroundColor(.red)
                    .font(.caption)
                
                Spacer()
            }
            .padding()
        }
    }
}


struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
