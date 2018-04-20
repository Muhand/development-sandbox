//
//  NewMessageTableViewCell.swift
//  buckets
//
//  Created by Muhand Jumah on 4/17/18.
//  Copyright © 2018 Muhand Jumah. All rights reserved.
//

import UIKit

class NewMessageTableViewCell: UITableViewCell {
    //////////////////////////////
    //Global variables
    //////////////////////////////
    var message: Message?
    var imageValue: UIImage?
    
    //////////////////////////////
    //Outlets variables
    //////////////////////////////
    @IBOutlet weak private var messageLabel: UILabel!
    @IBOutlet weak private var messageBackground: UIView!
    @IBOutlet var imageViewOutlet: UIImageView!
    
    
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
            self.imageValue = image
            self.imageViewOutlet.image = self.imageValue
        } else {
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
    
    
}
