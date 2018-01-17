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
        //Create a new geometry for the sun
        let sun = SCNNode(geometry: SCNSphere(radius: 0.35))

        //Set the node's properties
        //Sun
        sun.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "Sun")
        sun.position = SCNVector3(0,0,-1)
        
        //Add the node to the scene view
        //Sun
        self.sceneView.scene.rootNode.addChildNode(sun)
        
        //Create the rest of the planets
        let earth = planet(geometry: SCNSphere(radius: 0.2), diffuse: #imageLiteral(resourceName: "Earth day"), specular: #imageLiteral(resourceName: "Earth specular"), emission: #imageLiteral(resourceName: "Earth emission"), normal: #imageLiteral(resourceName: "Earth normal"), position: SCNVector3(1.2,0,0))
        let venus = planet(geometry: SCNSphere(radius: 0.1), diffuse: #imageLiteral(resourceName: "Venus surface"), specular: nil, emission: #imageLiteral(resourceName: "Venus atmosphere"), normal: nil, position: SCNVector3(0.7,0,0))
        
        //Add the planets relative to the sun
        sun.addChildNode(earth)
        sun.addChildNode(venus)
        
        //Create rotation animations
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(360.degressToRadians), z: 0, duration: 8)
        let forever = SCNAction.repeatForever(action)
        sun.runAction(forever)
        
    }
    
    func planet(geometry: SCNGeometry, diffuse: UIImage, specular: UIImage?, emission: UIImage?, normal: UIImage?, position: SCNVector3) -> SCNNode {
        let planet = SCNNode(geometry: geometry)
        planet.geometry?.firstMaterial?.diffuse.contents = diffuse
        planet.geometry?.firstMaterial?.specular.contents = specular
        planet.geometry?.firstMaterial?.emission.contents = emission
        planet.geometry?.firstMaterial?.normal.contents = normal
        planet.position = position
        
        return planet
    }

}

extension Int {
    var degressToRadians: Double { return Double(self) * .pi/180}
}

