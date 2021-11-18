//
//  APICaller.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 8/11/21.
//

import Foundation
import Moya

enum SPTAPI {
    //User Profile
    case getCurrentUserProfile(accessToken: String)
    //Browse
    case getUserTopTracks(accessToken: String,limit: Int)
    
    case getUserTopArtist(accessToken: String,limit: Int)
    
    case getNewReleases(accessToken: String,limit: Int = 50)
    
    case getFeaturedPlaylists(accessToken: String,limit: Int = 50)
    
    case getRecommendations(accessToken: String,seedGenre: Set<String>,limit: Int)
    
    case getRecommendationGenres(accessToken: String)
    //Album
    case getAlbumDetail(accessToken: String,id: String)
    //playslist
    case getPlaylistDetail(accessToken: String,id: String)
    //category
    case getCategory(accessToken: String,limit: Int)
    //category playlist
    case getCategoryPlaylist(accessToken: String,categoryID: String,limit: Int)
    //search
    case search(accessToken: String,query: String)
    //artist
    case getArtist(accessToken: String,id: String)
    
    case getArtistAlbums(accessToken: String,id: String,limit: Int)
    
    case getArtistTopTracks(accessToken: String,id: String)
    
    case getArtistRelateArtists(accessToken: String,id: String)
    //user playlist
    case getUserPlaylist(accessToken: String,limit: Int)
    //user album
    case getUserAlbum(accessToken: String,limit: Int)
}

extension SPTAPI: TargetType {
    var baseURL: URL {
        URL(string: "https://api.spotify.com/v1")!
    }
    
    var path: String {
        switch self {
        case .getCurrentUserProfile:
            return "/me"
        case .getNewReleases:
            return "/browse/new-releases"
        case .getFeaturedPlaylists:
            return "/browse/featured-playlists"
        case .getRecommendationGenres:
            return "/recommendations/available-genre-seeds"
        case .getRecommendations:
            return "/recommendations"
        case .getUserTopTracks:
            return "/me/top/tracks"
        case .getUserTopArtist:
            return "/me/top/artists"
        case .getAlbumDetail(_,let id):
            return "/albums/\(id)"
        case .getPlaylistDetail(_,let id):
            return "/playlists/\(id)"
        case .getCategory:
            return "/browse/categories"
        case .getCategoryPlaylist(_, let categoryID,_):
            return "/browse/categories/\(categoryID)/playlists"
        case .search:
            return "/search"
        case .getArtist(_,let id):
            return "artists/\(id)"
        case .getArtistAlbums(_,let id,_):
            return "artists/\(id)/albums"
        case .getArtistTopTracks(_,let id):
            return "artists/\(id)/top-tracks"
        case .getArtistRelateArtists(_,let id):
            return "artists/\(id)/related-artists"
        case .getUserPlaylist:
            return "/me/playlists"
        case .getUserAlbum:
            return "/me/albums"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .getCurrentUserProfile:
            return .requestPlain
        case .getNewReleases(_, let limit):
            return .requestParameters(parameters: ["limit": limit], encoding: URLEncoding.queryString)
        case .getFeaturedPlaylists(_, limit: let limit):
            return .requestParameters(parameters: ["limit": limit], encoding: URLEncoding.queryString)
        case .getRecommendationGenres:
            return .requestPlain
        case .getRecommendations(_,let genres,let limit):
            let seeds = genres.joined(separator: ",")
            return .requestParameters(parameters: ["seed_genres":seeds,"limit":limit ], encoding: URLEncoding.queryString)
        case .getUserTopTracks(_,let limit),.getUserTopArtist(_, let limit):
            return .requestParameters(parameters: ["limit": limit], encoding: URLEncoding.queryString)
        case .getAlbumDetail, .getPlaylistDetail:
            return .requestPlain
        case .getCategory(_,let limit):
            return .requestParameters(parameters: ["limit": limit], encoding: URLEncoding.queryString)
        case .getCategoryPlaylist(_, _,let limit):
            return .requestParameters(parameters: ["limit": limit], encoding: URLEncoding.queryString)
        case .search(_,let query):
            return .requestParameters(parameters: ["q": query,"type": "album,artist,playlist,track"], encoding: URLEncoding.queryString)
        case .getArtist:
            return .requestPlain
        case .getArtistAlbums(_,_,let limit):
            return .requestParameters(parameters: ["limit": limit], encoding: URLEncoding.queryString)
        case .getArtistTopTracks:
            return .requestParameters(parameters: ["market" : "TH"], encoding: URLEncoding.queryString)
        case .getArtistRelateArtists:
            return .requestPlain
        case .getUserPlaylist(_,let limit):
            return .requestParameters(parameters: ["limit": limit], encoding: URLEncoding.queryString)
        case .getUserAlbum(_,let limit):
            return .requestParameters(parameters: ["limit": limit], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getCurrentUserProfile(let accessToken):
            return ["Authorization": "Bearer \(accessToken)"]
        case .getNewReleases(let accessToken,_):
            return ["Authorization": "Bearer \(accessToken)"]
        case .getFeaturedPlaylists(let accessToken,_):
            return ["Authorization": "Bearer \(accessToken)"]
        case .getRecommendationGenres(let accessToken):
            return ["Authorization": "Bearer \(accessToken)"]
        case .getRecommendations(let accessToken,_,_ ):
            return ["Authorization": "Bearer \(accessToken)"]
        case .getUserTopTracks(let accessToken,_):
            return ["Authorization": "Bearer \(accessToken)"]
        case .getUserTopArtist(let accessToken,_):
            return ["Authorization": "Bearer \(accessToken)"]
        case .getAlbumDetail(let accessToken,_):
            return ["Authorization": "Bearer \(accessToken)"]
        case .getPlaylistDetail(let accessToken,_):
            return ["Authorization": "Bearer \(accessToken)"]
        case .getCategory(let accessToken,_):
            return ["Authorization": "Bearer \(accessToken)"]
        case .getCategoryPlaylist(let accessToken,_, _):
            return ["Authorization": "Bearer \(accessToken)"]
        case .search(let accessToken,_):
            return ["Authorization": "Bearer \(accessToken)"]
        case .getArtist(let accessToken,_):
            return ["Authorization": "Bearer \(accessToken)"]
        case .getArtistAlbums(let accessToken,_,_):
            return ["Authorization": "Bearer \(accessToken)"]
        case .getArtistTopTracks(let accessToken,_):
            return ["Authorization": "Bearer \(accessToken)"]
        case .getArtistRelateArtists(let accessToken,_):
            return ["Authorization": "Bearer \(accessToken)"]
        case .getUserPlaylist(let accessToken,_):
            return ["Authorization": "Bearer \(accessToken)"]
        case .getUserAlbum(let accessToken,_):
            return ["Authorization": "Bearer \(accessToken)"]
        }
    }
    
    
    
}
