//
//  GroupViewController:.swift
//  Study Space
//
//  Created by Gray Zhen on 1/4/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {

    //IBOutlets
    @IBOutlet weak var groupTableView: UITableView!
    
    private var groupArray = [GroupData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTableView.delegate = self
        groupTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getGroupsToDisplay()
    }
    
    private func getGroupsToDisplay() {
        DataServices.instance.REF_GROUPS.observe(.value) { (dataSnapShot) in
            DataServices.instance.getGroups { (groupDataArray) in
                self.groupArray = groupDataArray
                self.groupTableView.reloadData()
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }

}

extension GroupViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = groupArray[indexPath.row]
        guard let cell = groupTableView.dequeueReusableCell(withIdentifier: "groupCell") as? GroupTableViewCell else { return UITableViewCell()}
        cell.configureGroupCell(forName: group.groupName, andDescription: group.groupDescription, withMemberCount: group.memberCount)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let groupChatVC = storyboard?.instantiateViewController(withIdentifier: "GroupChatVC") as? GroupChatViewController else { return }
        groupChatVC.initGroup(forGroup: groupArray[indexPath.row])
        presentDetail(groupChatVC)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let groupKey = groupArray[indexPath.row].groupId
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (rowAction, indexPath) in
            let deleteGroupAlert = UIAlertController(title: "Delete Group", message: "Are you sure you want to delete?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "Delete", style: .default) { action in
                DataServices.instance.REF_GROUPS.child(groupKey).removeValue()
                self.getGroupsToDisplay()
            }
            deleteGroupAlert.addAction(cancelAction)
            deleteGroupAlert.addAction(okAction)
            self.present(deleteGroupAlert, animated: true, completion: nil)
        }
        deleteAction.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        return [deleteAction]
    }
    
}

