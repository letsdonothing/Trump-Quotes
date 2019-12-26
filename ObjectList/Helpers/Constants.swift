//
//  Constants.swift
//  ObjectList
//
//  Created by Сергей Новиков on 13/12/2019.
//  Copyright © 2019 Сергей Новиков. All rights reserved.
//

import Foundation
import UIKit

class Global {
    static let pageSize = 20
}

class Bounds {
    private static let guide = UIApplication.shared.windows.first!.safeAreaLayoutGuide

    static let viewHeight = guide.layoutFrame.size.height
    static let viewWidth = guide.layoutFrame.size.width
    
    static let fullHeight = UIScreen.main.bounds.height
    static let fullWidth = UIScreen.main.bounds.width
}

class Style {
    class Color {
        static let background = UIColor(named: "background")!
        static let foreground = UIColor(named: "foreground")!
        static let shadow = UIColor(named: "shadow")!
    }
}
