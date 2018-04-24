//
//  NewMessageTableViewCell.swift
//  buckets
//
//  Created by Muhand Jumah on 4/17/18.
//  Copyright © 2018 Muhand Jumah. All rights reserved.
//

import UIKit
import SwiftyAWS

class NewMessageTableViewCell: UITableViewCell, UIImageDelegate {
    //////////////////////////////
    //Global variables
    //////////////////////////////
    var message: Message?
    
    //////////////////////////////
    //Outlets variables
    //////////////////////////////
    @IBOutlet weak private var messageLabel: UILabel!
    @IBOutlet weak private var messageBackground: UIView!
    @IBOutlet var imageViewOutlet: UIImageView!
    @IBOutlet var activityIndicatorOutlet: UIActivityIndicatorView!
    
    
    //////////////////////////////
    //Constraints
    //////////////////////////////
    @IBOutlet private var leftConstraint: NSLayoutConstraint!
    @IBOutlet private var rightConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setMessage(image:UIImage? = nil, newMessage: Message) {
        self.message = newMessage
        self.messageLabel.text = newMessage.textMessage
        self.messageLabel.textColor = UIColor(hexString: "#000000")
        if let image = image {
            image.delegate = self
            print("x----------------------------x")
            self.imageViewOutlet.image = image
        } else {
            self.activityIndicatorOutlet.removeFromSuperview()
            self.imageViewOutlet.removeFromSuperview()
            self.messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        }
        if(newMessage.isMe) {
            self.messageLabel.textAlignment = .right
            self.messageBackground.backgroundColor = UIColor(hexString: "#D7F7C0")
            self.leftConstraint.isActive = false
            self.rightConstraint.isActive = true
        } else {
            self.messageLabel.textAlignment = .left
            self.messageBackground.backgroundColor = UIColor(hexString: "#FAFAFA")
            self.leftConstraint.isActive = true
            self.rightConstraint.isActive = false
        }
    }
    
    //////////////////////////////////////
    // Conform to protocols
    //////////////////////////////////////
    func highResImageIsDownloading() {
        print("Downloading...")
    }
    func highResImageDownloaded(image:UIImage) {
        print("Downloaded successfully")
        self.activityIndicatorOutlet.removeFromSuperview()
        self.imageViewOutlet.image = image
    }
    
    func failedToDownloadHighRes(error: ErrorHandling) {
        print("There was an error")
    }
    
}
