//
//  ProfileImageCell.swift
//  Study Space
//
//  Created by Gray Zhen on 1/29/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import UIKit

class ProfileImageCell: UITableViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var memberIds = [String]()
    
    func initCellInfo(withMemberId ids: [String]) {
        memberIds = ids
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileImageCollectionCell", for: indexPath) as? ProfileImageCollectionViewCell else { return UICollectionViewCell() }
        let memberId = memberIds[indexPath.row]
        if memberId != ""  {
            cell.initCellInto(withMemberId: memberId)
        }else {
            cell.initCellInto(withMemberId: "")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if memberIds.count > 0 {
            return memberIds.count
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemHeight = collectionView.bounds.height - 10
        let itemWidth = itemHeight
        return CGSize(width: itemWidth, height: itemHeight)
    }

}
