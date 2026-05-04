//
//  Player.swift
//  Game
//
//  Created by ntust on 2026/4/27.
//

import SpriteKit

class Player: SKSpriteNode {
    var moveSpeed: CGFloat = 5
    var jumpForce: CGFloat = 200
    var isInvincible = false
    var reverseControls = false
    var canJump = false
    var health = 3
    var hasAttack = false
    var canAttack = true
    var turnLeft = false
    var goLeft = false
    var goRight = false

    init() {
        let texture = SKTexture(imageNamed:"player1")

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
        goLeft = true
        turnLeft = true
    }

    func moveRight() {
        goRight = true
        turnLeft = false
    }

    func stop(){
        goLeft = false
        goRight = false
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
            DataManager.shared.playerHealth = health
            hasAttack = false
            DispatchQueue.main.async {
                DataManager.shared.playerHasAttack = false
            }

            if health <= 0 {
                GameManager.shared.playerLose()
            }

            DispatchQueue.main.async {
                GameManager.shared.respawnPlayer(player: self)
            }
            
            isInvincible = true
            run(.wait(forDuration: 1.0)) {
                self.isInvincible = false
            }
        }
    }
    
    func attack(scene: SKScene) {
        if !hasAttack { return }
        guard canAttack else { return }
        canAttack = false

        let hitbox = SKSpriteNode(
           color: .red,
           size: CGSize(width: 20, height: 20)
        )

        if turnLeft {
            hitbox.position = CGPoint(x: position.x - 40, y: position.y)
        } else {
            hitbox.position = CGPoint(x: position.x + 40, y: position.y)
        }

        hitbox.physicsBody = SKPhysicsBody(rectangleOf: hitbox.size)
        hitbox.physicsBody?.isDynamic = true
        hitbox.physicsBody?.affectedByGravity = false
        hitbox.physicsBody?.allowsRotation = false
        hitbox.physicsBody?.usesPreciseCollisionDetection = true

        hitbox.physicsBody?.categoryBitMask = PhysicsCategory.attack
        hitbox.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        hitbox.physicsBody?.collisionBitMask = 0
        
        let speed: CGFloat = 600
        if turnLeft {
            hitbox.physicsBody?.velocity = CGVector(dx: -speed, dy: 0)
        } else {
            hitbox.physicsBody?.velocity = CGVector(dx: speed, dy: 0)
        }
        
        scene.addChild(hitbox)

        hitbox.run(
          .sequence([
            .wait(forDuration: 1.0),
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
        
        if goLeft {
            let speed = reverseControls ? moveSpeed : -moveSpeed
            if self.position.x + speed > 50 { // prevent moving beyond left or right edge
                self.position.x += speed
            }
        }
        else if goRight {
            let speed = reverseControls ? -moveSpeed : moveSpeed
            if self.position.x + speed > 50 {
                self.position.x += speed
            }
        }
    }

    func applyInvincibility(duration: TimeInterval) {
        // cancel existing invincibility timer action if any
        removeAction(forKey: "invincibleTimeout")
        isInvincible = true
        // update UI effect state with expiry to allow safe clearing when re-applied
        DispatchQueue.main.async {
            DataManager.shared.activeEffect = "無敵狀態"
            DataManager.shared.activeEffectExpiresAt = Date().addingTimeInterval(duration)
        }

        let seq = SKAction.sequence([
            .wait(forDuration: duration),
            .run { [weak self] in
                guard let self = self else { return }
                self.isInvincible = false
                DispatchQueue.main.async {
                    if let expiry = DataManager.shared.activeEffectExpiresAt,
                       expiry <= Date() {
                        DataManager.shared.activeEffect = nil
                        DataManager.shared.activeEffectExpiresAt = nil
                    }
                }
            }
        ])
        run(seq, withKey: "invincibleTimeout")
    }

    func applyReverseControls(duration: TimeInterval) {
        removeAction(forKey: "reverseControlsTimeout")
        reverseControls = true
        DispatchQueue.main.async {
            DataManager.shared.activeEffect = "頭暈目眩"
            DataManager.shared.activeEffectExpiresAt = Date().addingTimeInterval(duration)
        }

        let seq = SKAction.sequence([
            .wait(forDuration: duration),
            .run { [weak self] in
                guard let self = self else { return }
                self.reverseControls = false
                DispatchQueue.main.async {
                    if let expiry = DataManager.shared.activeEffectExpiresAt,
                       expiry <= Date() {
                        DataManager.shared.activeEffect = nil
                        DataManager.shared.activeEffectExpiresAt = nil
                    }
                }
            }
        ])
        run(seq, withKey: "reverseControlsTimeout")
    }
}
