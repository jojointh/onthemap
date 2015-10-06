//
//  UIView.swift
//  On The Map
//
//  Created by Surasak on 10/6/15.
//  Copyright (c) 2015 Surasak. All rights reserved.
//

import UIKit

extension UIView {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(self.center.x - 4.0, self.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(self.center.x + 4.0, self.center.y))
        self.layer.addAnimation(animation, forKey: "position")
    }
    
    func shakeSubview() {
        for view in self.subviews {
            view.shake()
        }
    }
}