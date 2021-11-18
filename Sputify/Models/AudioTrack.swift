//
//  AudioTrack.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 8/11/21.
//

import Foundation
import ObjectMapper

struct AudioTrack: Mappable {
    
    let album: Album?
    let artists: [Artist]?
    let discNumber: Int?
    let duration: Int?
    let explicit: Bool?
    let href: String?
    let id: String?
    let name: String?
    let popularity: Int?
    let trackNumber: Int?
    
    init?(map: Map) {
        album = try? map.value("album")
        artists = try? map.value("artists") ?? [Artist]()
        discNumber = try? map.value("disc_number")
        duration = try? map.value("duration_ms")
        explicit = try? map.value("explicit")
        href = try? map.value("href")
        id = try? map.value("id")
        name = try? map.value("name")
        popularity = try? map.value("popularity")
        trackNumber = try? map.value("track_number")
    }
    
    mutating func mapping(map: Map) {
        
    }
    
    
    
    
}
