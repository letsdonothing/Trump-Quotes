//
//  ViewController.swift
//  ObjectList
//
//  Created by Сергей Новиков on 13/12/2019.
//  Copyright © 2019 Сергей Новиков. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var quoteCollectionView: QuoteCollectionView?
    private var hintTableView: HintTableView?
    private var loadingView: LoadingView?
    private var refreshControl: UIRefreshControl!
    private var searchController: UISearchController!
    
    private var presenter: QuoteCollectionPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresenter()
        setupUI()
        DispatchQueue.global(qos: .utility).async {
            self.presenter.loadPage()
        }
    }
    
    private func setupUI() {
        view.setup(subview: &quoteCollectionView)
        view.setup(subview: &loadingView)
        
        setupRefreshControl(to: quoteCollectionView)
        setupSearchController()
        
        loadingView?.isHidden = true
        setHintsHidden(for: true)
        quoteCollectionView?.displayingIndexCallback = presenter.loadPage(depending:)
        hintTableView?.onCellSelected = search(withText:)
        loadingView?.reload = presenter.loadPage
    }
    
    private func search(withText text: String) {
        presenter.pageContent = .querySearch(text)
        presenter.loadPage()
        searchController.dismiss(animated: true, completion: nil)
        searchController.searchBar.text = text
    }
    
    private func setHintsHidden(for state: Bool) {
        self.hintTableView?.alpha = state ? 1 : 0
        UIView.animate(withDuration: 0.1, animations: {
            self.hintTableView?.alpha = state ? 0 : 1
        }, completion: { _ in
            self.hintTableView?.isHidden = state
        })
    }

    private func setupPresenter() {
        let networkService = NetworkService()
        let quoteService = QuoteService(network: networkService)
        presenter = QuoteCollectionPresenter(quotetService: quoteService)
        presenter.delegate = self
    }
    
    private func setupRefreshControl(to view: UIScrollView?) {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        view?.refreshControl = refreshControl
    }
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.view.setup(subview: &hintTableView)
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc private func refresh() {
        if let text = searchController.searchBar.text, text.isEmpty {
            presenter.pageContent = .random
        }
        presenter.prepareToRefresh()
        presenter.loadPage()
    }
}

extension ViewController: QuoteViewDelegate {
    func set(quotes: [QuoteViewData]) {
        quoteCollectionView?.data = quotes
    }
    
    func append(quotes: [QuoteViewData]) {
        quoteCollectionView?.data += quotes
    }
    
    func startLoading() {
        DispatchQueue.main.async {
            self.loadingView?.minimizeIfNeeded()
            self.loadingView?.isHidden = false
            self.loadingView?.showLoading()
        }
    }

    func finishLoading() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.loadingView?.isHidden = true
        }
    }

    func showErrorToReload() {
        DispatchQueue.main.async {
            self.loadingView?.showError()
        }
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        hintTableView?.data = ["people", "President", "America"]
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        setHintsHidden(for: false)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        setHintsHidden(for: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text.count >= 3 else {
            return
        }
        search(withText: text)
    }
}

