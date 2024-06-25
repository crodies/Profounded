//
//  QuestionView.swift
//  profounded
//
//  Created by Vansh Patel on 6/18/24.
//

import Foundation
import SwiftUI

struct QuizQuestion {
    let title: String
    let choices: [String]
}

struct QuestionView: View {
    // Example quiz questions
    @State private var quizQuestions = [
        QuizQuestion(title: "If I were to get cut off on the highway, how would I best respond:", choices: ["Get mad", "Keep On Keeping On", "Shoot myself"]),
        QuizQuestion(title: "What is the capital of France?", choices: ["Paris", "London", "Berlin", "Madrid"]),
        QuizQuestion(title: "What is 2 + 2?", choices: ["3", "4", "5", "6"])
    ]
    
    @State private var selectedTab = 0
    
    @State private var answers = Array(repeating: "", count: 3)
    
    @State private var showResults = false

    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                ForEach(0..<quizQuestions.count, id: \.self) { index in
                    VStack {
                        Text(quizQuestions[index].title)
                            .font(.largeTitle)
                            .bold()
                            .padding()

                        VStack {
                            ForEach(quizQuestions[index].choices, id: \.self) { choice in
                                Button(action: {
                                    answers[index] = choice
                                    if index < quizQuestions.count - 1 {
                                        selectedTab += 1
                                    }
                                }) {
                                    Text(choice)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(minWidth: 200, idealWidth: 300, maxWidth: .infinity, minHeight: 50)
                                        .background(answers[index] == choice ? Color.blue.opacity(0.5) : Color.blue)
                                        .cornerRadius(10)
                                }
                                .padding(.bottom, 5)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        //.background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        
                        if index == quizQuestions.count - 1 {
                            Button(action: {
                                showResults = true
                            }) {
                                Text("Submit")
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(minWidth: 200, idealWidth: 300, maxWidth: .infinity, minHeight: 50)
                                    .background(Color.green)
                                    .cornerRadius(10)
                            }
                            .padding(.top, 20)
                        }
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .padding()
            .navigationDestination(isPresented: $showResults) {
                ResultView(answers: answers, quizQuestions: quizQuestions)
            }
        }
    }
}
