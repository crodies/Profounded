//
//  DatabaseTests.swift
//  profounded
//
//  Created by Hisham Zannoun on 6/25/24.
//

import Foundation
import SQLite

class DatabaseTester {
    private let dbManager = DatabaseManager.shared

    func runTests() {
        createUser()
        fetchUsers()
        updateUser()
        deleteUser()
    }

    private func createUser() {
        do {
            let userId = try dbManager.createUser(name: "John Doe", likes: "Philosophy, Psychology", answers: "Answer1, Answer2")
            print("Created user with ID: \(userId ?? -1)")
        } catch {
            print("Error creating user: \(error)")
        }
    }

    private func fetchUsers() {
        do {
            let usersList = try dbManager.fetchUsers()
            for user in usersList {
                print("User ID: \(user[dbManager.getUserId()]), Name: \(user[dbManager.getUserName()])")
            }
        } catch {
            print("Error fetching users: \(error)")
        }
    }

    private func updateUser() {
        do {
            try dbManager.updateUser(id: 1, name: "Jane Doe")
            print("Updated user with ID 1")
        } catch {
            print("Error updating user: \(error)")
        }
    }

    private func deleteUser() {
        do {
            try dbManager.deleteUser(id: 1)
            print("Deleted user with ID 1")
        } catch {
            print("Error deleting user: \(error)")
        }
    }
}


