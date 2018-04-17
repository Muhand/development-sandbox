//
//  Message.swift
//  buckets
//
//  Created by Muhand Jumah on 4/17/18.
//  Copyright © 2018 Muhand Jumah. All rights reserved.
//

import Foundation
import UIKit

class Message {
    var textMessage:String?
    var imageMessage: UIImage?
    var isMe: Bool = false
    
    init(text:String, isMe: Bool) {
        self.textMessage = text
        self.isMe = isMe
    }
    
    init(text:String, image:UIImage, isMe: Bool) {
        self.textMessage = text
        self.imageMessage = image
        self.isMe = isMe
    }
}
