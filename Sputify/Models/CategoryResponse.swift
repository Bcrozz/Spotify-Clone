//
//  CategoryResponse.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 14/11/21.
//

import Foundation
import ObjectMapper

struct CategoryResponse: Mappable {
    let href: String?
    let items: [Category]?
    
    init?(map: Map) {
        href = try? map.value("categories.href")
        items = try? map.value("categories.items")
    }
    
    mutating func mapping(map: Map) {
        
    }
}
