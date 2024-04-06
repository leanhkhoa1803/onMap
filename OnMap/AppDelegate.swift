//
//  AppDelegate.swift
//  OnMap
//
//  Created by KhoaLA8 on 26/3/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var authModel: AuthModel {
        get {
            if let data = UserDefaults.standard.data(forKey: "Auth"),
               let decodedAuth = try? JSONDecoder().decode(AuthModel.self, from: data) {
                return decodedAuth
            } else {
                return AuthModel(key: "", firstName: "", lastName: "", objectId: "")
            }
        }
        set {
            if let encodedAuth = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encodedAuth, forKey: "Auth")
            } else {
                print("Failed to encode array.")
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

