//
//  ViewController.swift
//  AR Scale
//
//  Created by Fiza Rasool on 21/06/19.
//  Copyright © 2019 Fiza Rasool. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var dotNodeArray = [SCNNode]()
    var textNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if dotNodeArray.count >= 2 {
            for dot in dotNodeArray {
                dot.removeFromParentNode()
            }
            dotNodeArray = [SCNNode]()
        }
        
        if let touchLocation = touches.first?.location(in: sceneView) {
            let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            if let hitResult = hitTestResults.first {
                addDot(at : hitResult)
            }
            
        }
    }
    
    func addDot(at hitResult : ARHitTestResult) {
        
        let dotGeometry = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        dotGeometry.materials = [material]
        let dotNode = SCNNode()
        dotNode.geometry = dotGeometry
        dotNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        dotNodeArray.append(dotNode)
        
        if dotNodeArray.count >= 2 {
            calculateDistance()
        }
    
    }
    
    func calculateDistance() {
        
        let start = dotNodeArray[0]
        let end = dotNodeArray[1]
        
        //distance = sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2)
        
        
        let distance = sqrt(
            pow(end.position.x - start.position.x, 2) +
            pow(end.position.y - start.position.y, 2) +
            pow(end.position.z - start.position.z, 2))
        
        showDistance(text : "\(distance)", atPosition : start.position)
        
    }
    
    func showDistance(text : String, atPosition position : SCNVector3) {
        
        textNode.removeFromParentNode()
        
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        
//        let material = SCNMaterial()
//        material.diffuse.contents = UIColor.red
//        textGeometry.materials = [material]
        
        textGeometry.firstMaterial?.diffuse.contents = UIColor.red
        
        textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3(position.x, position.y + 0.01, position.z)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        sceneView.scene.rootNode.addChildNode(textNode)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
 
}
