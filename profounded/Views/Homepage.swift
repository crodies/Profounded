//
//  HubView.swift
//  profound
//
//  Created by Vansh Patel on 6/18/24.
//

import SwiftUI

struct CustomProgressView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: Color(red: 0.85, green: 0.65, blue: 0.13, opacity: 1.0)))
            .scaleEffect(2)
    }
}

struct Homepage: View {
    var body: some View {
        TabView {
            NavigationView {
                DailyView()
                    .navigationBarHidden(true)
            }
            .navigationViewStyle(StackNavigationViewStyle())
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
        .navigationBarHidden(true)
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
    @State private var content: String
    var thumbs: Bool = false
    var answers: [String]?
    @Binding var selectedThumb: Int?
    @Binding var selectedAnswer: String?
    @State private var isAnswered: Bool = false

    init(content: String, thumbs: Bool = false, answers: [String]? = nil, selectedThumb: Binding<Int?> = .constant(nil), selectedAnswer: Binding<String?> = .constant(nil)) {
        self._content = State(initialValue: content)
        self.thumbs = thumbs
        self.answers = answers
        self._selectedThumb = selectedThumb
        self._selectedAnswer = selectedAnswer
    }

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            if isAnswered {
                Text("Thanks for answering! Come back tomorrow for another question!")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 5)
                    .italic()
            } else {
                Text(content)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 5)
                    .italic()
            }

            if let answers = answers {
                ForEach(answers, id: \.self) { answer in
                    Button(action: {
                        selectedAnswer = answer
                        addQuestionAnswer(description: content, answer: answer)
                    }) {
                        Text(answer)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(selectedAnswer == answer ? Color(red: 0.85, green: 0.65, blue: 0.13) : Color(red: 0.85, green: 0.65, blue: 0.13).opacity(0.5))
                            .foregroundColor(selectedAnswer == answer ? .white : .black)
                            .cornerRadius(10)
                    }
                    .disabled(isAnswered)
                }
            }

            if thumbs {
                HStack {
                    Button(action: {
                        selectedThumb = 1
                        addLikeOrDislike(isLike: true)
                    }) {
                        Image(systemName: "hand.thumbsup.fill")
                            .foregroundColor(selectedThumb == 1 ? Color(red: 0.85, green: 0.65, blue: 0.13) : Color.gray.opacity(0.5))
                    }
                    .disabled(isAnswered)
                    
                    Spacer()
                    
                    Button(action: {
                        selectedThumb = 2
                        addLikeOrDislike(isLike: false)
                    }) {
                        Image(systemName: "hand.thumbsdown.fill")
                            .foregroundColor(selectedThumb == 2 ? Color(red: 0.85, green: 0.65, blue: 0.13) : Color.gray.opacity(0.5))
                    }
                    .disabled(isAnswered)
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

    private func addLikeOrDislike(isLike: Bool) {
        guard !isAnswered else { return }
        let userId: Int64 = 2 // Hardcoded user ID for now

        let like = Like(
            id: Int64(Date().timeIntervalSince1970),
            userId: userId,
            date: Date(),
            type: .quote,
            isLike: isLike,
            description: content
        )
        DatabaseManager.shared.addLike(
            userId: userId,
            date: like.date,
            type: like.type,
            isLike: like.isLike,
            description: like.description
        )
        print("Inserted like: date: \(like.date), type: \(like.type.rawValue), isLike: \(like.isLike), description: \(like.description)")
        content = "Thanks for answering! Come back tomorrow for another quote!"
        isAnswered = true
    }

    private func addQuestionAnswer(description: String, answer: String) {
        let question = Question(
            id: Int64(Date().timeIntervalSince1970),
            date: Date(),
            description: description,
            answer: answer
        )
        DatabaseManager.shared.saveQuestionAnswer(
            date: question.date,
            description: question.description,
            answer: question.answer
        )
        print("Saved question answer: \(question)")
        isAnswered = true
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
                    .minimumScaleFactor(0.5) // This will scale down the text if it's too long
                    .lineLimit(1) // Ensure the text is on one line
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
                                    .foregroundColor(Color(red: 0.85, green: 0.65, blue: 0.13).opacity(0.5))
                                    .overlay(Text(person.prefix(1)).foregroundColor(.white))
                                Text(person)
                            }
                            .padding()
                        }
                    }
                }
            }

            // Spacer added to push the image down a bit for visibility
            Spacer().frame(height: 20)
            
            // Hardcoded AsyncImage with the provided URL
            Spacer()
        }
        .background(Color(UIColor(red: 1.0, green: 0.98, blue: 0.94, alpha: 1.0)))
        .navigationBarTitle("Discover", displayMode: .inline)
    }
}

struct AppsView: View {
    @State private var images: [GeneratedImage] = []
    private let userId: Int64 = 2

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        print("Settings tapped")
                    }) {
                        Image(systemName: "gearshape")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                
                Spacer().frame(height: 25)

                if let mostRecentImage = images.first {
                    if let url = URL(string: mostRecentImage.url) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                CustomProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 350, height: 350)
                                    .clipShape(Rectangle())
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 350, height: 350)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .onAppear {
                            print("Loading image from URL: \(mostRecentImage.url)")
                        }
                    }
                } else {
                    Spacer().frame(height: 350)
                }

                Spacer()

                NavigationLink(destination: GalleryView(images: images)) {
                    HStack {
                        Spacer()
                        Text("Gallery")
                            .font(.headline)
                            .padding()
                            .padding(.leading, 25)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .padding(.trailing)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.85, green: 0.65, blue: 0.13).opacity(0.5))
                    .foregroundColor(.black)
                    .cornerRadius(10)
                }
                .padding(.horizontal)

                NavigationLink(destination:
                LikesHistoryView()) {
                    HStack {
                        Spacer()
                        Text("Likes History")
                            .font(.headline)
                            .padding()
                            .padding(.leading, 25)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .padding(.trailing)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.85, green: 0.65, blue: 0.13).opacity(0.5))
                    .foregroundColor(.black)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top, 25)

                NavigationLink(destination: GenerateImageViewControllerRepresentable()) {
                    HStack {
                        Spacer()
                        Text("Generate Image")
                            .font(.headline)
                            .padding()
                            .padding(.leading, 25)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .padding(.trailing)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.85, green: 0.65, blue: 0.13).opacity(0.5))
                    .foregroundColor(.black)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top, 25)

                Spacer().frame(height: 50)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor(red: 1.0, green: 0.98, blue: 0.94, alpha: 1.0)))
        }
        .onAppear {
            fetchImages()
        }
    }

    private func fetchImages() {
        DatabaseManager.shared.fetchAllImages(for: userId) { fetchedImages in
            images = fetchedImages
            print("Fetched images: \(fetchedImages)")
        }
    }
}

#Preview {
    Homepage()
}
