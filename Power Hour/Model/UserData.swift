//
//  UserData.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/7/22.
//

import SwiftUI

struct UserData: Identifiable, Codable {
    let id: String?
    let name: String?
    let email: String?
    let href: String?
    let uri: String?
    var imageHref: String? = nil
    
    var type: String? = "user"
    var followers: Int? = 0
    
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
    
    init(_ dictionary: [String: Any]) {
        id = dictionary["id"] as? String
        name = dictionary["display_name"] as? String
        email = dictionary["email"] as? String
        href = dictionary["href"] as? String
        uri = dictionary["uri"] as? String
        
        if let images = dictionary["images"] as? [[String: Any]] {
            if images.count > 0 {
                imageHref = images[0]["url"] as? String
            }
        }
        
        if
            let followersResponse = dictionary["followers"] as? [String: Any],
            let total = followersResponse["total"] as? Int
        {
            followers = total
        }
        
        type = dictionary["type"] as? String
    }
    
    
    // Creating a user object from the database rather than the spotify api
    // Uses different nomenclature for objects
    init(_ dictionary: [String: Any], database: Bool) {
        id = dictionary["id"] as? String
        name = dictionary["name"] as? String
        email = dictionary["email"] as? String
        href = dictionary["href"] as? String
        uri = dictionary["uri"] as? String
        imageHref = dictionary["imageHref"] as? String
        
        followers = dictionary["followers"] as? Int
        type = dictionary["type"] as? String
    }
}
