//
//  UserManager.swift
//  profounded
//
//  Created by Hisham Zannoun on 6/24/24.
//

import Foundation

class UserManager {
    static let shared = UserManager()

    func loginUser(userId: Int64) {
        UserDefaults.standard.set(userId, forKey: "loggedInUserId")
    }

    func getLoggedInUserId() -> Int64? {
        if let userId = UserDefaults.standard.value(forKey: "loggedInUserId") as? Int64 {
            return userId
        }
        return nil
    }

    func isLoggedIn() -> Bool {
        return getLoggedInUserId() != nil
    }

    func logoutUser() {
        UserDefaults.standard.removeObject(forKey: "loggedInUserId")
    }
}
