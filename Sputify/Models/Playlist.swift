//
//  Playlist.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 8/11/21.
//

import Foundation
import ObjectMapper

struct Playlist: Mappable {
    
    let description: String?
    let href: String?
    let id: String?
    let images: [APIImage]?
    let name: String?
    let owner: User?
    let type: String?
    
    init?(map: Map) {
        description = try? map.value("description")
        href = try? map.value("href")
        id = try? map.value("id") ?? ""
        images = try? map.value("images") ?? [APIImage]()
        name = try? map.value("name")
        owner = try? map.value("owner")
        type = try? map.value("type")
    }
    
    mutating func mapping(map: Map) {
        
    }
    
}

struct User: Mappable {
    
    let displayName: String?
    let id: String?
    
    init?(map: Map) {
        displayName = try? map.value("display_name")
        id = try? map.value("id")
    }
    
    mutating func mapping(map: Map) {
        
    }
    
    
}
