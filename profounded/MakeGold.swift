//
//  MakeGold.swift
//  profounded
//
//  Created by Vansh Patel on 6/18/24.
//

import Foundation
import SwiftUI

extension Color {
    static let gold = Color(red: 0.83, green: 0.69, blue: 0.22)
    static let darkGold = Color(red: 0.72, green: 0.53, blue: 0.04)
}

struct GoldTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(Color.gold)
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.gold, Color.darkGold]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .mask(
                    content
                        .font(.largeTitle)
                )
            )
    }
    
    
}


extension View {
    func makeGold() -> some View {
        self.modifier(GoldTextModifier())
    }
}

