//
//  Plane.swift
//  ARBillboad
//
//  Created by Oscar Izquierdo on 04/06/2020.
//  Copyright © 2020 Oscar Izquierdo. All rights reserved.
//

import ARKit

class Status: SCNNode {
    
    var id: Int = 0
    let totalLive: Int
    var actualLive: Int = 0 
    
    let plane = SCNPlane(width: 0.20, height: 0.03)
    
    init(withId id: Int,  _ position: SCNVector3, totalLive: Int) {
        
        self.id = id
        self.totalLive = totalLive
        self.actualLive = totalLive
        
        super.init()
        
        plane.firstMaterial?.diffuse.contents = UIColor.systemYellow.cgColor
        
        self.geometry = plane
        
        // Añadimos físicas
        let shape = SCNPhysicsShape(geometry: plane, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .static, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    func face(to objectOrientation: simd_float4x4) {
        var transform = objectOrientation
        transform.columns.3.x = self.position.x
        transform.columns.3.y = self.position.y
        transform.columns.3.z = self.position.z
        self.transform = SCNMatrix4(transform)
    }
    
    func change(width: CGFloat){
        self.plane.width = width
    }
    
    func change(live: Int){
        self.actualLive = live
        self.plane.width = self.getWidthWithLive()
    }
}

extension Status {
    fileprivate func getWidthWithLive() -> CGFloat {
        return (CGFloat(self.actualLive) * CGFloat(0.20)) / CGFloat(totalLive)
    }
}
