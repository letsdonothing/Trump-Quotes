//
//  LoadingView.swift
//  ObjectList
//
//  Created by Сергей Новиков on 15/12/2019.
//  Copyright © 2019 Сергей Новиков. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var refreshButton: UIButton!
    
    private var isFirstLoading = true
    var reload: (() -> Void)?
    
    @IBAction private func refresh(_ sender: UIButton) {
        reload?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.addShadow(withRadius: 0)
        backgroundColor = Style.Color.background
    }
    
    func minimizeIfNeeded() {
        guard !isFirstLoading else {
            isFirstLoading.toggle()
            return
        }
        frame = CGRect(x: 0, y: Bounds.fullHeight - 44.0,
                       width: Bounds.fullWidth, height: 44)
        titleLabel.font = .systemFont(ofSize: 15)
        backgroundColor = Style.Color.foreground
        superview?.layoutIfNeeded()
    }
    
    func showError() {
        titleLabel.text = "Loading error"
        refreshButton.isHidden = false
    }
    
    func showLoading() {
        titleLabel.text = "LOADING..."
        refreshButton.isHidden = true
    }
}
