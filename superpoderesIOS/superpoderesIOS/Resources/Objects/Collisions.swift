//
//  Collisions.swift
//  ARBillboad
//
//  Created by Oscar Izquierdo on 04/06/2020.
//  Copyright © 2020 Oscar Izquierdo. All rights reserved.
//

import Foundation

struct Collisions: OptionSet {
    let rawValue: Int
    
    static let plane = Collisions(rawValue: 1 << 0)
    static let bullet = Collisions(rawValue: 1 << 1)
    static let box = Collisions(rawValue: 1 << 2)
}
