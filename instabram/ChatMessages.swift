//
//  ChatMessages.swift
//  instabram
//
//  Created by kaidong pei on 11/13/17.
//  Copyright © 2017 kaidong pei. All rights reserved.
//

import Foundation

import JSQMessagesViewController

class ChatMessages {
    var message: JSQMessage
    var timeStamp: Int
    
    init(msg: JSQMessage, tStamp: Int) {
        message = msg
        timeStamp = tStamp
    }
}
