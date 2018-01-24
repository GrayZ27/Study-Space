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
    @IBOutlet weak var signUpIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapToDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        view.addGestureRecognizer(tapToDismissKeyboard)
        signUpIndicator.isHidden = true
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
    
    //sign up user here
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        signUpUser()
    }
    
    private func signUpUser() {
        if signUpEmailTextField.text != nil && signUpEmailTextField.text != "" {
            guard let email = signUpEmailTextField.text else { return }
            if isValidEmail(email) {
                if signUpPasswordTextField.text != nil && signUpPasswordTextField.text != "" {
                    guard let password = signUpPasswordTextField.text else { return }
                    if isvalidPassword(password) {
                        if signUpReEnterPasswordTextField.text != nil && signUpReEnterPasswordTextField.text != "" {
                            guard let reEnterPassword = signUpReEnterPasswordTextField.text else { return }
                            if reEnterPassword == password {
                                signUpIndicator.isHidden = false
                                signUpIndicator.startAnimating()
                                AuthServices.instance.registerUser(withEmail: email, andPassword: password, whenCompleted: { (success, error) in
                                    if success {
                                        AuthServices.instance.loginUser(withEmail: email, andPassword: password, whenCompleted: { (success, error) in
                                            self.signUpIndicator.isHidden = true
                                            self.signUpIndicator.stopAnimating()
                                            if success {
                                                guard let boardVC = self.storyboard?.instantiateViewController(withIdentifier: "BoardView") else { return}
                                                self.present(boardVC, animated: true, completion: nil)
                                            }else {
                                                self.toShowAlert(message: error?.localizedDescription ?? "Can't login user, please try again later")
                                            }
                                        })
                                    }else {
                                        self.toShowAlert(message: error?.localizedDescription ?? "Can't sign up user, please try again later.")
                                    }
                                })
                            }else {
                                toShowAlert(message: "The re-enter password isn't the same to your password")
                            }
                        }else {
                            toShowAlert(message: "Please re-enter your password")
                        }
                    }else {
                        toShowAlert(message: "Your password is not validate")
                    }
                }else {
                    toShowAlert(message: "Please enter your password")
                }
            }else {
                toShowAlert(message: "Your email is not validate.")
            }
        }else {
            toShowAlert(message: "Please enter your e-mail.")
        }
    }
    
    //------------------Functions to validate an e-mail address and password----------------
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func isvalidPassword(_ password : String) -> Bool{
        let passwordRegEx = "^(?=.*[a-z])(?=.*[0-9])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
    
    //------------------Function to show alert----------------
    private func toShowAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .default{
            textField.resignFirstResponder()
        }
        if textField.returnKeyType == .done {
            textField.resignFirstResponder()
            signUpUser()
        }
        return true
    }
    
}

