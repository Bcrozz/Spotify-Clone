//
//  SpotifyAPI.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 8/11/21.
//

import Foundation
import Moya

enum SPTAuthorizeAPI {
    case reqestAuthorize(_ clientID: String = AuthManager.Constant.clientID,
                         _ scopes: String = AuthManager.Constant.scopes,
                         _ state: String = AuthManager.generateRandomString(),
                         _ redirectURL: String = AuthManager.Constant.redirectURL,
                         _ responseType: String = "code")
    
    case getAccessAndRefreshToken(_ authorization: String = AuthManager.Constant.authorizationHeader,
                                  code: String,
                                  _ grant_type: String = "authorization_code",
                                  _ redirectURL: String = AuthManager.Constant.redirectURL)
    
    case refreshAccessToken(_ authorization: String = AuthManager.Constant.authorizationHeader,
                            _ grant_type: String = "refresh_token",
                            refreshToken: String)
}

extension SPTAuthorizeAPI: TargetType {
    var baseURL: URL {
        URL(string: "https://accounts.spotify.com")!
    }
    
    var path: String {
        switch self {
        case .reqestAuthorize:
            return "/authorize"
            
        case .getAccessAndRefreshToken, .refreshAccessToken:
            return "/api/token"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .reqestAuthorize:
            return .get
            
        case .getAccessAndRefreshToken, .refreshAccessToken:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .reqestAuthorize(let clientID,
                              let scopes,
                              let state,
                              let redirectURL,
                              let responseType):
            return .requestParameters(parameters: ["response_type": responseType, "client_id": clientID, "scope": scopes, "redirect_uri": redirectURL, "state": state],
                                      encoding: URLEncoding.queryString)
            
        case .getAccessAndRefreshToken(_,
                                       let code,
                                       let grant_type,
                                       let redirectURL):
            return .requestCompositeParameters(bodyParameters: ["code": code,"grant_type": grant_type,"redirect_uri": redirectURL],
                                               bodyEncoding: URLEncoding.httpBody,
                                               urlParameters: [:])
            
        case .refreshAccessToken(_,
                                 let grant_type,
                                 let refreshToken):
            return .requestCompositeParameters(bodyParameters: ["grant_type": grant_type, "refresh_token": refreshToken],
                                               bodyEncoding: URLEncoding.httpBody,
                                               urlParameters: [:])
            
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .reqestAuthorize:
            return nil
            
        case .getAccessAndRefreshToken(let authorization,_,_,_), .refreshAccessToken(let authorization,_,_):
            return ["Content-Type": "application/x-www-form-urlencoded",
                    "Authorization": authorization]
        }
    }
    
    
}

extension SPTAuthorizeAPI {
    
    func getScopeFromArray(scopes: [String]) -> String {
        var scopesString = ""
        
        for scope in scopes {
            scopesString += "\(scope) "
        }
        
        return scopesString
    }
    
}
