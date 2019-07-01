//
//  UIViewExtension.swift
//  MVVM_Demo
//
//  Created by raj.sharma on 21/06/19.
//  Copyright © 2019 raj.sharma. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var corner: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.clipsToBounds = true
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
            self.clipsToBounds = true
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor.clear
        }
        set {
            self.layer.borderColor = newValue?.cgColor
            self.layer.borderWidth = 1.0
        }
    }
}
