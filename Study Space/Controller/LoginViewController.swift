//
//  LoginViewController.swift
//  Study Space
//
//  Created by Gray Zhen on 1/4/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //UIOutlets
    @IBOutlet weak var bgImageHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginViewWidthLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginBtnHeightLayoutConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewWillSetup()
        
    }
    
    func viewWillSetup() {
        
        bgImageHeightLayoutConstraint.constant = view.frame.size.height / 2 + 20
        loginViewWidthLayoutConstraint.constant = view.frame.size.width - 32
        loginViewHeightLayoutConstraint.constant = view.frame.size.height * 0.50
        loginBtnHeightLayoutConstraint.constant = (loginViewHeightLayoutConstraint.constant - 150) / 3
        
    }
    
}
