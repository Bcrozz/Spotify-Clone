//
//  AuthManager.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 8/11/21.
//

import Foundation
import Alamofire
import Moya

final class AuthManager {
    
    static let shared = AuthManager()
    
    final let authProvider = MoyaProvider<SPTAuthorizeAPI>()
    
    private var refreshingToken = false
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationData: Date? {
        return UserDefaults.standard.object(forKey: "expires_in") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationData else {
            return false
        }
        let currentDate = Date()
        let fiveMin = TimeInterval(300)
        return currentDate.addingTimeInterval(fiveMin) >= expirationDate
    }
    
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void)){
        // Get Token
        authProvider.request(.getAccessAndRefreshToken(code: code)){ [weak self] result in
            
            switch result {
            case .success(let response):
                do {
                    let jsonData = try response.mapJSON() as! [String: Any]
                    if let authresponse = AuthResponse(JSON: jsonData){
                        print(authresponse)
                        self?.cacheToken(result: authresponse)
                        completion(true)
                    }
                } catch {
                    print(error.localizedDescription)
                    completion(false)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
            
        }
    }
    
    private var onRefreshBlock = [(String) -> Void]()
    
    public func withVaidToken(completion: @escaping (String) -> Void){
        guard !refreshingToken else {
            onRefreshBlock.append(completion)
            return
        }
        
        if shouldRefreshToken {
            refreshTokenIfNeeded { [weak self] success in
                if success, let token = self?.accessToken {
                    completion(token)
                }
            }
        } else if let token = accessToken {
            completion(token)
        }
    }
    
    public func refreshTokenIfNeeded(completion: ((Bool) -> Void)?) {
        guard !refreshingToken else {
            return
        }
        
        guard shouldRefreshToken else {
            completion?(true)
            print("access token: \(accessToken ?? "---")")
            return
        }
        
        guard let refreshToken = self.refreshToken else {
            return
        }
        
        refreshingToken = true
        
        authProvider.request(.refreshAccessToken(refreshToken: refreshToken)) { [weak self] result in
            self?.refreshingToken = false
            switch result {
            case .success(let response):
                do {
                    let filteredResponse = try response.filter(statusCode: 200)
                    let jsonData = try filteredResponse.mapJSON() as! [String: Any]
                    if let authresponse = AuthResponse(JSON: jsonData) {
                        print(authresponse)
                        self?.onRefreshBlock.forEach{ $0(authresponse.access_token!) }
                        self?.onRefreshBlock.removeAll()
                        self?.cacheToken(result: authresponse)
                        print(refreshToken)
                        completion?(true)
                    }
                } catch {
                    print(error.localizedDescription)
                    completion?(false)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion?(false)
            }
        }
        
    }
    
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if result.refresh_token != nil {
            UserDefaults.standard.setValue(result.refresh_token, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in!)), forKey: "expires_in")
    }
    
    public func signOut(completion: (Bool) -> Void){
        UserDefaults.standard.setValue(nil, forKey: "access_token")
        UserDefaults.standard.setValue(nil, forKey: "refresh_token")
        UserDefaults.standard.setValue(nil, forKey: "expires_in")
        
        completion(true)
    }
    
    
}

extension AuthManager {
    
    struct Constant {
        static let clientID = "aaca8c8de4ec453fabda085ad753f20b"
        static let clientSecret = "149ef96e867d42f08bdc3e41679c4412"
        static let redirectURL = "https://github.com/Bcrozz/"
        static let authorizationHeader = "Basic "+Data("\(clientID):\(clientSecret)".utf8).base64EncodedString()
        static let scopes = "user-read-private user-read-email playlist-read-private user-read-playback-state user-modify-playback-state user-read-currently-playing user-library-read user-read-playback-position user-read-recently-played user-top-read streaming user-follow-read"
    }
    
    static func generateRandomString() -> String{
        let randomConstant = 16
        let possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        
        return String((0..<randomConstant).map{ _ in possible.randomElement()! })
        
    }
    
}
