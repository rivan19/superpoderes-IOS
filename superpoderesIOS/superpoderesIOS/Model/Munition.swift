//
//  Munition.swift
//  superpoderesIOS
//
//  Created by Ivan Llopis Guardado on 22/09/2020.
//

import Foundation

enum HitPoint: Int {
    case hitNormal = 1
    case hitDouble
}

enum Level: Int {
    case easy = 5
    case normal = 3
    case hard = 0
}

class Munition {
    var totalDouble = 0
    
    init(level: Level){
        switch level {
            case .easy:
                self.totalDouble = level.rawValue
            case .normal:
                self.totalDouble = level.rawValue
            case .hard:
                self.totalDouble = level.rawValue
        }
    }
    
    func shootDoubleHit(){
        if self.totalDouble >= 0 {
            self.totalDouble -= 1
        }
    }
    
    func addNewBox(with totalMunition: Int){
        self.totalDouble += totalMunition
    }
    
    func damageHit(damage: HitPoint) -> Int {
        if damage == .hitNormal {
            return 1
        } else {
            return Int.random(in: 2...4)
        }
    }
    
    func emptyMunition() -> Bool {
        if self.totalDouble <= 0 {
            return true
        } else {
            return false
        }
    }
    
}
