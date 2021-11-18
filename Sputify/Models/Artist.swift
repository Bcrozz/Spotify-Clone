//
//  Artist.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 8/11/21.
//

import Foundation
import ObjectMapper

//3 when you get /artists you will get 3 image size of artist
struct Artist: Mappable {
    let href: String?
    let id: String?
    let name: String?
    let type: String?
    let images: [APIImage]?
    
    init?(map: Map) {
        href = try? map.value("href")
        id = try? map.value("id")
        name = try? map.value("name")
        type = try? map.value("type")
        images = try? map.value("images") ?? [APIImage]()
    }
    
    mutating func mapping(map: Map) {
        
    }
    
    
}

