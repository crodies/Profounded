//
//  ImageHelpers.swift
//  profounded
//
//  Created by Hisham Zannoun on 6/26/24.
//

import Foundation

class ImageHelper {
    static let shared = ImageHelper()

    private init() {}

    func fetchMostRecentImage(for userId: Int64, completion: @escaping (GeneratedImage?) -> Void) {
        DatabaseManager.shared.fetchMostRecentImage(for: userId) { image in
            completion(image)
        }
    }
}
