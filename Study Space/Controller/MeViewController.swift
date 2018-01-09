//
//  MeViewController.swift
//  Study Space
//
//  Created by Gray Zhen on 1/9/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import UIKit

class MeViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    //IBOutlets
    @IBAction func logoutUserBtnPressed(_ sender: UIButton) {
        
        AuthServices.instance.logoutUser { (success, error) in
            
            if success {
                
                guard let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginView") else { return }
                self.present(loginVC, animated: true, completion: nil)
                
            }else {
                
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(defaultAction)
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }
        
    }

}
