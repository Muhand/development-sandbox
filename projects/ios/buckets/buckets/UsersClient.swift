//
//  UsersClient.swift
//  buckets
//
//  Created by Muhand Jumah on 4/13/18.
//  Copyright © 2018 Muhand Jumah. All rights reserved.
//

import UIKit
import Moya

struct NetworkManager {
    fileprivate let provider =
}

class UsersClient: NSObject {
    func fetchUsers(completion: ([NSDictionary]?) -> ()) {
        // Fetch the users
        let session = NSURLsession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        // Call the completion block
    }
}
