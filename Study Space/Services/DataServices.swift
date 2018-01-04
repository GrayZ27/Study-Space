//
//  DataServices.swift
//  Study Space
//
//  Created by Gray Zhen on 1/4/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import Foundation
import Firebase

class DataServices {
    
    static let instance = DataServices()
    
    private var _REF_BASE = DATABASE_BASE
    private var _REF_USERS = DATABASE_BASE.child("users")
    private var _REF_GROUPS = DATABASE_BASE.child("groups")
    private var _REF_FEED = DATABASE_BASE.child("feed")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    
    var REF_FEED: DatabaseReference {
        return _REF_FEED
    }
    
    //func to create users in Firebase
    func createDatabaseUser(withId id: String, andUserInfo userInfo: Dictionary<String, Any>) {
        REF_USERS.child(id).updateChildValues(userInfo)
    }
    
}
