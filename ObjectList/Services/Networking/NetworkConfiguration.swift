//
//  NetworkingService.swift
//  ObjectList
//
//  Created by Сергей Новиков on 14/12/2019.
//  Copyright © 2019 Сергей Новиков. All rights reserved.
//

import Foundation
import Moya
import Alamofire

enum API {
    case search(query: String, page: Int, size: Int = Global.pageSize)
    case searchFor(tag: String)
    case getRandomQuote
    case getTags
}

extension API: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.tronalddump.io")!
    }
    
    var path: String {
        switch self {
        case .getRandomQuote:
            return "/random/quote"
        case .getTags:
            return "/tag"
        case let .searchFor(tag):
            return "/tag/" + tag
        case .search(_, _, _):
            return "/search/quote"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .search(query, page, size):
            let params: [String : String] = [
                "query": query,
                "page": String(page),
                "size": String(size)
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["accept" : "application/hal+json"]
    }
}

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

class DefaultAlamofireManager: Alamofire.SessionManager {
    static let sharedManager: DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 10 // as seconds, you can set your request timeout
        configuration.timeoutIntervalForResource = 10 // as seconds, you can set your resource timeout
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return DefaultAlamofireManager(configuration: configuration)
    }()
}
