//
//  UserProfile.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 8/11/21.
//

import Foundation
import ObjectMapper

struct UserProfile: Mappable {
    
    let country: String?
    let displayName: String?
    let email: String?
    let externalURL: String?
    let followers: Int?
    let id: String?
    let productType: String?
    let images: Array<APIImage>?
    
    init?(map: Map) {
        country = try? map.value("country")
        displayName = try? map.value("display_name")
        email = try? map.value("email")
        externalURL = try? map.value("external_urls.spotify")
        followers = try? map.value("followers.total") ?? 0
        id = try? map.value("id")
        productType = try? map.value("product")
        images = try? map.value("images") ?? [APIImage]()
    }
    
    mutating func mapping(map: Map) {
        
    }
}







