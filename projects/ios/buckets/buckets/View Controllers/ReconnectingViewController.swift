//
//  ReconnectingViewController.swift
//  buckets
//
//  Created by Muhand Jumah on 4/14/18.
//  Copyright © 2018 Muhand Jumah. All rights reserved.
//

import UIKit
import SocketIO

class ReconnectingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        
        Helper.socket.on(clientEvent: .connect) { (ack, data) in
            self.navigationController?.popViewController(animated: true)
        }
        
        Helper.socket.on(clientEvent: .disconnect) { (ack, data) in
            print("Disconnected")
            self.navigationController?.popToRootViewController(animated: true)
        }
        
//        Helper.socket.on(clientEvent: .error) { (ack, data) in
//            print("error")
//            self.navigationController?.popToRootViewController(animated: true)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
