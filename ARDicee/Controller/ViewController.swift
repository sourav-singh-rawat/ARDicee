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
    
    var diceNodes = [SCNNode]()
    
    //MARK: - Life Cycle Methods
    
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
    
    //MARK: - ARSCNViewDelegate Methods
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let planAnchor = anchor as? ARPlaneAnchor else {return}
        
        let planNode = createPlan(withPlanAnchor: planAnchor)
        
        node.addChildNode(planNode)
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
    
    //MARK: - Plan Methods
    
    func createPlan(withPlanAnchor planAnchor:ARPlaneAnchor) -> SCNNode {
        let planNode = SCNNode()
        planNode.position = SCNVector3(planAnchor.center.x, 0, planAnchor.center.z)
        planNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
        
        let plan = SCNPlane(width: CGFloat(planAnchor.planeExtent.width), height: CGFloat(planAnchor.planeExtent.height))
        
        let gridMaterial = SCNMaterial()
        gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
        
        plan.materials = [gridMaterial]
        
        planNode.geometry = plan
        
        return planNode
    }
    
    //MARK: - Dice Methods
    
    func addDiceNode(_ x:Float,_ y:Float,_ z:Float){
        let diceScene = SCNScene(named: "art.scnassets/dice.scn")
        
        if let diceNode = diceScene?.rootNode.childNode(withName: "Dice", recursively: true) {
            diceNode.position = SCNVector3(x,y,z)
            
            sceneView.scene.rootNode.addChildNode(diceNode)
            
            rotateDiceAnimation(dice: diceNode)
            
            diceNodes.append(diceNode)
        }
    }
    
    func rotateDiceAnimation(dice: SCNNode) {
        let rotateX = Float(arc4random_uniform(4)+1) * (Float.pi/2)
        let rotateZ = Float(arc4random_uniform(4)+1) * (Float.pi/2)
        
        let action = SCNAction.rotateBy(x: CGFloat(rotateX * 5), y: 0, z: CGFloat(rotateZ * 5), duration: 0.5)
        
        dice.runAction(action)
    }
    
    func rollAll() {
        if !diceNodes.isEmpty {
            for dice in diceNodes {
                rotateDiceAnimation(dice: dice)
            }
        }
    }
    
    @IBAction func rollAgain(_ sender: UIBarButtonItem) {
        rollAll()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAll()
    }
    
    @IBAction func onTrashPressed(_ sender: UIBarButtonItem) {
        if !diceNodes.isEmpty {
            for dice in diceNodes {
                dice.removeFromParentNode()
            }
        }
    }
}
