//
//  PlaylistDetailResponse.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 14/11/21.
//

import Foundation
import ObjectMapper

struct PlaylistDetailResponse: Mappable {
    let description: String?
    let href: String?
    let externalURL: String?
    let id: String?
    let images: [APIImage]?
    let name: String?
    let owner: User?
    let tracksInList: PlaylistDetailTracksResponse?
    
    init?(map: Map) {
        description = try? map.value("description")
        href = try? map.value("href")
        externalURL = try? map.value("external_urls.spotify")
        id = try? map.value("id")
        images = try? map.value("images") ?? [APIImage]()
        name = try? map.value("name")
        owner = try? map.value("owner")
        tracksInList = try? map.value("tracks")
    }
    
    mutating func mapping(map: Map) {
        
    }
    
}

struct PlaylistDetailTracksResponse: Mappable {
    let items: [PlaylistItem]!
    
    init?(map: Map) {
        items = try? map.value("items") ?? [PlaylistItem]()
    }
    
    mutating func mapping(map: Map) {
        
    }
}

struct PlaylistItem: Mappable {
    let addedDate: String?
    let track: AudioTrack?
    
    init?(map: Map) {
        addedDate = try? map.value("added_at")
        track = try? map.value("track")
    }
    
    mutating func mapping(map: Map) {
        
    }
    
}
