//
//  DatabaseManager.swift
//  profounded
//
//  Created by Hisham Zannoun on 6/24/24.
//

import SQLite
import Foundation

class DatabaseManager {
    static let shared = DatabaseManager()
    private var db: Connection?

    private let users = Table("users")
    private let userId = Expression<Int64>("id")
    private let userName = Expression<String>("name")
    private let userLikes = Expression<String>("likes")
    private let userAnswers = Expression<String>("answers")

    private let generatedImages = Table("generated_images")
    private let imageId = Expression<Int64>("id")
    private let imageUserId = Expression<Int64>("user_id")
    private let imageUrl = Expression<String>("url")

    private let likes = Table("likes")
    private let likeId = Expression<Int64>("id")
    private let likeDate = Expression<Date>("date")
    private let likeType = Expression<String>("type")
    private let likeIsLike = Expression<Bool>("is_like")
    private let likeDescription = Expression<String>("description")

    private let questions = Table("questions")
    private let questionId = Expression<Int64>("id")
    private let questionDate = Expression<Date>("date")
    private let questionDescription = Expression<String>("description")
    private let questionAnswer = Expression<String>("answer")

    private init() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("app").appendingPathExtension("sqlite3")
            db = try Connection(fileUrl.path)
            createTables()
        } catch {
            print(error)
        }
    }

    private func createTables() {
        do {
            try db?.run(users.create(ifNotExists: true) { table in
                table.column(userId, primaryKey: .autoincrement)
                table.column(userName)
                table.column(userLikes)
                table.column(userAnswers)
            })

            try db?.run(generatedImages.create(ifNotExists: true) { table in
                table.column(imageId, primaryKey: .autoincrement)
                table.column(imageUserId)
                table.column(imageUrl)
                table.foreignKey(imageUserId, references: users, userId, delete: .cascade)
            })

            try db?.run(likes.create(ifNotExists: true) { table in
                table.column(likeId, primaryKey: .autoincrement)
                table.column(likeDate)
                table.column(likeType)
                table.column(likeIsLike)
                table.column(likeDescription)
            })

            try db?.run(questions.create(ifNotExists: true) { table in
                table.column(questionId, primaryKey: .autoincrement)
                table.column(questionDate)
                table.column(questionDescription)
                table.column(questionAnswer)
            })
        } catch {
            print(error)
        }
    }
}

