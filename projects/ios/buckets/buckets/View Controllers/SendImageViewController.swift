//
//  SendImageViewController.swift
//  buckets
//
//  Created by Muhand Jumah on 4/18/18.
//  Copyright © 2018 Muhand Jumah. All rights reserved.
//

import UIKit
import SwiftyAWS

protocol SendImageDelegate: class {
    func uploadingImage(message: Message)
    func imageUploaded()
    func imageFailedToUpload(error: ErrorHandling)
}

class SendImageViewController: UIViewController {
    
    weak var delegate:SendImageDelegate?
    
    var chosenImage: UIImage? {
        didSet {
        }
    }
    @IBOutlet var chosenImageView: UIImageView!
    @IBOutlet var chosenImageCaption: UITextField!
    @IBOutlet var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet var imageCaptionLabel: UITextField!
    
    
    @IBAction func sendChosenImageAction(_ sender: Any) {
        if let pickedImage = chosenImageView.image {
            
            let textMessage = self.imageCaptionLabel.text ?? ""
            let m = Message(text: textMessage, image: pickedImage, isMe: true)
            
            delegate?.uploadingImage(message:m)
            
            pickedImage.s3.upload(type: .jpeg, name: .efficient, permission: .publicReadWrite) { (path, key, error) in
                if error == nil {
                    self.delegate?.imageUploaded()
                    
                    let newSize = CGSize(width: 220, height: 260)
                    let f = self.resizeImage(image: pickedImage, targetSize: newSize)
                    
                    let imageData = UIImagePNGRepresentation(f)
                    let base64encoding = imageData?.base64EncodedString(options: .lineLength64Characters)
                    
                    //Send the selected image to the socket with its caption
                    let messageObject: [String: Any] = [
                        "img": base64encoding!,
                        "caption": self.chosenImageCaption.text!,
                        "sceneId": Helper.selectedSceneID!,
                        "highres": key!
                    ]
                    
                    Helper.socket.emit("newImage", messageObject)
                    
                } else {
                    self.delegate?.imageFailedToUpload(error: error!)
                }
            }
        }
        
        //Dismiss the view
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelChosenImageAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAWS()
        self.hideKeyboardWhenTappedAround()
        
        if chosenImage != nil {
            setImageView()
        }
        
        self.navigationController?.navigationBar.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func setImageView() {
        chosenImageView.image = chosenImage
    }
    
    private func setUpAWS() {
        SwiftyAWS.main.bucketName = "crash-chat"
        SwiftyAWS.main.configure(type: .USEast1, identity: "us-east-1:6a386b3c-11f5-4fba-b427-2cf6b9a00cf1")
    }
    
    //////////////////////////////////////////////////////////////
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x:0, y:0, width:newSize.width, height:newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size {
            if self.bottomViewConstraint.constant == 0 {
                UIView.animate(withDuration: 0.5) {
                    self.bottomViewConstraint.constant -= 330
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size {
            if self.bottomViewConstraint.constant != 0 {
                UIView.animate(withDuration: 0.5) {
                    self.bottomViewConstraint.constant = 0
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
}
