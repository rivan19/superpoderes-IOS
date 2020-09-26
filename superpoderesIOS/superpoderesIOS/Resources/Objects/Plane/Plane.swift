//
//  Plane.swift
//  ARBillboad
//
//  Created by Oscar Izquierdo on 04/06/2020.
//  Copyright © 2020 Oscar Izquierdo. All rights reserved.
//

import ARKit

class Plane: SCNNode {
    
    var id: Int = 0
    fileprivate let velocity: Float = 3
    var live: Int = {
        return Int.random(in: 1...3)
    }()
    
    init(withId id: Int, _ camera: ARCamera) {
        super.init()
        self.id = id
        
        let plane = SCNScene(named: "ship.scn") ?? SCNScene()
        let node = plane.rootNode
        self.addChildNode(node)
        
//        let rectangleLive = SCNPlane(width: 10, height: 3)
//        let rectMaterial = SCNMaterial()
//        rectMaterial.diffuse.contents = UIColor.systemYellow
//        rectangleLive.materials = [rectMaterial]
        
        //self.addChildNode(rectangleLive)
        // Añadimos físicas al avion
        let shape = SCNPhysicsShape(node: node, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .static, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        
        // Identificador de nuestro objeto para las colisiones
        self.physicsBody?.categoryBitMask = Collisions.plane.rawValue
        
        // Especeficamos los objetos contra los que puede colisionar
        self.physicsBody?.contactTestBitMask = Collisions.bullet.rawValue
        
        // Animar el avión un poquito
        let hoverUp = SCNAction.moveBy(x: 0, y: 0.2, z: 0, duration: 1.5)
        let hoverDown = SCNAction.moveBy(x: 0, y: -0.2, z: 0, duration: 1.5)
        let nearMove = SCNAction.moveBy(x: 0, y: 0, z: 0.5, duration: 0.75)
        let hoverSequence = SCNAction.sequence([hoverUp, hoverDown, nearMove])
        //let hoverSequence = SCNAction.sequence([hoverUp, hoverDown])
        let hoverForever = SCNAction.repeatForever(hoverSequence)
        self.runAction(hoverForever)
        
        let x = CGFloat.random(in: -1...1)
        let y = CGFloat.random(in: -1...1)
        let z = CGFloat.random(in: -2 ... -1)
        
        self.position = SCNVector3(x, y, z)
        
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    func face(to objectOrientation: simd_float4x4) {
        var transform = objectOrientation
        transform.columns.3.x = self.position.x
        transform.columns.3.y = self.position.y
        transform.columns.3.z = self.position.z
        self.transform = SCNMatrix4(transform)
    }
    
    func shoot(munition: Munition, hitPoint: HitPoint){
        if hitPoint == .hitNormal {
            self.live -= 1
        } else {
            if !munition.emptyMunition(){
                self.live -= munition.damageHit(damage: .hitDouble)
                //munition.shootDoubleHit()
            }
            else{
                self.live -= 1
            }
            
        }
        
        print("live - shoot:\(self.live)")
    }
    
    func isAlive() -> Bool{
        if self.live > 0 {
            return true
        } else {
            return false
        }
    }
}
