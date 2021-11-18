//
//  FeaturedPlaylists.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 13/11/21.
//

import Foundation
import ObjectMapper

struct FeaturedPlaylists: Mappable {
    
    let playlists: PlaylistResponse?
    
    init?(map: Map) {
        playlists = try? map.value("playlists")
    }
    
    mutating func mapping(map: Map) {
        
    }
}

struct PlaylistResponse: Mappable {
    
    let hrefLink: String?
    let items: Array<Playlist>?
    let nextLink: String?
    
    init?(map: Map) {
        hrefLink = try? map.value("href")
        items = try? map.value("items") ?? [Playlist]()
        nextLink = try? map.value("next")
    }
    
    mutating func mapping(map: Map) {
        
    }
    
}
