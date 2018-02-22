//
//  UsersViewController.swift
//  instabram
//
//  Created by kaidong pei on 11/9/17.
//  Copyright © 2017 kaidong pei. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import TwicketSegmentedControl

class UsersViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, TwicketSegmentedControlDelegate{
    
    
    
    @IBOutlet weak var currentImg: UIImageView!
    
    @IBOutlet weak var currentname: UILabel!
    
    
    @IBOutlet weak var navbar: UINavigationBar!
    
    @IBOutlet weak var tb: UITableView!
    var ref :  DatabaseReference?
    var storageRef = StorageReference()
    
    //var getUserLists: [User] = []
    var userList:[User] = []
    var friendID:[String] = []
    var friendList:[User] = []
    let userIdd = Auth.auth().currentUser?.uid ?? ""
    var currentUser: User?
    var friend = false
//    lazy var refreshControl: UIRefreshControl = {
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(MainViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
//
//        return refreshControl
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getInfo()
        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
        getUser()
        //self.tb.addSubview(self.refreshControl)
        tb.backgroundView?.backgroundColor = UIColor(red:0.11, green:0.56, blue:0.95, alpha:1.0)
        tb.tableFooterView = UIView()
        
        
        let titles = ["All users", "Friends", ]
        let frame = CGRect(x: 0, y:143, width: view.frame.width, height: 40)
        
        let segmentedControl = TwicketSegmentedControl(frame: frame)
        segmentedControl.setSegmentItems(titles)
        segmentedControl.delegate = self
        
        view.addSubview(segmentedControl)
        
        
        
        //tb.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if friend == true{
            return friendList .count
        } else{
        return userList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var list: [User] = []
        
        if friend == true{
            list = friendList
        } else {
            list = userList
        }
        
        
       
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "usercell", for: indexPath) as! UsersTableViewCell
        cell.name.text = list[indexPath.row].firstname! + " " + list[indexPath.row].lastname!
        
        let id = list[indexPath.row].uid
        
        
        
        let islandRef = storageRef.child("UserImages/\(id!).jpg")
        
        islandRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if error == nil{
                cell.img.image = UIImage(data: data!)
            }else{
                print(error?.localizedDescription)
                cell.img.image = UIImage(named: "blue-user-icon")
                
            }
            
        }
        
      
        
        if friendID.contains(list[indexPath.row].uid!)   {
                cell.addFriend.setImage(UIImage(named: "ff2"), for: .normal)
            } else {
                cell.addFriend.setImage(UIImage(named: "ff"), for: .normal)
            }
      
        cell.addFriend.tag = indexPath.row
        cell.addFriend.addTarget(self, action: #selector(mapsHit), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    @objc func mapsHit(sender: UIButton){
        let indexPathOfThisCell = sender.tag
        let id = self.userList[indexPathOfThisCell].uid
        //let userIdd = Auth.auth().currentUser?.uid ?? ""
        
        
        if friendID.contains(id!){
            sender.setImage(UIImage(named: "ff"), for: .normal)
            let index = friendID.index(of: id!)
            friendID.remove(at: index!)
            let delete = Database.database().reference().child("Users").child(userIdd).child("Friend").child(id!)
            delete.removeValue()
        } else {
            sender.setImage(UIImage(named: "ff2"), for: .normal)
            friendID.append(id!)
            Database.database().reference().child("Users").child(userIdd).child("Friend").updateChildValues([id! : "id"])
        }
        //uploadFriend()
        print(friendID)
   }
    
    func getFriendList(){
         friendID = []
        Database.database().reference().child("Users").child(userIdd).observeSingleEvent(of: .value, with: { (snapShot) in
            //print(snapShot)
            guard let dict = snapShot.value as? NSDictionary else { return }
             guard let Friend = dict["Friend"] as? NSDictionary else{
                    return }
            for i in Friend{
                let key = i.key
                self.friendID.append(key as! String)
               
            }
    })
      getFriend()
    }
    
    func getFriend(){
       
        friendList = []
        ref?.child("Users").observeSingleEvent(of: .value, with: { (snapShot) in
            for userTable in snapShot.children {
                
                var userDe: User
                
                userDe = User.init(withsnap: userTable as! DataSnapshot)
                    for i in self.friendID{
                        if userDe.uid == i{
                            self.friendList.append(userDe)
                        }
                }
            }
            self.tb.reloadData()
        })
        
        
    }
    
    
    func didSelect(_ segmentIndex: Int) {
        if segmentIndex == 0{
            friend = false
            navbar.topItem?.title = "All Users"
            
            
            
        } else{
            userList = []
            friendID = []
            friendList = []
            getUser()
            
            friend = true
            navbar.topItem?.title = "Friends"
            
            
            
        }
        self.tb.reloadData()
        
    }
    
    func getUser(){
        
        ref?.child("Users").observeSingleEvent(of: .value, with: { (snapShot) in
            for userTable in snapShot.children {
               
                var userDe: User
                
                userDe = User.init(withsnap: userTable as! DataSnapshot)
                if self.userIdd != userDe.uid{
               
                self.userList.append(userDe)
                } else if self.userIdd == userDe.uid {
                    self.currentUser = userDe
                }
            }
            //self.getFollower()
            self.getFriendList()
            //self.getFriend()
            
            self.tb.reloadData()
            
        })
        
        
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        userList = []
        friendID = []
        friendList = []
        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
        getUser()
        self.tb.reloadData()
        refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func getImage(uid:String) {
        let islandRef = storageRef.child("UserImages/\(String(describing: uid)).jpg")
        islandRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if error == nil{
                self.currentImg.image = UIImage(data: data!)
            }else{
                print(error!)
                self.currentImg.image = UIImage(named: "people-1")
                
            }
            
        }
    }
    func getInfo(){
        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
        let userID = Auth.auth().currentUser?.uid
        ref?.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.currentname.text = value?["FirstName"] as? String ?? ""
           
            self.getImage(uid: userID!)
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
