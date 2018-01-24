//
//  CustomUIButton.swift
//  Study Space
//
//  Created by Gray Zhen on 1/8/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import UIKit

class CustomUIButton: UIButton {

    override func awakeFromNib() {
        setupView()
        super.awakeFromNib()
    }
    
    private func setupView() {
        self.layer.cornerRadius = 2
    }
    
}
