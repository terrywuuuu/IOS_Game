//
//  LevelBulider.swift
//  Game
//
//  Created by ntust on 2026/4/27.
//

import SpriteKit

class LevelBuilder {
    func build(scene: SKScene, player: Player, level: Int) {
        let levelName = "level\(level)"
        guard let level = LevelLoader.load(name: levelName)
        else { return }

        createBackground(scene, level.background, level.levelWidth)

        player.position = CGPoint(x: level.playerSpawn.x, y: level.playerSpawn.y)
        GameManager.shared.checkpointManager.respawnPoint = player.position

        createGround(scene, level.grounds)

        createPlatform(scene, level.platforms)
        
        createMovingPlatform(scene, level.movingPlatforms)
        
        createFallingPlatform(scene, level.fallingPlatforms)

        createEnemy(level.enemies, scene: scene)
        createSpikeTraps(level.spikes, scene: scene)

        createCoin(scene, level.coins)

        createCheckpoint(scene, level.checkpoints)

        createItems(scene, level.items)

        createGoal(scene, level.goal)
        
        if player.parent != nil {
            player.removeFromParent()
        }
        scene.addChild(player)
    }

    func createBackground(_ scene: SKScene, _ image: String, _ levelWidth: Int) {
        let texture = SKTexture(imageNamed: image)
        let texWidth = texture.size().width
        let count = Int(ceil(CGFloat(levelWidth) / texWidth))
        
        for i in 0..<count {
                let bg = SKSpriteNode(texture: texture)
                bg.size = CGSize(width: texWidth, height: scene.size.height)
                bg.position = CGPoint(
                    x: texWidth * CGFloat(i) + texWidth / 2,
                    y: scene.size.height / 2 + 100
                )
                bg.zPosition = -1
                scene.addChild(bg)
            }
    }
    
    func createGround(_ scene: SKScene, _ groundData: [Ground]) {
        for g in groundData {
            let ground = SKSpriteNode(color: .brown, size:CGSize(width: g.width, height: g.height))
//            let ground = SKSpriteNode(imageNamed: g.texture)

            ground.position = CGPoint(x: g.x, y: g.y)

            ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)

            ground.physicsBody?.isDynamic = false

            ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
            ground.physicsBody?.contactTestBitMask = PhysicsCategory.player

            scene.addChild(ground)
        }
    }

    func createPlatform(_ scene: SKScene, _ platformData: [Platform]) {
        for p in platformData {
            let platform = SKSpriteNode(color: .gray, size: CGSize(width: p.width, height: p.height))

            platform.position = CGPoint(x: p.x, y: p.y)

            platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)

            platform.physicsBody?.isDynamic = false

            platform.physicsBody?.categoryBitMask = PhysicsCategory.ground
            platform.physicsBody?.contactTestBitMask = PhysicsCategory.player

            scene.addChild(platform)
        }
    }
    
    func createMovingPlatform(_ scene: SKScene, _ platformData: [movingPlatform]) {
        for p in platformData {
            let platform = SKSpriteNode(color: .gray, size: CGSize(width: p.width, height: p.height))

            platform.position = CGPoint(x: p.x, y: p.y)

            platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)

            platform.physicsBody?.isDynamic = false

            platform.physicsBody?.categoryBitMask = PhysicsCategory.ground
            platform.physicsBody?.contactTestBitMask = PhysicsCategory.player
            
            // 左右來回移動
            let moveRight = SKAction.moveBy(x: 600, y: 0,
                                            duration: 5.0)
            let moveLeft = moveRight.reversed()
            let seq = SKAction.sequence([moveRight, moveLeft])
            platform.run(SKAction.repeatForever(seq))

            scene.addChild(platform)
        }
    }
    
    func createFallingPlatform(_ scene: SKScene, _ platformData: [fallingPlatform]) {
        for p in platformData {
            let platform = FallingPlatform(originalPosition: CGPoint(x: p.x, y: p.y), width: p.width, height: p.height)

            platform.position = CGPoint(x: p.x, y: p.y)

            platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)

            platform.physicsBody?.isDynamic = false

            platform.physicsBody?.categoryBitMask = PhysicsCategory.fallingPlat
            platform.physicsBody?.contactTestBitMask = PhysicsCategory.player

            scene.addChild(platform)
        }
    }
    
    func createEnemy(_ enemyData: [EnemyData], scene: SKScene) {
        for e in enemyData {
            if e.type == "PatrolMonster" {
                let enemy = PatrolMonster(position: CGPoint(x: e.x, y: e.y))
                enemy.size = CGSize(width: 30, height: 50)
                scene.addChild(enemy)
            }
            else {
                let enemy = StaticMonster(position: CGPoint(x: e.x, y: e.y))
                enemy.size = CGSize(width: 30, height: 50)
                scene.addChild(enemy)
            }
        }
    }
    
    func createSpikeTraps(_ spikeData: [Spike], scene: SKScene) {
        for s in spikeData {
            let spike = SpikeTrap(position: CGPoint(x: s.x, y: s.y))
            scene.addChild(spike)
        }
    }

    func createCoin(_ scene: SKScene, _ coinData: [Coin]) {
        for c in coinData {
            let coin = SKSpriteNode(imageNamed: "meat")

            coin.position = CGPoint(x: c.x, y: c.y)
            coin.size = CGSize(width: 25, height: 30)

            coin.physicsBody = SKPhysicsBody(circleOfRadius: 15)

            coin.physicsBody?.isDynamic = false

            coin.physicsBody?.categoryBitMask = PhysicsCategory.coin

            scene.addChild(coin)
        }
    }

    func createCheckpoint(_ scene: SKScene, _ checkpointData: [Checkpoint]) {
        for c in checkpointData {
            let checkpoint = SKSpriteNode(imageNamed: "checkpoint")

            checkpoint.position = CGPoint(x: c.x, y: c.y)
            checkpoint.size = CGSize(width: 40, height: 60)

            checkpoint.physicsBody = SKPhysicsBody(rectangleOf: checkpoint.size)

            checkpoint.physicsBody?.isDynamic = false

            checkpoint.physicsBody?.categoryBitMask = PhysicsCategory.checkpoint

            scene.addChild(checkpoint)
        }
    }

    func createItems(_ scene: SKScene, _ itemData: [ItemData]) {
        for i in itemData {
            let item = SKSpriteNode(imageNamed: "item1")

            item.position = CGPoint(x: i.x, y: i.y)
            item.size = CGSize(width: 50, height: 50)

            item.physicsBody = SKPhysicsBody(circleOfRadius: 15)

            item.physicsBody?.isDynamic = false

            if i.type == "Darkness" {
                item.physicsBody?.categoryBitMask = PhysicsCategory.darkItem
            }
            else {
                item.physicsBody?.categoryBitMask = PhysicsCategory.item
            }

            scene.addChild(item)
        }
    }

    func createGoal(_ scene: SKScene, _ goalData: Goal) {
        let goal = SKSpriteNode(imageNamed: "door")

        goal.position = CGPoint(x: goalData.x, y: goalData.y)

        goal.physicsBody = SKPhysicsBody(rectangleOf: goal.size)

        goal.physicsBody?.isDynamic = false

        goal.physicsBody?.categoryBitMask = PhysicsCategory.levelEnd

        scene.addChild(goal)
    }
}
