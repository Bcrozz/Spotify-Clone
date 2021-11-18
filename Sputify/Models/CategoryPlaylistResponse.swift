//
//  CategoryPlaylistResponse.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 14/11/21.
//

import Foundation
import ObjectMapper

struct CategoryPlaylistResponse: Mappable {
    let href: String?
    let items: [Playlist]?
    
    init?(map: Map) {
        href = try? map.value("playlists.href")
        items = try? map.value("playlists.items") ?? [Playlist]()
    }
    
    mutating func mapping(map: Map) {
        
    }
}
