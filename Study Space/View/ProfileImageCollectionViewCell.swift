//
//  ProfileImageCollectionViewCell.swift
//  Study Space
//
//  Created by Gray Zhen on 1/29/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import UIKit

class ProfileImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    func initCellInto(withMemberId id: String) {
        
        if id != "" {
            DataServices.instance.getUserProfileImageLink(withUID: id, whenCompleted: { (imageLink) in
                DataServices.instance.getUserProfileImage(withImageString: imageLink) { (userImage) in
                    DispatchQueue.main.async {
                        self.profileImage.image = userImage
                    }
                }
            })
        }else {
            profileImage.image = UIImage(named: "defaultProfileImage")
        }
        
    }
}
