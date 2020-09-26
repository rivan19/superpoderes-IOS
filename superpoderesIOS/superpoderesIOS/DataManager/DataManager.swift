//
//  DataManager.swift
//  superpoderesIOS
//
//  Created by Ivan Llopis Guardado on 26/09/2020.
//

import Foundation

class DataManager {
    let segue_game_view_controller = "SEGUE_GAME_VIEW_CONTROLLER"
    let segue_view_controller = "SEGUE_VIEW_CONTROLLER"
    
    var maxScore = 0
    
    private init(){}
    static var shared = DataManager()
    
    func save(score: Int){
        DataProvider.dataProvider.save(score: score)
    }
    
    func getMaxScore() -> Int{
        self.maxScore = DataProvider.dataProvider.data() ?? 0
        return self.maxScore
    }
    
}
