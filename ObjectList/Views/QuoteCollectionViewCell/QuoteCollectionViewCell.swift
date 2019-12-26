//
//  ObjectCollectionViewCell.swift
//  ObjectList
//
//  Created by Сергей Новиков on 13/12/2019.
//  Copyright © 2019 Сергей Новиков. All rights reserved.
//

import UIKit

class QuoteCollectionViewCell: UICollectionViewCell {
    static let id = "objectCell"
    
    @IBOutlet weak var topStackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomStackViewConstraint: NSLayoutConstraint!
    
    @IBOutlet private var quoteLabel: UILabel!
    @IBOutlet private var tagStackView: UIStackView!
    
    var quoteText: String? {
        didSet {
            self.quoteLabel.text = quoteText
        }
    }
    var quoteTags: [String]? {
        didSet {
            setupStackView()
            setupTags()
        }
    }
    
    private func setupTags() {
        quoteTags?.forEach { tagString in
            let width = tagString.width(usingFont: .systemFont(ofSize: 12)) + 32
            let view = UIView(frame: CGRect(x: 0, y: 0,
                                            width: ceil(width),
                                            height: tagStackView.bounds.height))
            var tagView: TagView?
            view.setup(subview: &tagView)
            tagView?.text = tagString
            tagStackView.addArrangedSubview(view)
        }
    }
    
    func setupUI() {
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = Style.Color.foreground
        layer.addShadow(withRadius: 10)
    }
    
    private func setupStackView() {
        guard let tags = quoteTags else {
            return
        }
        topStackViewConstraint.constant = tags.isEmpty ? 0 : 20
        bottomStackViewConstraint.constant = tags.isEmpty ? 0 : 20
        tagStackView.bounds.size.height = tags.isEmpty ? 20 : 25
        tagStackView.subviews.forEach {
            $0.removeFromSuperview()
        }
    }

}
