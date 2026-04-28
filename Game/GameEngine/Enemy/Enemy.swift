//
//  Enemy.swift
//  Game
//
//  Created by ntust on 2026/4/27.
//

import SpriteKit

class Enemy: SKSpriteNode {

    init(position:CGPoint){

        let texture = SKTexture(imageNamed:"enemy")

        super.init(texture:texture,
                   color:.clear,
                   size:CGSize(width:45,height:45))

        self.position = position

        physicsBody = SKPhysicsBody(rectangleOf:size)

        physicsBody?.isDynamic = false

        physicsBody?.categoryBitMask = PhysicsCategory.enemy
    }

    required init?(coder:NSCoder){
        fatalError()
    }

}
