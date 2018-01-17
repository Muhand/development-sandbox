//
//  ViewController.swift
//  planets
//
//  Created by Muhand Jumah on 1/15/18.
//  Copyright © 2018 Muhand Jumah. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var sceneView: ARSCNView!
    
    //Constants
    let configuration = ARWorldTrackingConfiguration()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initSceneview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initSceneview() -> Void {
//        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.showsStatistics = true
        self.sceneView.session.run(configuration)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Create a new geometry node
        let earth = SCNNode(geometry: SCNSphere(radius: 0.2))
        
        //Set the node's properties
        earth.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "Earth day")
        earth.geometry?.firstMaterial?.specular.contents = #imageLiteral(resourceName: "Earth specular")
        earth.geometry?.firstMaterial?.normal.contents = #imageLiteral(resourceName: "Earth normal")
        earth.geometry?.firstMaterial?.emission.contents = #imageLiteral(resourceName: "Earth emission")
        earth.position = SCNVector3(0,0, -1)
        
        //Add the node to the scene view
        self.sceneView.scene.rootNode.addChildNode(earth)
        
        //Create rotation animations
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(360.degressToRadians), z: 0, duration: 8)
        let forever = SCNAction.repeatForever(action)
        earth.runAction(forever)
    }

}

extension Int {
    var degressToRadians: Double { return Double(self) * .pi/180}
}

