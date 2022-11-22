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
            
            let plan = SCNPlane(width: CGFloat(planAnchor.planeExtent.width), height: CGFloat(planAnchor.planeExtent.height))
            
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

            let result = sceneView.raycastQuery(from: touchLocation, allowing: .existingPlaneInfinite, alignment: .horizontal)
            
            if let hitLoc = result {
                addDiceNode(hitLoc.direction.x,hitLoc.direction.y,hitLoc.direction.z)
            }
        }
    }
    
    
    func addDiceNode(_ x:Float,_ y:Float,_ z:Float){
        let diceScene = SCNScene(named: "art.scnassets/dice.scn")
        
        if let diceNode = diceScene?.rootNode.childNode(withName: "Dice", recursively: true) {
            diceNode.position = SCNVector3(x,y,z)
            
            sceneView.scene.rootNode.addChildNode(diceNode)
            
            rotateDiceAnimation(diceNode: diceNode)
        }
    }
    
    func rotateDiceAnimation(diceNode: SCNNode) {
        let rotateX = Float(arc4random_uniform(4)+1) * (Float.pi/2)
        let rotateZ = Float(arc4random_uniform(4)+1) * (Float.pi/2)
        
        let action = SCNAction.rotateBy(x: CGFloat(rotateX), y: 0, z: CGFloat(rotateZ), duration: 0.5)
        
        diceNode.runAction(action)
    }
}
