//
//  UIButtonExtension.swift
//  JZFramework
//
//  Created by Jeff Zhang on 13/3/18.
//  Copyright © 2018 Jeff Zhang. All rights reserved.
//

import UIKit

extension UIButton{
    
    public static func getDefaultButton(title: String, font: UIFont?=nil,
                                        titleColor: UIColor?=nil, backgroundColor: UIColor?=nil) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = font ?? UIFont.getRegularText(Constants.defaultFontSize)
        if let color = titleColor{
            button.setTitleColor(color, for: .normal)
        }
        button.backgroundColor = backgroundColor ?? Constants.defaultViewBackgroundColor
        return button
    }
    
    public static func getDefautlButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        return button
    }
    
    public func underline() {
        let attributedString = NSMutableAttributedString(string: (self.titleLabel?.text!)!)
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: (self.titleLabel?.text!.count)!))
        self.titleLabel?.attributedText = attributedString
    }
    
}