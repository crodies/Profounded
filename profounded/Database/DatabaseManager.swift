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
    private let createdAt = Expression<String>("created_at") // Change to String
    
    private let likes = Table("likes")
    private let likeId = Expression<Int64>("id")
    private let likeDate = Expression<Date>("date")
    private let likeType = Expression<String>("type")
    private let likeIsLike = Expression<Bool>("is_like")
    private let likeDescription = Expression<String>("description")
    private let likeUserId = Expression<Int64>("user_id") // Add this line
    
    private let questions = Table("questions")
    private let questionId = Expression<Int64>("id")
    private let questionDate = Expression<Date>("date")
    private let questionDescription = Expression<String>("description")
    private let questionAnswer = Expression<String>("answer")
    
    private init() {
        setupDatabase()
    }
    
    // Sets up the database connection and initializes tables
    private func setupDatabase() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("app").appendingPathExtension("sqlite3")
            print("Database file path: \(fileUrl.path)")
            
            // Create the database connection
            db = try Connection(fileUrl.path)
            createTables()
        } catch {
            print("Database connection failed: \(error)")
            db = nil
        }
    }
    
    // Creates the tables once the database is initialized. Specifies which columns should be foreign keys
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
                table.column(createdAt)
                table.foreignKey(imageUserId, references: users, userId, delete: .cascade)
            })
            
            try db?.run(likes.create(ifNotExists: true) { table in
                        table.column(likeId, primaryKey: .autoincrement)
                        table.column(likeDate)
                        table.column(likeType)
                        table.column(likeIsLike)
                        table.column(likeDescription)
                        table.column(likeUserId) // Add userId column
                        table.foreignKey(likeUserId, references: users, userId, delete: .cascade) // Add foreign key constraint
            })
            
            try db?.run(questions.create(ifNotExists: true) { table in
                table.column(questionId, primaryKey: .autoincrement)
                table.column(questionDate)
                table.column(questionDescription)
                table.column(questionAnswer)
            })
        } catch {
            print("Error creating tables: \(error)")
        }
    }
    
    
    func createUser(name: String, likes: String, answers: String) throws -> Int64? {
        do {
            let insert = users.insert(userName <- name, userLikes <- likes, userAnswers <- answers)
            let userId = try db?.run(insert)
            return userId
        } catch {
            throw error
        }
    }
    
    func fetchUsers() throws -> [Row] {
        guard let db = db else {
            print("Database connection is nil")
            throw DatabaseError.connectionError
        }

        do {
            let usersList = try db.prepare(users)
            return Array(usersList)
        } catch {
            throw error
        }
    }
    
    func updateUser(id: Int64, name: String) throws {
        guard let db = db else {
            print("Database connection is nil")
            throw DatabaseError.connectionError
        }

        let user = users.filter(userId == id)
        do {
            try db.run(user.update(userName <- name))
        } catch {
            throw error
        }
    }
    
    func deleteUser(id: Int64) throws {
        guard let db = db else {
            print("Database connection is nil")
            throw DatabaseError.connectionError
        }

        let user = users.filter(userId == id)
        do {
            try db.run(user.delete())
        } catch {
            throw error
        }
    }
    
    // Saves a question along with its answer to the database
    func saveQuestionAnswer(date: Date, description: String, answer: String) {
            guard let db = db else {
                print("Database connection is nil")
                return
            }

            do {
                let insert = questions.insert(
                    questionDate <- date,
                    questionDescription <- description,
                    questionAnswer <- answer
                )
                try db.run(insert)
                print("Saved question answer: date: \(date), description: \(description), answer: \(answer)")
            } catch {
                print("Failed to save question answer: \(error)")
            }
    }
    
    // Adds a like or dislike to the database for a specific user
    func addLike(userId: Int64, date: Date, type: LikeType, isLike: Bool, description: String) {
            guard let db = db else {
                print("Database connection is nil")
                return
            }

            do {
                let insert = likes.insert(
                    likeUserId <- userId,
                    likeDate <- date,
                    likeType <- type.rawValue,
                    likeIsLike <- isLike,
                    likeDescription <- description
                )
                try db.run(insert)
                print("Inserted like: userId: \(userId), date: \(date), type: \(type.rawValue), isLike: \(isLike), description: \(description)")
            } catch {
                print("Failed to add like: \(error)")
            }
        }
        
        // Fetches the most recent likes for a specific user, limited to 10 entries. This is used for the image generation
        func fetchRecentLikes(for userId: Int64) throws -> [Like] {
                guard let db = db else {
                    throw DatabaseError.connectionError
                }

                let query = likes.filter(likeIsLike == true && likeUserId == userId)
                                 .order(likeDate.desc)
                                 .limit(10)
                let likeRows = try db.prepare(query)
                
                return likeRows.map { row in
                    Like(
                        id: row[likeId],
                        userId: row[likeUserId],
                        date: row[likeDate],
                        type: LikeType(rawValue: row[likeType])!,
                        isLike: row[likeIsLike],
                        description: row[likeDescription]
                    )
                }
        }
        
        // Fetches all likes for a specific user and returns them via a completion handler
        func fetchAllLikes(for userId: Int64, completion: @escaping ([Like]) -> Void) {
            guard let db = db else {
                completion([])
                return
            }

            do {
                let query = likes.filter(likeUserId == userId).order(likeDate.desc)
                let likeRows = try db.prepare(query)
                
                let fetchedLikes: [Like] = likeRows.map { row in
                    Like(
                        id: row[likeId],
                        userId: row[likeUserId], 
                        date: row[likeDate],
                        type: LikeType(rawValue: row[likeType])!,
                        isLike: row[likeIsLike],
                        description: row[likeDescription]
                    )
                }
                
                completion(fetchedLikes)
            } catch {
                print("Failed to fetch likes: \(error)")
                completion([])
            }
        }
    
    // Saves the URL of a generated image for a specific user
    func saveImageURL(userId: Int64, url: String) {
        let formatter = ISO8601DateFormatter()
        let currentDate = formatter.string(from: Date())
        do {
            let insert = generatedImages.insert(imageUserId <- userId, imageUrl <- url, createdAt <- currentDate)
            try db?.run(insert)
            print("Saved image URL: \(url)")
        } catch {
            print("Failed to save image URL: \(error)")
        }
    }

    // Fetches all generated images for a specific user and returns them via a completion handler. Is used in the Gallery screen
    func fetchAllImages(for userId: Int64, completion: @escaping ([GeneratedImage]) -> Void) {
        do {
            guard let db = db else {
                print("Database connection is nil")
                completion([])
                return
            }

            print("All images in the database before query:")
            let allImages = try db.prepare(generatedImages)
            for image in allImages {
                print("Image ID: \(image[self.imageId]), User ID: \(image[self.imageUserId]), URL: \(image[self.imageUrl]), Created At: \(image[self.createdAt])")
            }

            let query = generatedImages.filter(imageUserId == userId).order(createdAt.desc)
            let fetchedImages = try db.prepare(query).map { row in
                let formatter = ISO8601DateFormatter()
                let date = formatter.date(from: row[self.createdAt]) ?? Date()
                return GeneratedImage(
                    id: row[self.imageId],
                    userId: row[self.imageUserId],
                    url: row[self.imageUrl],
                    createdAt: date
                )
            }

            print("Query executed successfully, fetched \(fetchedImages.count) images")
            for image in fetchedImages {
                print("Fetched image: \(image)")
            }

            completion(fetchedImages)
        } catch {
            print("Failed to fetch images: \(error)")
            completion([])
        }
    }

    // Prints all images stored in the database for debugging purposes
    func printAllImages() {
        guard let db = db else {
            print("Database connection is nil")
            return
        }

        do {
            let allImages = try db.prepare(generatedImages)
            print("All images in the database:")
            for image in allImages {
                print("Image ID: \(image[self.imageId]), User ID: \(image[self.imageUserId]), URL: \(image[self.imageUrl]), Created At: \(image[self.createdAt])")
            }
        } catch {
            print("Failed to fetch all images: \(error)")
        }
    }
}

enum DatabaseError: Error {
    case connectionError
}

