//
//  PhilosophyManager.swift
//  profounded
//
//  Created by Hisham Zannoun on 6/24/24.
//

import Foundation

class PhilosophyManager {
    static let shared = PhilosophyManager()

    private init() {}

    func getRandomPhilosophy() -> (name: String, description: String)? {
        guard let philosophies = PhilosophyData.data["Philosophy"] as? [String: [String: Any]] else { return nil }
        let randomPhilosophy = philosophies.randomElement()
        guard let philosophyName = randomPhilosophy?.key,
              let philosophyDetails = randomPhilosophy?.value,
              let description = philosophyDetails["Description"] as? String else { return nil }
        return (philosophyName, description)
    }

    func getRandomQuote() -> String? {
        guard let philosophies = PhilosophyData.data["Philosophy"] as? [String: [String: Any]] else { return nil }
        var allQuotes: [String] = []
        for (_, details) in philosophies {
            if let quotes = details["Quotes"] as? [String] {
                allQuotes.append(contentsOf: quotes)
            }
        }
        return allQuotes.randomElement()
    }
}
