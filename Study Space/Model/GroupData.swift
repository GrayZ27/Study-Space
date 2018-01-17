//
//  GroupData.swift
//  Study Space
//
//  Created by Gray Zhen on 1/17/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import Foundation

struct GroupData {
    
    private var _groupName: String
    private var _groupDescription: String
    private var _groupId: String
    private var _members: [String]
    private var _memberCount: Int
    
    var groupName: String {
        return _groupName
    }
    
    var groupDescription: String {
        return _groupDescription
    }
    
    var groupId: String {
        return _groupId
    }
    
    var members: [String] {
        return _members
    }
    
    var memberCount: Int {
        return _memberCount
    }
    
    init(forGroupName name: String, andDescription description: String, withGroupId id: String, andGroupMembers members: [String], withMemberCount count: Int ) {
        _groupName = name
        _groupDescription = description
        _groupId = id
        _members = members
        _memberCount = count
    }
    
}
