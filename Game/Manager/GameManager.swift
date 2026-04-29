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
    
    let checkpointManager = CheckpointManager()
    let gameStateManager = GameStateManager()
    var score = 0

    func addCoin() {
        score += 10

        print("Score:",score)
    }

    func activateCheckpoint(point: CGPoint) {
        checkpointManager.activateCheckpoint(point: point)
    }
    
    func respawnPlayer(player: Player) {
        checkpointManager.respawn(player: player)
    }

    func playerLose() {
        gameStateManager.lose()
    }
    
    func levelComplete() {
        gameStateManager.win()
    }
}
