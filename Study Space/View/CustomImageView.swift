//
//  CustomImageView.swift
//  Study Space
//
//  Created by Gray Zhen on 1/23/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {

    override func awakeFromNib() {
        
        setupView()
        super.awakeFromNib()
        
    }
    
    private func setupView() {
        
        self.layer.cornerRadius = self.layer.frame.size.height / 2
        
    }

}
