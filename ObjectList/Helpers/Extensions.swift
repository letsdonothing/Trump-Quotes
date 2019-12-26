//
//  Extensions.swift
//  ObjectList
//
//  Created by Сергей Новиков on 13/12/2019.
//  Copyright © 2019 Сергей Новиков. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T? {
        let nibName = String(describing: T.self)
        let bundle = Bundle(for: T.self)
        let nibs = bundle.loadNibNamed(nibName, owner: nil, options: nil)
        let view = nibs?.first as? T
        
        return view
    }
    
    func setup<T: UIView>(subview: inout T?) {
        guard let pView: T = .fromNib() else {
            return
        }
        subview = pView
        subview!.frame = self.bounds
        self.addSubview(subview!)
    }
}

extension UINib {
    static func ofType<T: UIView>(_ type: T.Type) -> UINib? {
        let nibName = String(describing: type)
        return UINib(nibName: nibName, bundle: Bundle(for: type))
    }
}

extension CALayer {
    func addShadow(withRadius radius: CGFloat) {
        cornerRadius = radius
        shadowColor = Style.Color.shadow.cgColor
        shadowOffset = CGSize(width: 0, height: 3)
        shadowOpacity = 1
        shadowRadius = 10
        shadowPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        shouldRasterize = true
        masksToBounds = false
        rasterizationScale = UIScreen.main.scale
        backgroundColor = UIColor.clear.cgColor
    }
}

extension String {
    func width(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
