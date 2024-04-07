//
//  StudentModel.swift
//  OnMap
//
//  Created by KhoaLA8 on 30/3/24.
//

import Foundation

struct StudentModel: Codable {
    var createdAt: String?
    var firstName: String
    var lastName: String
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    var objectId: String?
    var uniqueKey: String?
    var updatedAt: String?
    
    init(_ dictionary: [String: AnyObject]) {
        self.createdAt = dictionary["createdAt"] as? String
        self.uniqueKey = dictionary["uniqueKey"] as? String ?? ""
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.mapString = dictionary["mapString"] as? String ?? ""
        self.mediaURL = dictionary["mediaURL"] as? String ?? ""
        self.latitude = dictionary["latitude"] as? Double ?? 0.0
        self.longitude = dictionary["longitude"] as? Double ?? 0.0
        self.objectId = dictionary["objectId"] as? String
        self.updatedAt = dictionary["updatedAt"] as? String
    }
}

class StudentsData: NSObject {
    
    var students = [StudentModel]()
    
    class func sharedInstance() -> StudentsData {
        struct Singleton {
            static var sharedInstance = StudentsData()
        }
        return Singleton.sharedInstance
    }
    
}

struct StudentsLocation: Codable {
    let results: [StudentModel]
}

struct UserProfile: Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
 
}
