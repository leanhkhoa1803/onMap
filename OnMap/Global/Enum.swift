//
//  Enum.swift
//  OnMap
//
//  Created by KhoaLA8 on 27/3/24.
//

import Foundation
import UIKit

enum Endpoints {
    
    static let base = "https://onthemap-api.udacity.com/v1"
    
    case udacitySignUp
    case udacityLogin
    case getStudentLocations
    case addLocation
    case updateLocation
    case getLoggedInUserProfile
    
    var stringValue: String {
        switch self {
        case .udacitySignUp:
            return "https://auth.udacity.com/sign-up"
        case .udacityLogin:
            return Endpoints.base + "/session"
        case .getStudentLocations:
            return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
        case .addLocation:
            return Endpoints.base + "/StudentLocation"
        case .updateLocation:
            return Endpoints.base + "/StudentLocation/" + Endpoints.authModel!.objectId
        case .getLoggedInUserProfile:
            return Endpoints.base + "/users/" + Endpoints.authModel!.key
            
        }
    }
    
    var url: URL {
        return URL(string: stringValue)!
    }
    
    static var authModel: AuthModel? {
        return (UIApplication.shared.delegate as? AppDelegate)?.authModel
    }
}
