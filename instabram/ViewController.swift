//
//  ViewController.swift
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


class ViewController: BaseViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var naiv: UINavigationBar!
    @IBOutlet weak var text: UITextView!
    @IBOutlet weak var img: UIImageView!
    var post: Post?
    
    
    var ref :  DatabaseReference?
    var storageRef = StorageReference()
    var like = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // ref = Database.database().reference()
        storageRef = Storage.storage().reference()
        ref =  Database.database().reference().child("Post").childByAutoId()
       // text.addBorder()
//        //naiv.backgroundColor = UIColor.clear
//        naiv.tintColor = UIColor.black
//        naiv.setBackgroundImage(UIImage(), for: .default)
//        naiv.shadowImage = UIImage()
//        naiv.isTranslucent = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.black
    }
    
    @IBAction func imgPick(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(image, animated: true)
    }
    
    
    
    @IBAction func postBtn(_ sender: Any) {
        creatPost()
        uploadImage()
        self.dismiss(animated: true, completion: nil)
        
    }
    
   
    
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func  creatPost() {
        
        let timestamp = Double((Date().timeIntervalSince1970))
        
        let post = Post()
        post.postId = ref?.key
        let userId = Auth.auth().currentUser?.uid ?? ""
        
        let pathDict = ["Description" :  text.text,
                        "UserId":userId,
                        "Like": like,
                        "Timestamp": timestamp,
                        "PostId": post.postId!] as [String:Any]
        ref?.updateChildValues(pathDict, withCompletionBlock: { (error, ref) in Database.database().reference().child("Users").child(userId).child("Post").updateChildValues([ref.key : "id"])
       })
    }
    
    
    func uploadImage(){
        let post = Post()
        post.postId = ref?.key
        
            guard let img = img.image else { return  }
            let data = UIImageJPEGRepresentation(img, 0.8)
            let imgReference = storageRef.child("PostImages/\(String(describing: post.postId!)).jpg")
            
            _ = imgReference.putData(data!, metadata: nil) { (metadata, error) in
                if error == nil{
                    //print("uploaded")
                }else{
                    print(error as Any)
                }
            }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            img.image = image
        }
        else
        {
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

