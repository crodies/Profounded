//
//  Question.swift
//  profounded
//
//  Created by Hisham Zannoun on 6/24/24.
//

import Foundation

struct Question: Identifiable {
    let id: Int64
    let date: Date
    let description: String
    let answer: String
}
