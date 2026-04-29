//
//  LevelBulider.swift
//  Game
//
//  Created by ntust on 2026/4/27.
//

import SpriteKit

class LevelBuilder {
    func build(scene: SKScene, player: Player) {
        guard let level = LevelLoader.load(name: "level1")
        else { return }

        createBackground(scene, level.background)

        player.position = CGPoint(x: level.playerSpawn.x, y: level.playerSpawn.y)   

        createGround(scene, level.grounds)

        createPlatform(scene, level.platforms)

        createEnemy(level.enemies, scene: scene)
        createSpikeTraps(level.spikes, scene: scene)

        createCoin(scene, level.coins)

        createCheckpoint(scene, level.checkpoints)

        createItems(scene, level.items)

        createGoal(scene, level.goal)

        scene.addChild(player)
    }

    func createBackground(_ scene: SKScene, _ image: String) {
        let background = SKSpriteNode(color: .cyan, size: CGSize(width: 2000, height: 1000))

        background.position = CGPoint(x: 1500, y: 400)

        background.zPosition = -1

        scene.addChild(background)
    }
    
    func createGround(_ scene: SKScene, _ groundData: [Ground]) {
        for g in groundData {
            let ground = SKSpriteNode(color: .brown, size:CGSize(width: g.width, height: g.height))
//            let ground = SKSpriteNode(imageNamed: g.texture)

            ground.position = CGPoint(x: g.x, y: g.y)

            ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)

            ground.physicsBody?.isDynamic = false

            ground.physicsBody?.categoryBitMask = PhysicsCategory.ground

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

            scene.addChild(platform)
        }
    }
    
    func createEnemy(_ enemyData: [EnemyData], scene: SKScene) {
        for e in enemyData {
            let enemy = StaticMonster(position: CGPoint(x: e.x, y: e.y))
            scene.addChild(enemy)
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
            let coin = SKSpriteNode(color: .yellow, size: CGSize(width: 30, height: 30))

            coin.position = CGPoint(x: c.x, y: c.y)

            coin.physicsBody = SKPhysicsBody(circleOfRadius: 15)

            coin.physicsBody?.isDynamic = false

            coin.physicsBody?.categoryBitMask = PhysicsCategory.coin

            scene.addChild(coin)
        }
    }

    func createCheckpoint(_ scene: SKScene, _ checkpointData: [Checkpoint]) {
        for c in checkpointData {
            let checkpoint = SKSpriteNode(color: .blue, size: CGSize(width: 40, height: 80))

            checkpoint.position = CGPoint(x: c.x, y: c.y)

            checkpoint.physicsBody = SKPhysicsBody(rectangleOf: checkpoint.size)

            checkpoint.physicsBody?.isDynamic = false

            checkpoint.physicsBody?.categoryBitMask = PhysicsCategory.checkpoint

            scene.addChild(checkpoint)
        }
    }

    func createItems(_ scene: SKScene, _ itemData: [ItemData]) {
        for i in itemData {
            let item = SKSpriteNode(color: .purple, size: CGSize(width: 30, height: 30))

            item.position = CGPoint(x: i.x, y: i.y)

            item.physicsBody = SKPhysicsBody(circleOfRadius: 15)

            item.physicsBody?.isDynamic = false

            item.physicsBody?.categoryBitMask = PhysicsCategory.item

            scene.addChild(item)
        }
    }

    func createGoal(_ scene: SKScene, _ goalData: Goal) {
        let goal = SKSpriteNode(color: .green, size: CGSize(width: 50, height: 100))

        goal.position = CGPoint(x: goalData.x, y: goalData.y)

        goal.physicsBody = SKPhysicsBody(rectangleOf: goal.size)

        goal.physicsBody?.isDynamic = false

        goal.physicsBody?.categoryBitMask = PhysicsCategory.levelEnd

        scene.addChild(goal)
    }
}
