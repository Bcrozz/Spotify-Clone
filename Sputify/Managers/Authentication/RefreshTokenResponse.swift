//
//  RefreshTokenResponse.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 9/11/21.
//

import Foundation
import ObjectMapper

struct RefreshTokenResponse: Mappable {
    
    var access_token: String?
    var expires_in: Int?
    var scope: String?
    var token_type: String?
    
    init?(map: Map) {
        access_token = try? map.value("access_token") ?? ""
        expires_in   = try? map.value("expires_in") ?? 0
        scope = try? map.value("scope")
        token_type = try? map.value("token_type")
    }
    
    mutating func mapping(map: Map) {
        access_token    <- map["access_token"]
        expires_in      <- map["expires_in"]
        scope           <- map["scope"]
        token_type      <- map["token_type"]
    }
    
    
}
