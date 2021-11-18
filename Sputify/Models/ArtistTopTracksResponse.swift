//
//  ArtistTopTracksResponse.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 16/11/21.
//

import Foundation
import ObjectMapper

struct ArtistTopTracksResponse: Mappable {
    let tracks: [AudioTrack]?
    
    init?(map: Map) {
        tracks = try? map.value("tracks")
    }
    
    mutating func mapping(map: Map) {
        
    }
}
