//
//  AlbumResponse.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 14/11/21.
//

import Foundation
import ObjectMapper

struct AlbumsDetailResponse: Mappable {
    
    let href: String?
    let albumType: String?
    let artists: [Artist]?
    let availableMarket: [String]?
    let externalURL: String?
    let id: String?
    let images: [APIImage]?
    let label: String?
    let name: String?
    let releaseDate: String?
    let totalTracks: Int?
    let tracks: TracksResponse?
    
    
    init?(map: Map) {
        href = try? map.value("href")
        albumType = try? map.value("album_type")
        artists = try? map.value("artists") ?? [Artist]()
        availableMarket = try? map.value("available_markets") ?? [String]()
        externalURL = try? map.value("external_urls.spotify")
        id = try? map.value("id")
        images = try? map.value("images") ?? [APIImage]()
        label = try? map.value("label")
        name = try? map.value("name")
        releaseDate = try? map.value("release_date")
        totalTracks = try? map.value("total_tracks")
        tracks = try? map.value("tracks")
    }
    
    mutating func mapping(map: Map) {
        
    }
    
}

struct TracksResponse: Mappable {
    let items: [AudioTrack]!
    
    init?(map: Map) {
        items = try? map.value("items") ?? [AudioTrack]()
    }
    
    mutating func mapping(map: Map) {
        
    }
}
