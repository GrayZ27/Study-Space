//
//  CustomUITextField.swift
//  Study Space
//
//  Created by Gray Zhen on 1/7/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import UIKit

class CustomUITextField: UITextField {

    private var paddings = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    
    override func awakeFromNib() {
        
        setupView()
        super.awakeFromNib()
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, paddings)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, paddings)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, paddings)
    }
    
    private func setupView() {
        
        let placeholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 0.9543312014, blue: 0.9730788859, alpha: 0.5)])
        self.attributedPlaceholder = placeholder
        
    }

}
