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
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    
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
        loginIndicator.isHidden = true
        let tapToDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tapToDismissKeyboard)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    private func viewWillSetup() {
        
        bgImageHeightLayoutConstraint.constant = view.frame.size.height / 2 + 20
        loginViewWidthLayoutConstraint.constant = view.frame.size.width - 32
        loginViewHeightLayoutConstraint.constant = view.frame.size.height * 0.57
        loginTextFieldStackViewHeightLayoutConstraint.constant = loginViewHeightLayoutConstraint.constant * 0.4
        loginOptionsStackViewHeightLayoutConstraint.constant = loginViewHeightLayoutConstraint.constant * 0.12
        
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //IBActions
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        loginUser()
    }
    
    private func loginUser() {
        if loginEmailTextField.text != nil && loginEmailTextField.text != "" {
            guard let email = loginEmailTextField.text else { return }
            if loginPasswordTextField.text != nil && loginPasswordTextField.text != "" {
                guard let password = loginPasswordTextField.text else { return }
                loginIndicator.isHidden = false
                loginIndicator.startAnimating()
                AuthServices.instance.loginUser(withEmail: email, andPassword: password, whenCompleted: { (success, error) in
                    self.loginIndicator.isHidden = true
                    self.loginIndicator.stopAnimating()
                    if success {
                        guard let boardVC = self.storyboard?.instantiateViewController(withIdentifier: "BoardView") else { return}
                        self.present(boardVC, animated: true, completion: nil)
                    }else {
                        self.toShowAlert(message: error?.localizedDescription ?? "Can't login user, please try again later.")
                    }
                })
            }else {
                toShowAlert(message: "Please enter your password to login.")
            }
        }else {
            toShowAlert(message: "Please enter your email to login.")
        }
    }
    
    @IBAction func signUpByEmailBtnPressed(_ sender: UIButton) {
        guard let signUpView = storyboard?.instantiateViewController(withIdentifier: "SignUpView") else { return }
        present(signUpView, animated: true, completion: nil)
    }
    
    @IBAction func forgotPasswordReset(_ sender: UIButton) {
        guard let resetPasswordVC = storyboard?.instantiateViewController(withIdentifier: "ResetPasswordView") else { return }
        present(resetPasswordVC, animated: true, completion: nil)
    }
    
    private func toShowAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.returnKeyType == .default {
            textField.resignFirstResponder()
        }
        
        if textField.returnKeyType == .done {
            textField.resignFirstResponder()
            loginUser()
        }
        
        return true
    }
    
}










