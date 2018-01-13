//
//  PostMessageViewController.swift
//  Study Space
//
//  Created by Gray Zhen on 1/11/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import UIKit
import Firebase

class PostMessageViewController: UIViewController {

    //IBOutlets
    @IBOutlet weak var sendMessageBtn: UIButton!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageWillPostTextView: UITextView!
    @IBOutlet weak var sendingMessageIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageWillPostTextView.delegate = self
        sendingMessageIndicator.isHidden = true
        sendMessageBtn.bindToKeyboard()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    //IBActions
    @IBAction func dismissBtnPressed(_ sender: UIButton) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendMessageBtnPressed(_ sender: UIButton) {
        sendingMessage()
    }
    
    private func sendingMessage() {
        if messageWillPostTextView.text != nil && messageWillPostTextView.text != "" && messageWillPostTextView.text != "I want to say ......" {
            let sendingAlert = UIAlertController(title: "Sending", message: "Send this message?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let sendAction = UIAlertAction(title: "Send", style: .default) { action in
                self.sendMessageBtn.isEnabled = false
                self.sendingMessageIndicator.isHidden = false
                self.sendingMessageIndicator.startAnimating()
                let currentTime = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .short, timeStyle: .medium)
                guard let uid = Auth.auth().currentUser?.uid else { return }
                DataServices.instance.uploadPostToFirebase(withMessage: self.messageWillPostTextView.text, andUID: uid, onTime: currentTime, withGroupKey: nil, whenCompleted: { (success) in
                    if success {
                        self.view.endEditing(true)
                        self.dismiss(animated: true, completion: nil)
                        self.sendMessageBtn.isEnabled = true
                        self.sendingMessageIndicator.isHidden = true
                        self.sendingMessageIndicator.stopAnimating()
                    }else{
                        self.sendMessageBtn.isEnabled = true
                        self.toShowAlert(message: "Can't send your message now, please try again later.")
                    }
                })
            }
            sendingAlert.addAction(cancelAction)
            sendingAlert.addAction(sendAction)
            present(sendingAlert, animated: true, completion: nil)
        }else {
            toShowAlert(message: "Your sending content is not legal")
        }
    }
    
    private func toShowAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}

extension PostMessageViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "I want to say ......"{
            textView.text = ""
            textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true

    }
    
}
