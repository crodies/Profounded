//
//  GenerateImageViewController.swift
//  profounded
//
//  Created by Hisham Zannoun on 7/4/24.
//

import SwiftUI
import UIKit

struct GenerateImageViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> GenerateImageViewController {
        let viewController = GenerateImageViewController()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: GenerateImageViewController, context: Context) {
    }
}
