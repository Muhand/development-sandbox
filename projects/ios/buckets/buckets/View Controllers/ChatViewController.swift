//
//  ChatViewController.swift
//  buckets
//
//  Created by Muhand Jumah on 4/16/18.
//  Copyright © 2018 Muhand Jumah. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    ////////////////////////////
    // Variables
    ////////////////////////////
    var messages:[Message] = []
    struct TableViewCellIDS {
        static let newMessage = "newMessageID"
    }
    
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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendMessage(message: Message) {
        
        messages.append(message)
        self.messagesTableView.beginUpdates()
        let indexPath:IndexPath = IndexPath(row:(self.messages.count - 1), section:0)
        self.messagesTableView.insertRows(at: [indexPath], with: .bottom)
        self.messagesTableView.endUpdates()
        self.messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//        self.messagesTableView.reloadData()
        
        
        //Now send the message through socket
        Helper.socket.emit("new_message", message.textMessage!)
    }

    func setupTableView() {
        self.messagesTableView.dataSource = self
        self.messagesTableView.delegate = self
        let messageNib = UINib(nibName: "NewMessageTableViewCell", bundle: nil)
        self.messagesTableView.register(messageNib, forCellReuseIdentifier: TableViewCellIDS.newMessage)
    }
    
    ///////////////////////////////////
    // Conform to delegates
    ///////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(messages.count)
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIDS.newMessage, for: indexPath) as! NewMessageTableViewCell
        
        cell.setMessage(newMessage: messages[indexPath.row])
        
        return cell
    }
    
    ///////////////////////////////////
    // Helper functions
    ///////////////////////////////////
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
