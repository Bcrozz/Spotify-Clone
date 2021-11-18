//
//  UserTopTracksResponse.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 14/11/21.
//

import Foundation
import ObjectMapper

struct UserTopTracksResponse: Mappable {
    let items: [AudioTrack]?
    
    init?(map: Map) {
        items = try? map.value("items") ?? [AudioTrack]()
    }
    
    mutating func mapping(map: Map) {
        
    }
    
}
