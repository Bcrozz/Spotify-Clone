//
//  UserTopArtistsResponse.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 14/11/21.
//

import Foundation
import ObjectMapper

struct UserTopArtistsResponse: Mappable {
    let items: [Artist]?
    
    init?(map: Map) {
        items = try? map.value("items") ?? [Artist]()
    }
    
    mutating func mapping(map: Map) {
        
    }
}
