//
//  FirebaseStorageManager.swift
//  profounded
//
//  Created by Hisham Zannoun on 7/1/24.
//

import Foundation
import FirebaseStorage

class FirebaseStorageManager {
    static let shared = FirebaseStorageManager()
    private let storage = Storage.storage()

    private init() {}

    func uploadImage(imageData: Data, userId: Int64, completion: @escaping (Result<String, Error>) -> Void) {
        let storageRef = storage.reference().child("Images/\(userId)/\(UUID().uuidString).png")
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        storageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { (url, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let url = url {
                    completion(.success(url.absoluteString))
                }
            }
        }
    }
}
