//
//  PlaylistData.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/7/22.
//

import SwiftUI

struct Playlist: Identifiable, Codable {
    let id: String?
    let name: String?
    let href: String?
    let uri: String? // Spotify app specific url
    let description: String?
    var externalUrl: String? = nil
    var imageHref: String? = nil
    var smallImageHref: String? = nil
    
    var user: UserData? = nil
    
    // less important data
    var tracks: Int? = 0
    var type: String? = "playlist"
    
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
    
    init(_ dictionary: [String: Any]) {
        id = dictionary["id"] as? String
        name = dictionary["name"] as? String
        href = dictionary["href"] as? String
        uri = dictionary["uri"] as? String
        description = dictionary["description"] as? String
        
        if let userData = dictionary["owner"] as? [String: Any] {
            user = UserData(userData)
        }
        
        if
            let externalUrls = dictionary["external_urls"] as? [String: Any],
            let spotifyExternalUrl = externalUrls["spotify"] as? String
        {
            externalUrl = spotifyExternalUrl
        }
        
        if let images = dictionary["images"] as? [[String: Any]] {
            if images.count > 0 {
                imageHref = images[0]["url"] as? String
            }
            if images.count > 1 {
                smallImageHref = images[1]["url"] as? String
            }
        }
        
        if
            let tracksResponse = dictionary["tracks"] as? [String: Any],
            let total = tracksResponse["total"] as? Int
        {
            tracks = total
        }
        
        type = dictionary["type"] as? String
    }
}
