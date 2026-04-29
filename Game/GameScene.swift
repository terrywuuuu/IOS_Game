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
    let gameCamera = SKCameraNode()
    var cameraController: CameraController!
    let timeManager = TimeManager()
    
//    private var label : SKLabelNode?
//    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx:0,dy:-15)

        physicsWorld.contactDelegate = self

        AudioManager.shared.setScene(self)
        AudioManager.shared.playBGM()

        collisionManager = CollisionManager(player: player)

        levelBuilder.build(scene: self, player: player)

        addChild(gameCamera)
        gameCamera.position = player.position
        cameraController = CameraController(camera: gameCamera, player: player)

        run(
            .repeatForever(
                .sequence([
                    .wait(forDuration: 1),
                    .run {
                        self.timeManager.tick()
                    }
                ])
        ))

        timeManager.gameOverCallback = { [weak self] in
            guard let self = self else { return }

            print("Game Over")

            GameManager.shared.gameStateManager.state = .lose
        }
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

    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0: // A
            player.moveLeft()
        case 2: // D
            player.moveRight()
        case 13: // W
            player.jump()
        case 49: // Space
            player.attack(scene: self)
        default:
            break
        }
    }

    override func keyUp(with event: NSEvent) {
        switch event.keyCode {
        case 0, 2:
            player.stop()
        default:
            break
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        collisionManager.handle(contact)
    }
    
    override func update(_ currentTime: TimeInterval) {
        switch GameManager.shared.gameStateManager.state {
        case .playing:
            player.update()
            cameraController.update()
            break
        case .paused:
            return
        case .win:
            // 顯示勝利畫面
            return
        case .lose:
            // 顯示失敗畫面
            return
        }
    }
}
