//
//  TagView.swift
//  ObjectList
//
//  Created by Сергей Новиков on 14/12/2019.
//  Copyright © 2019 Сергей Новиков. All rights reserved.
//

import UIKit

class TagView: UIView {
    @IBOutlet private var captionLabel: UILabel!
    
    var color: UIColor = .gray {
        didSet {
            self.backgroundColor = color
        }
    }
    var text: String? {
        didSet {
            self.captionLabel.text = text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }
}
