//
//  Box.swift
//  superpoderesIOS
//
//  Created by Ivan Llopis Guardado on 22/09/2020.
//

import ARKit

class Box: SCNNode {
    var totalMunition: Int = {
        return Int.random(in: 5...10)
    }()
    
    override init() {
        super.init()
        
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.darkGray
        
        box.materials = [material]
        self.geometry = box
        
        //Aplicamos las físicas
        let shape = SCNPhysicsShape(geometry: box, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .static, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        
        self.physicsBody?.categoryBitMask = Collisions.box.rawValue
        self.physicsBody?.contactTestBitMask = Collisions.bullet.rawValue
        
        let x = CGFloat.random(in: -1...1)
        let y = CGFloat.random(in: -1...1)
        let z = CGFloat.random(in: -2 ... -1)
        
        self.position = SCNVector3(x, y, z)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
