//
//  NetworkService.swift
//  ObjectList
//
//  Created by Сергей Новиков on 14/12/2019.
//  Copyright © 2019 Сергей Новиков. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import SwiftyJSON

//enum NetworkError: Error {
//    case parseFailure
//    case requestFailure
//}

class NetworkService {
    private var provider: MoyaProvider<API>
    private let endpointClosure = { (target: API) -> Endpoint in
        return Endpoint(url: url(target),
                        sampleResponseClosure: {.networkResponse(200, target.sampleData)},
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }
    
    init() {
        provider = MoyaProvider(endpointClosure: endpointClosure,
                                manager: DefaultAlamofireManager.sharedManager)
    }
    
    func getRandomQuote(completionHandler: @escaping ((Quote?) -> Void)) {
        provider.request(.getRandomQuote, completion: { result in
            switch result {
            case .success(let response):
                guard let quote = self.parseQuote(from: JSON(response.data)) else {
                    completionHandler(nil)
                    return
                }
                completionHandler(quote)
            case .failure(_):
                completionHandler(nil)
            }
        })
    }
    
    func getPageWithQuotes(contains query: String, number: Int,
                           completionHandler: @escaping (([Quote]?) -> Void)) {
        provider.request(.search(query: query, page: number, size: Global.pageSize),
                         completion: { [weak self] result in
                            switch result {
                            case .success(let response):
                                guard let quotes = self?.parsePage(from: JSON(response.data)) else {
                                    completionHandler([])
                                    return
                                }
                                completionHandler(quotes)
                            case .failure(_):
                                completionHandler(nil)
                            }
        })
    }
    
    private func parseQuote(from json: JSON) -> Quote? {
        guard let dict = json.dictionary,
            let quote = dict["value"]?.string,
            let tagArray = dict["tags"]?.array else {
                return nil
        }
        let arrayString = tagArray.map { $0.stringValue }
        return Quote(value: quote, tags: arrayString)
    }
    
    private func parsePage(from json: JSON) -> [Quote]? {
        guard let dict = json.dictionary,
            let embedded = dict["_embedded"]?.dictionary,
            let quoteArray = embedded["quotes"]?.array else {
                return nil
        }
        
        return quoteArray.compactMap {
            return self.parseQuote(from: $0)
        }
    }
    
}
