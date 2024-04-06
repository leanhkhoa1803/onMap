//
//  AuthModel.swift
//  OnMap
//
//  Created by KhoaLA8 on 5/4/24.
//

import Foundation

class AuthModel : Codable {
    var sessionId: String? = nil
    var key = ""
    var firstName = ""
    var lastName = ""
    var objectId = ""
    
    init(sessionId: String? = nil, key: String, firstName: String, lastName: String, objectId: String) {
        self.sessionId = sessionId
        self.key = key
        self.firstName = firstName
        self.lastName = lastName
        self.objectId = objectId
    }
    
    init?(json: [String: Any]) {
        guard let key = json["key"] as? String,
              let firstName = json["firstName"] as? String,
              let lastName = json["lastName"] as? String,
              let objectId = json["objectId"] as? String else {
            return nil
        }
        
        self.sessionId = json["sessionId"] as? String
        self.key = key
        self.firstName = firstName
        self.lastName = lastName
        self.objectId = objectId
    }
}
