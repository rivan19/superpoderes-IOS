//
//  DataProvider.swift
//  superpoderesIOS
//
//  Created by Ivan Llopis Guardado on 26/09/2020.
//

import Foundation

class DataProvider {
    let keyUserDefaultPersistence = "USER_DEFAULT_SCORE_MAX"
    private init(){}
    static var dataProvider = DataProvider()
    
    func save(score: Int){
        UserDefaults.standard.set(score, forKey: keyUserDefaultPersistence)
    }
    
    func data() -> Int? {
        return UserDefaults.standard.integer(forKey: keyUserDefaultPersistence)
    }
}
