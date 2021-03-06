//
//  UIStackViewExtension.swift
//  JZiOSFramework
//
//  Created by Jeff Zhang on 13/3/18.
//  Copyright © 2018 Jeff Zhang. All rights reserved.
//

import Foundation

extension UIStackView{
    
    public convenience init(arrangedSubviews: [UIView], axis: UILayoutConstraintAxis, spacing: CGFloat) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
    }
    
    public func resetArrangedSubviews(_ subviews: [UIView]) {
        self.subviews.forEach {
            $0.removeFromSuperview()
        }
        addArrangedSubviews(subviews)
    }
    
    public func addArrangedSubviews(_ views: [UIView]) {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }
}
