//
//  profoundedApp.swift
//  profounded
//
//  Created by Vansh Patel on 6/13/24.
//

import SwiftUI
import UIKit
import SQLite
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct profoundedApp: App {
    init() {
        @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
        
        DatabaseManager.shared.printAllImages()

        // Custom Tab Bar Appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 1.0, green: 0.98, blue: 0.94, alpha: 1.0)
        
        // Remove the shadow (line) by setting the shadow color to clear
        appearance.shadowColor = .clear
        
        let tabBarItemAppearance = UITabBarItemAppearance()
        tabBarItemAppearance.selected.iconColor = UIColor(red: 0.85, green: 0.65, blue: 0.13, alpha: 1.0) // Light gold
        tabBarItemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.85, green: 0.65, blue: 0.13, alpha: 1.0)]
        tabBarItemAppearance.normal.iconColor = UIColor(red: 0.85, green: 0.65, blue: 0.13, alpha: 0.5) // Faded gold
        tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.85, green: 0.65, blue: 0.13, alpha: 0.5)]
        
        appearance.stackedLayoutAppearance = tabBarItemAppearance
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

