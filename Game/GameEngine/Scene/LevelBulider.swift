//
//  LevelBulider.swift
//  Game
//
//  Created by ntust on 2026/4/27.
//

import SpriteKit

class LevelBuilder {
    func build(scene: SKScene, player: Player) {
        createGround(scene)

        createEnemy(scene)

        createCoin(scene)

        scene.addChild(player)
    }
    
    func createGround(_ scene: SKScene) {
        let ground = SKSpriteNode(color: .brown, size:CGSize(width: 2000, height: 60))

        ground.position = CGPoint(x:1000,y:100)

        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)

        ground.physicsBody?.isDynamic = false

        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground

        scene.addChild(ground)
    }
    
    func createEnemy(_ scene: SKScene) {

        let enemy = Enemy(position: CGPoint(x: 700, y: 150))

        scene.addChild(enemy)
    }
    
    func createCoin(_ scene: SKScene) {
        let coin = SKSpriteNode(color: .yellow, size: CGSize(width: 30, height: 30))

        coin.position = CGPoint(x: 500, y: 250)

        coin.physicsBody = SKPhysicsBody(circleOfRadius: 15)

        coin.physicsBody?.isDynamic = false

        coin.physicsBody?.categoryBitMask = PhysicsCategory.coin

        scene.addChild(coin)
    }
}
