//
//  ViewModel.swift
//  buckets
//
//  Created by Muhand Jumah on 4/13/18.
//  Copyright © 2018 Muhand Jumah. All rights reserved.
//

import UIKit

class ViewModel: NSObject {
    var usersClient: UsersClient!
    var users: [NSDictionary]?
    
    func fetchUsers(completion: () -> () ) {
        UsersClient.fetchUsers { users in
            self.users = users
        }
    }
    func numberOfItemsInSection(section: Int) -> Int {
        return 10
    }
    
    func titleForItemAtIndexPath(indexPath: IndexPath) -> String {
        return "Test2"
    }
    
}
