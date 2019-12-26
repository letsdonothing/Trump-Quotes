//
//  ObjectCollectionView.swift
//  ObjectList
//
//  Created by Сергей Новиков on 13/12/2019.
//  Copyright © 2019 Сергей Новиков. All rights reserved.
//

import UIKit

class QuoteCollectionView: UICollectionView {
    private var noResultLabel: UILabel!
    var displayingIndexCallback: ((Int) -> Void)?
    var data: [QuoteViewData] = [] {
        didSet {
            DispatchQueue.main.async {
                self.updateContent()
            }
        }
    }
    
    override func didMoveToSuperview() {
        setup()
    }
    
    private func setup() {
        guard let nib: UINib = .ofType(QuoteCollectionViewCell.self) else {
            return
        }
        register(nib, forCellWithReuseIdentifier: QuoteCollectionViewCell.id)
        backgroundColor = .clear
        dataSource = self
        delegate = self
    }
    
    private func setNoResults() {
        let string = "No Results"
        let font = UIFont.systemFont(ofSize: 28)
        let width = string.width(usingFont: font)
        let x = (Bounds.fullWidth - width) / 2
        noResultLabel = UILabel(frame: CGRect(x: x, y: 100, width: width, height: 30))
        noResultLabel.text = string
        noResultLabel.font = font
        addSubview(noResultLabel)
    }
}

extension QuoteCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuoteCollectionViewCell.id, for: indexPath) as! QuoteCollectionViewCell
        setup(cell: cell, for: indexPath.row)
        return cell
    }
    
    private func setup(cell: QuoteCollectionViewCell, for index: Int) {
        cell.quoteText = data[index].text
        cell.quoteTags = data[index].tags
        cell.setupUI()
    }
    
    private func updateContent() {
        if data.isEmpty {
            setNoResults()
        } else {
            noResultLabel?.removeFromSuperview()
        }
        self.reloadData()
    }
}

extension QuoteCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        displayingIndexCallback?(indexPath.row)
    }
}

extension QuoteCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize(for: indexPath.row)
    }
    
    private func cellSize(for index: Int) -> CGSize {
        if data[index].tags.isEmpty {
            return CGSize(width: Bounds.fullWidth - 32, height: 84)
        }
        return CGSize(width: Bounds.fullWidth - 32, height: 130)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16.0
    }
}

