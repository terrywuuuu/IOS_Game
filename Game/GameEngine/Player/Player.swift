//
//  Player.swift
//  Game
//
//  Created by ntust on 2026/4/27.
//

import SpriteKit

class Player: SKSpriteNode {
    var moveSpeed: CGFloat = 5
    var jumpForce: CGFloat = 100
    var isInvincible = false
    var reverseControls = false
    var canJump = false
    var health = 3
    var hasAttack = false
    var canAttack = true
    var turnLeft = false
    var goLeft = false
    var goRight = false
    var walkTextures: [SKTexture] = []
    var attackTextures: [SKTexture] = []
    var jumpTexture: SKTexture!
    var landTexture: SKTexture!
    var state: PlayerState = .idle
    private var invincibilityWorkItem: DispatchWorkItem?
    private var reverseControlsWorkItem: DispatchWorkItem?
    private var invincibleUntil: Date?
    private var reverseUntil: Date?

    init() {
        let texture = SKTexture(imageNamed:"player1")
        texture.filteringMode = .nearest

        super.init(texture: texture,
                   color: .clear,
                   size: CGSize(width:50,height:50))

        setupPhysics()
        setupAnimations()
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
        xScale = -1
    }

    func moveRight() {
        goRight = true
        turnLeft = false
        xScale = 1
    }

    func stop(){
        goLeft = false
        goRight = false
        changeState(to: .idle)
    }

    func jump() {
        if canJump {
            changeState(to: .jumping)

            physicsBody?.applyImpulse(CGVector(dx: 0, dy: jumpForce))

            canJump = false
        }
    }
    
    func land() {
        if !canJump {
            canJump = true
            changeState(to: .falling)
        }
    }

    func takeDamage() {
        print(isInvincible)
        if !isInvincible {
            health -= 1
            print("Lives:", health)
            DataManager.shared.playerHealth = health
            hasAttack = false
            DispatchQueue.main.async {
                DataManager.shared.playerHasAttack = false
            }

            applyInvincibility(duration: 1.0)
            
            if health <= 0 {
                GameManager.shared.playerLose()
            } else {
                DispatchQueue.main.async {
                    GameManager.shared.respawnPlayer(player: self)
                }
            }
        }
    }
    
    func attack(scene: SKScene) {
        if !hasAttack { return }
        guard canAttack else { return }
        canAttack = false

        changeState(to: .attacking)
        
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

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.canAttack = true
        }
    }

    func update() {
        if self.position.y < -100 {
            takeDamage()
        }
        
        if goLeft {
            if canChangeToMoveState() {
                if canJump {
                    changeState(to: .walking)
                }
            }
            
            let speed = reverseControls ? moveSpeed : -moveSpeed
            if self.position.x + speed > 50 { // prevent moving beyond left or right edge
                self.position.x += speed
            }
        }
        else if goRight {
            if canChangeToMoveState() {
                if canJump {
                    changeState(to: .walking)
                }
            }
            
            let speed = reverseControls ? -moveSpeed : moveSpeed
            if self.position.x + speed > 50 {
                self.position.x += speed
            }
        }
    }

    func applyInvincibility(duration: TimeInterval) {
        // cancel any existing scheduled work
        invincibilityWorkItem?.cancel()
        invincibilityWorkItem = nil

        let expiry = Date().addingTimeInterval(duration)
        invincibleUntil = expiry
        isInvincible = true

        DispatchQueue.main.async {
            DataManager.shared.activeEffect = "無敵狀態"
            DataManager.shared.activeEffectExpiresAt = expiry
        }

        let work = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            guard self.invincibleUntil == expiry else { return }
            self.isInvincible = false
            self.invincibleUntil = nil

            DispatchQueue.main.async {
                if let expiryCheck = DataManager.shared.activeEffectExpiresAt,
                   expiryCheck <= Date(), DataManager.shared.activeEffect == "無敵狀態" {
                    DataManager.shared.activeEffect = nil
                    DataManager.shared.activeEffectExpiresAt = nil
                }
            }
        }

        invincibilityWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: work)
    }

    func applyReverseControls(duration: TimeInterval) {
        // cancel existing scheduled work
        reverseControlsWorkItem?.cancel()
        reverseControlsWorkItem = nil

        let expiry = Date().addingTimeInterval(duration)
        reverseUntil = expiry
        reverseControls = true

        DispatchQueue.main.async {
            DataManager.shared.activeEffect = "頭暈目眩"
            DataManager.shared.activeEffectExpiresAt = expiry
        }

        let work = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            guard self.reverseUntil == expiry else { return }
            self.reverseControls = false
            self.reverseUntil = nil

            DispatchQueue.main.async {
                if let expiryCheck = DataManager.shared.activeEffectExpiresAt,
                   expiryCheck <= Date(), DataManager.shared.activeEffect == "頭暈目眩" {
                    DataManager.shared.activeEffect = nil
                    DataManager.shared.activeEffectExpiresAt = nil
                }
            }
        }

        reverseControlsWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: work)
    }
}
