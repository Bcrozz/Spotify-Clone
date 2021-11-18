//
//  SearchResultResponse.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 15/11/21.
//

import Foundation
import ObjectMapper

struct SearchResultResponse: Mappable {
    let playlists: [Playlist]?
    let albums: [Album]?
    let artists: [Artist]?
    let tracks: [AudioTrack]?
    
    init?(map: Map) {
        playlists = try? map.value("playlists.items")
        albums = try? map.value("albums.items")
        artists = try? map.value("artists.items")
        tracks = try? map.value("tracks.items")
    }
    
    mutating func mapping(map: Map) {
        
    }
}
