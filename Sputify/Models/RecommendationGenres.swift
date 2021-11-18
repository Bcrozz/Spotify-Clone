//
//  RecommendationGenres.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 13/11/21.
//

import Foundation
import ObjectMapper

struct RecommendationGenres: Mappable {
    let genres: [String]?
    var seeds: Set<String> = []
    
    init?(map: Map) {
        genres = try? map.value("genres") ?? [String]()
    }
    
    mutating func mapping(map: Map) {
        
    }
    

    
}
