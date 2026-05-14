//
//  PlayerAnimation.swift
//  Game
//
//  Created by ntust on 2026/5/7.
//

import Foundation

import SpriteKit

extension Player {
    func setupAnimations(_ player: Int) {
        walkTextures = [
            SKTexture(imageNamed: "player\(player)_walk1"),
            SKTexture(imageNamed: "player\(player)_walk2"),
            SKTexture(imageNamed: "player\(player)_walk3"),
            SKTexture(imageNamed: "player\(player)_walk4")
        ]
        
        attackTextures = [
            SKTexture(imageNamed: "player\(player)_attack2")
        ]
        
        jumpTexture = SKTexture(imageNamed: "player\(player)_jump1")
        jumpTexture.filteringMode = .nearest
        landTexture = SKTexture(imageNamed: "player\(player)_jump2")
        landTexture.filteringMode = .nearest

        for texture in walkTextures {
            texture.filteringMode = .nearest
        }
        
        for texture in attackTextures {
            texture.filteringMode = .nearest
        }
    }

    func playWalkAnimation() {
        let walkAction = SKAction.animate(
            with: walkTextures,
            timePerFrame: 0.1
        )
        size = CGSize(width: 70, height: 70)

        run(
            SKAction.repeatForever(walkAction),
            withKey: "walk"
        )
    }

    func stopWalkAnimation() {
        texture = SKTexture(imageNamed: playerName)
        texture?.filteringMode = .nearest
        size = CGSize(width: 50, height: 50)
    }
    
    func playJumpAnimation() {
        size = CGSize(width: 80, height: 80)
        texture = jumpTexture
    }
    
    func playLandAnimation() {
        texture = landTexture
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 0.2),
            SKAction.run { [weak self] in
                self?.changeState(to: .idle)
            }
        ]))
    }
    
    func playAttackAnimation() {
        size = CGSize(width: 80, height: 80)
        let attackAction = SKAction.animate(
            with: attackTextures,
            timePerFrame: 0.5
        )
        
        let backToIdle = SKAction.run { [weak self] in
            self?.changeState(to: .idle)
        }
        
        let sequence = SKAction.sequence([
            attackAction,
            backToIdle
        ])
        
        run(sequence, withKey: "attack")
    }
}
