//
//  RecommendationResponse.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 13/11/21.
//

import Foundation
import ObjectMapper

struct RecommendationResponse: Mappable {
    
    let tracks: [AudioTrack]?
    
    init?(map: Map) {
        tracks = try? map.value("tracks") ?? [AudioTrack]()
    }
    
    mutating func mapping(map: Map) {
        
    }
    
    
}
