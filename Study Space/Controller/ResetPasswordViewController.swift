//
//  ResetPasswordViewController.swift
//  Study Space
//
//  Created by Gray Zhen on 1/10/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    //IBOutlets
    @IBOutlet weak var emailForResetPasswordTextField: CustomUITextField!
    @IBOutlet weak var resetPasswordIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailForResetPasswordTextField.delegate = self
        let tapToDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(ResetPasswordViewController.tapToDismissKeyboard))
        view.addGestureRecognizer(tapToDismissKeyboard)
        resetPasswordIndicator.isHidden = true
    }
    
    //IBActions
    @IBAction func closeResetViewBtnpressed(_ sender: UIButton) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendResetPasswordBtnPressed(_ sender: UIButton) {
        
        if emailForResetPasswordTextField.text != nil && emailForResetPasswordTextField.text != "" {
            guard let email = emailForResetPasswordTextField.text else { return }
            resetPasswordIndicator.isHidden = false
            resetPasswordIndicator.startAnimating()
            AuthServices.instance.forgotPasswordReset(withEmail: email, whenCompleted: { (success, error) in
                self.resetPasswordIndicator.isHidden = true
                self.resetPasswordIndicator.stopAnimating()
                if success {
                    self.toShowAlertWithHandler(message: "Please check your email to reset your password", withStoryBoardIdentifier: "LoginView")
                }else {
                    self.toShowAlert(message: error?.localizedDescription ?? "Can't reset password now, please try again later.")
                }
            })
            
        }else {
            toShowAlert(message: "Please enter your email for reset password.")
        }
        
    }
    
    private func toShowAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func toShowAlertWithHandler(message: String, withStoryBoardIdentifier identifier: String) {
        let alert = UIAlertController(title: "Sent reset E-mail", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .cancel) { action in
            guard let targetVC = self.storyboard?.instantiateViewController(withIdentifier: identifier) else { return }
            self.present(targetVC, animated: true, completion: nil)
        }
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func tapToDismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension ResetPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
