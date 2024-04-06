//
//  ClientServices.swift
//  OnMap
//
//  Created by KhoaLA8 on 27/3/24.
//

import Foundation
import UIKit

class ClientServices : UIViewController{
    
    let apiService = ApiServices();
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var authResponse = AuthModel(sessionId: "", key: "", firstName: "", lastName: "", objectId: "")
    func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        apiService.POSTRequest(url: Endpoints.udacityLogin.url, responseType: LoginResponse.self,isRange: true, body: body, httpMethod: "POST") { (response, error) in
            if let response = response {
                self.authResponse =  AuthModel(sessionId: response.session.id, key: response.account.key, firstName: "", lastName: "", objectId: "")
                self.appDelegate.authModel = self.authResponse

                self.saveDataAppDelegate(data: self.appDelegate.authModel)
                
                self.getLoggedInUserProfile(completion: { (success, error) in
                    if success {
                        self.appDelegate.authModel = self.authResponse
                        self.saveDataAppDelegate(data: self.appDelegate.authModel)
                    }
                })
                
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
    }
    
    func getLoggedInUserProfile(completion: @escaping (Bool, Error?) -> Void) {
        apiService.GETRequest(url: Endpoints.getLoggedInUserProfile.url, responseType: UserProfile.self,isRange: true) { (response, error) in
            if let response = response {
                self.authResponse =  AuthModel(sessionId: self.appDelegate.authModel.sessionId, key: self.appDelegate.authModel.key, firstName: response.firstName, lastName: response.lastName, objectId: "")

                completion(true, nil)
            } else {
                print("Failed to get user's profile.")
                completion(false, error)
            }
        }
    }
    
    func getStudentLocations(completion: @escaping ([StudentModel]?, Error?) -> Void) {
        apiService.GETRequest(url: Endpoints.getStudentLocations.url, responseType: StudentsLocation.self, isRange: false) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    func addStudentLocation(information: StudentModel, completion: @escaping (Bool, Error?) -> Void) {
        let body = "{\"uniqueKey\": \"\(information.uniqueKey ?? "")\", \"firstName\": \"\(information.firstName)\", \"lastName\": \"\(information.lastName)\",\"mapString\": \"\(information.mapString ?? "")\", \"mediaURL\": \"\(information.mediaURL ?? "")\",\"latitude\": \(information.latitude ?? 0.0), \"longitude\": \(information.longitude ?? 0.0)}"
        
        apiService.POSTRequest(url: Endpoints.addLocation.url, responseType: PostLocationResponse.self,isRange: false, body: body, httpMethod: "POST") { (response, error) in
            if let response = response, response.createdAt != nil {
                self.authResponse =  AuthModel(sessionId: self.appDelegate.authModel.sessionId, key: self.appDelegate.authModel.key, firstName: self.appDelegate.authModel.firstName, lastName: self.appDelegate.authModel.lastName, objectId: response.objectId!)
                self.appDelegate.authModel = self.authResponse
                self.saveDataAppDelegate(data: self.appDelegate.authModel)
                completion(true, nil)
            }
            completion(false, error)
        }
    }
    
    
}
