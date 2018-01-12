//
//  MessageData.swift
//  Study Space
//
//  Created by Gray Zhen on 1/12/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import Foundation

struct MessageData {
    
    private var _messageBody: String
    private var _senderId: String
    private var _currentTime: String
    
    var messageBody: String {
        return _messageBody
    }
    
    var senderId: String {
        return _senderId
    }
    
    var currentTime: String {
        return _currentTime
    }
    
    init(forMessageBody message: String, withSenderId senderId: String, atCurrentTime time: String) {
        _messageBody = message
        _senderId = senderId
        _currentTime = time
    }
    
}
