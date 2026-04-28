//
//  Player.swift
//  Game
//
//  Created by ntust on 2026/4/27.
//

import SpriteKit

class Player: SKSpriteNode {

    var moveSpeed: CGFloat = 220
    var jumpForce: CGFloat = 600

    var canJump = false

    var health = 3

    init() {

        let texture = SKTexture(imageNamed:"player")

        super.init(texture: texture,
                   color: .clear,
                   size: CGSize(width:50,height:50))

        setupPhysics()
    }

    required init?(coder:NSCoder) {
        fatalError()
    }

    func setupPhysics() {

        physicsBody = SKPhysicsBody(rectangleOf:size)

        physicsBody?.allowsRotation = false

        physicsBody?.categoryBitMask =
            PhysicsCategory.player

        physicsBody?.collisionBitMask =
            PhysicsCategory.ground

        physicsBody?.contactTestBitMask =
            PhysicsCategory.enemy |
            PhysicsCategory.coin
    }

    func moveLeft() {

        physicsBody?.velocity.dx = -moveSpeed
    }

    func moveRight() {

        physicsBody?.velocity.dx = moveSpeed
    }

    func stop(){

        physicsBody?.velocity.dx = 0
    }

    func jump() {

        if canJump {

            physicsBody?.velocity.dy = jumpForce

            canJump = false
        }
    }

    func takeDamage() {

        health -= 1

        print("Lives:", health)
    }
    
    func attack(scene: SKScene) {
        let hitbox = SKSpriteNode(
           color: .red,
           size: CGSize(width: 40, height: 20)
        )

        hitbox.position = CGPoint(x: position.x + 40, y: position.y)

        hitbox.physicsBody = SKPhysicsBody(rectangleOf: hitbox.size)

        hitbox.physicsBody?.isDynamic = false

        hitbox.physicsBody?.categoryBitMask = PhysicsCategory.attack

        scene.addChild(hitbox)

        hitbox.run(
          .sequence([
            .wait(forDuration:0.15),
            .removeFromParent()
          ])
        )
    }

    func update() {
        
    }
}
