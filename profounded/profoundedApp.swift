//
//  profoundedApp.swift
//  profounded
//
//  Created by Vansh Patel on 6/13/24.
//

import SwiftUI

@main
struct profoundedApp: App {
    init() {
        // Custom Tab Bar Appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 1.0, green: 0.98, blue: 0.94, alpha: 1.0)
        
        // Remove the shadow (line) by setting the shadow color to clear
        appearance.shadowColor = .clear
        
        let tabBarItemAppearance = UITabBarItemAppearance()
        tabBarItemAppearance.selected.iconColor = UIColor(red: 0.85, green: 0.53, blue: 0.1, alpha: 1.0) // Light orange/brownish color
        tabBarItemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.85, green: 0.53, blue: 0.1, alpha: 1.0)]
        tabBarItemAppearance.normal.iconColor = UIColor.gray
        tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
        
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
