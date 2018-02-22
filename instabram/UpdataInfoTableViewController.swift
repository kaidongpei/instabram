//
//  UpdataInfoTableViewController.swift
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
import SWMessages

class UpdataInfoTableViewController: UITableViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var ref :  DatabaseReference?
    var storageRef = StorageReference()
    @IBOutlet var tb: UITableView!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var city: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getInfo()
        
        title = "USER INFO"
        self.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.leftBarButtonItem = nil;
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton;
        setupNavigationWithColor(UIColor.black)
        
        tb.backgroundView = UIImageView(image: UIImage(named:  "backblur"))
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func getInfo(){
        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
        let userID = Auth.auth().currentUser?.uid
        ref?.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.fname.text = value?["FirstName"] as? String ?? ""
            self.lname.text = value?["LastName"] as? String ?? ""
            self.city.text = value?["City"] as? String ?? ""
            self.getImage(uid: userID!)
        }) { (error) in
            print(error.localizedDescription)
        }
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return 1
        } else {
            return 4
        }
    }
    func getImage(uid:String) {
        let islandRef = storageRef.child("UserImages/\(String(describing: uid)).jpg")
        islandRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if error == nil{
                self.userImage.image = UIImage(data: data!)
            }else{
                print(error!)
                self.userImage.image = UIImage(named: "people-1")
                
            }
            
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
           userImage.image = image
        }
        else
        {
        }
        self.dismiss(animated: true, completion: nil)
    }
    func uploadImage(){
        SWMessage.sharedInstance.showNotificationWithTitle("User Inforamtion Updataed", subtitle: "UPDATAED", type: .success)
        if let user = Auth.auth().currentUser {
            guard let img = userImage.image else { return  }
            let data = UIImageJPEGRepresentation(img, 0.8)
            let imgReference = storageRef.child("UserImages/\(String(describing: user.uid)).jpg")
            
            _ = imgReference.putData(data!, metadata: nil) { (metadata, error) in
                if error == nil{
                    SWMessage.sharedInstance.showNotificationWithTitle("User Inforamtion Updataed", subtitle: "UPDATAED", type: .success)
                }else{
                    print(error!)
                }
           }
        }
    }
    @IBAction func imagePick(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(image, animated: true)
    }
    
    @IBAction func submit(_ sender: Any) {
      
        if let user = Auth.auth().currentUser {
         
            if let useid:Any = user.uid{
                
               let userDict = ["FirstName": fname.text,
                                "LastName" : lname.text,
                                "City": city.text]
                ref?.child("Users").child(user.uid).updateChildValues(userDict, withCompletionBlock: { (error, dataBaseRef) in
                    
                    
                })
                
                uploadImage()
                
            }
//            //self.dismiss(animated: true, completion: nil)
//            SWMessage.sharedInstance.showNotificationWithTitle("User Inforamtion Updataed", subtitle: "UPDATAED", type: .success)
        }
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
