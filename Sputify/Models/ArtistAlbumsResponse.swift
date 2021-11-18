//
//  ArtistResponse.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 16/11/21.
//

import Foundation
import ObjectMapper

struct ArtistAlbumsResponse: Mappable {
    let href: String?
    let items: [Album]?
    let totoal: Int?
    
    init?(map: Map) {
        href = try? map.value("href")
        items = try? map.value("items")
        totoal = try? map.value("total")
    }
    
    mutating func mapping(map: Map) {
        
    }
    
}
