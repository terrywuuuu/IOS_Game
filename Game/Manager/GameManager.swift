//
//  GameManager.swift
//  Game
//
//  Created by ntust on 2026/4/27.
//

import SpriteKit

class GameManager {
    static let shared = GameManager()
    
    private init(){}
    
    var score = 0

    func addCoin(){
        score += 100

        print("Score:",score)
    }

}
