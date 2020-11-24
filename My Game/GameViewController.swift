//
//  GameViewController.swift
//  My Game
//
//  Created by Илья Селиванов  on 23.11.2020.
//

import SceneKit

class GameViewController: UIViewController {
    
    let label = UILabel()
    
    
    //MARK: - Properties
    var duration: TimeInterval = 5
    var score = 0
    var ship: SCNNode!
    //MARK: - Methods
    
    // add label storyboard
    func addLabel() {
       
    }
    
    func addShip() {
        
        
        // move ship farther from view
        let x = Int.random(in: -25...25)
        let y = Int.random(in: -25...25)
        let z = -105
        ship.position = SCNVector3(x, y, z)
        
        //Make the ship look at given point
        ship.look(at: SCNVector3(2 * x, 2 * y, 2 * z))
        
        
        //animate ship movement  towards camera
      //  ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        ship.runAction(.move(to: SCNVector3(), duration: duration)) {
            self.ship.removeFromParentNode()
            print(#line, #function, "Game over")
        }
        
        //add ship to the scene
        scnView.scene?.rootNode.addChildNode(ship)
    }
    
    func getShip() -> SCNNode {
        // get scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // retrieve the ship node
        let ship = scene.rootNode.childNode(withName: "ship", recursively: true)!.clone()
        
        return ship
    }
    
    func removeShip() {

        
        // revove the ship
        scnView.scene?.rootNode.childNode(withName: "ship", recursively: true)?.removeFromParentNode()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        //cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the ship node
       // let ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
        
        // animate the 3d object
     //   ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
       // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
        
        //remove the ship
        removeShip()
        
        // Get ship
        ship = getShip()
        
        // add ship
        addShip()
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        
       // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            
            // retrieved the first clicked object
            let result = hitResults[0]
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.2
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                
                self.ship.removeFromParentNode()
                self.score += 1
                
                
                print(#line, #function, "The ship \(self.score) has been shot")
                self.duration *= 0.95
                
                self.ship = self.getShip()
                self.addShip()
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
        }
    }
    //MARK: - Computed Propeeties
    var scnView: SCNView {
       self.view as! SCNView
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}
