//
//  UIButtonExtensions.swift
//  Jungle 2019
//
//  Created by Pin Yiu on 4/2/2020.
//  Copyright © 2020 CityU_Henry. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {

    open override var isEnabled: Bool{
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }

}
