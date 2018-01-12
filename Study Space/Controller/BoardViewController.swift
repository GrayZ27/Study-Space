//
//  BoardViewController.swift
//  Study Space
//
//  Created by Gray Zhen on 1/4/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import UIKit
import Firebase

class BoardViewController: UIViewController {

    //IBOutlets
    @IBOutlet weak var messagesTableView: UITableView!
    
    private var messageDataArray = [MessageData]()
    var newMessageCount: Int?
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        messagesTableView.estimatedRowHeight = 95
        messagesTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        DataServices.instance.getAllBoardMessages { (messageDataArray) in
            //or just use "messageDataArray.reversed()" instend of self.customReversedArray(messageDataArray) as! [MessageData]
            self.messageDataArray = self.customReversedArray(messageDataArray) as! [MessageData]
            if self.newMessageCount == nil || self.newMessageCount != messageDataArray.count {
                self.newMessageCount = messageDataArray.count
                self.messagesTableView.reloadData()
                print("reloaded table")
            }
        }
        
    }
    
    //custom reversed array function or use reversed() function to reverse an array
    private func customReversedArray(_ array: [Any]) -> [Any] {
        var newArray = [Any]()
        for item in array {
            newArray.insert(item, at: 0)
        }
        return newArray
    }
    

}

extension BoardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messageDataArray[indexPath.row]
        let imageName = "defaultProfileImage"

        if message.senderId == Auth.auth().currentUser?.uid {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "yourMessageCell") as? YourMessageTableViewCell else { return UITableViewCell()}
            cell.configureYourMessageCell(forMessageBody: message.messageBody, withProfileImage: imageName, atCurrentTime: message.currentTime)
            return cell
        }else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "usersMessageCell") as? UsersMessageTableViewCell else { return UITableViewCell() }
            cell.configureCell(forMessageBody: message.messageBody, withProfileImage: imageName, andProfileName: message.senderId, atCurrentTime: message.currentTime)
            return cell
        }
    }
}















