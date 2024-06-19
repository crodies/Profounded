//
//  ResultsView.swift
//  profounded
//
//  Created by Vansh Patel on 6/18/24.
//

import Foundation
import SwiftUI


struct ResultView: View {
    var answers: [String]
    var questions: [Question]

    var body: some View {
        List {
            ForEach(0..<questions.count, id: \.self) { index in
                VStack(alignment: .leading) {
                    Text(questions[index].title)
                        .font(.headline)
                    Text("Your answer: \(answers[index])")
                        .foregroundColor(.secondary)
                }
                .padding()
            }
        }
        .navigationBarTitle("Your Results", displayMode: .inline)
    }
}
