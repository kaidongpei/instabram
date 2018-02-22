//
//  ChatViewController.swift
//  instabram
//
//  Created by kaidong pei on 11/13/17.
//  Copyright © 2017 kaidong pei. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase


class ChatViewController: JSQMessagesViewController {

    @IBOutlet weak var navTitle: UINavigationBar!
    var getTitle = ""
    var getFriID = ""
    
    var friendObj: User?
    var currentUser = Auth.auth().currentUser?.uid
    var currentUserName: String = ""
    var messages:Array<ChatMessages> = []
    var chatMessagesArray : Array<ChatMessages> = []
    var ref: DatabaseReference?
    var get = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        print(getFriID)
        //getFriID = AppDelegate
        
    
        collectionView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0)

        navTitle.topItem?.title = getTitle
        ref = Database.database().reference()
        
        navTitle.backgroundColor = UIColor.clear
        navTitle.tintColor = UIColor.black
        navTitle.setBackgroundImage(UIImage(), for: .default)
        navTitle.shadowImage = UIImage()
        navTitle.isTranslucent = true
       // self.collectionView.setContentOffset(CGPoint(x: 0, y: 20), animated: true)
        
        
        senderId = currentUser
        senderDisplayName = currentUserName
        collectionView.backgroundView = UIImageView(image: UIImage(named: "backblur"))
        messages = getMessages()
        self.view.addSubview(navTitle)
        // Do any additional setup after loading the view.
    }
    

   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    @IBAction func back(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
       
    }
    func getMessages() -> [ChatMessages] {
        messages = []
        chatMessagesArray = []
        var convoKey: String = ""
        if getFriID < currentUser! {
            convoKey = getFriID + "" + currentUser!
        }else {
            convoKey = currentUser! + getFriID
        }
        ref?.child("conversations/\(convoKey)").queryOrderedByKey().observe(.value, with: { (snapshot) in
            self.messages = []
            self.chatMessagesArray = []
            guard let value = snapshot.value as? NSDictionary else {return}
            for item in value {
                let msgDict = item.value as? Dictionary<String,String>
                let msg =  JSQMessage(senderId: msgDict?["senderId"], displayName: msgDict?["displayName"], text: msgDict?["message"])
                let chatMsg = ChatMessages(msg: msg!, tStamp: Int(item.key as! String)!)
                
                self.messages.append(chatMsg)
            }
            self.chatMessagesArray = self.messages.sorted(by: { (obj1, obj2) -> Bool in
                
                let ts1 = obj1.timeStamp
                let ts2 = obj2.timeStamp
                
                return(ts1 < ts2)
            })
            print(self.chatMessagesArray.count)
            //print(self.messages)
            self.collectionView.reloadData()
            
        })
        self.collectionView.reloadData()
        return messages
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("here \(messages.count)")
        return chatMessagesArray.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        
        let message = chatMessagesArray[indexPath.row].message
        
        if currentUser == message.senderId {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: .white)
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: .gray)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
            as! JSQMessagesCollectionViewCell
        let message = chatMessagesArray[indexPath.row].message
        if currentUser == message.senderId {
            cell.textView!.textColor = UIColor.black
        } else {
            cell.textView!.textColor = UIColor.white
        }
        return cell
        
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        scrollToBottom(animated: true)
        let message = chatMessagesArray[indexPath.row].message
        let messageUsername = message.senderDisplayName
        
        return NSAttributedString(string: messageUsername!)
    }
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 15
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return chatMessagesArray[indexPath.row].message
    }
    

    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text)
        
        //messages.append(message!)
        
        let timestamp = Int(Date().timeIntervalSince1970)
        let convo = ["senderId": message?.senderId!, "displayName": message?.senderDisplayName!, "message": message?.text!]
        var conversationKey: String = ""
        if getFriID < currentUser! {
            conversationKey = getFriID + "" + currentUser!
        }else {
            conversationKey = currentUser! + getFriID
        }
        let childUpdates = ["/conversations/\(conversationKey)/\(timestamp)": convo]
        ref?.updateChildValues(childUpdates)
        let chMsg = ChatMessages(msg: message!, tStamp: timestamp)
        chatMessagesArray.append(chMsg)
        let notificationKey = ref?.child("notificationRequests").childByAutoId().key
        let notification = ["message" : message?.text! , "username": getFriID, "sender": senderId] as? [String: String]
       
        let notifyUpdates = ["/notificationRequests/\(notificationKey!)": notification!]
        ref?.updateChildValues(notifyUpdates)
        finishSendingMessage()
        
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
