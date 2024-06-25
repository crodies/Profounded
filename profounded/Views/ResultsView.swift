//
//  ResultsView.swift
//  profound
//
//  Created by Vansh Patel on 6/18/24.
//

import Foundation
import SwiftUI

struct ResultView: View {
    var answers: [String]
    var quizQuestions: [QuizQuestion]

    var body: some View {
        VStack {
            List {
                ForEach(0..<quizQuestions.count, id: \.self) { index in
                    VStack(alignment: .leading) {
                        Text(quizQuestions[index].title)
                            .font(.headline)
                        Text("Your answer: \(answers[index])")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
            }
            
            NavigationLink(destination: Homepage()) {
                Text("Continue")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.bottom, 30)
        }
        .navigationBarTitle("Your Results", displayMode: .inline)
    }
}
