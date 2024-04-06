//
//  LoginController.swift
//  OnMap
//
//  Created by KhoaLA8 on 26/3/24.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let clientServices = ClientServices();
    let signUpUrl = Endpoints.udacitySignUp.url
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.isHidden = true
        appDelegate.authModel = AuthModel(sessionId: "", key: "", firstName: "", lastName: "", objectId: "")
        // Access UserDefaults
        let userDefaults = UserDefaults.standard
        
        // Retrieve the encoded data from UserDefaults
        if let savedData = userDefaults.data(forKey: "Auth") {
            // Decode the data into an array of Meme objects
            let decoder = JSONDecoder()
            if let decodedAuth = try? decoder.decode(AuthModel.self, from: savedData) {
                self.appDelegate.authModel = decodedAuth
            }
        }
    }


    @IBAction func login(_ sender: Any) {
        isLoggingIn(true)
        clientServices.login(email: self.emailText.text ?? "", password: self.passwordText.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    @IBAction func signUp(_ sender: Any) {
        UIApplication.shared.open(signUpUrl, options: [:], completionHandler: nil)
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        isLoggingIn(false)
        if success {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "tabBarView", sender: nil)
            }
        } else {
            showAlert(message: "Please enter valid credentials.", title: "Login Error")
        }
    }
    
    func isLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                self.isButtonEnabled(false, button: self.loginButton)
            }
        } else {
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.isButtonEnabled(true, button: self.loginButton)
            }
        }
        DispatchQueue.main.async {
            self.emailText.isEnabled = !loggingIn
            self.passwordText.isEnabled = !loggingIn
            self.loginButton.isEnabled = !loggingIn
            self.signUpButton.isEnabled = !loggingIn
        }
    }
    
    
}

