//
//  ViewGameController.swift
//  superpoderesIOS
//
//  Created by Ivan Llopis Guardado on 22/09/2020.
//

import UIKit
import ARKit

class ViewGameController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    var planes: [Plane] = []
    var statuses: [Status] = []
    var idPlane = 0
    var hitPoint: HitPoint = .hitNormal
    var level: Level = .easy
    var munition = Munition(level: .easy)
    let configuration = ARWorldTrackingConfiguration()
    var score = 0 {
        didSet{
            DispatchQueue.main.async { [weak self] in
                self?.scoreLabel.text = "\(self?.score ?? 0)"
            }
        }
    }
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var totalAmount: UILabel!
    
    func setLevel(level: Level) {
        self.level = level
        self.munition = Munition(level: self.level)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupComponents()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        sceneView.session.pause()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addNewPlane(quantity: getNumberOfPlains())
        self.addNewBox()
    }
    
    fileprivate func setupComponents(){
        self.updateTextLabelAmount()
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        
        sceneView.session.delegate = self
        
        sceneView.scene.physicsWorld.contactDelegate = self
        
        
    }
    
    fileprivate func initScore() {
        self.score = 0
    }
    
    fileprivate func newGame(){
        self.sceneView.scene.rootNode.childNodes.forEach { (node) in
            node.removeFromParentNode()
        }
        
        munition = Munition(level: self.level)
        self.initScore()
        
        setupComponents()
        
        self.addNewPlane(quantity: getNumberOfPlains())
        self.addNewBox()
    }
    
    private func addNewBox(){
        if Bool.random() {
            if Bool.random(){
                let box = Box()
                self.sceneView.prepare([box]) { (_) in
                    self.sceneView.scene.rootNode.addChildNode(box)
                }
            }
        }
    }
    
    private func addNewPlane(quantity: Int = 1) {
        guard let camera = self.sceneView.session.currentFrame?.camera else { return }
        
        for _ in 1...quantity {
            idPlane += 1
            let plane = Plane(withId: idPlane, camera)
            plane.id = idPlane
            let statusPosition = SCNVector3(plane.position.x, plane.position.y + 0.3, plane.position.z)
            let status = Status(withId: plane.id, statusPosition, totalLive: plane.live)
            
            self.planes.append(plane)
            self.statuses.append(status)
            
            self.sceneView.prepare([plane, status]) { _ in
                self.sceneView.scene.rootNode.addChildNode(plane)
                self.sceneView.scene.rootNode.addChildNode(status)
            }
        }
    }
    
    @IBAction func tapShoot(_ sender: Any) {
        guard let camera = self.sceneView.session.currentFrame?.camera else { return }
        let bullet = Bullet(camera)
        sceneView.scene.rootNode.addChildNode(bullet)
        hitPoint = .hitNormal
    }
    

    @IBAction func tapDoubleShoot(_ sender: Any) {
        if !munition.emptyMunition() {
            guard let camera = self.sceneView.session.currentFrame?.camera else { return }
            let bullet = Bullet(camera)
            sceneView.scene.rootNode.addChildNode(bullet)
            hitPoint = .hitDouble
            munition.shootDoubleHit()
            self.updateTextLabelAmount()
        }else {
            self.tapShoot(sender)
        }
        
    }
    
    func updateTextLabelAmount(){
        self.totalAmount.text = "\(munition.totalDouble)"
    }
    
    @IBAction func exitButton(_ sender: Any) {
        var actions: [UIAlertAction] = []
        self.sceneView.session.pause()
        
        let actionNO = UIAlertAction(title: "No", style: .default) { [weak self] (_) in
            if let self = self {
                self.sceneView.session.run(self.configuration)
            }
        }
        
        let actionYES = UIAlertAction(title: "Si", style: .default) { [weak self] (_) in
            if let self = self {
                self.performSegue(withIdentifier: DataManager.shared.segue_view_controller, sender: nil)
            }
        }
        
        actions.append(actionYES)
        actions.append(actionNO)
        
        showAlertControllerWithParams(titleAlert: "PAUSE", messageAlert: "Puntos Actuales: \(score).\nDeseas Salir?", actions: actions)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        guard let _ = segue.destination as? ViewController else {
            return
        }
        
    }
    
*/
}

//MARK: - Contact delegate
extension ViewGameController: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        // Si algo choca con el avión
        if contact.nodeA.physicsBody?.categoryBitMask == Collisions.plane.rawValue ||
            contact.nodeB.physicsBody?.categoryBitMask == Collisions.plane.rawValue || contact.nodeA.physicsBody?.categoryBitMask == Collisions.box.rawValue ||
            contact.nodeB.physicsBody?.categoryBitMask == Collisions.box.rawValue {
            
            var node: SCNNode!
            var nodeBullet: SCNNode!
            var nodeBox: SCNNode!
            
            if contact.nodeA is Plane { node = contact.nodeA }
            if contact.nodeB is Plane { node = contact.nodeB }
            
            if contact.nodeA is Bullet { nodeBullet = contact.nodeA}
            if contact.nodeB is Bullet { nodeBullet = contact.nodeB}
            
            if contact.nodeA is Box { nodeBox = contact.nodeA}
            if contact.nodeB is Box { nodeBox = contact.nodeB}
            
            if let idPlaneSelected = node as? Plane {
                // Explossion
                Explossion.show(with: node, in: sceneView.scene)
                
                idPlaneSelected.shoot(munition: munition, hitPoint: hitPoint)
                
                if !idPlaneSelected.isAlive()
                {
                    if let n = node as? Plane, n.id == idPlaneSelected.id {
                        node.removeFromParentNode()
                        score += 2
                    }
                    
                    self.sceneView.scene.rootNode.childNodes.forEach { (node) in
                        if let status = node as? Status, status.id == idPlaneSelected.id {
                            node.removeFromParentNode()
                        }
                    }
                    
                    self.addNewPlane(quantity: 1)
                    self.addNewBox()
                } else {
                    statuses.forEach { (status) in
                        if status.id == idPlaneSelected.id {
                            status.change(live: idPlaneSelected.live)
                        }
                    }
                }
                
            }
            
            if let boxSelected = nodeBox as? Box {
                // Explossion
                Explossion.show(with: nodeBox, in: sceneView.scene)
                munition.addNewBox(with: boxSelected.totalMunition)
                nodeBox.removeFromParentNode()
                score += 1
                self.addNewBox()
            }
            
            if nodeBullet is Bullet {
                nodeBullet.removeFromParentNode()
            }
            
        }
        DispatchQueue.main.async {
            self.updateTextLabelAmount()
        }
        
    }
    
}

//MARK: - ARSCNViewDelegate
extension ViewGameController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if let cameraOrientation = session.currentFrame?.camera.transform {
            
            self.planes.forEach{ (plane) in
                plane.face(to: cameraOrientation)
                
                let matrix = SCNMatrix4(cameraOrientation)
                let pos = SCNVector3(matrix.m41, matrix.m42, matrix.m43)
                
                self.statuses.forEach { (status) in
                    if status.id == plane.id {
                        let statusPosition = SCNVector3(plane.position.x, plane.position.y + 0.3, plane.position.z)
                        status.position = statusPosition
                        status.face(to: cameraOrientation)
                    }
                }
                
                if plane.position.z >= pos.z {
                    print("end game")
                    if score > DataManager.shared.getMaxScore()
                    {
                        DataManager.shared.save(score: score)
                    }
                    
                    var actions: [UIAlertAction] = []
                    //self.sceneView.session.pause()
                    session.pause()
                    //plane.removeAllActions()
                    
                    
                    
                    let actionYES = UIAlertAction(title: "Si", style: .default) { [weak self] (_) in
                        self?.planes.removeAll()
                        self?.statuses.removeAll()
                        DispatchQueue.main.async {
                            self?.newGame()
                        }
                        
                        
                    }
                    let actionNO = UIAlertAction(title: "No", style: .default) { [weak self] (_) in
                        self?.performSegue(withIdentifier: DataManager.shared.segue_view_controller, sender: nil)
                        
                    }
                    
                    actions.append(actionYES)
                    actions.append(actionNO)
                    
                    showAlertControllerWithParams(titleAlert: "GAME OVER", messageAlert: "Puntos Totales: \(score).\nDeseas Jugar Otra Partida?", actions: actions)
                }
            }
        }
        
    }
}

extension ViewGameController {
    func getNumberOfPlains() -> Int{
        switch self.level {
        case .easy:
            return 1
        case .normal:
            return 2
        case .hard:
            return 3
        }
    }
}

