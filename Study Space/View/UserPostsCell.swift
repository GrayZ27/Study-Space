//
//  UserPostsCell.swift
//  Study Space
//
//  Created by Gray Zhen on 1/26/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import UIKit

class UserPostsCell: UITableViewCell {

    //IBOutlets
    @IBOutlet weak var userPostsLabel: UILabel!
    @IBOutlet weak var postTimeLabel: UILabel!
    
    func configureUserPostsCell(withPostBody post: String, andPostTime time: String) {
        userPostsLabel.text = post
        postTimeLabel.text = time
    }

}
