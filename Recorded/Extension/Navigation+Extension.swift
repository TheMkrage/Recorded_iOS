//
//  Navigation+Extension.swift
//  Recorded
//
//  Created by Matthew Krager on 2/18/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit

extension UINavigationController {
    func queueCurl() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = "pageCurl"
        self.view.layer.add(transition, forKey: nil)
    }
    
    func queueUnCurl() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = "pageUnCurl"
        self.view.layer.add(transition, forKey: nil)
    }
}
