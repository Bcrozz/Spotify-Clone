//
//  ArtistRelatedArtistsResponse.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 16/11/21.
//

import Foundation
import ObjectMapper

struct ArtistRelatedArtistsResponse: Mappable {
    let artists: [Artist]?
    
    init?(map: Map) {
        artists = try? map.value("artists")
    }
    
    mutating func mapping(map: Map) {
        
    }
}
