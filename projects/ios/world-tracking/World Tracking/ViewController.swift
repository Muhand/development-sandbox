//
//  ViewController.swift
//  World Tracking
//
//  Created by Muhand Jumah on 1/12/18.
//  Copyright © 2018 Muhand Jumah. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func box(_ sender: Any) {
        let node = SCNNode()
        node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.03)
        node.geometry?.firstMaterial?.specular.contents = UIColor.white
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.green
        let x = randomNumbers(firstNum: -0.3, secondNum: 0.3)
        let y = randomNumbers(firstNum: -0.3, secondNum: 0.3)
        let z = randomNumbers(firstNum: -0.3, secondNum: 0.3)
        
        node.position = SCNVector3(x,y,z)
        self.sceneView.scene.rootNode.addChildNode(node)
        
    }
    @IBAction func home(_ sender: Any) {
        //Create nodes
        let houseWalls = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
        let attic = SCNNode(geometry: SCNPyramid(width: 0.1, height: 0.08, length: 0.1))
        let door = SCNNode(geometry: SCNPlane(width: 0.03, height: 0.06))
        
        //Start setting the nodes properties such as colors
        houseWalls.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        houseWalls.geometry?.firstMaterial?.specular.contents = UIColor.white
        attic.geometry?.firstMaterial?.diffuse.contents = UIColor.green
        attic.geometry?.firstMaterial?.specular.contents = UIColor.white
        door.geometry?.firstMaterial?.diffuse.contents = UIColor.brown
        door.geometry?.firstMaterial?.specular.contents = UIColor.white
        
        //Set the positioning
        houseWalls.position = SCNVector3(-0.2,-0.2,-0.2)
        attic.position = SCNVector3(0,0.05,0)
        door.position = SCNVector3(0,-0.02,0.052)
        
        //Add the nodes
        self.sceneView.scene.rootNode.addChildNode(houseWalls)
        houseWalls.addChildNode(attic)
        houseWalls.addChildNode(door)
        
        //Rotate the house
        houseWalls.eulerAngles = SCNVector3(0,Float(45.degreesToRadians),0)
    }
    
    @IBAction func reset(_ sender: Any) {
        self.restartSession()
    }
    
    func restartSession() {
        self.sceneView.session.pause()
        self.sceneView.scene.rootNode.enumerateChildNodes{ (node, _) in
            node.removeFromParentNode()
        }
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func randomNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
}
extension Int {
    
    var degreesToRadians: Double { return Double(self) * .pi/180}
}


