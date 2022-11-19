//
//  ViewController.swift
//  ARDicee
//
//  Created by Sourav Singh Rawat on 18/11/22.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            let planAnchor = anchor as! ARPlaneAnchor
            
            let planNode = SCNNode()
            planNode.position = SCNVector3(planAnchor.center.x, 0, planAnchor.center.z)
            planNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            let plan = SCNPlane(width: CGFloat(planAnchor.extent.x), height: CGFloat(planAnchor.extent.z))
            
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            
            plan.materials = [gridMaterial]
            
            planNode.geometry = plan
            
            node.addChildNode(planNode)
            
//            let diceScene = SCNScene(named: "art.scnassets/dice.scn")!
//
//            if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
//
//                diceNode.position = SCNVector3(0, 0, -0.5)
//
//                // Set the scene to the view
//                planNode.addChildNode(diceNode)
//
//                node.addChildNode(planNode)
//            }
        } else {
            return
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touche = touches.first {
            let touchLocation  = touche.location(in: sceneView)
            
            let result = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if !result.isEmpty {
                print("Touched inside")
            }else {
                print("Touched outside")
            }
        }
    }
    
    private func createNewScene() {
        // Create a new scene
        
    }
}
