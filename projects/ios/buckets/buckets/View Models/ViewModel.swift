//
//  ViewModel.swift
//  buckets
//
//  Created by Muhand Jumah on 4/13/18.
//  Copyright © 2018 Muhand Jumah. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewModel: NSObject {
//    var usersClient: UsersClient!
    var users: JSON?
    
    func fetchUsers(completion: @escaping () -> () ) {
        NetworkService.standard.request(target: .users, success: { (data) in
            self.users = JSON(data as Any)
            completion()
        }, error: { (error) in
            print(error)
        }) { (failure) in
            print(failure)
        }
    }
    func numberOfItemsInSection(section: Int) -> Int {
        return users?.count ?? 0
    }
    
    func titleForItemAtIndexPath(indexPath: IndexPath) -> String {
        let user = JSON(self.users![indexPath.row])
        return ((user["first_name"]).stringValue + "    " + (user["last_name"]).stringValue)
    }
    
    func userForItemAtIndexPath(indexPath: IndexPath) -> Helper.User {
        let userJSON = JSON(self.users![indexPath.row])
        let id = userJSON["_id"].stringValue
        let location = userJSON["location"].arrayValue.map({ $0.floatValue })
        let phone_number = userJSON["phone_number"].stringValue
        let country_code = userJSON["country_code"].intValue
        let first_name = userJSON["first_name"].stringValue
        let last_name = userJSON["last_name"].stringValue
        let __v = userJSON["__v"].stringValue
        let createdAt = userJSON["createdAt"].stringValue
        let lastTimeLocationUpdated = userJSON["lastTimeLocationUpdated"].stringValue
        let sceneId = userJSON["sceneId"].stringValue
        let nonAppUsers = userJSON["nonAppUsers"].arrayValue.map({ $0.stringValue })
        let friends = userJSON["friends"].arrayValue.map({ $0.stringValue })
        let voipToken = userJSON["voipToken"].stringValue
        let crashing = userJSON["crashing"].arrayValue.map({ $0.stringValue })
        let loginSecret = userJSON["loginSecret"].stringValue
        let loginToken = userJSON["loginToken"].stringValue
        
        let user =  Helper.User(id: id, location: location, phone_number: phone_number, country_code: country_code,
                    first_name: first_name, last_name: last_name, __v: __v, createdAt: createdAt,
                    lastTimeLocationUpdated: lastTimeLocationUpdated, sceneId: sceneId,
                    nonAppUsers: nonAppUsers, friends: friends, voipToken: voipToken, crashing: crashing,
                    loginSecret: loginSecret, loginToken: loginToken)
        
        return user
    }
    
}
