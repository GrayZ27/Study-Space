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
    @IBOutlet weak var loginEmailTextField: CustomUITextField!
    @IBOutlet weak var loginPasswordTextField: CustomUITextField!
    
    //UIOutlets for Layout Constraint
    @IBOutlet weak var bgImageHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginViewWidthLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginTextFieldStackViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginOptionsStackViewHeightLayoutConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginEmailTextField.delegate = self
        loginPasswordTextField.delegate = self
        
        viewWillSetup()
        
        let tapToDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tapToDismissKeyboard)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    private func viewWillSetup() {
        
        bgImageHeightLayoutConstraint.constant = view.frame.size.height / 2 + 20
        loginViewWidthLayoutConstraint.constant = view.frame.size.width - 32
        loginViewHeightLayoutConstraint.constant = view.frame.size.height * 0.55
        loginTextFieldStackViewHeightLayoutConstraint.constant = loginViewHeightLayoutConstraint.constant * 0.4
        loginOptionsStackViewHeightLayoutConstraint.constant = loginViewHeightLayoutConstraint.constant * 0.12
        
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //IBActions
    @IBAction func signUpByEmailBtnPressed(_ sender: UIButton) {
        guard let signUpView = storyboard?.instantiateViewController(withIdentifier: "SignUpView") else { return }
        present(signUpView, animated: true, completion: nil)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.returnKeyType == .default {
            textField.resignFirstResponder()
        }
        
        if textField.returnKeyType == .done {
            textField.resignFirstResponder()
            print("I'll do Login later")
        }
        
        return true
    }
    
}










