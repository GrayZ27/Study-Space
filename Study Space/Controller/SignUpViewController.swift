//
//  SignUpViewController.swift
//  Study Space
//
//  Created by Gray Zhen on 1/8/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    //IBOutlets
    @IBOutlet weak var signUpEmailTextField: CustomUITextField!
    @IBOutlet weak var signUpPasswordTextField: CustomUITextField!
    @IBOutlet weak var signUpReEnterPasswordTextField: CustomUITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapToDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        view.addGestureRecognizer(tapToDismissKeyboard)
        
        signUpEmailTextField.delegate = self
        signUpPasswordTextField.delegate = self
        signUpReEnterPasswordTextField.delegate = self
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //IBActions
    @IBAction func dismissBtnPressed(_ sender: UIButton) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }

}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.returnKeyType == .default{
            textField.resignFirstResponder()
        }
        
        if textField.returnKeyType == .done {
            textField.resignFirstResponder()
            print("I'll do sign up later")
        }
        
        return true
    }
    
}
