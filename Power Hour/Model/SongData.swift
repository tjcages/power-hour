//
//  SongData.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/10/22.
//

import SwiftUI

struct Song: Identifiable, Equatable {
    var id: String? = nil
    var title: String? = nil
    var artist: String? = nil
    var imageHref: String? = nil
    var videoHref: String? = nil
    var uri: String? = nil
    
    var image: UIImage? = nil
    
    var added: Date? = nil
    var duration: Int? = nil
    var order: Int? = nil
    var type: String? = nil
    
    var played = false
    
    init(_ dictionary: [String: Any]) {
        if let track = dictionary["track"] as? [String: Any] {
            id = track["id"] as? String
            title = track["name"] as? String
            
            if
                let album = track["album"] as? [String: Any],
                let images = album["images"] as? [[String: Any]],
                images.count > 0
            {
                imageHref = images[0]["url"] as? String
            }
            
            if
                let artists = track["artists"] as? [[String: Any]],
                artists.count > 0
            {
                artist = artists[0]["name"] as? String
            }
            
            uri = track["uri"] as? String
            
            duration = track["duration_ms"] as? Int
            order = track["track_number"] as? Int
            type = track["type"] as? String
        }
        
        added = dictionary["added_at"] as? Date
        
        if
            let videoThumbnail = dictionary["video_thumbnail"] as? [String: Any],
            let href = videoThumbnail["url"] as? String
        {
            videoHref = href
        }
    }
    
    // Creating a user object from the database rather than the spotify api
    // Uses different nomenclature for objects
    init(_ dictionary: [String: Any], sdk: Bool) {
        id = dictionary["id"] as? String
        title = dictionary["title"] as? String
        artist = dictionary["artist"] as? String
        imageHref = dictionary["imageHref"] as? String
        uri = dictionary["uri"] as? String
        
        duration = dictionary["duration"] as? Int
        order = dictionary["order"] as? Int
        type = dictionary["type"] as? String
        
        image = dictionary["image"] as? UIImage
    }
}
