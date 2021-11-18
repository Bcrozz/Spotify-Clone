//
//  Album.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 13/11/21.
//

import Foundation
import ObjectMapper
//may be get 3 images size
struct Album: Mappable {
    
    let albumType: String?
    let artists: [Artist]?
    let availableMarkets: [String]?
    let href: String?
    let id: String?
    let images: [APIImage]?
    let name: String?
    let releaseData: String?
    let totalTracks: Int?
    
    init?(map: Map) {
        albumType = try? map.value("album_type")
        artists = try? map.value("artists") ?? [Artist]()
        availableMarkets = try? map.value("available_markets") ?? [String]()
        href = try? map.value("href")
        id = try? map.value("id")
        images = try? map.value("images") ?? [APIImage]()
        name = try? map.value("name")
        releaseData = try? map.value("release_date")
        totalTracks = try? map.value("total_tracks")
    }
    
    mutating func mapping(map: Map) {
        
    }
    
    
}
