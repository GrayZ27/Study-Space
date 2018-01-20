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
        present(groupChatVC, animated: true, completion: nil)
        
    }
    
}

