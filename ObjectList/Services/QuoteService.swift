//
//  ObjectService.swift
//  ObjectList
//
//  Created by Сергей Новиков on 13/12/2019.
//  Copyright © 2019 Сергей Новиков. All rights reserved.
//

import Foundation

class QuoteService {
    private let queue = DispatchQueue.global()
    private let networkService: NetworkService
    
    init(network service: NetworkService) {
        self.networkService = service
    }
    
    func getPage(onSuccess successHandler: @escaping (([Quote]) -> Void),
                 onFailure failureHandler: @escaping (() -> Void)) {
        let quoteGroup = DispatchGroup()
        var quoteArray: [Quote] = []
        for _ in 0..<Global.pageSize {
            queue.async(group: quoteGroup, execute: {
                quoteGroup.enter()
                self.networkService.getRandomQuote {
                    guard let quote = $0 else {
                        failureHandler()
                        return
                    }
                    quoteArray.append(quote)
                    quoteGroup.leave()
                }
            })
        }
        
        quoteGroup.notify(queue: queue, execute: {
            successHandler(quoteArray)
        })
    }
    
    func getPage(contains query: String, number: Int,
                 onSuccess successHandler: @escaping (([Quote]) -> Void),
                 onFailure failureHandler: @escaping (() -> Void)) {
        networkService.getPageWithQuotes(contains: query, number: number) {
            guard let quoteArray = $0 else {
                failureHandler()
                return
            }
            successHandler(quoteArray)
        }
    }
    
    func getPage(with tag: String, number: Int,
                 onSuccess successHandler: @escaping (([Quote]) -> Void),
                 onFailure failureHandler: @escaping (() -> Void)) {
        
        
        
        failureHandler()
    }
     
}
