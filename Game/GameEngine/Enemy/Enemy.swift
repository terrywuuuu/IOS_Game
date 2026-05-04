//
//  Enemy.swift
//  Game
//
//  Created by ntust on 2026/4/27.
//

import SpriteKit

class Enemy: SKSpriteNode {
    init(position: CGPoint, textureName: String) {
        let texture = SKTexture(imageNamed: textureName)

        super.init(texture: texture,
                   color: .clear,
                   size: CGSize(width: 45, height: 45))

        self.position = position

        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = false

        physicsBody?.categoryBitMask = PhysicsCategory.enemy
        physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.attack
        physicsBody?.collisionBitMask = 0
    }

    required init?(coder:NSCoder){
        fatalError()
    }
}

class SpikeTrap: Enemy {
    init(position: CGPoint) {
        super.init(position: position, textureName: "spike")
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

class StaticMonster: Enemy {
    init(position: CGPoint) {
        super.init(position: position, textureName: "enemy1")
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
