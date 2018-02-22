//
//  Post.swift
//  instabram
//
//  Created by kaidong pei on 11/9/17.
//  Copyright © 2017 kaidong pei. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase


class Post:NSObject {
    var postId: String?
    var desciption: String?
    var like: Int?
    var postTime: Double?
    var userId: String?
    
    init(withsnap snapshot:DataSnapshot) {
        guard let dict = snapshot.value as? [String:Any] else { return }
        postId = dict["PostId"] as? String
        desciption = dict["Description"] as? String
        like = dict["Like"] as? Int
        postTime = dict["Timestamp"] as? Double
        userId = dict["UserId"] as? String
    }
    override required init() {
        super.init()
    }
}
