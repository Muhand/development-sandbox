//
//  ImageExtension.swift
//  buckets
//
//  Created by Muhand Jumah on 4/21/18.
//  Copyright © 2018 Muhand Jumah. All rights reserved.
//

import Foundation
import UIKit
import SwiftyAWS

protocol UIImageDelegate {
    func highResImageDownloaded(image:UIImage)
    func failedToDownloadHighRes(error:ErrorHandling)

}

fileprivate var highResPath:String?
fileprivate var imageDelegate:UIImageDelegate?

extension UIImage {
    var highResImagePath: String {
        set {
            print("GOT HIGH RES!")
            highResPath = newValue
            downloadHighResImage()
        }
        get {
            guard let x = highResPath else {return "" }
            return x
//            return highResPath!
        }
    }
    
    var delegate: UIImageDelegate {
        set {
            print("SET DELEGATE To")
            print(newValue)
            imageDelegate = newValue
        }
        get {
            return imageDelegate!
        }
    }

    func downloadHighResImage() {
        if (imageDelegate != nil) {
            setUpAWS()
//            print("WORKSSSS")
//            if let dotRange = highResImagePath.range(of: ".") {
//                highResImagePath.removeSubrange(dotRange.lowerBound..<str.endIndex)
//            }
            
//            if let dotRange = highResImagePath.range(of: ".") {
//                highResImagePath.removeSubrange(dotRange.lowerBound..<highResImagePath.endIndex)
//            }
//
//            var truncated = highResImagePath.removeSubrange.substring(to: highResImagePath.removeSubrange.index(before: highResImagePath.removeSubrange.endIndex-4))

            if highResImagePath.count > 1 {
                let endIndex = highResImagePath.index(highResImagePath.endIndex, offsetBy: -5)
                let truncated = highResImagePath.substring(to: endIndex)
                
                
                truncated.s3.download(imageExtension: .jpeg) { (image, path, error) in
                    if (error == nil) {
                        self.delegate.highResImageDownloaded(image: image!)
                    } else {
                        print(error)
                        self.delegate.failedToDownloadHighRes(error: error!)
                    }
                }
            }
        }
    }
    
    private func setUpAWS() {
        SwiftyAWS.main.bucketName = "crash-chat"
        SwiftyAWS.main.configure(type: .USEast1, identity: "us-east-1:6a386b3c-11f5-4fba-b427-2cf6b9a00cf1")
    }
    
    
}
