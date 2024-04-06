//
//  LoginResponse.swift
//  OnMap
//
//  Created by KhoaLA8 on 26/3/24.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}
