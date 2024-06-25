//
//  HubView.swift
//  profound
//
//  Created by Vansh Patel on 6/18/24.
//

import Foundation
import SwiftUI

struct Homepage: View {
    var body: some View {
        TabView {
            NavigationView {
                DailyView()
            }
            .tabItem {
                Image(systemName: "house")
                Text("Daily")
            }
            
            FeedView()
                .tabItem {
                    Image(systemName: "eye")
                    Text("Discover")
                }
            
            AppsView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Account")
                }
        }
        .background(Color(UIColor(red: 1.0, green: 0.98, blue: 0.94, alpha: 1.0)))
    }
}

import SwiftUI

struct DailyView: View {
    @State private var selectedThumb: Int? = nil
    @State private var selectedAnswer: String? = nil
    @State private var philosophy: (name: String, description: String)? = nil
    @State private var quote: String? = nil
    @State private var lastUpdated: Date? = nil

    var body: some View {
        VStack(spacing: 10) {
            if let quote = quote {
                CardView(content: quote, thumbs: true, selectedThumb: $selectedThumb)
            }
            
            CardView(content: "If you replace all parts of a boat, is it still the same boat?", answers: ["Yes", "No", "Not Sure"], selectedAnswer: $selectedAnswer)
            
            if let philosophy = philosophy {
                PhilosophyCardView(name: philosophy.name, description: philosophy.description)
            }

            Spacer()
        }
        .padding()
        .background(Color(UIColor(red: 1.0, green: 0.98, blue: 0.94, alpha: 1.0)))
        .onAppear {
            loadDailyContent()
        }
    }

    private func loadDailyContent() {
        let currentDate = Date()
        if let lastUpdated = lastUpdated, Calendar.current.isDate(currentDate, inSameDayAs: lastUpdated) {
            return
        }
        lastUpdated = currentDate
        let philosophyManager = PhilosophyManager.shared
        if let randomPhilosophy = philosophyManager.getRandomPhilosophy() {
            self.philosophy = randomPhilosophy
        }
        self.quote = philosophyManager.getRandomQuote()
    }
}

struct CardView: View {
    var content: String
    var thumbs: Bool = false
    var answers: [String]?
    @Binding var selectedThumb: Int?
    @Binding var selectedAnswer: String?

    init(content: String, thumbs: Bool = false, answers: [String]? = nil, selectedThumb: Binding<Int?> = .constant(nil), selectedAnswer: Binding<String?> = .constant(nil)) {
        self.content = content
        self.thumbs = thumbs
        self.answers = answers
        self._selectedThumb = selectedThumb
        self._selectedAnswer = selectedAnswer
    }

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Text(content)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.bottom, 5)
                .italic()

            if let answers = answers {
                ForEach(answers, id: \.self) { answer in
                    Button(action: {
                        selectedAnswer = answer
                    }) {
                        Text(answer)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(selectedAnswer == answer ? Color.orange : Color.orange.opacity(0.2))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }

            if thumbs {
                HStack {
                    Button(action: {
                        selectedThumb = 1
                    }) {
                        Image(systemName: "hand.thumbsup.fill")
                            .foregroundColor(selectedThumb == 1 ? .orange : .gray)
                    }
                    Spacer()
                    Button(action: {
                        selectedThumb = 2
                    }) {
                        Image(systemName: "hand.thumbsdown.fill")
                            .foregroundColor(selectedThumb == 2 ? .orange : .gray)
                    }
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .frame(maxWidth: .infinity, alignment: .center)
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct PhilosophyCardView: View {
    var name: String
    var description: String

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Today's Philosophy")
                .font(.headline)
                .bold()

            HStack {
                Image("LaurelWreathLeft")
                    .resizable()
                    .frame(width: 60, height: 60)
                Text(name)
                    .font(.system(size: 30, weight: .heavy, design: .serif))
                    .italic()
                Image("LaurelWreathRight")
                    .resizable()
                    .frame(width: 60, height: 60)
            }

            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
                .italic()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .frame(maxWidth: .infinity, alignment: .center)
        .fixedSize(horizontal: false, vertical: true) 
    }
}

struct PersonDetailView: View {
    var person: String
    
    var body: some View {
        VStack {
            Text("Details for \(person)")
                .font(.largeTitle)
                .padding()
            
            Spacer()
        }
    }
}

struct FeedView: View {
    let people = ["Stoicism", "Existentialism", "Nihilism", "Absurdism", "Utilitarianism", "Deontology", "Virtue Ethics", "Confucianism"]

    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(people, id: \.self) { person in
                        NavigationLink(destination: PersonDetailView(person: person)) {
                            VStack {
                                Circle()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.orange)
                                    .overlay(Text(person.prefix(1)).foregroundColor(.white))
                                Text(person)
                            }
                            .padding()
                        }
                    }
                }
            }
            
            Spacer()
        }
        .navigationBarTitle("Discover", displayMode: .inline)
    }
}

struct AppsView: View {
    var body: some View {
        Text("Account")
    }
}

#Preview {
    Homepage()
}
