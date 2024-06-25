//
//  Like.swift
//  profounded
//
//  Created by Hisham Zannoun on 6/24/24.
//

import Foundation

enum LikeType: String {
    case philosophy
    case philosopher
    case quote
    case concept
}

struct Like: Identifiable {
    let id: Int64
    let date: Date
    let type: LikeType
    let isLike: Bool
    let description: String
}
