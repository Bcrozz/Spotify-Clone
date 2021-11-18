//
//  UserPlaylistResponse.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 17/11/21.
//

import Foundation
import ObjectMapper

struct UserPlaylistResponse: Mappable {
    let items: [Playlist]?
    
    init?(map: Map) {
        items = try? map.value("items")
    }
    
    mutating func mapping(map: Map) {
        
    }
}
