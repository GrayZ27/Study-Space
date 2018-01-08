//
//  ShadowUIView.swift
//  Study Space
//
//  Created by Gray Zhen on 1/7/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import UIKit

class ShadowUIView: UIView {

    override func awakeFromNib() {
        
        setupView()
        super.awakeFromNib()
        
    }

    private func setupView() {
        
        self.layer.shadowOpacity = 0.65
        self.layer.shadowRadius = 6
        self.layer.shadowColor = UIColor.white.cgColor
        
    }
    
}
