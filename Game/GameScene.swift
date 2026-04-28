//
//  GameScene.swift
//  Game
//
//  Created by ntust on 2026/4/18.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player = Player()
    let levelBuilder = LevelBuilder()
    var collisionManager: CollisionManager!
    
//    private var label : SKLabelNode?
//    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx:0,dy:-15)

        physicsWorld.contactDelegate = self

        player.position = CGPoint(x: 200,y: 300)

        collisionManager = CollisionManager(player: player)

        levelBuilder.build(scene: self, player: player)
    }
//
//    
//    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
//    }
//    
//    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
//    }
//    
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//        
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//    
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//    
//
    
    func didBegin(_ contact: SKPhysicsContact) {
        collisionManager.handle(contact)
    }
    
    override func update(_ currentTime: TimeInterval) {
//        player.update()
//
//        enemy.update()
//
//        checkCollisions()
        if player.physicsBody?.velocity.dy == 0 {
            player.canJump = true
        }
    }
}
