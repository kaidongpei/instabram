//
//  FriendsViewController.swift
//  instabram
//
//  Created by kaidong pei on 11/13/17.
//  Copyright © 2017 kaidong pei. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

var get = false

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tb: UITableView!
    
    var friendID:[String] = []
    var friendList:[User] = []
    let userIdd = Auth.auth().currentUser?.uid ?? ""
    var ref :  DatabaseReference?
    var storageRef = StorageReference()
    var recieve = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if get == true{
//        let view = storyboard?.instantiateViewController(withIdentifier: "chat") as! ChatViewController
//         self.present(view, animated: true, completion: nil)
//        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        recieve = appDelegate.getFID
        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
        tb.tableFooterView = UIView()
        
        
        
//        getFriendList()
//        getFriend()
        // Do any additional setup after loading the view.
       
        tb.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return friendList .count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "friend", for: indexPath) as! FriendsTableViewCell
        cell.name.text = friendList[indexPath.row].firstname
        let id = friendList[indexPath.row].uid
        let islandRef = storageRef.child("UserImages/\(id!).jpg")
        
            cell.red.image = nil
        if id == recieve {
            cell.red.image = UIImage(named: "email")
            recieve = ""
        } else {
            
        }
        
        
        
        islandRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if error == nil{
                cell.img.image = UIImage(data: data!)
                
            } else {
                
                print(error?.localizedDescription)
                cell.img.image = UIImage(named: "blue-user-icon")
                
            }
            
        }
        
        return cell
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        friendList = []
        friendID = []
        getFriendList()
        getFriend()
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func getFriend(){
        
       // friendList = []
        ref?.child("Users").observeSingleEvent(of: .value, with: { (snapShot) in
            for userTable in snapShot.children {
                
                var userDe: User
                
                userDe = User.init(withsnap: userTable as! DataSnapshot)
                for i in self.friendID{
                    if userDe.uid == i{
                        self.friendList.append(userDe)
                    }
                    print(self.friendList)
                    
                }
                
            }
           self.tb.reloadData()
        })
        
    }
    
    func getFriendList(){
        //friendID = []
        Database.database().reference().child("Users").child(userIdd).observeSingleEvent(of: .value, with: { (snapShot) in
            print(snapShot)
            guard let dict = snapShot.value as? NSDictionary else { return }
            guard let Friend = dict["Friend"] as? NSDictionary else{
                return }
            for i in Friend{
                let key = i.key
                self.friendID.append(key as! String)
                print(key)
            }
            
        })

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view = storyboard?.instantiateViewController(withIdentifier: "chat") as! ChatViewController
        view.getTitle = friendList[indexPath.row].firstname!
        view.getFriID = friendList[indexPath.row].uid!
        //navigationController?.pushViewController(view, animated: true)
        self.present(view, animated: true, completion: nil)
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
