//
//  ViewController.swift
//  ar-drawing
//
//  Created by Muhand Jumah on 1/15/18.
//  Copyright © 2018 Muhand Jumah. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    //Outlets
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var draw: UIButton!
    
    
    
    
    //Constants
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initSession()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        //Every frame this delegate will be called
        //Create a point of view variable (Point of view holds the location and rotation which are helpful for getting position and what are we looking at)
        guard let pointOfView = self.sceneView.pointOfView else {return}
        
        //This is a transform matrix inside pointOfView which holds the location and rotation in row and column format
        let transform = pointOfView.transform
        
        //Get the current location and orientation from the matrices
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        let position = SCNVector3(transform.m41, transform.m42, transform.m43)
        
        //Add both vectors to get the current camera's position
        let currentPositionOfCamera = orientation + position
        
        //Run everything on the main thread
        DispatchQueue.main.async {
            if self.draw.isHighlighted {
                //Create a new sphere
                let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
                
                //Set sphere properties
                sphereNode.position = currentPositionOfCamera
                sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                
                //Add the sphere to the scene view
                self.sceneView.scene.rootNode.addChildNode(sphereNode)
                
                print("Draw button is being pressed")
            } else {
                //Remove all old pointers
                self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
                    if(node.name == "pointer"){
                        node.removeFromParentNode()
                    }
                })
                
                //Create a new pointer to be a placeholder to where we will draw next
                let pointer = SCNNode(geometry: SCNSphere(radius: 0.01))
                pointer.name = "pointer"
                
                //Set the pointer properties
                pointer.position = currentPositionOfCamera
                pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                
                //Add the sphere to the scene view
                self.sceneView.scene.rootNode.addChildNode(pointer)
            }
        }
        
    }

    func initSession() -> Void {
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.showsStatistics = true
        self.sceneView.session.run(configuration)
        self.sceneView.delegate = self
    }

}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3(left.x + right.x,
                      left.y + right.y,
                      left.z + right.z)
}
