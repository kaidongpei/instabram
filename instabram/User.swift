//
//  User.swift
//  instabram
//
//  Created by kaidong pei on 11/9/17.
//  Copyright © 2017 kaidong pei. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

class User {
    
    var firstname: String?
    var lastname: String?
    var email: String?
    var city: String?
    var uid : String?
  
    
    init(withsnap snapshot:DataSnapshot) {
        guard let dict = snapshot.value as? [String:Any] else { return }
        firstname = dict["FirstName"] as? String
        lastname = dict["LastName"] as? String
        email = dict["EmailID"] as? String
        city = dict["City"] as? String
        uid = dict["UserId"] as? String
        

        
    }
    
    
}
