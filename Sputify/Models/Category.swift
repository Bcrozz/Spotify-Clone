//
//  Category.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 14/11/21.
//

import Foundation
import ObjectMapper
//1
struct Category: Mappable {
    let href: String?
    let icons: [APIImage]?
    let id: String?
    let name: String?
    
    init?(map: Map) {
        href = try? map.value("href")
        icons = try? map.value("icons") ?? [APIImage]()
        id = try? map.value("id")
        name = try? map.value("name")
    }
    
    mutating func mapping(map: Map) {
        
    }
}
