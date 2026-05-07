//
//  PlayerAnimation.swift
//  Game
//
//  Created by ntust on 2026/5/7.
//

import Foundation

import SpriteKit

extension Player {
    func setupAnimations() {
        walkTextures = [
            SKTexture(imageNamed: "player_walk1"),
            SKTexture(imageNamed: "player_walk2"),
            SKTexture(imageNamed: "player_walk3"),
            SKTexture(imageNamed: "player_walk4")
        ]
        
        attackTextures = [
            SKTexture(imageNamed: "player_attack2")
        ]
        
        jumpTexture = SKTexture(imageNamed: "player_jump1")
        jumpTexture.filteringMode = .nearest
        landTexture = SKTexture(imageNamed: "player_jump2")
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
        texture = SKTexture(imageNamed: "player1")
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
