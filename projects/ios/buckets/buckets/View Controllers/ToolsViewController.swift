//
//  toolsViewController.swift
//  buckets
//
//  Created by Muhand Jumah on 4/14/18.
//  Copyright © 2018 Muhand Jumah. All rights reserved.
//

import UIKit
import SocketIO

class ToolsViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBAction func connectToChatAction(_ sender: Any) {
        if Helper.loggedInUser?.sceneId == "" && Helper.loggedInUser?.crashing.count == 0 {
            let alert = UIAlertController(title: "Information", message: "This user belongs to no scene, nor is he crashing any scene; therefore, a chat room can not be presented", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        } else {
            //Present all the available scenes to chat, my secene and crashed scenes
            guard let availableChat = self.storyboard?.instantiateViewController(withIdentifier: "availableChat") as? AvailableChatroomsViewController else {return}
            
            self.navigationController?.pushViewController(availableChat, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = "Welcome \(Helper.loggedInUser?.first_name ?? "test")"
        
        //Connect to the socket
        Helper.manager = SocketManager(socketURL: URL(string: Helper.server.serverEnv)!, config: [.log(false), .compress])
        Helper.socket = Helper.manager.defaultSocket
        Helper.socket.connect()
        Helper.socket.on(clientEvent: .connect) { (data, ack) in
            //Now authenticate
            let authentication: [String: Any] = [
                "security": Helper.loggedInUser?.loginToken
            ]
            
            Helper.socket.emit("authenticate", authentication)
        }
        
        Helper.socket.on(clientEvent: .disconnect) { (data, ack) in
            print("GOT DISCONNECTED")
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        Helper.socket.on(clientEvent: .reconnect) { (data, ack) in
            guard let reconnecting = self.storyboard?.instantiateViewController(withIdentifier: "reconnecting") as? ReconnectingViewController else {return}
            
            self.navigationController?.pushViewController(reconnecting, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
