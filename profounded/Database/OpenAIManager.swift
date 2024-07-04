//
//  OpenAIManager.swift
//  profounded
//
//  Created by Hisham Zannoun on 7/4/24.
//

import Alamofire
import UIKit
import Foundation

struct OpenAIImageResponse: Decodable {
    struct ImageData: Decodable {
        let url: String
    }
    let data: [ImageData]
}

class OpenAIService {
    private let apiKey = "sk-proj-sx2GwT6lVMSWQFNeKhyxT3BlbkFJjNc7HJjZPf0SC8hqVujs" 
    private let baseURL = "https://api.openai.com/v1/images/generations"
    
    func generateImage(prompt: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "prompt": prompt,
            "n": 1,
            "size": "1024x1024"
        ]
        
        AF.request(baseURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let json):
                    print("Raw JSON response: \(json)")
                    // Temporarily not decoding to understand the structure
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    private func downloadImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    completion(.success(image))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

class GenerateImageViewController: UIViewController {
    let openAIService = OpenAIService()
    var userId: Int64 = 2 // Replace with actual user ID

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        // Create and add the Generate Image button
        let generateButton = UIButton(type: .system)
        generateButton.setTitle("Generate Image", for: .normal)
        generateButton.addTarget(self, action: #selector(generateImageButtonTapped), for: .touchUpInside)
        
        generateButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(generateButton)
        
        NSLayoutConstraint.activate([
            generateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            generateButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            generateButton.widthAnchor.constraint(equalToConstant: 200),
            generateButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func generateImageButtonTapped() {
        do {
            let recentLikes = try DatabaseManager.shared.fetchRecentLikes(for: userId)
            let likesDescriptions = recentLikes.map { $0.description }.joined(separator: ", ")
            let prompt = "Generate an abstract image representing these philosophical beliefs and quotes, and what they would look like. Incorporate a multitude of colors and shapes but keep it abstract. Here are the ideas: \(likesDescriptions)"
            generateAndSaveImage(prompt: prompt, forUserId: userId)
        } catch {
            print("Failed to fetch recent likes: \(error)")
        }
    }
    
    func generateAndSaveImage(prompt: String, forUserId userId: Int64) {
        openAIService.generateImage(prompt: prompt) { result in
            switch result {
            case .success(let image):
                if let imageData = image.pngData() {
                    FirebaseStorageManager.shared.uploadImage(imageData: imageData, userId: userId) { result in
                        switch result {
                        case .success(let imageUrl):
                            DatabaseManager.shared.saveImageURL(userId: userId, url: imageUrl)
                            DispatchQueue.main.async {
                                // Display the image in an UIImageView
                                self.displayGeneratedImage(image)
                            }
                        case .failure(let error):
                            print("Failed to upload image to Firebase: \(error)")
                        }
                    }
                } else {
                    print("Failed to convert image to PNG data")
                }
            case .failure(let error):
                print("Failed to generate image: \(error)")
            }
        }
    }
    
    func displayGeneratedImage(_ image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.frame = self.view.bounds
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
    }
}
