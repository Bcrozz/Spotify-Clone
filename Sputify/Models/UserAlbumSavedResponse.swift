//
//  UserAlbumSavedResponse.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 17/11/21.
//

import Foundation
import ObjectMapper

struct UserAlbumSavedResponse: Mappable {
    let items: [UserAlbumDetail]?
    
    init?(map: Map) {
        items = try? map.value("items")
    }
    
    mutating func mapping(map: Map) {
        
    }
    
}

struct UserAlbumDetail: Mappable {
    let album: Album?
    
    init?(map: Map) {
        album = try? map.value("album")
    }
    
    mutating func mapping(map: Map) {
        
    }
}
