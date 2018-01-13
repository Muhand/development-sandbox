//
//  ViewController.swift
//  blank-project
//
//  Created by Muhand Jumah on 1/12/18.
//  Copyright © 2018 Muhand Jumah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
 
    @IBAction func increament(_ sender: Any) {
        
        self.label.text = String(Int(self.label.text!)!+1);
    } 
    
    @IBAction func decrement(_ sender: Any) {
        self.label.text = String(Int(self.label.text!)!-1);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    } 


}

