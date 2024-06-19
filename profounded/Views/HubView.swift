//
//  HubView.swift
//  profounded
//
//  Created by Vansh Patel on 6/18/24.
//

import Foundation
import SwiftUI

struct basedView: View {
    var body: some View {
        TabView {
            NavigationView {
                HomeView()
            }
            .tabItem {
                Image(systemName: "house")
                Text("Daily")
            }
            
            FeedView()
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Discover")
                }
            
            AppsView()
                .tabItem {
                    Image(systemName: "syringe.fill")
                    Text("Account")
                }
        }
    }
}

struct HomeView: View {
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
                                    .foregroundColor(.blue)
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
        .navigationBarTitle("Home", displayMode: .inline)
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
    var body: some View {
        Text("Discover View")
    }
}


struct AppsView: View {
    var body: some View {
            Text("Account")
    }
}



