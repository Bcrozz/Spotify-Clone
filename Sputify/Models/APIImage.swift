//
//  APIImage.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 13/11/21.
//

import Foundation
import ObjectMapper

struct APIImage: Mappable {
    
    let url: String?
    
    init?(map: Map) {
        url = try? map.value("url")
    }
    
    mutating func mapping(map: Map) {
        
    }
    
}
