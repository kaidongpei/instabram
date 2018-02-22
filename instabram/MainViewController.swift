//
//  MainViewController.swift
//  instabram
//
//  Created by kaidong pei on 11/7/17.
//  Copyright © 2017 kaidong pei. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tb: UITableView!
    var postList: [Post] = []
    //var userList: [User] = []
    var post: Post?
    var ref : DatabaseReference?
    var storageRef : StorageReference?
    var postsLikedArr: [String] = []
    var postsArrSorted: [String] = []
    let userIDD = Auth.auth().currentUser?.uid
    
//    lazy var refreshControl: UIRefreshControl = {
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(MainViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
//
//        return refreshControl
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let currentUserId = Auth.auth().currentUser?.uid{
//            Messaging.messaging().subscribe(toTopic: currentUserId)
//        }
//        //getPublic()
//        ref = Database.database().reference()
//        storageRef = Storage.storage().reference()
//        getPostList()
//        self.tb.addSubview(self.refreshControl)
//
//        postsArrSorted = postsLikedArr.sorted()
//
//
//        getPublic()
        
        self.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.leftBarButtonItem = nil;
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton;
        setupNavigationWithColor(UIColor.black)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavigationWithColor(_ color: UIColor) {
        let font = UIFont.boldSystemFont(ofSize: 20);
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : color, NSAttributedStringKey.font : font as Any]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = color
        
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        self.postList.sort(by: {$0.postTime! > $1.postTime!})
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainTableViewCell
        
        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
        //let userID = Auth.auth().currentUser?.uid
        ref?.child("Users").child(postList[indexPath.row].userId!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            cell.name.text = value?["FirstName"] as? String ?? ""
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        if postsLikedArr.contains(postList[indexPath.row].postId!) == true{
            cell.likeBtn.setImage(UIImage(named: "like2"), for: .normal)
        } else {
             cell.likeBtn.setImage(UIImage(named: "like"), for: .normal)
        }

        cell.likeNum.text = String(describing: postList[indexPath.row].like)
        //cell.name.text = self.postList[indexPath.row].userId
        cell.postDes.text = postList[indexPath.row].desciption
        cell.likeNum.text = String(describing: postList[indexPath.row].like!)
        let id = postList[indexPath.row].postId
        let islandRef = storageRef?.child("PostImages/\(id!).jpg")
        
        islandRef?.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if error == nil{
                cell.postimg.image = UIImage(data: data!)
            }else{
                print(error?.localizedDescription)
                cell.postimg.image = UIImage(named: "pic")
                
            }
            
        }
        cell.likeBtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: #selector(likeBtnAction), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450
    }
    func getPostList(){
       // if let user = Auth.auth().currentUser{
            ref?.child("Post").observeSingleEvent(of: .value, with: { (snapShot) in
                for pos in snapShot.children {
                    
                    var postInfo: Post
                    postInfo = Post.init(withsnap: pos as! DataSnapshot)
                    self.postList.append(postInfo)
                }
                self.tb.reloadData()
            })
        }
    
   
//    func getUser(){
//        ref?.child("Users").observeSingleEvent(of: .value, with: { (snapShot) in
//            for pathTable in snapShot.children {
//                var userDe: User
//
//                userDe = User.init(withsnap: pathTable as! DataSnapshot)
//                self.userList.append(userDe)
//                //print(self.userList)
//                }
//            })
//            self.tb.reloadData()
//    }
//    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
//
//        postList = []
//        ref = Database.database().reference()
//        storageRef = Storage.storage().reference()
//        getPostList()
//        self.tb.reloadData()
//        refreshControl.endRefreshing()
//    }
    
    @objc func likeBtnAction(_ sender: UIButton) {
//       DispatchQueue.main.async {
//        self.getPostList()
//        self.postList = []
//            self.postsLikedArr = []
//            self.getPublic()
//        }
        
        let postsArrSorted = postList
        let postObj = postsArrSorted[sender.tag]
        if postsLikedArr.contains(postObj.postId!) == false {
            sender.setImage(UIImage(named: "like"), for: .normal)
            postsLikedArr.append(postObj.postId!)
            ref?.child("PublicUsers/\((userIDD)!)/postsLiked/\(postObj.postId!)").setValue(true)
            ref?.child("Post/\(postObj.postId!)/Like").observeSingleEvent(of: .value, with: { (snap) in
                var val = snap.value as? Int
                val = val! + 1
                self.ref?.child("Post/\(postObj.postId!)/Like").setValue(val)
            }) { (error) in
                print(error.localizedDescription)
            }
        }else {
            sender.setImage(UIImage(named: "like2"), for: .normal)
            let index = postsLikedArr.index(of: postObj.postId!)!
            postsLikedArr.remove(at: index)
            ref?.child("PublicUsers/\((userIDD)!)/postsLiked/\(postObj.postId!)").setValue(nil)
            ref?.child("Post/\(postObj.postId!)/Like").observeSingleEvent(of: .value, with: { (snap) in
                var val = snap.value as? Int
                val = val! - 1
                self.ref?.child("Post/\(postObj.postId!)/Like").setValue(val)
            }) { (error) in
                print(error.localizedDescription)
            }
            
        }
//        DispatchQueue.main.async {
//        self.tb.reloadData()
//        }
    }
    
    func getPublic(){
        ref?.child("PublicUsers/\((userIDD)!)").observeSingleEvent(of: .value, with: { (snapShot) in
            guard let dict = snapShot.value as? [String:Any] else { return }
            
            guard let userLike = (dict["postsLiked"]) else{
                return }
            
            for i in userLike as! NSDictionary{
                let key = i.key
                self.postsLikedArr.append(key as! String)
                            }
        }
        )
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         postList = []
         postsLikedArr = []
         postsArrSorted = []
        if let currentUserId = Auth.auth().currentUser?.uid{
            Messaging.messaging().subscribe(toTopic: currentUserId)
        }
        //getPublic()
        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
        getPostList()
        //self.tb.addSubview(self.refreshControl)
        
        postsArrSorted = postsLikedArr.sorted()
        
        
        getPublic()

       
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
