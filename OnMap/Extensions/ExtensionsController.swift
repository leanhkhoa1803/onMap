//
//  ExtensionsController.swift
//  OnMap
//
//  Created by KhoaLA8 on 27/3/24.
//

import Foundation
import UIKit

extension UIViewController {
    
    // MARK: Enabled and disabled states for buttons
    
    func isButtonEnabled(_ enabled: Bool, button: UIButton) {
        if enabled {
            button.isEnabled = true
            button.alpha = 1.0
        } else {
            button.isEnabled = false
            button.alpha = 0.5
        }
    }
    
    // MARK: Show alerts
    
    func showAlert(message: String, title: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
    
    // MARK: Open links in Safari
    
    func openLink(_ url: String) {
        guard let url = URL(string: url), UIApplication.shared.canOpenURL(url) else {
            showAlert(message: "Cannot open link.", title: "Invalid Link")
            return
        }
        UIApplication.shared.open(url, options: [:])
    }

    func saveDataAppDelegate(data : AuthModel){
        // Access UserDefaults
        let userDefaults = UserDefaults.standard
        
        // Encode the array of Meme objects
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(data) {
            userDefaults.set(encodedData, forKey: "Auth")
        } else {
            print("Failed to encode array.")
        }
    }
    
    func addLocation() {
        var auth = initAppDelegate()
        if auth.objectId != "" {
            let alertVC = UIAlertController(title: "", message: "This student has already posted a location. Would you like to overwrite this location?", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { (action: UIAlertAction) in
                self.performSegue(withIdentifier: "ShowAddLatLongLocation", sender: nil)
            }))
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
                DispatchQueue.main.async {
                    alertVC.dismiss(animated: true, completion: nil)
                }
            }))
            self.present(alertVC, animated: true)
        }else{
            performSegue(withIdentifier: "ShowAddLatLongLocation", sender: nil)
        }
    }
    
    func initAppDelegate() -> AuthModel{
        var auth = AuthModel(sessionId: "", key: "", firstName: "", lastName: "", objectId: "")
        // Access UserDefaults
        let userDefaults = UserDefaults.standard
        
        // Retrieve the encoded data from UserDefaults
        if let savedData = userDefaults.data(forKey: "Auth") {
            // Decode the data into an array of Meme objects
            let decoder = JSONDecoder()
            if let decodedAuth = try? decoder.decode(AuthModel.self, from: savedData) {
                auth =  decodedAuth
            }
        }
        return auth
    }
}
