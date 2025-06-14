//
//  User.swift
//  SocialApp
//
//  Created by hiwot alemu on 11/30/24.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String

    
//
        var initials: String {
            let formatter = PersonNameComponentsFormatter()
            if let components = formatter.personNameComponents(from: fullname) {
                formatter.style = .abbreviated
                return formatter.string(from: components)
            }
            return ""
        }
    

    
//    var initials: String {
//        let formatter = PersonNameComponentsFormatter()
//        if let components = formatter.personNameComponents(from: fullname)
//        {
//            
//            formatter.style = .abbreviated
//            return formatter.string(from: components)
//        }
//        return ""
//    }
}
    
extension User{
//        static var MOCK_USER = User(id: NSUUID().uuidString, fullname: "John Doe", email: " JoneDoe@gmail.com")
    
}
struct PrivacySettings: Codable {
    var profileVisibility: Visibility
    var emailVisibility: Visibility
    var activityTracking: Bool
    
    enum Visibility: String, Codable {
        case `public` = "Public"
        case friends = "Friends"
        case `private` = "Private"
    }
}

