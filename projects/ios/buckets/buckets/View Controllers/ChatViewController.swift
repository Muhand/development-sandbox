//
//  ChatViewController.swift
//  buckets
//
//  Created by Muhand Jumah on 4/16/18.
//  Copyright © 2018 Muhand Jumah. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftyAWS

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    ////////////////////////////
    // Variables
    ////////////////////////////
    var messages:[Message] = []
    struct TableViewCellIDS {
        static let newMessage = "newMessageID"
    }
    var imagePicker = UIImagePickerController()
    var chosenImage:UIImage?
    
    ////////////////////////////
    // Outlets
    ////////////////////////////
    @IBOutlet weak var textMessageField: UITextField!
    @IBOutlet weak var messagesTableView: UITableView!
    
    ////////////////////////////
    // Actions
    ////////////////////////////
    @IBAction func newMessageAction(_ sender: Any) {
        if (textMessageField.text != "") {
            let newMessage = Message(text: textMessageField.text!, isMe: true)
            sendMessage(message: newMessage)
        }
    }
    
    @IBAction func newImageAction(_ sender: Any) {
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setupTableView()
        
        let name = "\(Helper.loggedInUser?.first_name ?? "Firstname") \(Helper.loggedInUser?.last_name ?? "Lastname")"
        self.title = name
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        print("ORIGINAL \(self.view.frame.origin.y)")
        
        handleSocketEvents()
        let downloadChatObject: [String: Any] = [
            "sceneId": Helper.selectedSceneID
        ]
        
        Helper.socket.emit("downloadChat", downloadChatObject)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendMessage(message: Message) {
        insertMessage(message: message)
        
        //Now send the message through socket
        let messageObject: [String: Any] = [
            "text": message.textMessage!,
            "sceneId": Helper.selectedSceneID
        ]
        
        Helper.socket.emit("newMessage", messageObject)
    }
    

    func setupTableView() {
        self.messagesTableView.dataSource = self
        self.messagesTableView.delegate = self
        let messageNib = UINib(nibName: "NewMessageTableViewCell", bundle: nil)
        self.messagesTableView.register(messageNib, forCellReuseIdentifier: TableViewCellIDS.newMessage)
        self.messagesTableView.estimatedRowHeight = UITableViewAutomaticDimension
        self.messagesTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    ///////////////////////////////////
    // Conform to delegates
    ///////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIDS.newMessage, for: indexPath) as! NewMessageTableViewCell
        
        
        let newMessage = messages[indexPath.row]
        
        if (newMessage.imageMessage != nil) {
            cell.setMessage(image: newMessage.imageMessage, newMessage: messages[indexPath.row])
        } else {
            cell.setMessage(newMessage: messages[indexPath.row])
        }
        
        return cell
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//
////            let newSize = CGSize(width: 220, height: 260)
////            let f = resizeImage(image: pickedImage, targetSize: newSize)
//
////            let senderNameTmp = "Me"
////            let isMeTmp = true
////            let newMessage = ImageTextMessage(image: f, senderName: senderNameTmp, isMe: isMeTmp)
//
//            //Append the new message
////            messages.append(newMessage)
//
//            //Refresh the table
////            messagesTableView.reloadData()
//
////            let imageData = UIImagePNGRepresentation(f)
////            let base64encoding = imageData?.base64EncodedString(options: .lineLength64Characters)
//
////            Helper.socket.emit("new_image", base64encoding!)
//        }
        
        guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
        
        dismiss(animated: true, completion: nil)
        
        //Navigate to sendImageView
        guard let sendImage = self.storyboard?.instantiateViewController(withIdentifier: "sendImage") as? SendImageViewController else {return}
        
        sendImage.chosenImage = pickedImage
        sendImage.delegate = self
        self.navigationController?.pushViewController(sendImage, animated: true)
    }
    
    ///////////////////////////////////
    // Helper functions
    ///////////////////////////////////
    func handleSocketEvents() {
        Helper.socket.on("messageRecieved") { (data, ack) in
            let data = JSON(data.first as Any)
            let text = data["text"].stringValue
            let timestamp = data["timestamp"].stringValue
            
//            guard let decodedData = Data(base64Encoded: imageData, options: .ignoreUnknownCharacters),
//                let image = UIImage(data: decodedData)
//                else { return }
//
//            self.view?.addImage(image)
            
            let recievedMessage = Message(text: text, isMe: false)
            self.insertMessage(message: recievedMessage)
        }
        
        Helper.socket.on("imageReceived") { (data, ack) in
            let data = JSON(data.first as Any)
      
            let imgData = data["image"].stringValue
            guard let decodedData = Data(base64Encoded: imgData, options: .ignoreUnknownCharacters),
                let imagev = UIImage(data: decodedData)
                else { return }
            let caption = data["caption"].stringValue
            let timestamp = data["timestamp"].stringValue
            let highResPath = data["highres"].stringValue
            print("-----------------------------")
            print(highResPath)
            print("-----------------------------")
            imagev.highResImagePath = highResPath
            let recievedMessage = Message(text: caption, image: imagev, isMe: false)
            
            self.insertMessage(message: recievedMessage)
        }
        
        Helper.socket.on("chatHistory") { (data, ack) in
            let data = JSON(data.first as Any)
            print(data)
            for messageJSON in data["messages"].arrayValue {
                let text = messageJSON["text"].stringValue
                let timestamp = messageJSON["timestamp"].stringValue
                let by = messageJSON["by"].stringValue
                print(text)
                
                if by == Helper.loggedInUser?.id {
                    let recievedMessage = Message(text: text, isMe: true)
                    self.insertMessage(message: recievedMessage)
                } else {
                    let recievedMessage = Message(text: text, isMe: false)
                    self.insertMessage(message: recievedMessage)
                }
            }
            
//            let recievedMessage = Message(text: text, isMe: false)
//            self.insertMessage(message: recievedMessage)
        }
    }
    
    func insertMessage(message:Message) {
        messages.append(message)
        self.messagesTableView.beginUpdates()
        let indexPath:IndexPath = IndexPath(row:(self.messages.count - 1), section:0)
        self.messagesTableView.insertRows(at: [indexPath], with: .bottom)
        self.messagesTableView.endUpdates()
        self.messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: message.isMe)
        //        self.messagesTableView.reloadData()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size {
            if self.view.frame.origin.y == 0{
                print("BEFORE SHOW \(self.view.frame.origin.y)")
//                self.view.frame.origin.y -= keyboardSize.height
                self.view.frame.origin.y -= 330
                print("AFTER SHOW \(self.view.frame.origin.y)")
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size {
            if self.view.frame.origin.y != 0{
                print("BEFORE HIDE \(self.view.frame.origin.y)")
//                self.view.frame.origin.y -= keyboardSize.height
                self.view.frame.origin.y = 0
                print("AFTER HIDE \(self.view.frame.origin.y)")
            }
        }
    }
}


extension ChatViewController:SendImageDelegate {
    
    func imageUploaded() {
        
    }
    
    func uploadingImage(message: Message) {
        insertMessage(message: message)
    }
    
    func imageFailedToUpload(error: ErrorHandling) {
        
    }
    
//    func uploadingImage() {
//
//    }
//
//    func imageUploaded() {
//
//    }
//
//    func imageFailedToUpload(error: NSError) {
//
//    }
//
//    func imageSent(message: Message) {
////        sendMessage(message: message)
//        insertMessage(message: message)
//    }
    
    
}
