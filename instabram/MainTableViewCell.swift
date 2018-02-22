//
//  MainTableViewCell.swift
//  instabram
//
//  Created by kaidong pei on 11/8/17.
//  Copyright © 2017 kaidong pei. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var postimg: UIImageView!
    @IBOutlet weak var postDes: UILabel!
    @IBOutlet weak var likeNum: UILabel!
    
    @IBOutlet weak var likeBtn: UIButton!
    
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeBtn(_ sender: UIButton) {
//        let postObj = postsArrSorted[sender.tag]
//        if postsLikedArr.contains(postObj.postId) == false {
//            sender.setImage(UIImage(named: "like2"), for: .normal)
//            postsLikedArr.append(postObj.postId)
//            ref?.child("publicUsers/\((currentUserId)!)/postsLiked/\(postObj.postId)").setValue(true)
//            ref?.child("posts/\(postObj.postId)/likes").observeSingleEvent(of: .value, with: { (snap) in
//                var val = snap.value as? Int
//                val = val! + 1
//                self.ref?.child("posts/\(postObj.postId)/likes").setValue(val)
//            }) { (error) in
//                print(error.localizedDescription)
//            }
//        }else {
//            sender.setImage(UIImage(named: "like"), for: .normal)
//            let index = postsLikedArr.index(of: postObj.postId)!
//            postsLikedArr.remove(at: index)
//            ref?.child("publicUsers/\((currentUserId)!)/postsLiked/\(postObj.postId)").setValue(nil)
//            ref?.child("posts/\(postObj.postId)/likes").observeSingleEvent(of: .value, with: { (snap) in
//                var val = snap.value as? Int
//                val = val! - 1
//                self.ref?.child("posts/\(postObj.postId)/likes").setValue(val)
//            }) { (error) in
//                print(error.localizedDescription)
//            }
//        }

        
    }
}
