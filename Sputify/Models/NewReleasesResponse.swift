//
//  NewReleasesResponse.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 13/11/21.
//

import Foundation
import ObjectMapper

struct NewReleasesResponse: Mappable {
    let albumsResponse: AlbumsResponse?
    
    init?(map: Map) {
        albumsResponse = try? map.value("albums")
    }
    
    mutating func mapping(map: Map) {
        
    }
    
    
    
}

struct AlbumsResponse: Mappable {
    
    let hrefLink: String?
    let items: Array<Album>?
    let nextLink: String?
    
    init?(map: Map) {
        hrefLink = try? map.value("href")
        items = try? map.value("items") ?? [Album]()
        nextLink = try? map.value("next")
    }
    
    mutating func mapping(map: Map) {
        
    }
    
    
}

