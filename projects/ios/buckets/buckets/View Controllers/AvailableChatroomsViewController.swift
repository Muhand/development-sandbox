//
//  AvailableChatroomsViewController.swift
//  buckets
//
//  Created by Muhand Jumah on 4/18/18.
//  Copyright © 2018 Muhand Jumah. All rights reserved.
//

import UIKit

class AvailableChatroomsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var scenesTableView: UITableView!
    var scenes:[String]=[]
    struct TableViewCellIDS {
        static let room = "roomID"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        if Helper.loggedInUser?.sceneId != "" {
            scenes.append((Helper.loggedInUser?.sceneId)!)
        } else {
            if (Helper.loggedInUser?.crashing.count)! > 0 {
                for crashedScene in (Helper.loggedInUser?.crashing)! {
                    scenes.append(crashedScene)
                }
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTableView() {
        self.scenesTableView.dataSource = self
        self.scenesTableView.delegate = self
        let roomNib = UINib(nibName: "RoomTableViewCell", bundle: nil)
        self.scenesTableView.register(roomNib, forCellReuseIdentifier: TableViewCellIDS.room)
    }

    //////////////////////////////////
    // Conform to protocols
    //////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scenes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIDS.room, for: indexPath) as! RoomTableViewCell
        
        if (Helper.loggedInUser?.sceneId != "" && indexPath.row == 0) {
            cell.textLabel?.text = "\(scenes[indexPath.row]) - my scene"
        } else {
            cell.textLabel?.text = scenes[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Helper.selectedSceneID = scenes[indexPath.row]
        
        guard let chat = self.storyboard?.instantiateViewController(withIdentifier: "chat") as? ChatViewController else {return}
        
        self.navigationController?.pushViewController(chat, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }

}
