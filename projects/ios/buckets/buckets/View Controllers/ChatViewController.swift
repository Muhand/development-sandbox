//
//  ChatViewController.swift
//  buckets
//
//  Created by Muhand Jumah on 4/16/18.
//  Copyright © 2018 Muhand Jumah. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                print("BEFORE SHOW \(self.view.frame.origin.y)")
                self.view.frame.origin.y -= 333
                print("AFTER SHOW \(self.view.frame.origin.y)")
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                print("BEFORE HIDE \(self.view.frame.origin.y)")
                self.view.frame.origin.y = 0
                print("AFTER HIDE \(self.view.frame.origin.y)")
            }
        }
    }

}
