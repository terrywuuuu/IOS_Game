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
    var isInvincible = false
    var reverseControls = false
    var canJump = false
    var health = 3
    var hasAttack = false
    var canAttack = true

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
            PhysicsCategory.coin |
            PhysicsCategory.checkpoint |
            PhysicsCategory.item |
            PhysicsCategory.levelEnd
    }

    func moveLeft() {
        let speed = reverseControls ? moveSpeed : -moveSpeed
        physicsBody?.velocity.dx = speed
    }

    func moveRight() {
        let speed = reverseControls ? -moveSpeed : moveSpeed
        physicsBody?.velocity.dx = speed
    }

    func stop(){
        physicsBody?.velocity.dx = 0
    }

    func jump() {
        if canJump {
            physicsBody?.applyImpulse(CGVector(dx: 0, dy: jumpForce))

            canJump = false
        }
    }

    func takeDamage() {
        if !isInvincible {
            health -= 1
            print("Lives:", health)

            if health <= 0 {
                GameManager.shared.playerLose()  
            }

            GameManager.shared.respawnPlayer(player: self)
        }
    }
    
    func attack(scene: SKScene) {
        if !hasAttack { return }
        guard canAttack else { return }
        canAttack = false

        let hitbox = SKSpriteNode(
           color: .red,
           size: CGSize(width: 40, height: 20)
        )

        hitbox.position = CGPoint(x: position.x + 40, y: position.y)

        hitbox.physicsBody = SKPhysicsBody(rectangleOf: hitbox.size)

        hitbox.physicsBody?.isDynamic = false

        hitbox.physicsBody?.categoryBitMask = PhysicsCategory.attack
        hitbox.physicsBody?.contactTestBitMask = PhysicsCategory.enemy

        scene.addChild(hitbox)

        hitbox.run(
          .sequence([
            .wait(forDuration:0.15),
            .removeFromParent()
          ])
        )

        run(.wait(forDuration: 0.3)) {
            self.canAttack = true
        }
    }

    func update() {
        if self.position.y < -100 {
            takeDamage()
        }
    }

    func setInvincible(_ value: Bool) {
        isInvincible = value
    }
}
