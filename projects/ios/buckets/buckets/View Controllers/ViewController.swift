//
//  ViewController.swift
//  buckets
//
//  Created by Muhand Jumah on 4/12/18.
//  Copyright © 2018 Muhand Jumah. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var selectedUser:Helper.User? = nil
    
    
    @IBOutlet var viewModel: ViewModel!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func loginAction(_ sender: Any) {
        if (selectedUser == nil) {
            let alert = UIAlertController(title: "Error", message: "You need to select your user", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        } else {
            NetworkService.standard.request(target: .world(security: (selectedUser?.loginToken)!), success: { (data) in
                
                Helper.loggedInUser = self.selectedUser!
                let worldJSON = JSON(data)
                let id = worldJSON["_id"].stringValue
                let first_name = worldJSON["first_name"].stringValue
                let last_name = worldJSON["last_name"].stringValue
                let phone_number = worldJSON["phone_number"].stringValue
                let country_code = worldJSON["country_code"].intValue
                let sceneId = worldJSON["sceneId"].stringValue
                
                let arrayOfFriends = worldJSON["friends"].arrayValue
                var friends = [Helper.Friend]()
                
                for friendJSON in arrayOfFriends {
                    
                    
                    let friend_id = friendJSON["_id"].stringValue
                    let friend_phone_number = friendJSON["phone_number"].stringValue
                    let friend_country_code = friendJSON["country_code"].intValue
                    let friend_first_name = friendJSON["first_name"].stringValue
                    let friend_last_name = friendJSON["last_name"].stringValue
                    let friend_sceneId = friendJSON["sceneId"].stringValue
                    
                    let friend = Helper.Friend(id: friend_id, phone_number: friend_phone_number, country_code: friend_country_code, first_name: friend_first_name, last_name: friend_last_name, sceneId: friend_sceneId)
                    
                    friends.append(friend)
                    
                }
                
                let world = Helper.World(id: id, first_name: first_name, last_name: last_name, phone_number: phone_number, country_code: country_code, sceneId: sceneId, friends: friends)
                
                Helper.downloadedWorld = world
                
                guard let tools = self.storyboard?.instantiateViewController(withIdentifier: "tools") as? ToolsViewController else {return}
                
                self.navigationController?.pushViewController(tools, animated: true)
                


                
            }, error: { (error) in
                print(error)
            }) { (failure) in
                print(failure)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        viewModel.fetchUsers {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (Helper.socket != nil && Helper.socket.status == .connected) {
            print(Helper.socket.status)
            Helper.socket.disconnect()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //////////////////////////////
    // Conform to protocols
    //////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        configureCell(cell: cell, forRowAtIndexPath: indexPath)
        
        return cell 
    }
    
    func configureCell(cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {
        cell.textLabel?.text = viewModel.titleForItemAtIndexPath(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUser = viewModel.userForItemAtIndexPath(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedUser = nil
    }
}

