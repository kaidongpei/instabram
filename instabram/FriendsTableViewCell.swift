//
//  FriendsTableViewCell.swift
//  instabram
//
//  Created by kaidong pei on 11/13/17.
//  Copyright © 2017 kaidong pei. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var red: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
