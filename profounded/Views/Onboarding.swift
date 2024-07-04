//
//  Onboarding.swift
//  profounded
//
//  Created by Hisham Zannoun on 6/25/24.
//

import SwiftUI

struct OnboardView: View {
    var body: some View {
        VStack {
            Text("We're all done. You're ready to start learning about different philosophies!")
                .font(.title)
                .padding()

            Spacer()

            NavigationLink(destination: Homepage().navigationBarHidden(true)) {
                Text("Continue")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.bottom, 30)
        }
        .padding()
        .navigationBarBackButtonHidden(true) // Hide the back button
    }
}

#Preview {
    OnboardView()
}

