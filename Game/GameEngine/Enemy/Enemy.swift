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

class PatrolMonster: Enemy {
    init(position: CGPoint) {
        super.init(position: position, textureName: "enemy1")
        
        let goRight = SKAction.moveBy(x: 200, y: 0,
                                      duration: 2.0)
        let goLeft = goRight.reversed()

        // 翻轉面向
        let faceRight = SKAction.run { self.xScale = -abs(self.xScale) }
        let faceLeft  = SKAction.run { self.xScale = abs(self.xScale) }

        let seq = SKAction.sequence([faceRight, goRight, faceLeft, goLeft])
        run(SKAction.repeatForever(seq))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
