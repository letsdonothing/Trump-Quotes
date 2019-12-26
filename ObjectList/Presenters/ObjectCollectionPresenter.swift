//
//  ObjectCollectionPresenter.swift
//  ObjectList
//
//  Created by Сергей Новиков on 13/12/2019.
//  Copyright © 2019 Сергей Новиков. All rights reserved.
//

import Foundation

enum PageContent {
    case random
    case querySearch(String)
    case tagSearch(String)
}

struct QuoteViewData {
    var text: String
    var tags: [String]
}

protocol QuoteViewDelegate: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func set(quotes: [QuoteViewData])
    func append(quotes: [QuoteViewData])
    func showErrorToReload()
}

class QuoteCollectionPresenter {
    private let quotetService: QuoteService
    private var loadedPageNumber = 0
    private var isRefreshing = false
    
    weak var delegate: QuoteViewDelegate?
    var pageContent: PageContent {
        didSet {
            prepareToRefresh()
        }
    }
    
    init(quotetService: QuoteService) {
        self.quotetService = quotetService
        self.pageContent = .random
    }
    
    func prepareToRefresh() {
        isRefreshing = true
        loadedPageNumber = 0
    }
    
    func loadPage() {
        delegate?.startLoading()
        switch pageContent {
        case .random:
            quotetService.getPage(onSuccess: handlePage(of:), onFailure: showError)
        case .querySearch(let query):
            quotetService.getPage(contains: query, number: loadedPageNumber + 1,
                                  onSuccess: handlePage(of:), onFailure: showError)
        default:
            return
        }
    }
    
    private func handlePage(of quotes: [Quote]) {
        pass(quotes: quotes)
        delegate?.finishLoading()
        loadedPageNumber += 1
    }
    
    private func pass(quotes: [Quote]) {
        let mappedQuotes = quotes.map {
            QuoteViewData(text: $0.value, tags: $0.tags)
        }
        if isRefreshing {
            delegate?.set(quotes: mappedQuotes)
            isRefreshing.toggle()
            loadedPageNumber = 0
        } else {
            delegate?.append(quotes: mappedQuotes)
        }
    }
    
    private func showError() {
        delegate?.showErrorToReload()
    }
    
    func loadPage(depending index: Int) {
        if index == (loadedPageNumber - 1) * Global.pageSize + 10 {
            DispatchQueue.global(qos: .utility).async {
                self.loadPage()
            }
        }
    }
    
}


